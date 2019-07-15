%%%-------------------------------------------------------------------
%%% @author yafei
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Jan 2016 7:41 PM
%%%-------------------------------------------------------------------
-module(mod_cputime).
-author("yafei").

%% API
-behaviour(gen_mod).
-export([
    start/2,
    stop/1,
    process_local_iq/3
]).
-include("ejabberd.hrl").
-include("jlib.hrl").
-include("logger.hrl").
-define(JUD_MATCHES, macro_body).
-define(NS_CPUTIME, <<"ejabberd:cputime">>).
start(Host, Opts) ->
    IQDisc = gen_mod:get_opt(
        iqdisc,
        Opts,
        fun gen_iq_handler:check_type/1,
        one_queue
    ),
    mod_disco:register_feature(Host, ?NS_CPUTIME),
    gen_iq_handler:add_iq_handler(ejabberd_local, Host, ?NS_CPUTIME, ?MODULE, process_local_iq, IQDisc),
    crypto:start(),
    application:start(emysql),
    Server = gen_mod:get_module_opt(Host,
        ?MODULE, server, fun(Server) -> binary_to_list(Server) end, "localhost"),
    Port = gen_mod:get_module_opt(Host,
        ?MODULE, port, fun(Port) -> Port end, 3306),
    Database = gen_mod:get_module_opt(Host,
        ?MODULE, database, fun(Database) -> binary_to_list(Database) end, "employees"),
    User = gen_mod:get_module_opt(Host,
        ?MODULE, user, fun(User) -> User end, "zhangyanxi"),
    Password = gen_mod:get_module_opt(Host,
        ?MODULE, password, fun(Password) -> binary_to_list(Password) end, "yanxi312"),
    PoolSize = gen_mod:get_module_opt(Host,
        ?MODULE, poolsize, fun(PoolSize) -> PoolSize end, 1),
    Encoding = gen_mod:get_module_opt(Host,
        ?MODULE, encoding, fun(Encoding) -> list_to_atom(binary_to_list(Encoding)) end, utf8),
    ?DEBUG("MySQL Server: ~p~n", [Server]),
    ?DEBUG("MySQL Port: ~p~n", [Port]),
    ?DEBUG("MySQL DB: ~p~n", [Database]),
    ?DEBUG("MySQL User: ~p~n", [User]),
    ?DEBUG("MySQL Password: ~p~n", [Password]),
    ?DEBUG("MySQL PoolSize: ~p~n", [PoolSize]),
    ?DEBUG("MySQL Encoding: ~p~n", [Encoding]),
    emysql:add_pool(pool_employees, [
        {size, PoolSize},
        {user, User},
        {password, Password},
        {host, Server},
        {port, Port},
        {database, Database},
        {encoding, Encoding}
    ]),
    {_, _, _, Result, _} = emysql:execute(pool_employees, <<"SELECT * FROM employees LIMIT 100">>),
%%     [
%%         [10001,{date,{1953,9,2}},<<"Georgi">>,<<"Facello">>,<<"M">>,{date,{1986,6,26}}],
%%         [10002,{date,{1964,6,2}},<<"Bezalel">>,<<"Simmel">>,<<"F">>,{date,{1985,11,21}}],
%%         [10003,{date,{1959,12,3}},<<"Parto">>,<<"Bamford">>,<<"M">>,{date,{1986,8,28}}],
%%         [10004,{date,{1954,5,1}},<<"Chirstian">>,<<"Koblick">>,<<"M">>,{date,{1986,12,1}}],
%%         [10005,{date,{1955,1,21}},<<"Kyoichi">>,<<"Maliniak">>,<<"M">>,{date,{1989,9,12}}],
%%         [10006,{date,{1953,4,20}},<<"Anneke">>,<<"Preusig">>,<<"F">>,{date,{1989,6,2}}],
%%         [10007,{date,{1957,5,23}},<<"Tzvetan">>,<<"Zielinski">>,<<"F">>,{date,{1989,2,10}}],
%%         [10008,{date,{1958,2,19}},<<"Saniya">>,<<"Kalloufi">>,<<"M">>,{date,{1994,9,15}}],
%%         [10009,{date,{1952,4,19}},<<"Sumant">>,<<"Peac">>,<<"F">>,{date,{1985,2,18}}],
%%         [10010,{date,{1963,6,1}},<<"Duangkaew">>,<<"Piveteau">>,<<"F">>,{date,{1989,8,24}}]
%%     ].
    ?DEBUG("============================~n~p~n", [Result]),
    ok.
stop(Host) ->
    mod_disco:unregister_feature(Host, ?NS_CPUTIME),
    gen_iq_handler:remove_iq_handler(ejabberd_local, Host, ?NS_CPUTIME),
    ok.
process_local_iq(_From, _To, #iq{type = Type, sub_el = SubEl} = IQ) ->
    case Type of
        set ->
            IQ#iq{type = error, sub_el = [SubEl, ?ERR_NOT_ALLOWED]};
        get ->
            CPUTime = element(1, erlang:statistics(runtime)) / 1000,
            SCPUTime = lists:flatten(io_lib:format("~.3f", [CPUTime])),
            Packet = IQ#iq{type = result, sub_el = [
                #xmlel{name = <<"query">>, attrs = [{<<"xmlns">>, ?NS_CPUTIME}], children = [
                    #xmlel{name = <<"time">>, attrs = [], children = [{xmlcdata, list_to_binary(SCPUTime)}]}]}
            ]},
            Packet
    end.
