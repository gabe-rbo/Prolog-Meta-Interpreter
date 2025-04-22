:- op(500, xfy, <==).
:- dynamic([gives/3, would_please/2, would_confort/2, feels_sorry_for/2,
            likes/2, needs/2, operational/1]).

prove( true, true) :- !.

prove( ( Goal1, Goal2), ( Proof1, Proof2)) :-
    prove( Goal1, Proof1),
    prove( Goal2, Proof2).

prove(Goal, Goal <== Proof) :-
	functor(Goal) \== (','),
    clause(Goal, Body),
    prove(Body, Proof).

% Nos capítulos 15 e 16, árvores de prova foram utilizados como uma base
% para gerar o "como?" de uma explicação em um sistema esperto. Vamos
% usar isso para Explained-Based Generalization.

% Explained-Based Generalization

gives( Person1, Person2, Gift) :-
    likes( Person1, Person2),
    would_please( Gift, Person2).

gives( Person1, Person2, Gift) :-
    feels_sorry_for( Person1, Person2),
    would_confort( Gift, Person2).

would_please( Gift, Person) :-
    needs( Person, Gift).

would_confort( Gift, Person) :-
    likes( Person, Gift).

feels_sorry_for( Person1, Person2) :-
    Person1 \== Person2,
    likes( Person1, Person2),
    sad( Person2).

feels_sorry_for( Person, Person) :-
    sad( Person).

operational( likes( _ ,_)).
operational( needs( _, _)).
operational( sad(_)).

likes( john, annie).
likes( john, john).
likes( john, chocolate).
%likes( john, chocolate).
needs( annie, tennis_racket).
%needs( john, chocolate).
sad( john).
