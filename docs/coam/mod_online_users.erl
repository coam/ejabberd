%%%-------------------------------------------------------------------
%%% @author yafei
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Jan 2016 8:47 PM
%%%-------------------------------------------------------------------
-module(mod_online_users).
-author("yafei").

%% API
-behaviour(gen_mod).
-export([
    start/2,
    stop/1,
    process/2
]).
-include("ejabberd.hrl").
-include("jlib.hrl").
-include("ejabberd_http.hrl").
-include("logger.hrl").
%% 处理函数,直接返回要输出到浏览器的内容
%%process(_LocalPath, _Request) ->
%%    ?INFO_MSG("#######################===Process module mod_online_users===", []),
%%    Users = mnesia:table_info(session, size),
%%    OnlineUsers = jiffy:encode({[{<<"onlineusers">>, Users}]}),
%%    {200, [], OnlineUsers}.

%%process(_LocalPath, _Request) ->
%%    ConnectedUsersNumber = ejabberd_sm:connected_users_number(),
%%    %% 获取在线用户列表
%%    AllSessionList = ejabberd_sm:dirty_get_sessions_list(),
%%    %% 构造JSON对象数组
%%    AllSessions = lists:map(fun({User, Server, Resource}) ->
%%        {[{user, User}, {server, Server}, {resource, Resource}]}
%%                            end,
%%        AllSessionList),
%%    %% 编码JSON格式
%%    Json = jiffy:encode({[
%%        {connected_users_number, ConnectedUsersNumber},
%%        {sessions, AllSessions}
%%    ]}),
%%    {200, [], Json}.

process(_LocalPath, _Request) ->
    ConnectedUsersNumber = ejabberd_sm:connected_users_number(),
    %% 用户列表
    AllSessionList = ejabberd_sm:dirty_get_sessions_list(),
    ?DEBUG("All sessions ~p~n", [AllSessionList]),
    %% Mnesia 表信息
    MnesiaSystemInfo = mnesia:system_info(all),
    ?DEBUG("Mnesia Information ~p~n", [MnesiaSystemInfo]),
    %% [{<<"root">>,<<"xmpp.myserver.info">>,<<"3439698832141213525690305">>}]
    %% 构造一个JSON对象数组
    %% 对象: {[]}
    %% 数组: []
    AllSessions = lists:map(fun({User, Server, Resource}) ->
        {[{user, User}, {server, Server}, {resource, Resource}]}
                            end,
        AllSessionList),
    RemoveElements = [subscribers, fallback_error_function],
    MnesiaSystemInfoJiffy = lists:filtermap(fun({Key, Value}) ->
        case lists:any(fun(E2) -> E2 =:= Key end, RemoveElements) of
            true ->
                false;
            false ->
                case Key of
                    directory ->
                        {true, {Key, list_to_bitstring(Value)}};
                    version ->
                        {true, {Key, list_to_bitstring(Value)}};
                    log_version ->
                        {true, {Key, list_to_bitstring(Value)}};
                    schema_version ->
                        {V1, V2} = Value,
                        {true, {Key, list_to_bitstring([integer_to_list(V1), ".", integer_to_list(V2)])}};
                    protocol_version ->
                        {V1, V2} = Value,
                        {true, {Key, list_to_bitstring([integer_to_list(V1), ".", integer_to_list(V2)])}};
                    _ ->
                        {true, {Key, Value}}
                end
        end
                                            end,
        MnesiaSystemInfo),
    Json = jiffy:encode({[
        {connected_users_number, ConnectedUsersNumber},
        {sessions, AllSessions},
        {mnesia, {MnesiaSystemInfoJiffy}}
    ]}),
    {200, [], Json}.

start(_Host, _Opts) ->
    ?INFO_MSG("#######################===Starting module mod_online_users===", []),
    ok.

stop(_Host) ->
    ?INFO_MSG("#######################===Stopping module mod_online_users===", []),
    ok.