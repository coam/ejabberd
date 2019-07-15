%%%-------------------------------------------------------------------
%%% @author yafei
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Jan 2016 7:24 PM
%%%-------------------------------------------------------------------
-module(mod_available_user).
-author("yafei").
-behavior(gen_mod).

%% API
-export([start/2, stop/1, process/2]).
-include("ejabberd.hrl").
-include("jlib.hrl").
-include("logger.hrl").
-include("ejabberd_http.hrl").
start(_Host, _Opts) ->
    ?INFO_MSG("####**************************************#>>>>>>>>>>>>>>>>>>>>> Loading module 'mod_available_user-start' ", []),
    ok.
stop(_Host) ->
    ?INFO_MSG("#####>>>>>>>>>>>>>>>>>>>>> Loading module 'mod_available_user-stop' ", []),
    ok.
process(Path, _Request) ->
    ?INFO_MSG("#####>>>>>>>>>>>>>>>>>>>>> Loading module 'mod_available_user-process' ", []),
    {xmlelement, "html", [{"xmlns", "http://www.w3.org/1999/xhtml"}],
        [{xmlelement, "head", [],
            [{xmlelement, "title", [], []}]},
            {xmlelement, "body", [],
                [{xmlelement, "p", [], [{xmlcdata, is_user_exists(Path)}]}]}]}.
is_user_exists(User) ->
    ?INFO_MSG("#####>>>>>>>>>>>>>>>>>>>>> Loading module 'mod_available_user-is_user_exists' ", []),
    Result = ejabberd_auth:is_user_exists(User, "coopens.com"),
    case Result of
        true -> "The username " ++ User ++ " is already taken...";
        false -> "The username " ++ User ++ " is available..."
    end.