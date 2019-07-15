%%%-------------------------------------------------------------------
%%% @author yafei
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Jan 2016 9:56 PM
%%%-------------------------------------------------------------------
-module(mod_iqtest).
-author("yafei").

%% API
-behaviour(gen_mod).
-export([start/2, stop/1,
    process_sm_iq/3 %% I assume this is needed to handle JID to JID communication of the IQ?
]).
-include("ejabberd.hrl").
-include("jlib.hrl").
-include("logger.hrl").
-define(NS_TEST, "http://jabber.org/protocol/test").
-define(NS_TEST2, "http://jabber.org/protocol/test2").

start(Host, Opts) ->
    IQDisc = gen_mod:get_opt(
        iqdisc,
        Opts,
        fun gen_iq_handler:check_type/1,
        one_queue
    ),
    gen_iq_handler:add_iq_handler(
        ejabberd_sm, Host, ?NS_TEST, ?MODULE, process_sm_iq, IQDisc
    ),
    gen_iq_handler:add_iq_handler(
        ejabberd_sm, Host, ?NS_TEST2, ?MODULE, process_sm_iq, IQDisc
    ),
    ?INFO_MSG("Loading module 'mod_iqtest' v.01", []).

stop(Host) ->
    gen_iq_handler:remove_iq_handler(
        ejabberd_sm, Host, ?NS_TEST
    ),
    gen_iq_handler:remove_iq_handler(
        ejabberd_sm, Host, ?NS_TEST2
    ),
    ?INFO_MSG("Stoping module 'mod_iqtest' ", []).

process_sm_iq(_From, _To, #iq{type = get, xmlns = ?NS_TEST} = IQ) ->
    ?INFO_MSG("Processing IQ Get query:~n ~p", [IQ]),
    IQ#iq{
        type = result, sub_el = [{xmlelement, "value", [], [{xmlcdata, "Hello World of Testing."}]}]
    };
process_sm_iq(_From, _To, #iq{type = get, xmlns = ?NS_TEST2} = IQ) ->
    ?INFO_MSG("Processing IQ Get query of namespace 2:~n ~p", [IQ]),
    IQ#iq{
        type = result, sub_el = [{xmlelement, "value", [], [{xmlcdata, "Hello World of Test 2."}]}]
    };
process_sm_iq(_From, _To, #iq{type = set} = IQ) ->
    ?INFO_MSG("Processing IQ Set: it does nothing", []),
    IQ#iq{
        type = result, sub_el = []
    };
process_sm_iq(_From, _To, #iq{sub_el = SubEl} = IQ) ->
    ?INFO_MSG("Processing IQ other type: it does nothing", []),
    IQ#iq{
        type = error, sub_el = [SubEl, ?ERR_FEATURE_NOT_IMPLEMENTED]
    }.