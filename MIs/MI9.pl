mi9(true) :- !.
mi9(!) :- !. 


mi9(Goal) :-  % Goal não pode ser uma tupla, tem que ser um predicado
    ((\=(Goal, (_, _)), \=(Goal, (_;_))), \=(Goal, [_]); (=(Goal, (_ -> _; _)); =(Goal, (_ -> _)))), !,
    (predicate_property(Goal, built_in) -> call(Goal)
    ;   clause(Goal, Body),
        (encontra_cortes(Body, BodyEsq, BodyDir, _, _) -> mi9(BodyEsq), !, mi9(BodyDir) % Cortamos a raiz.
        ;   mi9(Body))).

mi9((Goal1, Goals)) :-  % Tupla de e's.
    \=(Goal1, (_,_)), \=(Goal1, (_;_)), !,
    (encontra_cortes((Goal1, Goals), GoalsEsq, GoalsDir, ',', ',') -> mi9(GoalsEsq), !, mi9(GoalsDir)
    ;   (mi9(Goal1), mi9(Goals))).

mi9((Goals1, Goals2)) :- % E's de tuplas
    (=(Goals1, (_,_)); =(Goals1, (_;_))), !,
    (encontra_cortes(Goals1, Goals1Esq, Goals1Dir, FTras1, FFront1) ->
    (=(FTras1, ';'), =(FFront1, ';') -> (mi9(Goals1Esq); !; mi9(Goals1Dir))
     ;=(FTras1, ';'), =(FFront1, ',') -> (mi9(Goals1Esq); !, mi9(Goals1Dir))
     ;=(FTras1, ','), =(FFront1, ';') -> (mi9(Goals1Esq), !; mi9(Goals1Dir))
     ;=(FTras1, ''), =(FFront1, ',') -> (!, mi9(Goals1Dir))
     ;=(FTras1, ''), =(FFront1, ';') -> (!; mi9(Goals1Dir))
     ;=(FTras1, ','), =(FFront1, '') -> (mi9(Goals1Esq), !)
     ;=(FTras1, ';'), =(FFront1, '') -> (mi9(Goals1Esq); !)
     ;  mi9(Goals1Esq), !, mi9(Goals1Dir))
    ; mi9(Goals1)),
    (encontra_cortes(Goals2, Goals2Esq, Goals2Dir, FTras2, FFront2) ->
    (=(FTras2, ';'), =(FFront2, ';') -> (mi9(Goals2Esq); !; mi9(Goals2Dir))
     ;=(FTras2, ';'), =(FFront2, ',') -> (mi9(Goals2Esq); !, mi9(Goals2Dir))
     ;=(FTras2, ','), =(FFront2, ';') -> (mi9(Goals2Esq), !; mi9(Goals2Dir))
     ;=(FTras2, ''), =(FFront2, ',') -> (!, mi9(Goals2Dir))
     ;=(FTras2, ''), =(FFront2, ';') -> (!; mi9(Goals2Dir))
     ;=(FTras2, ','), =(FFront2, '') -> (mi9(Goals2Esq), !)
     ;=(FTras2, ';'), =(FFront2, '') -> (mi9(Goals2Esq); !)
     ;  mi9(Goals2Esq), !, mi9(Goals2Dir))
    ; mi9(Goals2)). 

mi9((Goal1;Goals)) :-  % Tupla de ou's ou ou's de tuplas.
    (encontra_cortes((Goal1;Goals), GoalsEsq, GoalsDir, FTras, FFront) ->
     (=(FTras, ';'), =(FFront, ';') -> (mi9(GoalsEsq); !; mi9(GoalsDir))
     ;=(FTras, ';'), =(FFront, ',') -> (mi9(GoalsEsq); !, mi9(GoalsDir))
     ;=(FTras, ','), =(FFront, ';') -> (mi9(GoalsEsq), !; mi9(GoalsDir))
     ;=(FTras, ''), =(FFront, ',') -> (!, mi9(GoalsDir))
     ;=(FTras, ''), =(FFront, ';') -> !, (!; mi9(GoalsDir))
     ;=(FTras, ','), =(FFront, '') -> (mi9(GoalsEsq), !)
     ;=(FTras, ';'), =(FFront, '') -> (mi9(GoalsEsq); !), !  % o ; não considera o corte como corte
     ;  mi9(GoalsEsq), !, mi9(GoalsDir))
    ; (mi9(Goal1); mi9(Goals))).

