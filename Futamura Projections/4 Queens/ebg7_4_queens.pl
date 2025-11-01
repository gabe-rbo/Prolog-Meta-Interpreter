/*
?- set_prolog_flag(stack_limit, 17179869184), numlist(1, 4, Queens), Goal1 = n_queens(Queens, Sol), GenGoal1 = n_queens(GenQ, GenS), Goal2 = ebg(Goal1, GenGoal1, NewRule1), GenGoal2 = ebg(G, GG, NR), Goal3 = ebg(Goal2, GenGoal2, NewRule2), GenGoal3 = ebg(G1, GG1, NR1), Goal4 = ebg(Goal3, GenGoal3, NewRule3), GenGoal4 = ebg(G2, GG2, NR2), Goal5 = ebg(Goal4, GenGoal4, NewRule4), GenGoal5 = ebg(G3, GG3, NR3), Goal6 = ebg(Goal5, GenGoal5, NewRule5), GenGoal6 = ebg(G4, GG4, NR4), Goal7 = ebg(Goal6, GenGoal6, NewRule6), GenGoal7 = ebg(G5, GG5, NR5), time_to_file('time_ebg7_4_queens.txt', ebg(Goal7, GenGoal7, NewRule7)),  !, tell('ebg7_4_queens.pl'), write(NewRule7), told.
% 8,819,807,577 inferences, 11706.109 CPU in 21205.324 seconds (55% CPU, 753436 Lips)
ERROR: Stack limit (16.0Gb) exceeded
ERROR:   Stack sizes: local: 0.4Gb, global: 11.4Gb, trail: 5.0Mb
ERROR:   Stack depth: 36,774, last-call: 0%, Choice points: 216,348
ERROR:   In:
ERROR:     [36,774] system:copy_term(<compound (:-)/2>, <compound (:-)/2>)
ERROR:     [36,773] user:ebg(<compound simplify/2>, <compound simplify/2>, _1974, 50021229)
ERROR:     [36,772] user:ebg('<garbage_collected>', '<garbage_collected>', _2016, 50021229)
ERROR:     [36,771] user:ebg('<garbage_collected>', '<garbage_collected>', _2046, 50021229)
ERROR:     [36,770] user:ebg(<compound ebg/4>, <compound ebg/4>, _2076, 50021125)
ERROR:
ERROR: Use the --stack_limit=size[KMG] command line option or
ERROR: ?- set_prolog_flag(stack_limit, 34_359_738_368). to double the limit.
   Call: (18) _1190=true ?
*/
