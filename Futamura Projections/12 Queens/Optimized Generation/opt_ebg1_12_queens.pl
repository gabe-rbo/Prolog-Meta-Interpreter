/*
?- numlist(1, 12, Queens), Goal = n_queens(Queens, Sol), GenGoal = n_queens(GenQ, GenS), time(ebg(Goal, GenGoal, NewRule)), !.
% 1,184,185,260 inferences, 150.578 CPU in 152.025 seconds (99% CPU, 7864258 Lips)

?- numlist(1, 12, Queens), time(ebg1_12_queens(Queens, Sol)), !.
% 77,174,872 inferences, 5.391 CPU in 5.570 seconds (97% CPU, 14316498 Lips)
Queens = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
Sol = [1, 3, 5, 8, 10, 12, 6, 11, 2, 7, 9, 4].

?- numlist(1, 12, Queens), time(n_queens(Queens, Sol)), !.
% 114,618,178 inferences, 6.266 CPU in 6.267 seconds (100% CPU, 18293176 Lips)
Queens = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
Sol = [1, 3, 5, 8, 10, 12, 6, 11, 2, 7, 9, 4].
*/

ebg1_12_queens(GenQ, [_A, _B, _C, _D, _E, _F, _G, _H, _I, _J, _K, _L]):-(del(_A, GenQ, _M), del(_B, _M, _N), del(_C, _N, _O), del(_D, _O, _P), del(_E, _P, _Q), del(_F, _Q, _R), del(_G, _R, _S), del(_H, _S, _T), del(_I, _T, _U), del(_J, _U, _V), del(_K, _V, _W), del(_L, _W, [])), (noatk(_A, _B, 1), _X is 1+1, noatk(_A, _C, _X), _Y is _X+1, noatk(_A, _D, _Y), _Z is _Y+1, noatk(_A, _E, _Z), _A1 is _Z+1, noatk(_A, _F, _A1), _B1 is _A1+1, noatk(_A, _G, _B1), _C1 is _B1+1, noatk(_A, _H, _C1), _D1 is _C1+1, noatk(_A, _I, _D1), _E1 is _D1+1, noatk(_A, _J, _E1), _F1 is _E1+1, noatk(_A, _K, _F1), _G1 is _F1+1, noatk(_A, _L, _G1), _ is _G1+1), (noatk(_B, _C, 1), _H1 is 1+1, noatk(_B, _D, _H1), _I1 is _H1+1, noatk(_B, _E, _I1), _J1 is _I1+1, noatk(_B, _F, _J1), _K1 is _J1+1, noatk(_B, _G, _K1), _L1 is _K1+1, noatk(_B, _H, _L1), _M1 is _L1+1, noatk(_B, _I, _M1), _N1 is _M1+1, noatk(_B, _J, _N1), _O1 is _N1+1, noatk(_B, _K, _O1), _P1 is _O1+1, noatk(_B, _L, _P1), _ is _P1+1), (noatk(_C, _D, 1), _Q1 is 1+1, noatk(_C, _E, _Q1), _R1 is _Q1+1, noatk(_C, _F, _R1), _S1 is _R1+1, noatk(_C, _G, _S1), _T1 is _S1+1, noatk(_C, _H, _T1), _U1 is _T1+1, noatk(_C, _I, _U1), _V1 is _U1+1, noatk(_C, _J, _V1), _W1 is _V1+1, noatk(_C, _K, _W1), _X1 is _W1+1, noatk(_C, _L, _X1), _ is _X1+1), (noatk(_D, _E, 1), _Y1 is 1+1, noatk(_D, _F, _Y1), _Z1 is _Y1+1, noatk(_D, _G, _Z1), _A2 is _Z1+1, noatk(_D, _H, _A2), _B2 is _A2+1, noatk(_D, _I, _B2), _C2 is _B2+1, noatk(_D, _J, _C2), _D2 is _C2+1, noatk(_D, _K, _D2), _E2 is _D2+1, noatk(_D, _L, _E2), _ is _E2+1), (noatk(_E, _F, 1), _F2 is 1+1, noatk(_E, _G, _F2), _G2 is _F2+1, noatk(_E, _H, _G2), _H2 is _G2+1, noatk(_E, _I, _H2), _I2 is _H2+1, noatk(_E, _J, _I2), _J2 is _I2+1, noatk(_E, _K, _J2), _K2 is _J2+1, noatk(_E, _L, _K2), _ is _K2+1), (noatk(_F, _G, 1), _L2 is 1+1, noatk(_F, _H, _L2), _M2 is _L2+1, noatk(_F, _I, _M2), _N2 is _M2+1, noatk(_F, _J, _N2), _O2 is _N2+1, noatk(_F, _K, _O2), _P2 is _O2+1, noatk(_F, _L, _P2), _ is _P2+1), (noatk(_G, _H, 1), _Q2 is 1+1, noatk(_G, _I, _Q2), _R2 is _Q2+1, noatk(_G, _J, _R2), _S2 is _R2+1, noatk(_G, _K, _S2), _T2 is _S2+1, noatk(_G, _L, _T2), _ is _T2+1), (noatk(_H, _I, 1), _U2 is 1+1, noatk(_H, _J, _U2), _V2 is _U2+1, noatk(_H, _K, _V2), _W2 is _V2+1, noatk(_H, _L, _W2), _ is _W2+1), (noatk(_I, _J, 1), _X2 is 1+1, noatk(_I, _K, _X2), _Y2 is _X2+1, noatk(_I, _L, _Y2), _ is _Y2+1), (noatk(_J, _K, 1), _Z2 is 1+1, noatk(_J, _L, _Z2), _ is _Z2+1), noatk(_K, _L, 1), _ is 1+1.

