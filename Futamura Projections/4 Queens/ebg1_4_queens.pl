/*
?- numlist(1, 4, Queens), Goal = n_queens(Queens, Sol), GenGoal = n_queens(GenQ, GenS), time(ebg(Goal, GenGoal, NewRule)), !.
% 4,809 inferences, 0.000 CPU in 0.001 seconds (0% CPU, Infinite Lips)

?- numlist(1, 4, Queens), time(ebg1_4_queens(Queens, Sol)).
% 176 inferences, 0.000 CPU in 0.000 seconds (0% CPU, Infinite Lips)
Queens = [1, 2, 3, 4],
Sol = [2, 4, 1, 3] ;
% 86 inferences, 0.000 CPU in 0.000 seconds (0% CPU, Infinite Lips)
Queens = [1, 2, 3, 4],
Sol = [3, 1, 4, 2] ;
% 136 inferences, 0.000 CPU in 0.000 seconds (0% CPU, Infinite Lips)
false.

?- numlist(1, 4, Queens), time(n_queens(Queens, Sol)).
% 265 inferences, 0.000 CPU in 0.000 seconds (0% CPU, Infinite Lips)
Queens = [1, 2, 3, 4],
Sol = [2, 4, 1, 3] ;
% 119 inferences, 0.000 CPU in 0.000 seconds (0% CPU, Infinite Lips)
Queens = [1, 2, 3, 4],
Sol = [3, 1, 4, 2] ;
% 213 inferences, 0.000 CPU in 0.000 seconds (0% CPU, Infinite Lips)
false.
*/

ebg1_4_queens(GenQ, [_A, _B, _C, _D]):-(del(_A, GenQ, _E), del(_B, _E, _F), del(_C, _F, _G), del(_D, _G, [])), (noatk(_A, _B, 1), _H is 1+1, noatk(_A, _C, _H), _I is _H+1, noatk(_A, _D, _I), _ is _I+1), (noatk(_B, _C, 1), _J is 1+1, noatk(_B, _D, _J), _ is _J+1), noatk(_C, _D, 1), _ is 1+1).

