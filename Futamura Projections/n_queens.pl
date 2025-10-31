n_queens(S, SP) :-
    perm(S, SP),
    safe(SP).

safe([]).
safe([Q|Qs]):-
    nodiag(Q,Qs,1),
    safe(Qs).

nodiag(_,[],_).
nodiag(Q1,[Q2|Qs],N):-
    noatk(Q1,Q2,N),
    N1 is N + 1,
    nodiag(Q1,Qs,N1).

noatk(Q1, Q2, N) :-
	Q1  > Q2, !,
	D  is Q1 - Q2,
	D  =\= N.

noatk(Q1, Q2, N) :-
	Q1  =< Q2,
	D  is Q2 -Q1,
	D  =\= N.

perm([], []).
perm(L, [X|LP]) :-
    del(X, L, LwoX),
    perm(LwoX, LP).

del(X, [X|L], L).
del(X, [Y|L], [Y|LwoX]) :-
    del(X, L, LwoX).

operational(del(_X, _L, _NL)).
operational(noatk(_Q1, _Q2, _N)).
