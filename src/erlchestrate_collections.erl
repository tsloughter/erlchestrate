-module(erlchestrate_collections).

-export([delete/1, delete/2]).

delete_(Required, Optional, Body) ->
    {ok, Token} = application:get_env(erlchestrate, token),
    erlchestrate_utils:request(delete,
                               <<"https://api.orchestrate.io/v0">>,
                               <<"/{collection}">>,
                               Required, Optional, [{force, [{type, string}]}],
                               [{<<"Authorization">>, Token},
                                {<<"Content-Type">>,
                                 <<"application/json; charset=utf-8">>}],
                               Body).

delete(Collection) ->
    delete_([{<<"collection">>, Collection}], [], []).

delete(Collection, Optional) ->
    delete_([{<<"collection">>, Collection}], Optional, []).
