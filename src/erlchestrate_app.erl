%%%-------------------------------------------------------------------
%%% @author Tristan Sloughter <t@crashfast.com>
%%% @copyright (C) 2013, Tristan Sloughter
%%% @doc
%%%
%%% @end
%%% Created : 18 Nov 2013 by Tristan Sloughter <t@crashfast.com>
%%%-------------------------------------------------------------------
-module(erlchestrate_app).

-behaviour(application).

%% Application callbacks
-export([start/2
        ,stop/1]).

-export([token/0
        ,token/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

start(_StartType, _StartArgs) ->
    erlchestrate_sup:start_link().

stop(_State) ->
    ok.

token(Token) when is_list(Token) ->
    token(list_to_binary(Token));
token(Token) when is_binary(Token) ->
    EncodedToken = base64:encode(<<Token/binary, ":">>),
    application:set_env(erlchestrate, token, <<"Basic ", EncodedToken/binary>>).

token() ->
    {ok, Token} = application:get_env(erlchestrate, token),
    Token.

%%%===================================================================
%%% Internal functions
%%%===================================================================
