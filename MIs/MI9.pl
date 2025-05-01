mi9(true) :- !.
mi9(!) :- !. % Tupla vazia

mi9(Goal) :-  % Goal não pode ser uma tupla, tem que ser um predicado
    ((\=(Goal, (_, _)), \=(Goal, (_;_))); (=(Goal, (_ -> _; _)); =(Goal, (_ -> _)))), !,
    (predicate_property(Goal, built_in) -> call(Goal)
    ;   clause(Goal, Body),
        (encontra_cortes(Body, BodyEsq, BodyDir) -> mi9(BodyEsq), !, mi9(BodyDir) % Cortamos a raiz.
        ;   mi9(Body))).

mi9((Goal1, Goals)) :-  % Tupla (e).
    (encontra_cortes((Goal1, Goals), GoalsEsq, GoalsDir) -> mi9(GoalsEsq), !, mi9(GoalsDir)
    ;   mi9(Goal1), mi9(Goals)).

/*
mi9((Goal1; Goals)) :-  % Tupla (ou).
    (encontra_cortes((Goal1; Goals), GoalsEsq, GoalsDir) ->
     (\=(GoalsEsq, !) ->  mi9(GoalsEsq) %=(GoalsEsq, (T1; T2)), (mi9(T1); mi9(T2)), ! %, mi9(GoalsDir)
         ;    =(GoalsDir, (T1; T2)), !, (mi9(T1); mi9(T2))))
     ;   (mi9(Goal1); mi9(Goals)).
*/


/*
mi9((Goal1; Goals)) :-  % Tupla (ou).
    (encontra_cortes((Goal1; Goals), GoalsEsq, GoalsDir) -> % Como recu
     (\=(GoalsEsq, !), \=(GoalsDir, !) -> mi9(GoalsEsq); !, mi9(GoalsEsq)
     %=(GoalsEsq, (T1; T2)), (mi9(T1); (mi9(T2), !, mi9(GoalsDir)))
      ; (\=(GoalsEsq, !), =(GoalsDir, !) -> =(GoalsEsq, (T1; T2)), mi9(T1); mi9(T2), !
         ; =(GoalsEsq, !), \=(GoalsDir, !) -> =(GoalsDir, (T1; T2)), !, mi9(T1); mi9(T2)))
     ; (mi9(Goal1); mi9(Goals))).
*/

mi9((Goal1; Goals)) :-
    (encontra_cortes((Goal1; Goals), GoalsEsq, GoalsDir) -> (
        =((Goal1; Goals), (GoalsEsq; (!, GoalsDir))) -> (mi9(GoalsEsq); !, mi9(GoalsDir))
      ; =((Goal1; Goals), (GoalsEsq; (!; GoalsDir))) -> (mi9(GoalsEsq); !; mi9(GoalsDir))
         % Se esses dois falham, é porque tem vírgula antes de !. Basta descobrir depois.
         % O funtor de tupla é chatésimo!!!
      %; =(Goals, (!; GoalsDir)) -> (mi9(GoalsEsq)), !; mi9(GoalsDir))
      % Essa cláusula de cima é equivalente a apenas mi9(GoalsEsq).
     ;  mi9(GoalsEsq), !)
      %; =((Goal1; Goals), (GoalsEsq, (!, GoalsDir))) -> (mi9(GoalsEsq), !, mi9(GoalsDir))
      %; =((Goal1; Goals), (GoalsEsq, (!; GoalsDir))) -> (mi9(GoalsEsq), !; mi9(GoalsDir)))
    ;   (mi9(Goal1); mi9(Goals))).

% Predicados auxiliares.
encontra_cortes((!, Elementos), !, Elementos) :- !.
encontra_cortes((!; Elementos), !, Elementos) :- !.

encontra_cortes((E, !, Elementos), E, Elementos) :- !.
encontra_cortes((E, !; Elementos), E, Elementos) :- !.
encontra_cortes((E; !; Elementos), E, Elementos) :- !.
encontra_cortes((E; !, Elementos), E, Elementos) :- !.

encontra_cortes((Elementos, !), Elementos, !) :- !.
encontra_cortes((Elementos; !), Elementos, !) :- !.

encontra_cortes((T1;T2), TEsq, TDir) :-
    (encontra_cortes(T1, T1Esq, T1Dir) -> =(TEsq, T1Esq), =(TDir, (T1Dir;T2))
    ;   encontra_cortes(T2, T2Esq, T2Dir), =(TEsq, (T1;T2Esq)), =(TDir, T2Dir)).

encontra_cortes((E1, Elementos), (E1, TEsq), TDir) :-
    encontra_cortes(Elementos, TEsq, TDir).


/*
como mi9(!) é true, isso acaba atrapalhando algumas coisas, por exemplo:
(a, b; c; d, e, f; g; !)

?- encontra_cortes((a, b; c; d, e, f; g; !), T1, T2).
T1 = (a, b;c;d, e, f;g),
T2 = !.

No predicado do ou isso se tornaria

mi9((Goal1; Goals)) :-  % Tupla (ou).
    (encontra_cortes((Goal1, Goals), GoalsEsq, GoalsDir) -> (mi9(GoalsEsq), !; mi9(GoalsDir))
    ;   (mi9(Goal1); mi9(Goals))).

Isto é, Mi9(Algo), !; mi9(!). O que é sempre verdade.
O mesmo para quando mi9(!), !; mi9(Algo). Portanto, precisamos verificar
*/

a.
b.
c :- fail.

/*
trace]  ?- a; b, c.
   Call: (13) a ? creep
   Exit: (13) a ? creep
true ;
   Call: (13) b ? creep
   Exit: (13) b ? creep
   Call: (13) c ? creep
   Call: (14) fail ? creep
   Fail: (14) fail ? creep
   Fail: (13) c ? creep
false.

; funciona como um ou de tudo que vem depois.

a; b.
Se a for true, ele retorna true de imediado, e depois tenta b.
mas, a; !, b ou a, !;b é true caso a seja true, apenas. Logo, quando há
corte não precisamos nem chamar b.

Então isso


mi9((Goal1; Goals)) :-  % Tupla (ou).
    (encontra_cortes((Goal1; Goals), GoalsEsq, GoalsDir) ->
     (\=(GoalsEsq, !), \=(GoalsDir, !) -> =(GoalsEsq, (T1; T2)),mi9(T1); mi9(T2), !, mi9(GoalsDir)
      ; (\=(GoalsEsq, !), =(GoalsDir, !) -> =(GoalsEsq, (T1; T2)),mi9(T1); mi9(T2), !
         ; =(GoalsEsq, !), \=(GoalsDir, !) -> =(GoalsDir, (T1; T2)), !,mi9(T1); mi9(T2)))
     ; (mi9(Goal1); mi9(Goals))).

Po

Mudança de planos. Já sabemos onde está o primeiro ou, basta
identificar os cortes.
*/






