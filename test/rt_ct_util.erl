-module(rt_ct_util).

-include("riak_tests.hrl").

-export([start_node/1, setup/0]).

start_node(Name) ->
    {ok, _} = net_kernel:start([Name]),
    true = erlang:set_cookie(Name, riak).

setup() ->
    ensure_clean_devrel(),
    configure_environment().

ensure_clean_devrel() ->
    Result = os:cmd("cd " ++ ?PRIV_DIR ++ " && source ./clean_devrel riak && cd -"),
    io:format("Running clean devrel on the riak dependency...~n~p~n", [Result]),
    ok.

configure_environment() ->
    application:set_env(riak_test, rt_harness, rtdev),
    %% TODO ensure that rt_config is able to read configuration below
    ListParams = [
        {rt_max_wait_time, 600000},
        {rt_retry_delay, 500},
        {rt_harness, rtdev}
    ],
    lists:map(fun({N, V}) ->
            application:set_env(riak_test, N, V)
        end, ListParams),
    %% TODO remove hardcoded paths
    application:set_env(riak_test, rtdev_path, [
        {root,     "/Users/goncalotomas/git/riak_tests/_build/default/lib/riak"},
       {current,  "/Users/goncalotomas/git/riak_tests/_build/default/lib/riak"},
       {previous, "/Users/goncalotomas/git/riak_tests/_build/default/lib/riak"},
       {legacy,   "/Users/goncalotomas/git/riak_tests/_build/default/lib/riak"}
    ]).
