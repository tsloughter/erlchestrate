-module(erlchestrate_keys).

-export([put/3
        ,put/4
        ,get/2
        ,get/3]).

put_(Required, Optional, Body) ->
    erlchestrate_utils:request(put,
                               <<"/{collection}/{key}">>,
                               Required, Optional, [],
                               [{<<"Authorization">>, erlchestrate_app:token()},
                                {<<"Content-Type">>,
                                 <<"application/json; charset=utf-8">>}],
                               Body).

put(Collection, Key, Body) ->
    put_([{<<"collection">>, Collection}, {<<"key">>, Key}],
         [], Body).

put(Collection, Key, Optional, Body) ->
    put_([{<<"collection">>, Collection}, {<<"key">>, Key}],
         Optional, Body).

get_(Required, Optional, Body) ->
    erlchestrate_utils:request(get,
                               <<"/{collection}/{key}">>,
                               Required, Optional, [],
                               [{<<"Authorization">>, erlchestrate_app:token()},
                                {<<"Content-Type">>,
                                 <<"application/json; charset=utf-8">>}],
                               Body).

get(Collection, Key) ->
    get_([{<<"collection">>, Collection}, {<<"key">>, Key}],
         [], []).

get(Collection, Key, Optional) ->
    get_([{<<"collection">>, Collection}, {<<"key">>, Key}],
         Optional, []).
