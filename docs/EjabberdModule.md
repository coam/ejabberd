---
author: "张亚飞"
date: 2014-09-26
tags: ["Note"]
categories: ["Linux"]
title: Ejabberd 模块
---

# Ejabberd 模块

[processone/ejabberd-contrib](https://github.com/processone/ejabberd-contrib)
[Ejabberd模块安装工具](http://developerworks.github.io/2015/03/17/ejabberd-easy-installer-and-structure-for-ejabberd-contributed-modules/)

********************************************************************************************************************************************************************************************************

### `Ejabberd` 模块 `mod_*`

`Ejabberd` 官方运行实际提供的模块以文件名 `mod_*.beam` 的格式存储在 `/lib/ejabberd/ebin/*` 下

需要在 `/etc/ejabberd/ejabberd.yml` 中配置是否启用以及相关参数

以下节选自默认配置

```
##
## Modules enabled in all ejabberd virtual hosts.
##
modules: 
  mod_adhoc: {}
  ## mod_admin_extra: {}
  mod_announce: # recommends mod_adhoc
    access: announce
  mod_blocking: {} # requires mod_privacy
  mod_caps: {}
  mod_carboncopy: {}
  ...
```

> 主要有以下命令

``` bash 
ejabberdctl modules_update_specs # 更新所有模块
ejabberdctl modules_available    # 查看可用安装模块
ejabberdctl module_install mod_logxml # 安装模块 mod_logxml
ejabberdctl module_uninstall mod_logxml # 安装模块 mod_logxml
```

如下是示例:

```
root@coam:/lib/ejabberd/ebin# ejabberdctl modules_available
atom_pubsub     Provides access to all PEP nodes via an AtomPub interface
ejabberd_auth_http      Authentication via HTTP request
ejabberd_mod_mam        Message Archive Management (XEP-0313)
ejabberd_trace  Easy tracing of connections made to ejabberd
ircd    IRC server frontend to ejabberd
mod_archive     Supports almost all the XEP-0136 version 0.6 except otr
mod_cron        Execute scheduled commands
mod_http_offline        POST offline messages to a web
mod_http_upload HTTP File Upload
mod_log_chat    Logging chat messages in text files
mod_logsession  Log session connections to file
mod_logxml      Log XMPP packets to XML file
mod_mam_mnesia  Message Archive Management (XEP-0313)
mod_message_log Log one line per message transmission in text file
mod_muc_log_http        Serve MUC logs on the web
mod_openid      Transform the Jabber Server in an openid provider
mod_post_log    logs messages to an HTTP API
mod_profile     User Profile (XEP-0154) in Mnesia table
mod_rest        HTTP interface to POST stanzas into ejabberd
mod_restful     RESTful API for ejabberd
mod_s2s_log     Log all s2s connections in a file
mod_shcommands  Execute shell commands
mod_statsdx     Calculates and gathers statistics actively
mod_webpresence Publish user presence information in the web
```

`ejabberdctl modules_available` 命令主要展示管理 [ejabberd-contrib](https://github.com/processone/ejabberd-contrib) 项目所提供的第三方模块

********************************************************************************************************************************************************************************************************

## `Ejabberd` 增加聊天记录模块 `mod_mam`

在 `ejabberd.yml` 中添加如下配置:

```
mod_mam:
  default: always
  db_type: sql
```

于此,聊天消息便记录到了 `Mysql` 数据库表 `archive` 中

参考
[Ejabberd 增加聊天记录模块](http://www.jianshu.com/p/c60f49f1ffe6/comments/767458)
[如何使用Ejabberd消息归档模块](http://developerworks.github.io/2015/05/10/ejabberd-mam-module-how-to-use/)
[基于ejabberd简单实现xmpp群聊离线消息](http://www.cnblogs.com/lovechengcheng/p/4083398.html)

********************************************************************************************************************************************************************************************************

### Ejabberd 配置 OAuth Token 模块

> 回调出现 302 Found 错误,将 *ejabberd/src/ejabberd_oauth.erl* 替换成 https://github.com/barabansheg/ejabberd/blob/master/src/ejabberd_oauth.erl
 ** 修改部分主要参见 https://github.com/barabansheg/ejabberd/commit/358fac13218a9a0e576efe4fa1f369a8ddc0907e **
 ** Token expire 问题可参考 https://github.com/barabansheg/ejabberd/commit/25793e8589ec895b739b79ca0a895999eccae0d7 **
 
 ** 以上已被删除,修改部分详见 https://github.com/zyfmix/ejabberd/commit/6cd7ed46c32cffa711cbb0b7baf585c66f894ab9**

scope 去掉官网提供的 user_get_roster ,可能不支持了

访问 http://coopens.com:5280/oauth/authorization_token?response_type=token&client_id=clientId&redirect_uri=http://coopens.com&scope=sasl_auth

填写 具有 admin 权限的 {username: zyf | server: coopens.com | password: 123456} 可获取 回调带 Token 的 uri: 
[https://coopens.com/?access_token=IxUhJmkY8Wm0EaifTS4l56i0S6bcxJa3&token_type=bearer&expires_in=1&scope=sasl_auth&state=]

参考 
[Google+ Russia Slava](https://plus.google.com/u/0/+VyacheslavKoslov/posts)
[Ejabberd OAuth](http://docs.ejabberd.im/admin/guide/oauth/#xml-rpc-examples)


********************************************************************************************************************************************************************************************************

### `Ejabberd` 配置 `mod_http_bind` 模块

> mod_http_bind 模块主要提供 web 端 的 http-bind 查询接口,Ejabberd 主要在以下两部分配置:

* ejabberd.yml

```
listen:
  ...
  -
    port: 5280
    module: ejabberd_http
    request_handlers:
       "/http-bind": mod_http_bind
    http_poll: true
    web_admin: true
  ...
```

* ejabberd.yml

```
modules:
  ...
  mod_http_bind:
    max_inactivity: 50
  ...
```

于是便可以在 converse.js 的 js 启动脚本中按如下配置连接 ejabberd 服务器

``` javascript 
converse.initialize({
    //bosh_service_url: 'https://conversejs.org/http-bind/', // Please use this connection manager only for testing purposes
    bosh_service_url: 'https://coopens.com:5280/http-bind/', // Please use this connection manager only for testing purposes
    keepalive: true,
    message_carbons: true,
    play_sounds: true,
    roster_groups: true,
    show_controlbox_by_default: true,
    xhr_user_search: false
});
```

参考 
[http://docs.ejabberd.im/admin/guide/configuration/#mod_http_bind](http://docs.ejabberd.im/admin/guide/configuration/#mod_http_bind)

********************************************************************************************************************************************************************************************************

###  xml 消息日志记录模块 mod_logxml

https://github.com/processone/ejabberd-contrib/tree/master/mod_logxml
http://developerworks.github.io/2014/10/15/ejabberd-mod-logxml/

``` ini 
cd ~/.ejabberd-modules/mod_logxml/conf
sudo vi  mod_logxml.yml
modules:
    mod_logxml:
  #     stanza:
  #       - iq
  #       - other
  #     direction:
  #       - external
  #     orientation:
  #       - send
  #       - recv
       logdir: "/data/home/yzhang/ServerRun/Erlang/dev/logs/"
  #     timezone: universal
  #     show_ip: false
  #     rotate_days: 1
       rotate_megs: 100000
  #     rotate_kpackets: no
  #     check_rotate_kpackets: 1
```

``` bash 
Wed Feb 24 17:26:45 yzhang@coam:~/.ejabberd-modules$ sudo ejabberdctl module_install mod_logxml
src/mod_logxml.erl:263: Warning: erlang:now/0: Deprecated BIF. See the "Time and Time Correction in Erlang" chapter of the ERTS User's Guide for more information.
src/mod_logxml.erl:264: Warning: erlang:now/0: Deprecated BIF. See the "Time and Time Correction in Erlang" chapter of the ERTS User's Guide for more information.
ok
```

注意
#### mod_logxml.erl 需要 ejabberd16.01.141 已改动 jlib:timestamp_to_iso/1 方法 jlib:timestamp_to_legacy/1 详见 https://github.com/processone/ejabberd/pull/917
需要暂时修改 mod_logxml Line 267 部分如下,否则启动 ejabberdctl 会报错,并且不会记录数据包日志信息

``` bash 
get_now_iso(Timezone) ->
    TimeStamp = case Timezone of
                    local -> calendar:now_to_local_time(now());
                    universal -> calendar:now_to_universal_time(now())
                end,
%%    binary_to_list(jlib:timestamp_to_iso(TimeStamp)).
    binary_to_list(jlib:timestamp_to_legacy(TimeStamp)).
```

#### [mod_logxml Line#202](https://github.com/processone/ejabberd-contrib/blob/master/mod_logxml/src/mod_logxml.erl#L202) 像下面这样:

``` bash 
%% TimestampISO, binary_to_list(xml:element_to_binary(Packet))]).
TimestampISO, binary_to_list(fxml:element_to_binary(Packet))]).
```

主要原因是 Ejabberd 官方统一将原来的 p1_xml 统一改为 fast_xml ,详见 [Switch to Fast XML module](https://github.com/processone/ejabberd/commit/dfc29ea03ca91e1eb5387d93612e2ac4b4b496da)

********************************************************************************************************************************************************************************************************

### Ejabberd 配置 mod_push 消息推送模块

[royneary/mod_push](https://github.com/royneary/mod_push)

mod_push 为 ejabberd 实现了 XEP-0357 (Push) 消息推送协议

### 安装 mod_push 模块

``` bash 
git clone https://github.com/royneary/mod_push.git
# copy the source code folder to the module sources folder of your ejabberd
# installation (may be different on your machine)
sudo cp -R mod_push /var/spool/jabber/.ejabberd-modules/sources/
# if done right ejabberdctl will list mod_push as available module
ejabberdctl modules_available
# automatically compile and install mod_push
ejabberdctl module_install mod_push 
```

********************************************************************************************************************************************************************************************************
