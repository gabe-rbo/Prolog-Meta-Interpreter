% Este metainterpretador grava a árvore de prova.

mi8(Goal) :- mi8(Goal, Prova), nl, abrir(Prova), nl.

mi8(true, []) :- !.
mi8(!, []) :- !.

mi8(Goal, [Goal|[Corpo]]) :-
    \=(Goal, (_, _)),
    (built_in(Goal) -> call(Goal)
    ;   clause(Goal, Body),
        (encontra_cortes(Body, BodyEsq, BodyDir) -> mi8(BodyEsq, CorpoEsq), !,
                                                    mi8(BodyDir, CorpoDir),
                                                    concatenar(CorpoEsq, [!|CorpoDir],
                                                               Corpo)
        ;   mi8(Body, Corpo))).

mi8((Goal1, Goals), [Corpo]) :-  % Tupla.
    (encontra_cortes((Goal1, Goals), GoalsEsq, GoalsDir) -> mi8(GoalsEsq, CorpoEsq), !,
                                                            mi8(GoalsDir, CorpoDir),
                                                            concatenar(CorpoEsq, [!|CorpoDir],
                                                                       Corpo)
    ;   mi8(Goal1, CorpoEsq), mi8(Goals, CorpoDir),
        concatenar(CorpoEsq, CorpoDir, Corpo)).

% Predicados Auxiliares
built_in(Predicate) :-
    predicate_property(Predicate, built_in).

encontra_cortes((E, (!, Elementos)), E, Elementos) :- \=(E, (_, _)), !.
encontra_cortes((!, Elementos), !, Elementos) :- !.
encontra_cortes((E, !), E, !) :- !.
encontra_cortes((E1, Elementos), (E1, TuplaEsq), TuplaDir) :-
    encontra_cortes(Elementos, TuplaEsq, TuplaDir).

concatenar([], L2, L2).
concatenar([X|L1], L2, [X|L]) :-
    concatenar(L1, L2, L).

abrir(Prova) :- not(abrir(Prova, 0)).

abrir([], _).

abrir([Cabeca1, Cabeca2|Cauda], N) :- not(is_list(Cabeca1)), not(is_list(Cabeca2)),
    %tab(N),
    escreve_barras(N), write(Cabeca1), nl,
    abrir([Cabeca2|Cauda], N).


abrir([Cabeca1, Cabeca2|Cauda], N) :- not(is_list(Cabeca1)), is_list(Cabeca2),
    %tab(N)
    escreve_barras(N), write(Cabeca1), nl,
    N1 is N + 1,
    abrir([Cabeca2|Cauda], N1).

abrir([Cabeca1, Cabeca2|Cauda], N) :- is_list(Cabeca1), not(is_list(Cabeca2)),
    abrir(Cabeca1, N),
    N1 is N - 1,
    abrir([Cabeca2|Cauda], N1).

abrir([Cabeca1, Cabeca2|Cauda], N) :- is_list(Cabeca1), is_list(Cabeca2),
    abrir(Cabeca1, N),
    N1 is N + 1,
    abrir([Cabeca2|Cauda], N1).

abrir([L], N) :- is_list(L),
    abrir(L, N).

escreve_barras(0) :- !.
escreve_barras(N) :-
    write('|'),
    N1 is N - 1,
    escreve_barras(N1).
