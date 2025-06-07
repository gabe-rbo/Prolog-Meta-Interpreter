test_goal(Goal) :-
    write('Testing: '), print(Goal), nl,
    findall(Goal, Goal, NativeSolutions),
    findall(Goal, mi(Goal), MiSolutions),
    (   NativeSolutions == MiSolutions
    ->  format('  [PASS] Both produced: ~p~n~n', [NativeSolutions])
    ;   format('  [FAIL]~n'),
        format('    Native -> ~p~n', [NativeSolutions]),
        format('    mi     -> ~p~n~n', [MiSolutions]),
        fail
    ).

run_tests :-
    % 1. Simple conjunction and unification
    test_goal( (X=a, Y=b) ),

    % 2. Backtracking and disjunction
    test_goal( (mymember(X, [1,2]), X > 1 ; mymember(X, [3,4])) ),

    % 3. Built-ins
    test_goal( (mymember(X,[1,2,3]), Y is X * 2) ),

    % 4. Simple Cut
    % The cut prunes the choice for the first mymember, but not the second.
    test_goal( (mymember(X, [1,2]), !, mymember(Y, [a,b])) ),

    % 5. THE DEFINITIVE CUT SCOPING TEST
    % This is the kind of test that proves the cut's scope is correct.
    % We define helper predicates for this test.
    % test_p(X) should succeed once with X=a, then the parent_p should succeed.
    test_goal( parent_p(X) ),

    % 6. Failure
    test_goal( (mymember(X, [1,2]), X > 5) ),
    test_goal( fail ),

    % 7. If-Then-Else
    test_goal( (mymember(X, [1,2,3]), (X > 1 -> Y=gt ; Y=le)) ),

    write('All tests completed.'), nl.

% --- Helper predicates for the test cases ---
parent_p(X) :- test_p(X).
parent_p(final).

test_p(X) :- mymember(X, [a,b]), !.

mymember(X, [X|_]).
mymember(X, [X|L]) :-
    mymember(X, L).
