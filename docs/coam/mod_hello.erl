%%%-------------------------------------------------------------------
%%% @author yafei
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Jan 2016 7:01 PM
%%%-------------------------------------------------------------------
-module(mod_hello).
-author("yafei").
-behavior(gen_mod).

-include("ejabberd.hrl").
-include("logger.hrl").

%% API
-export([start/2, stop/1]).

start(_Host, _Opt) ->
    ?INFO_MSG("#####>>>>>>>>>>>>>>>>>>>>> Loading module 'mod_hello' ", []).
stop(_Host) ->
    ok.