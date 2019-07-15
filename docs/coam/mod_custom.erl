%%%-------------------------------------------------------------------
%%% @author yafei
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Dec 2015 2:52 PM
%%%-------------------------------------------------------------------
%% Module name (has to match with the filename)
-module(mod_custom).
%% Module author
-author("yafei").

%% Module version
-vsn('1.0').
%% Debug flag
-define(EJABBERD_DEBUG, true).
%% Implement the OTP gen_mod behavior
-behavior(gen_mod).
%% Module exports
-export([start/2, stop/1, process/2]).
%%
%% INCLUDES
%%
%% base ejabberd headers
-include("ejabberd.hrl").
%% ejabberd compatibility functions
-include("jlib.hrl").
%% ejabberd HTTP headers
-include("ejabberd_http.hrl").
%% initialization function
start(_Host, _Opts) ->
    ok.
%% function on module unload
stop(_Host) ->
    ok.
%% process any request to "/sockets"
process(["sockets"], _Request) ->
    % FIXME: implementation goes here
    "Not implemented yet";
%% process all remaining requests
%%process(_Page, _Request) ->
%%    % FIXME: implementation goes here
%%    "Fallback result".
process(_LocalPath, _Request) ->
    ConnectedUsersNumber = ejabberd_sm:connected_users_number(),
    Json = jiffy:encode({[
        {connected_users_number, ConnectedUsersNumber}
    ]}),
    {200, [
        {<<"Access-Control-Allow-Origin">>,   <<"http://www.coopens.com">>},
        {<<"Access-Control-Allow-Headers">>,  <<"Content-Type,X-Requested-With">>},
        {<<"Content-Type">>,                  <<"application/json; charset=utf-8">>}
    ], Json}.

