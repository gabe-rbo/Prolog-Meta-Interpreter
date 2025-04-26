% Este arquivo decida-se à usar dos metainterpretadores completos para
% criar a EBG completa. Aqui, a EBG será baseada no Livro do Bratko e, como ela por si só é um
% metainterpretador, irei implementar também o meu metainterpretador completo.

ebg1(true, true, true).
ebg1(!, !, !). 

ebg1(Goal, GenGoal, GenGoal) :-
    built_in(GenGoal),
    call(Goal).


ebg1(Goal, GenGoal, GenGoal) :-  % Será que deve ser mantida?
    not(operational(Goal)),
    built_in(Goal),
    call(Goal).

ebg1((Goal1, Goal2), (Gen1, Gen2), Cond) :-
    (encontra_cortes((Goal1, Goal2), GoalsEsq, GoalsDir) -> ebg1(GoalsEsq, GenEsq, CondEsq), !,
                                                            ebg1(GoalsDir, GenDir, CondDir),
                                                            and(CondEsq, CondDir, Cond),
                                                            =((Gen1, Gen2), (GenEsq, GenDir))
    ;   ebg1(Goal1, Gen1, Cond1),
        ebg1(Goal2, Gen2, Cond2),
        and(Cond1, Cond2, Cond)).

ebg1(Goal, GenGoal, Cond) :-
    \=(Goal, (_, _)),
    not(built_in(Goal)),
    not(operational(Goal)),
    clause(GenGoal, GenBody),
    (encontra_cortes(GenBody, GenBodyEsq, GenBodyDir) -> copy_term(GenBodyEsq, BodyEsq),
                                                         copy_term(GenBodyDir, BodyDir),
                                                         ebg1(BodyEsq, GenBodyEsq, CondEsq), !,
                                                         ebg1(BodyDir, GenBodyDir, CondDir),
                                                         =(GenGoal, (GenBodyEsq, !, GenBodyDir)),
                                                         and(CondEsq, CondDir, Cond)
     ;   copy_term((GenGoal, GenBody), (Goal, Body)),
         ebg1(Body, GenBody, Cond)).
         

% Predicados Auxiliares
and(true, Cond, Cond) :- !.
and(Cond, true, Cond) :- !.
and(Cond1, Cond2, (Cond1, Cond2)).

built_in(Predicate) :-
    predicate_property(Predicate, built_in).

encontra_cortes((E, (!, Elementos)), E, Elementos) :- \=(E, (_, _)), !.
encontra_cortes((!, Elementos), !, Elementos) :- !.
encontra_cortes((E, !), E, !) :- !.
encontra_cortes((E1, Elementos), (E1, TuplaEsq), TuplaDir) :-
    encontra_cortes(Elementos, TuplaEsq, TuplaDir).
