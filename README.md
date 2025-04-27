# The Metainterpreter

This is a complete prolog metainterpreter, meaning it executes all possible programs, including those with cuts and builtins.
There are 3 versions in the MIs folder:
- MI1 executes all programs but doesn't cut.
- MI7 executes all programs, including builtins, and cuts. Can metainterpret itself.
- MI8 is similar to MI7 but it writes the tree/path of the predicate to be proven.

# EBG

Executes problems with cut and gives most general generalization. It's not yet able of generalizing conditions like not(Predicate) 
