-module(erlchestrate_collections).

-export([delete/1, delete/2]).

delete_(Required, Optional, Body) ->
    erlchestrate_utils:request(delete,
                               <<"/{collection}">>,
                               Required, Optional, [{force, [{type, boolean}]}],
                               [{<<"Authorization">>, erlchestrate_app:token()},
                                {<<"Content-Type">>,
                                 <<"application/json; charset=utf-8">>}],
                               Body).

delete(Collection) ->
    delete_([{<<"collection">>, Collection}], [], []).

delete(Collection, Optional) ->
    delete_([{<<"collection">>, Collection}], Optional, []).
