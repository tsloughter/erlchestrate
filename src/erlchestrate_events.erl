-module(erlchestrate_events).

-export([put/4, put/5, get/3, get/4]).

put_(Required, Optional, Body) ->
    {ok, Token} = application:get_env(erlchestrate, token),
    erlchestrate_utils:request(put,
                               <<"https://api.orchestrate.io/v0">>,
                               <<"/{collection}/{key}/events/{type}">>,
                               Required,
                               Optional,
                               [{timestamp, [{type, string}]}],
                               [{<<"Authorization">>, Token},
                                {<<"Content-Type">>,
                                 <<"application/json; charset=utf-8">>}],
                               Body).

put(Collection, Key, Type, Body) ->
    put_([{<<"collection">>, Collection}, {<<"key">>, Key},
          {<<"type">>, Type}],
         [], Body).

put(Collection, Key, Type, Optional, Body) ->
    put_([{<<"collection">>, Collection}, {<<"key">>, Key},
          {<<"type">>, Type}],
         Optional, Body).

get_(Required, Optional, Body) ->
    {ok, Token} = application:get_env(erlchestrate, token),
    erlchestrate_utils:request(get,
                               <<"https://api.orchestrate.io/v0">>,
                               <<"/{collection}/{key}/events/{type}">>,
                               Required,
                               Optional,
                               [{'end', [{type, string}]}, {start, [{type, string}]}],
                               [{<<"Authorization">>, Token},
                                {<<"Content-Type">>,
                                 <<"application/json; charset=utf-8">>}],
                               Body).

get(Collection, Key, Type) ->
    get_([{<<"collection">>, Collection}, {<<"key">>, Key},
          {<<"type">>, Type}],
         [], []).

get(Collection, Key, Type, Optional) ->
    get_([{<<"collection">>, Collection}, {<<"key">>, Key},
          {<<"type">>, Type}],
         Optional, []).