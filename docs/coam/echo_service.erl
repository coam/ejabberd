%%%-------------------------------------------------------------------
%%% @author Chi Zhang <elecpaoao@gmail.com>
%%% @copyright (C) 2012, Chi Zhang
%%% @doc
%%%  echo service demo
%%% @end
%%% Created : 24 May 2012 by Chi Zhang <elecpaoao@gmail.com>
%%%-------------------------------------------------------------------
-module(echo_service).
-behaviour(gen_fsm).
%% API
-export([start_link/2]).
-export([start/2, socket_type/0]).
%% gen_fsm callbacks
-export([init/1, state_name/2, state_name/3, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-define(SERVER, ?MODULE).
-include("ejabberd.hrl").
-include("logger.hrl").
-record(state, {sockmod, csock, opts}).
%%%===================================================================
%%% API
%%%===================================================================
start(SockData, Opts) ->
    start_link(SockData, Opts).
socket_type() ->
    raw.
start_link(SockData, Opts) ->
    gen_fsm:start_link(?MODULE, [SockData, Opts], []).
%%%===================================================================
%%% gen_fsm
%%%===================================================================
init([{SockMod, CSock}, Opts]) ->
    ?ERROR_MSG("##################################### start with sockmod: ~p csock: ~p opts: ~p", [SockMod, CSock, Opts]),
    State = #state{sockmod = SockMod, csock = CSock, opts = Opts},
    activate_socket(State),
    {ok, state_name, State}.

state_name(_Event, State) ->
    {next_state, state_name, State}.

state_name(_Event, _From, State) ->
    Reply = ok,
    {reply, Reply, state_name, State}.

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

handle_info({_, CSock, Packet}, StateName, #state{sockmod = SockMod} = State) ->
    ?ERROR_MSG("##################################### received: ~p", [Packet]),
    SockMod:send(CSock, Packet),
    activate_socket(State),
    {next_state, StateName, State};
handle_info({tcp_closed, _CSock}, _StateName, State) ->
    ?ERROR_MSG("##################################### client closed: ~p", [State]),
    {stop, normal, State};
handle_info(_Info, StateName, State) ->
    ?ERROR_MSG("##################################### received: ~p", [_Info]),
    {next_state, StateName, State}.

terminate(_Reason, _StateName, _State) ->
    ?ERROR_MSG("##################################### terminated ~p", [_Reason]),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
activate_socket(#state{csock = CSock}) ->
    inet:setopts(CSock, [{active, once}]).