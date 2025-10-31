/*
time_to_file(FilePath, Goal)

Runs time(Goal) and captures its output to FilePath.
*/
time_to_file(FilePath, Goal) :-
    setup_call_cleanup(
        (
            stream_property(OriginalError, alias(user_error)),
            open(FilePath, write, FileStream),
            set_prolog_IO(user_input, user_output, FileStream)
        ),
        (
            time(Goal)
        ),
        (
            set_prolog_IO(user_input, user_output, OriginalError),
             close(FileStream)
        )
    ).
