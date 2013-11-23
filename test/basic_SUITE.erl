-module(basic_SUITE).

-export([suite/0
        ,all/0
        ,groups/0
        ,init_per_group/2
        ,end_per_group/2
        ,init_per_testcase/2
        ,end_per_testcase/2]).
-export([keys/1]).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

suite() ->
    [].

all() ->
    [{group, database_access}].

groups() ->
    [{database_access, [], [keys]}].

init_per_group(database_access, Config) ->
    application:ensure_all_started(erlchestrate),
    Token = os:getenv("TOKEN"),
    erlchestrate_app:token(Token),
    Collection = create_random_name("ct_test_collection_"),
    [{collection_name, Collection} | Config].

end_per_group(database_access, Config) ->
    Collection = ?config(collection_name, Config),
    erlchestrate_collections:delete(Collection),
    ok.

init_per_testcase(_, Config) ->
    Config.

end_per_testcase(_, _Config) ->
    ok.

keys(Config) ->
    Collection = ?config(collection_name, Config),
    erlchestrate_keys:put(Collection, <<"key1">>, jsx:encode(true)),
    ?assertEqual(true, erlchestrate_keys:get(Collection, <<"key1">>)).

%%%===================================================================
%%% Helper Functions
%%%===================================================================

create_random_name(Name) ->
    random:seed(erlang:now()),
    list_to_binary(Name ++ erlang:integer_to_list(random:uniform(1000000))).
