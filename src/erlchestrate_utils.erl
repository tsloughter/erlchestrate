-module(erlchestrate_utils).

-export([request/7
        ,request/8]).

request(HttpMethod, Host, Endpoint, Required, Optional, QueryParams, Headers) ->
    request(HttpMethod, Host, Endpoint, Required, Optional, QueryParams, Headers, []).
request(HttpMethod, Host, Endpoint, Required, Optional, QueryParams, Headers, Body) ->
    Path = lists:foldl(fun({K, V}, Acc) ->
                               binary:replace(Acc, <<"{", K/binary, "}">>, V)
                       end, Endpoint, Required),
    OptionalParams = build_qs(Optional, QueryParams),
    do(HttpMethod,
       Host,
       <<Path/binary, "?" , OptionalParams/binary>>, Headers, Body).

do(Method, Url, Path, Headers, Body) ->
    {ok, Status, _RespHeaders, Client}
        = hackney:request(Method, <<Url/binary, Path/binary>>,
                          Headers,
                          Body, []),
    lager:info("at=do method=~p path=~s status=~p", [Method, Path, Status]),
    {ok, Result, _Client1} = hackney:body(Client),
    jsx:decode(Result).

build_qs(Options, OptionalParams) ->
    list_to_binary(string:join(lists:foldl(fun({Name, Value}, QS) ->
                                                   [case proplists:get_value(Name, OptionalParams) of
                                                        undefined ->
                                                            [];
                                                        [{type, string}] ->
                                                            io_lib:format("~p=~s", [Name, Value]);
                                                        [{type, integer}] ->
                                                            io_lib:format("~p=~i", [Name, Value])
                                                    end | QS]
                                           end, [], Options), "&")).
