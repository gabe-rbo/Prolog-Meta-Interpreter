mi6(true) :- !.
mi6(','()) :- !. % Tupla vazia

mi6(Goal) :-  % Goal não pode ser uma tupla, tem que ser um predicado
    \=(Goal, (_, _)),
    (built_in(Goal) -> call(Goal)
    ;   clause(Goal, Body),
        (encontra_cortes(Body, BodyEsq, BodyDir) -> mi6(BodyEsq), !, mi6(BodyDir) % Cortamos a raiz.
        ;   mi6(Body))).

mi6((Goal1, Goals)) :-  % Tupla.
    (encontra_cortes((Goal1, Goals), GoalsEsq, GoalsDir) -> mi6(GoalsEsq), !, mi6(GoalsDir)
    ;   mi6(Goal1), mi6(Goals)).

% Predicados Auxiliares
built_in(Predicate) :-
    predicate_property(Predicate, built_in).

% Encontra cortes agora funciona recursivamente sobre tuplas.
encontra_cortes((E, (!, Elementos)), E, Elementos) :- \=(E, (_, _)), !.
encontra_cortes((!, Elementos), ','(), Elementos) :- !. % Não há tupla vazia
encontra_cortes((E, !), E, ','()) :- !.
encontra_cortes((E1, Elementos), (E1, TuplaEsq), TuplaDir) :-
    encontra_cortes(Elementos, TuplaEsq, TuplaDir).
