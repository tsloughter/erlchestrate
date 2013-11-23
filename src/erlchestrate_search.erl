-module(erlchestrate_search).

-export([get/1
        ,get/2]).

get_(Required, Optional, Body) ->
    ramler_utils:request(get,
                         <<"/{collection}">>,
                         Required, Optional,
                         [{offset, [{type, integer}]},
                          {limit, [{type, integer}]},
                          {'query', [{type, string}]}],
			 [{<<"Authorization">>, erlchestrate_app:token()},
			  {<<"Content-Type">>,
			   <<"application/json; charset=utf-8">>}],
			 Body).

get(Collection) ->
    get_([{<<"collection">>, Collection}], [], []).

get(Collection, Optional) ->
    get_([{<<"collection">>, Collection}], Optional, []).
