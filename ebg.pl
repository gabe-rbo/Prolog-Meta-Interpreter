ebg(Goal, GenGoal, (GenGoal :- GenBody)) :-
    prolog_current_choice(ChoicePoint),
    ebg(Goal, GenGoal, GenBody, ChoicePoint).

ebg(true, true, true, _ChoicePoint) :- !.

ebg(!, !, true, ChoicePoint) :-
    prolog_cut_to(ChoicePoint).

ebg(Goal, GenGoal, GenGoal, _ChoicePoint) :-
    operational(GenGoal), !, call(Goal).

ebg(Goal, GenGoal, GenGoal, _ChoicePoint) :-
    not(operational(Goal)), Goal \= (_, _), Goal \= (_; _), Goal \= (_ -> _),
    predicate_property(Goal, built_in), !, call(Goal).

ebg(Goal, GenGoal, NewRule, _ChoicePoint) :-
    not(operational(Goal)), not(predicate_property(Goal, built_in)),
    prolog_current_choice(ChoicePoint),
    clause(GenGoal, GenBody),
    copy_term((GenGoal :- GenBody), (Goal :- Body)),
    ebg(Body, GenBody, NewRule, ChoicePoint).

ebg((A, B), (GenA, GenB), NewRule, ChoicePoint) :-
    ebg(A, GenA, NewRuleA, ChoicePoint),
    ebg(B, GenB, NewRuleB, ChoicePoint),
    simplify((NewRuleA, NewRuleB), NewRule).

ebg((A -> B), (GenA -> GenB), NewRule, ChoicePoint) :-
    ebg(A, GenA, NewRuleA), !,
    ebg(B, GenB, NewRuleB, ChoicePoint),
    simplify((NewRuleA -> NewRuleB), NewRule).

ebg((A -> B; _), (GenA -> GenB), NewRule, ChoicePoint) :-
    ebg(A, GenA, NewRuleA), !,
    ebg(B, GenB, NewRuleB, ChoicePoint),
    simplify((NewRuleA -> NewRuleB), NewRule).

ebg((_ -> _; C), GenC, NewRuleC, ChoicePoint) :- !,
    ebg(C, GenC, NewRuleC, ChoicePoint).

ebg((A; B), (GenA; GenB), NewRule, ChoicePoint) :-
    (ebg(A, GenA, NewRuleA, ChoicePoint);
     ebg(B, GenB, NewRuleB, ChoicePoint)),
    simplify((NewRuleA; NewRuleB), NewRule).

simplify((true, NewRuleB), NewRuleB) :- !.
simplify((NewRuleA, true), NewRuleA) :- !.
simplify((NewRuleA, NewRuleB), (NewRuleA, NewRuleB)) :- !.

simplify((true -> NewRuleB), NewRuleB) :- !.
simplify((NewRuleA -> true), NewRuleA) :- !.
simplify((NewRuleA -> NewRuleB), (NewRuleA -> NewRuleB)).

simplify((A;true), A) :- !.
simplify((A;B), A) :- var(B). % B was not yet instanciated.
simplify((true;B), (true;B)).
