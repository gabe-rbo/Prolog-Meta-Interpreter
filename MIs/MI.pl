mi(!, ChoicePoint) :- !, prolog_cut_to(ChoicePoint).
mi(true, _) :- !.

mi(Goal, _) :-
    Goal \= (_, _), Goal\= (_; _), Goal \= (_ -> _), Goal \= !,
    predicate_property(Goal, built_in), !, call(Goal).

mi(Goal, _) :-
    Goal \= (_, _), Goal\= (_; _), Goal \= (_ -> _), Goal \= !,
    prolog_current_choice(ChoicePoint),
    clause(Goal, Body),
    mi(Body, ChoicePoint).

mi((A, B), ChoicePoint) :-
    mi(A, ChoicePoint), mi(B, ChoicePoint).

mi((A; B), ChoicePoint) :-
    mi(A, ChoicePoint); mi(B, ChoicePoint).

mi((A -> B), ChoicePoint) :-
    mi(A), !, mi(B, ChoicePoint).

mi(Goal) :- !, prolog_current_choice(ChoicePoint), mi(Goal, ChoicePoint).

