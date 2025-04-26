% Este arquivo decida-se à usar dos metainterpretadores completos para
% criar a EBG completa.
% Aqui, a EBG será baseada no Livro do Bratko e, como ela por si só é um
% metainterpretador, irei implementar também o meu metainterpretador
% completo.
% Também usaremos de árvores de prova.

ebg1(true, true, true).
ebg1(!, !, !). % Não precisamos adicionar o corte diretamente na tupla, isso já retorna !

/*
ebg1(Goal, GenGoal, GenGoal) :-
    operational(GenGoal),
    not(built_in(Goal)),
    call(Goal).
*/

%/*
ebg1(Goal, GenGoal, GenGoal) :-
    % Essa cláusula atrapalha tudo. Agora funciona! Talvez precise apenas disso?
    %operational(GenGoal),
    % Bratko verifica se é operacional justamente porque não pode ver se é builtin!!!!
    % Operacional/1 não é bultin, mas sim um predicado que ele inventou para encontrar o =:=.
    built_in(GenGoal),
    call(Goal).
%*/

/*
ebg1(Goal, GenGoal, GenGoal) :-  % Será que deve ser mantida?
    not(operational(Goal)),
    built_in(Goal),
    call(Goal).
*/

%ebg1((Goal1, Goal2), Gen, Cond) :-
ebg1((Goal1, Goal2), (Gen1, Gen2), Cond) :-
    (encontra_cortes((Goal1, Goal2), GoalsEsq, GoalsDir) -> ebg1(GoalsEsq, GenEsq, CondEsq), !,
                                                            ebg1(GoalsDir, GenDir, CondDir),
                                                            and(CondEsq, CondDir, Cond),
                                                            %=(Gen, (GenEsq, !, GenDir))
                                                            %=((Gen1, Gen2), (GenEsq, !, GenDir))
                                                            =((Gen1, Gen2), (GenEsq, GenDir))
    ;   ebg1(Goal1, Gen1, Cond1),
        ebg1(Goal2, Gen2, Cond2),
        %=(Gen, (Gen1, Gen2)),  % Isso não está unificando. Vamos mudar a cabeça do predicado
        and(Cond1, Cond2, Cond)).

ebg1(Goal, GenGoal, Cond) :-
    \=(Goal, (_, _)),
    not(built_in(Goal)),
    not(operational(Goal)),
    clause(GenGoal, GenBody),
    (encontra_cortes(GenBody, GenBodyEsq, GenBodyDir) -> copy_term(GenBodyEsq, BodyEsq),
                                                         copy_term(GenBodyDir, BodyDir),
                                                         ebg1(BodyEsq, GenBodyEsq, CondEsq), !,
                                                         ebg1(BodyDir, GenBodyDir, CondDir),
                                                         =(GenGoal, (GenBodyEsq, !, GenBodyDir)),
                                                         and(CondEsq, CondDir, Cond)
     ;   copy_term((GenGoal, GenBody), (Goal, Body)),
         ebg1(Body, GenBody, Cond)).

/*
ebg1(Goal, GenGoal, Cond) :-
    \=(Goal, (_, _)),
    %not(operational(Goal)),
    (built_in(Goal) ; operational(Goal) *-> call(Goal)  % Podemos verificar aqui se Goal já é operacional
    ;   clause(GenGoal, GenBody),
        (encontra_cortes(GenBody, GenBodyEsq, GenBodyDir) *-> copy_term(GenBodyEsq, BodyEsq),
                                                             copy_term(GenBodyDir, BodyDir),
                                                             ebg1(BodyEsq, GenBodyEsq, CondEsq), !,
                                                             ebg1(BodyDir, GenBodyDir, CondDir),
                                                             =(GenGoal, (GenBodyEsq, !, GenBodyDir)),
                                                             and(CondEsq, CondDir, Cond)
        ;   copy_term((GenGoal, GenBody), (Goal, Body)),
            ebg1(Body, GenBody, Cond))).
*/

% Predicados Auxiliares
and(true, Cond, Cond) :- !.
and(Cond, true, Cond) :- !.
and(Cond1, Cond2, (Cond1, Cond2)).

built_in(Predicate) :-
    predicate_property(Predicate, built_in).

encontra_cortes((E, (!, Elementos)), E, Elementos) :- \=(E, (_, _)), !.
encontra_cortes((!, Elementos), !, Elementos) :- !.
encontra_cortes((E, !), E, !) :- !.
encontra_cortes((E1, Elementos), (E1, TuplaEsq), TuplaDir) :-
    encontra_cortes(Elementos, TuplaEsq, TuplaDir).


