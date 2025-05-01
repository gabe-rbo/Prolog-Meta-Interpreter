mi9(true) :- !.
mi9(!) :- !. 

mi9(Goal) :-  % Goal não pode ser uma tupla, tem que ser um predicado
    ((\=(Goal, (_, _)), \=(Goal, (_;_))); (=(Goal, (_ -> _; _)); =(Goal, (_ -> _)))), !,
    (predicate_property(Goal, built_in) -> call(Goal)
    ;   clause(Goal, Body),
        (encontra_cortes(Body, BodyEsq, BodyDir) -> mi9(BodyEsq), !, mi9(BodyDir) % Cortamos a raiz.
        ;   mi9(Body))).

mi9((Goal1, Goals)) :-  % Tupla (e).
    (encontra_cortes((Goal1, Goals), GoalsEsq, GoalsDir) -> mi9(GoalsEsq), !, mi9(GoalsDir)
    ;   mi9(Goal1), mi9(Goals)).

mi9((Goal1; Goals)) :-
    (encontra_cortes((Goal1; Goals), GoalsEsq, GoalsDir) -> (
        =((Goal1; Goals), (GoalsEsq; (!, GoalsDir))) -> (mi9(GoalsEsq); !, mi9(GoalsDir))
      ; =((Goal1; Goals), (GoalsEsq; (!; GoalsDir))) -> (mi9(GoalsEsq); !; mi9(GoalsDir))
      ;  mi9(GoalsEsq), !)
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
