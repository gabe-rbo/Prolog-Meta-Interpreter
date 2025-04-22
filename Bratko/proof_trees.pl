% Goal: True -> Proof_Tree(Goal): True.
% (Goal1, Goal2): True -> Proof_Tree(Goal1, Goal2): True
% Para um Goal que corresponde à cabeça de uma cláusula cujo corpo é
% Corpo, a árvore de prova é Goal <== Proof_Tree(Goal) onde Proof_Tree
% é a árvore de prova do corpo.

:- op(500, xfy, <==).
% :- dynamic([gives/3, would_please/2, would_confort/2,
% feels_sorry_for/2, likes/2, needs/2, operational/1]).

prove( true, true) :- !.

prove( ( Goal1, Goal2), ( Proof1, Proof2)) :- !,
    prove( Goal1, Proof1),
    prove( Goal2, Proof2).

prove(Goal, Goal <== Proof) :-
    %not(=(Goal, ','(_, _))),
    clause(Goal, Body),
    prove(Body, Proof).

% Nos capítulos 15 e 16, árvores de prova foram utilizados como uma base
% para gerar o "como?" de uma explicação em um sistema esperto. Vamos
% usar isso para Explained-Based Generalization.

% Explained-Based Generalization

gives( Person1, Person2, Gift) :-
    likes( Person1, Person2),
    would_please( Gift, Person2).

gives( Person1, Person2, Gift) :-
    feels_sorry_for( Person1, Person2),
    would_confort( Gift, Person2).

would_please( Gift, Person) :-
    needs( Person, Gift).

would_confort( Gift, Person) :-
    likes( Person, Gift).

feels_sorry_for( Person1, Person2) :-
    %not(==(Person1, Person2)),
    likes( Person1, Person2),
    sad( Person2).

feels_sorry_for( Person, Person) :-
    sad( Person).


operational( likes( _ ,_)).
operational( needs( _, _)).
operational( sad(_)).

likes( john, annie).
likes( john, john).
likes( john, chocolate).
%likes( john, chocolate).
needs( annie, tennis_racket).
%needs( john, chocolate).
sad( john).

% ========================
% Outra teoria de domínio
% ========================

go( Level, GoalLevel, Moves) :-
    move_list( Moves, Distance),
    =:=(Distance, GoalLevel - Level).

move_list([], 0).
move_list([Move1|Moves], Distance + Distance1) :-
    move_list(Moves, Distance),
    move(Move1, Distance1).

move(up, 1).
move(down, -1).

operational(=:=(_, _)).

% ebg (Goal, GeneralizedGoal, SufficientCondition):
%  SufficientCondition in terms of operational predicates garantee  that
%  generalization of Goalm GeneralizedGoal, is true.
%  GeneralizedGoal must not be a variable

ebg( true, true, true) :- !. % Para não dar erro de private_procedure true/0

ebg( Goal, GenGoal, GenGoal) :-
    operational( GenGoal), !,
    call( Goal).

ebg( ( Goal1, Goal2), ( Gen1, Gen2), Cond) :- !,
    ebg( Goal1, Gen1, Cond1),
    ebg( Goal2, Gen2, Cond2),
    and( Cond1, Cond2, Cond).  % Cond = (Cond1, Cond2).

ebg( Goal, GenGoal, Cond) :-
    not(operational( Goal)),
    clause( GenGoal, GenBody),  % Queremos provar a generalização.
    copy_term( ( GenGoal, GenBody),
               ( Goal, Body)), % Cópia de (GenGoal, GenBody). As soluções
                               % devem coincidir!
    ebg( Body, GenBody, Cond).

and(true, Cond, Cond) :- !. % (true and Cond) <==> Cond.
and(Cond, true, Cond) :- !. % (Cond and True) <==> Cond.
and(Cond1, Cond2, (Cond1, Cond2)).

/*
 Testes EBG:
=(Goal, go(3, 6, Moves)), =(GenGoal, go(Level1, Level2, GenMoves)),
ebg(Goal, GenGoal, Condition).
, asserta((GenGoal :- Condition)).

Goal = go(3, 6, [up, up, up]), Moves = GenMoves, GenMoves = [up, up,
up], GenGoal = go(L1, L2, [up, up, up]), Condition = (0+1+1+1=:=L2-L1) ;
Goal = go(3, 6, [down, up, up, up, up]), Moves = GenMoves, GenMoves =
[down, up, up, up, up], GenGoal = go(L1, L2, [down, up, up, up, up]),
Condition = (0+1+1+1+1+ -1=:=L2-L1) ; ...

 Ao gerar soluções generalizadas, podemos adicioná-las como cláusulas
 do programa para responder coisas similares sem precisar realizar
 buscas.

*/
