-module(erlchestrate_events).

-export([put/4
        ,put/5
        ,get/3
        ,get/4]).

put_(Required, Optional, Body) ->
    erlchestrate_utils:request(put,
                               <<"/{collection}/{key}/events/{type}">>,
                               Required,
                               Optional,
                               [{timestamp, [{type, string}]}],
                               [{<<"Authorization">>, erlchestrate_app:token()},
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
    erlchestrate_utils:request(get,
                               <<"/{collection}/{key}/events/{type}">>,
                               Required,
                               Optional,
                               [{'end', [{type, string}]}, {start, [{type, string}]}],
                               [{<<"Authorization">>, erlchestrate_app:token()},
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
