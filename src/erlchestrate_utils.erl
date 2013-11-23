-module(erlchestrate_utils).

-export([request/6
        ,request/7]).

request(HttpMethod, Endpoint, Required, Optional, QueryParams, Headers) ->
    request(HttpMethod, Endpoint, Required, Optional, QueryParams, Headers, []).
request(HttpMethod, Endpoint, Required, Optional, QueryParams, Headers, Body) ->
    BaseUri = <<"https://api.orchestrate.io/v0">>,
    Path = lists:foldl(fun({K, V}, Acc) ->
                               binary:replace(Acc, <<"{", K/binary, "}">>, V)
                       end, Endpoint, Required),
    OptionalParams = build_qs(Optional, QueryParams),
    do(HttpMethod,
       BaseUri,
       <<Path/binary, "?" , OptionalParams/binary>>, Headers, Body).

do(Method, Url, Path, Headers, Body) ->
    case hackney:request(Method, <<Url/binary, Path/binary>>,
                         Headers,
                         Body, []) of
        {ok, 204, _RespHeaders, _Client} ->
            lager:info("at=do method=~p path=~s status=~p", [Method, Path, 204]),
            ok;
        {ok, Status, _RespHeaders, Client} when Status >= 400->
            {ok, Result, _Client1} = hackney:body(Client),
            Error = jsx:decode(Result),
            lager:error("at=do method=~p path=~s status=~p code=~s error=\"~s\"",
                       [Method, Path, Status,
                       proplists:get_value(<<"code">>, Error),
                       proplists:get_value(<<"info">>,
                                          proplists:get_value(<<"details">>, Error))]),
            ok;
        {ok, Status, _RespHeaders, Client} ->
            lager:info("at=do method=~p path=~s status=~p", [Method, Path, Status]),
            {ok, Result, _Client1} = hackney:body(Client),
            jsx:decode(Result)
    end.

build_qs(Options, OptionalParams) ->
    list_to_binary(string:join(lists:foldl(fun({Name, Value}, QS) ->
                                                   [case proplists:get_value(Name, OptionalParams) of
                                                        undefined ->
                                                            [];
                                                        [{type, string}] ->
                                                            io_lib:format("~p=~s", [Name, Value]);
                                                        [{type, integer}] ->
                                                            io_lib:format("~p=~i", [Name, Value]);
                                                        [{type, boolean}] ->
                                                            io_lib:format("~p=~p", [Name, Value])

                                                    end | QS]
                                           end, [], Options), "&")).
