-module(erlchestrate_graph).

-export([put/5
        ,put/6
        ,get/3
        ,get/4]).

put_(Required, Optional, Body) ->
    erlchestrate_utils:request(put,
                               <<"/relations/{kind}/relation/{to_collection}/{to_key}">>,
                               Required, Optional, [],
                               [{<<"Authorization">>, erlchestrate_app:token()},
                                {<<"Content-Type">>,
                                 <<"application/json; charset=utf-8">>}],
                               Body).

put(Collection, Key, Kind, ToCollection, ToKey) ->
    put_([{<<"collection">>, Collection},
          {<<"to_collection">>, ToCollection}, {<<"key">>, Key},
          {<<"to_key">>, ToKey}, {<<"kind">>, Kind}],
         [], []).

put(Collection, Key, Kind, ToCollection, ToKey, Optional) ->
    put_([{<<"collection">>, Collection},
          {<<"to_collection">>, ToCollection}, {<<"key">>, Key},
          {<<"to_key">>, ToKey}, {<<"kind">>, Kind}],
         Optional, []).

get_(Required, Optional, Body) ->
    erlchestrate_utils:request(get,
                               <<"/{collection}/{key}/relations/{[kind]}">>,
                               Required,
                               Optional, [],
                               [{<<"Authorization">>, erlchestrate_app:token()},
                                {<<"Content-Type">>,
                                 <<"application/json; charset=utf-8">>}],
                               Body).

get(Collection, Key, Kind) when is_binary(Kind) ->
    get(Collection, Key, [Kind], []);
get(Collection, Key, Kinds) when is_list(Kinds) ->
    get(Collection, Key, Kinds, []).

get(Collection, Key, Kind, Optional) when is_binary(Kind) ->
    get(Collection, Key, [Kind], Optional);
get(Collection, Key, Kinds, Optional) when is_list(Kinds) ->
    get_([{<<"collection">>, Collection}, {<<"key">>, Key},
          {<<"[kind]">>, Kinds}],
         Optional, []).
