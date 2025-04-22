% Esse é um metainterpretador prolog que realiza trace.

membro(X, [X|_]).
membro(X, [_|L]) :- membro(X, L).


prove(true) :- !.

prove( (Goal1, Goal2)) :- !,
    prove( Goal1),
    prove( Goal2).

prove(Goal) :-
    write('Call: '), write(Goal), nl,
    clause(Goal, Body),
    prove(Body),
    write('Exit: '), write(Goal), nl.

% Esse metainterpretador tem vários defeitos
% 1) Não realiza trace de programas retornam false;
% 2) Não há indicativo de backtracking caso o mesmo Goal é refeito.

% Testes
% ------------------------------
% ?- prove(membro(X, [a, b, c]))
% Call: membro(_1264,[a,b,c])
% Exit: membro(a,[a,b,c])
% X = a ;
% Call: membro(_1264,[b,c])
% Exit: membro(b,[b,c])
% Exit: membro(b,[a,b,c])
% X = b ;
% Call: membro(_1264,[c])
% Exit: membro(c,[c])
% Exit: membro(c,[b,c])
% Exit: membro(c,[a,b,c])
% X = c ;
% Call: membro(_1264,[])
% false.