mi9([Goals]) :-   % Para as nested lists criadas.
    mi9(Goals).

% Predicados auxiliares.
% Not nested
encontra_cortes((!, Elementos), !, Elementos, '', ',') :- \=(Elementos, (_, _)), \=(Elementos, (_;_)), !.
encontra_cortes((!; Elementos), !, Elementos, '', ';') :- \=(Elementos, (_, _)), \=(Elementos, (_;_)), !.

encontra_cortes((E, !, Elementos), E, Elementos, ',', ',') :- \=(E, (_, _)), \=(E, (_;_)), !.
encontra_cortes((E, !; Elementos), E, Elementos, ',', ';') :- \=(E, (_, _)), \=(E, (_;_)), !.
encontra_cortes((E; !; Elementos), E, Elementos, ';', ';') :- \=(E, (_, _)), \=(E, (_;_)), !.
encontra_cortes((E; !, Elementos), E, Elementos, ';', ',') :- \=(E, (_, _)), \=(E, (_;_)), !.

encontra_cortes((Elementos, !), Elementos, !, ',', '') :- \=(Elementos, (_, _)), \=(Elementos, (_;_)), !.
encontra_cortes((Elementos; !), Elementos, !, ';', '') :- \=(Elementos, (_, _)), \=(Elementos, (_;_)), !.

% Nested.
% Usaremos [E] já que não podemos simplesmente (E)
encontra_cortes((!, Elementos), !, [Elementos], '', ',') :- (=(Elementos, (_, _)); =(Elementos, (_;_))), !.
encontra_cortes((!; Elementos), !, [Elementos], '', ';') :- (=(Elementos, (_, _)); =(Elementos, (_;_))), !.

encontra_cortes((E, !, Elementos), [E], Elementos, ',', ',') :- (=(E, (_, _)); =(E, (_;_))), !.
encontra_cortes((E, !; Elementos), [E], Elementos, ',', ';') :- (=(E, (_, _)); =(E, (_;_))), !.
encontra_cortes((E; !; Elementos), [E], Elementos, ';', ';') :- (=(E, (_, _)); =(E, (_;_))), !.
encontra_cortes((E; !, Elementos), [E], Elementos, ';', ',') :- (=(E, (_, _)); =(E, (_;_))), !.

encontra_cortes((Elementos, !), [Elementos], !, ',', '') :- (=(Elementos, (_, _)); =(Elementos, (_;_))), !.
encontra_cortes((Elementos; !), [Elementos], !, ';', '') :- (=(Elementos, (_, _)); =(Elementos, (_;_))), !.

encontra_cortes((T1;T2), TEsq, TDir, FTras, FFront) :-
    (encontra_cortes(T1, T1Esq, T1Dir, FTras, FFront) -> =(TEsq, T1Esq), =(TDir, (T1Dir;T2))
    ;   encontra_cortes(T2, T2Esq, T2Dir, FTras, FFront), =(TEsq, (T1;T2Esq)), =(TDir, T2Dir)), !.

encontra_cortes((E1, Elementos), (E1, TEsq), TDir, FTras, FFront) :-
    \=(Elementos, (_, _)), \=(Elementos, (_;_)), !,
    encontra_cortes(Elementos, TEsq, TDir, FTras, FFront), !.

encontra_cortes((E1, Elementos, E2), (E1, Elementos, TEsq), TDir, FTras, FFront) :-
    (=(Elementos, (_, _)); =(Elementos, (_;_))), !,
    encontra_cortes(E2, TEsq, TDir, FTras, FFront).

