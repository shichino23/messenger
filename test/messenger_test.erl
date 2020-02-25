-module(messenger_test).
-behavior(riak_test).
-export([confirm/0]).

-spec confirm() -> pass | fail.
confirm() ->
    io:format("dasdasdasdasdas~n"),
    pass.
