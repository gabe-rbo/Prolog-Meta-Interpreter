% MI5, Procurando cortes
% Acredito que metainterprete o corte perfeitamente

mi5(true) :- !.
mi5([]) :- !. % Para o lado vazio do corte.

mi5(Goal) :-  % Goal não pode ser uma tupla, tem que ser um predicado
    \=(Goal, (_, _)),
    (built_in(Goal) -> call(Goal)
    ;   clause(Goal, Body), mi4(Body)).

mi5((Goal1, Goals)) :-  % Tupla
    (encontra_cortes((Goal1, Goals), GoalsEsq, GoalsDir) -> mi5(GoalsEsq), !, mi5(GoalsDir)
    ;   mi5(Goal1), mi5(Goals)).

% Predicados Auxiliares
built_in(Predicate) :-
    predicate_property(Predicate, built_in).

converte(([]), []).
converte(A, [A]) :- \=(A, (_, _)).  % A não pode ser uma tupla
converte((A, B), [A | Bs]) :- !,
    converte(B, Bs).

concatenar([], L, L).
concatenar([X|L1], L2, [X|L3]) :-
    concatenar(L1, L2, L3).

encontra_cortes(Tupla, TuplaEsq, TuplaDir) :-
    converte(Tupla, Lista),
    concatenar(LEsq, [!|LDir], Lista),
    converte(TuplaEsq, LEsq),
    converte(TuplaDir, LDir), !.
