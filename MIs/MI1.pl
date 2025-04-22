% Primeiro meta-interpretador prolog, sem corte.
% Baseado no Bratko. É capaz de metainterpretar builtins

built_in(Predicate) :-
    predicate_property(Predicate, built_in).

mi(true).

mi((Goal1, Goal2)) :-
    mi(Goal1),
    mi(Goal2).

mi(Goal) :-
    (   built_in(Goal) -> call(Goal)
    ;   clause(Goal, Body), mi(Body)).
