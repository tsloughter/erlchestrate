-module(erlchestrate_graph).

-export([put/5, put/6, get/3, get/4]).

put_(Required, Optional, Body) ->
    {ok, Token} = application:get_env(erlchestrate, token),
    erlchestrate_utils:request(put,
                               <<"https://api.orchestrate.io/v0">>,
                               <<"/relations/{kind}/relation/{to_collection}/{to_key}">>,
                               Required, Optional, [],
                               [{<<"Authorization">>, Token},
                                {<<"Content-Type">>,
                                 <<"application/json; charset=utf-8">>}],
                               Body).

put(Collection, To_collection, Key, To_key, Kind) ->
    put_([{<<"collection">>, Collection},
          {<<"to_collection">>, To_collection}, {<<"key">>, Key},
          {<<"to_key">>, To_key}, {<<"kind">>, Kind}],
         [], []).

put(Collection, To_collection, Key, To_key, Kind,
    Optional) ->
    put_([{<<"collection">>, Collection},
          {<<"to_collection">>, To_collection}, {<<"key">>, Key},
          {<<"to_key">>, To_key}, {<<"kind">>, Kind}],
         Optional, []).

get_(Required, Optional, Body) ->
    {ok, Token} = application:get_env(erlchestrate, token),
    erlchestrate_utils:request(get,
                               <<"https://api.orchestrate.io/v0">>,
                               <<"/{collection}/{key}/relations/{kind}">>,
                               Required,
                               Optional, [],
                               [{<<"Authorization">>, Token},
                                {<<"Content-Type">>,
                                 <<"application/json; charset=utf-8">>}],
                               Body).

get(Collection, Key, Kind) ->
    get_([{<<"collection">>, Collection}, {<<"key">>, Key},
          {<<"kind">>, Kind}],
         [], []).

get(Collection, Key, Kind, Optional) ->
    get_([{<<"collection">>, Collection}, {<<"key">>, Key},
          {<<"kind">>, Kind}],
         Optional, []).
