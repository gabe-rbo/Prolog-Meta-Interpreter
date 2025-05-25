mi(true) :- !.
mi(!) :- !.
mi(fail) :- !, fail.


mi(Goal) :-
    ((Goal \= (_, _), Goal \= (_; _)) ; Goal \= (_ -> _) ; Goal = (_ -> _ ; _)), !,
    (predicate_property(Goal, built_in) -> call(Goal)
    ;   clause(Goal, Body),
        (   encontra_cortes(Body, TEsq, TDir, F) -> (
                                                  F = 'E,' -> (!, mi(TDir))
                                                 ;F = 'E;' -> (!; mi(TDir))
                                                 ;F = ';E' -> (mi(TEsq); !)
                                                 ;F = ',E' -> (mi(TEsq), !)
                                                 ;F = ',,' -> (mi(TEsq), !, mi(TDir))
                                                 ;F = ',;' -> (mi(TEsq), !; mi(TDir))
                                                 ;F = ';;' -> (mi(TEsq); !; mi(TDir))
                                                 ;F = ';,' -> (mi(TEsq); !, mi(TDir)))
        ;   (Body = ! -> !)
        ;   mi(Body))).

mi((!, Goal)) :- !, mi(Goal).
mi((!; Goal)) :- !; mi(Goal).
mi((Goal, !)) :- mi(Goal), !.
mi((Goal; !)) :- mi(Goal); !.

mi((A, B)) :-
        (   encontra_cortes(A, TAEsq, TADir, FA) -> (
                                                  FA = 'E,' -> (!, mi(TADir))
                                                 ;FA = 'E;' -> (!; mi(TADir))
                                                 ;FA = ';E' -> (mi(TAEsq); !)
                                                 ;FA = ',E' -> (mi(TAEsq), !)
                                                 ;FA = ',,' -> (mi(TAEsq), !, mi(TADir))
                                                 ;FA = ',;' -> (mi(TAEsq), !; mi(TADir))
                                                 ;FA = ';;' -> (mi(TAEsq); !; mi(TADir))
                                                 ;FA = ';,' -> (mi(TAEsq); !, mi(TADir)))
    ;   mi(A)),
        (   encontra_cortes(B, TBEsq, TBDir, FB) -> (
                                                  FB = 'E,' -> (!, mi(TBDir))
                                                 ;FB = 'E;' -> (!; mi(TBDir))
                                                 ;FB = ';E' -> (mi(TBEsq); !)
                                                 ;FB = ',E' -> (mi(TBEsq), !)
                                                 ;FB = ',,' -> (mi(TBEsq), !, mi(TBDir))
                                                 ;FB = ',;' -> (mi(TBEsq), !; mi(TBDir))
                                                 ;FB = ';;' -> (mi(TBEsq); !; mi(TBDir))
                                                 ;FB = ';,' -> (mi(TBEsq); !, mi(TBDir)))
    ;   mi(B)).

mi((A; B)) :-
        (   encontra_cortes(A, TAEsq, TADir, FA) -> (
                                                  FA = 'E,' -> (!, mi(TADir))
                                                 ;FA = 'E;' -> (!; mi(TADir))
                                                 ;FA = ';E' -> (mi(TAEsq); !)
                                                 ;FA = ',E' -> (mi(TAEsq), !)
                                                 ;FA = ',,' -> (mi(TAEsq), !, mi(TADir))
                                                 ;FA = ',;' -> (mi(TAEsq), !; mi(TADir))
                                                 ;FA = ';;' -> (mi(TAEsq); !; mi(TADir))
                                                 ;FA = ';,' -> (mi(TAEsq); !, mi(TADir)))
    ;   mi(A));
        (   encontra_cortes(B, TBEsq, TBDir, FB) -> (
                                                  FB = 'E,' -> (!, mi(TBDir))
                                                 ;FB = 'E;' -> (!; mi(TBDir))
                                                 ;FB = ';E' -> (mi(TBEsq); !)
                                                 ;FB = ',E' -> (mi(TBEsq), !)
                                                 ;FB = ',,' -> (mi(TBEsq), !, mi(TBDir))
                                                 ;FB = ',;' -> (mi(TBEsq), !; mi(TBDir))
                                                 ;FB = ';;' -> (mi(TBEsq); !; mi(TBDir))
                                                 ;FB = ';,' -> (mi(TBEsq); !, mi(TBDir)))
    ;   mi(B)).



% ===================== Predicados Auxiliares =====================
encontra_cortes((!, Elementos), !, Elementos, 'E,') :- !. % Empty ,
encontra_cortes((!; Elementos), !, Elementos, 'E;') :- !.
encontra_cortes((Elementos, !), Elementos, !, ',E') :- Elementos \= (_ -> _), !.
encontra_cortes((Elementos; !), Elementos, !, ';E') :- !.

encontra_cortes((E, !, Elementos), E, Elementos, ',,') :- !.
encontra_cortes((E, !; Elementos), E, Elementos, ',;') :- !.
encontra_cortes((E; !; Elementos), E, Elementos, ';;') :- !.
encontra_cortes((E; !, Elementos), E, Elementos, ';,') :- !.

encontra_cortes((A -> !), A, !, ',E') :- !. % A -> B == A, B.
encontra_cortes((A -> B ; !), (A, B), !, ';E') :- B \= !, !. % A -> B ; ! == (A, B) ; !.
encontra_cortes((A -> ! ; C), A, C, ',;') :- !. % A , ! ; C == (A, !) ; C.
encontra_cortes((A -> ! ; !), A, !, ',E') :- !. % (A , !) ; ! == (A ; !), (! ; !) == A , !.

encontra_cortes((A -> B), (A, TEsq), TDir, F) :- !,
    encontra_cortes(B, TEsq, TDir, F).

encontra_cortes(((A; B) ; C), TEsq, TDir, F) :- !,
    encontra_cortes((A ; (B ; C)), TEsq, TDir, F).

encontra_cortes((A ; B), (A ; TBEsq), TBDir, F) :-
    A \= !, !,
    encontra_cortes(B, TBEsq, TBDir, F).

encontra_cortes((A, B), (A, TBEsq), TBDir, F) :-
    A \= !, A \= (_ , _),
    B \= (_ ; _), !,
    encontra_cortes(B, TBEsq, TBDir, F).

encontra_cortes(((A, B), C), TEsq, TDir, F) :-
    C \= (_ ; _), !,
    encontra_cortes((A, (B, C)), TEsq, TDir, F).






