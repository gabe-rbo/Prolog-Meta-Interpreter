/*
set_prolog_flag(stack_limit, 4_294_967_296), numlist(1, 4, Queens), Goal1 = n_queens(Queens, Sol), GenGoal1 = n_queens(GenQ, GenS), Goal2 = ebg(Goal1, GenGoal1, NewRule1), GenGoal2 = ebg(G, GG, NR), Goal3 = ebg(Goal2, GenGoal2, NewRule2), GenGoal3 = ebg(G1, GG1, NR1), Goal4 = ebg(Goal3, GenGoal3, NewRule3), GenGoal4 = ebg(G2, GG2, NR2), Goal5 = ebg(Goal4, GenGoal4, NewRule4), GenGoal5 = ebg(G3, GG3, NR3), Goal6 = ebg(Goal5, GenGoal5, NewRule5), GenGoal6 = ebg(G4, GG4, NR4), time_to_file('time_ebg6_4_queens.txt', ebg(Goal6, GenGoal6, NewRule6)),  !, tell('ebg6_4_queens.pl'), write(NewRule6), write('.'), told.

SWI-Prolog crashes before any solution is found.
*/
