:- set_prolog_flag(stack_limit, 128_849_018_880).

%% gen_opt_n_queens(+NQueens, +MaxEBG)
%
%  Main predicate to generate optimized n-queens solvers by building
%  a "tower" of EBG meta-generalization goals.
%
gen_opt_n_queens(NQueens, MaxEBG) :-
    numlist(1, NQueens, QueensList),
    length(GenSList, NQueens),

    writeln('Starting EBG generation...'),
    % Start the generation loop from level 1
    loop_gen(1, MaxEBG, NQueens, QueensList, GenSList),
    writeln('EBG generation complete.').

%% loop_gen(+I, +MaxEBG, +NQueens, +QueensList, +GenSList)
%
%  Recursive loop that generates the file for level I.
%
loop_gen(I, MaxEBG, _, _, _) :-
    I > MaxEBG, % Base case: stop when we exceed the max level
    !,
    true.
loop_gen(I, MaxEBG, NQueens, QueensList, GenSList) :-
    % 1. Define names for this level
    format(atom(FileName), 'opt_ebg_~w_~w_queens.pl', [I, NQueens]),
    format(atom(Functor), 'opt_ebg_~w_~w_queens', [I, NQueens]),
    format('--- Generating level ~w (~w) ---~n', [I, FileName]),

    % 2. Build the nested EBG goal "tower" for this level
    %    This constructs the GOAL *to be generalized*.
    build_ebg_tower(I, NQueens, QueensList, GenSList, Goal, GenGoal),

    % 3. Define the *actual* goal for the EBG engine
    %    This wraps the tower from step 2 inside the final ebg/3 call.
    TermToRun = ebg(Goal, GenGoal, GeneratedRule),

    % 4. Run the EBG engine and capture statistics
    statistics(runtime, [T0|_]),
    statistics(inferences, I0),
    (   call(TermToRun) ->
        true
    ;   format(atom(ErrorMsg), 'EBG call failed for level ~w', [I]),
        writeln(ErrorMsg),
        throw(error(ebg_failed, _))
    ),
    statistics(runtime, [T1|_]),
    statistics(inferences, I1),

    Time is (T1 - T0) / 1000.0,
    Inferences is I1 - I0,
    format('Level ~w generated. (Time: ~3fs, Inferences: ~D)~n', [I, Time, Inferences]),

    % 5. Perform head replacement on the generated rule
    %    The ebg/3 predicate will return a rule headed with 'n_queens' (for I=1)
    %    or 'ebg' (for I > 1). We replace it with our desired 'opt_ebg...' name.
    (   GeneratedRule = (GenHead :- Body)
    ->  GenHead =.. [_OldFunctor | GenArgs], % Deconstruct old head
        NewHead =.. [Functor | GenArgs],     % Construct new head
        NewRule = (NewHead :- Body)
    ;   % Handle case where EBG might return a fact (no body)
        GeneratedRule =.. [_OldFunctor | GenArgs],
        NewRule =.. [Functor | GenArgs]
    ),


    % 6. Write the new rule to its file
    open(FileName, write, Stream),
    % Write the comment header
    QueryTerm = time(ebg(Goal, GenGoal, _NewRule)),
    format(Stream, '/*\n', []),
    format(Stream, 'Generation Query (level ~w for ~w queens):\n?- ~q.\n\n', [I, NQueens, QueryTerm]),
    format(Stream, 'Stats:\n% ~D inferences, ~3f CPU seconds.\n', [Inferences, Time]),
    format(Stream, '*/\n\n', []),
    % Write the rule itself
    writeq(Stream, NewRule), write(Stream, '.'), nl(Stream),
    close(Stream),
    format('File saved: ~w~n', [FileName]),

    % 7. Recurse for the next level
    I_next is I + 1,
    loop_gen(I_next, MaxEBG, NQueens, QueensList, GenSList).


%% build_ebg_tower(+Level, +NQueens, +QL, +GSL, -Goal, -GenGoal)
%
%  Recursively constructs the nested ebg(...) goal term that will
%  be *fed into* the final ebg/3 call.
%
%  *** THIS IS THE FIX: Base case is now Level = 1 ***
%
%  Level 1 (base case): The goal to be generalized is n_queens/2
build_ebg_tower(1, _NQueens, QueensList, GenSList, Goal, GenGoal) :-
    !,
    Goal =.. [n_queens, QueensList, _Sol],
    GenGoal =.. [n_queens, _GenQ, GenSList].
%
%  Level I (recursive case): The goal to be generalized is ebg( Level(I-1) )
build_ebg_tower(I, NQueens, QueensList, GenSList, Goal, GenGoal) :-
    I > 1,
    I_prev is I - 1,
    % Recursively build the goal for the level *below* this one
    build_ebg_tower(I_prev, NQueens, QueensList, GenSList, PrevGoal, PrevGenGoal),

    % The new goal is ebg() wrapping the previous goals
    Goal = ebg(PrevGoal, PrevGenGoal, _Rule),
    % The new general goal is a generic ebg(vars) term
    GenGoal = ebg(_G, _GG, _NR).