/* Testes:
 =(Goal, go(3, 6, Moves)), =(GenGoal, go(L1, L2, GenMoves)), ebg1(Goal, GenGoal, Cond).
 Está repetindo muitas soluções.
 Ou seja, criamos muitos pontos de escolhas

 O do Bratko funciona perfeitamente, sem repetir soluções. Isto
 significa que eu adicionei pontos de escolha.
 É CLARO!! SER BUILTIN NÃO PRESERVA CONDITION!!!

 =(Goal, go(3, 6, Moves)), =(GenGoal, go(L1, L2, GenMoves)), ebg1(Goal, GenGoal, Cond).
Goal = go(3, 6, [up, up, up]),
Moves = [up, up, up],
GenGoal = go(L1, L2, GenMoves),
Cond = (move_list(GenMoves, _A), _A=:=L2-L1) ;
Goal = go(3, 6, [down, up, up, up, up]),
Moves = [down, up, up, up, up],
GenGoal = go(L1, L2, GenMoves),
Cond = (move_list(GenMoves, _A), _A=:=L2-L1) ;
Goal = go(3, 6, [up, down, up, up, up]),
Moves = [up, down, up, up, up],
GenGoal = go(L1, L2, GenMoves),
Cond = (move_list(GenMoves, _A), _A=:=L2-L1) ;
Goal = go(3, 6, [up, up, down, up, up]),
Moves = [up, up, down, up, up],
GenGoal = go(L1, L2, GenMoves),
Cond = (move_list(GenMoves, _A), _A=:=L2-L1) ;
Goal = go(3, 6, [up, up, up, down, up]),
Moves = [up, up, up, down, up],
GenGoal = go(L1, L2, GenMoves),
Cond = (move_list(GenMoves, _A), _A=:=L2-L1) ...

Perfeito, no entanto, Cond agora não está unificando, vamos descobrir o
porquê.

Executando sem a cláusula de built_in Cond fica perfeito:

=(Goal, go(3, 6, Moves)), =(GenGoal, go(L1, L2, GenMoves)), ebg1(Goal, GenGoal, Cond).
Goal = go(3, 6, [up, up, up]),
Moves = GenMoves, GenMoves = [up, up, up],
GenGoal = go(L1, L2, [up, up, up]),
Cond = (0+1+1+1=:=L2-L1) ;

O problema está em como built_in é interpretado.

=(Goal, go(3, 6, Moves)), =(GenGoal, go(L1, L2, GenMoves)), ebg1(Goal, GenGoal, Cond).
Goal = go(3, 6, [up, up, up]),
Moves = GenMoves, GenMoves = [up, up, up],
GenGoal = go(L1, L2, [up, up, up]),
Cond = (0+1+1+1=:=L2-L1) ;
Goal = go(3, 6, [down, up, up, up, up]),
Moves = GenMoves, GenMoves = [down, up, up, up, up],
GenGoal = go(L1, L2, [down, up, up, up, up]),
Cond = (0+1+1+1+1+ -1=:=L2-L1) .

A cláusula de não ser operacional mas ser builtin é necessária para, por
exemplo, executar o P91 dos 99P.

?- =(Goal, knight(5, L)), =(GenGoal, knight(N, GenL)), ebg1(Goal, GenGoal, Cond).
Goal = knight(5, [5/1, 4/3, 5/5, 3/4, 1/5, 2/3, 4/2, 2/1, 1/3, 2/5, 4/4, 5/2, 3/1, 1/2, 2/4, 4/5, 3/3, 5/4, 3/5, 1/4, 2/2, 4/1, 5/3, 3/2, 1/1]),
L = [5/1, 4/3, 5/5, 3/4, 1/5, 2/3, 4/2, 2/1, 1/3, 2/5, 4/4, 5/2, 3/1, 1/2, 2/4, 4/5, 3/3, 5/4, 3/5, 1/4, 2/2, 4/1, 5/3, 3/2, 1/1],
GenGoal = knight('$VAR'('N'), '$VAR'('GenL')),
Cond = (casas('$VAR'('N'), _246930), delete(_246930, 1/1, _246944), knight2('$VAR'('N'), [1/1], _246944, '$VAR'('GenL')))

Se mantemos essa cláusula, obtemos isto:
=(Goal, go(3, 6, Moves)), =(GenGoal, go(L1, L2, GenMoves)), ebg1(Goal, GenGoal, Cond).
Goal = go(3, 6, [up, up, up]),
Moves = [up, up, up],
GenGoal = go(L1, L2, GenMoves),
Cond = (move_list(GenMoves, _A), _A=:=L2-L1) .

O que não está errado, mas é diferente do que o metainterpretador do
Bratko propõe.
*/
