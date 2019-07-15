---
author: "张亚飞"
date: 2014-09-26
tags: ["Note"]
categories: ["Linux"]
title: Ejabberd Note
---

# Ejabberd Note

### Ejabberd Xamp 服务器搭建

[ejabberd官方文档] (http://docs.ejabberd.im/)
[ejabberd github](https://github.com/processone/ejabberd)
[Ejabberd2 中文翻译文档](http://wiki.jabbercn.org/Ejabberd2:%E5%AE%89%E8%A3%85%E5%92%8C%E6%93%8D%E4%BD%9C%E6%8C%87%E5%8D%97)

[Ejabberd - configuration 配置文件文档](http://docs.ejabberd.im/admin/guide/configuration/#modroster)
[Ejabberd XEP-* 支持列表](https://www.process-one.net/en/ejabberd/protocols/)

### 优秀 Ejabberd 开发者博客

[元气糯米团子的Coding Blog](http://developerworks.github.io/)
[Ejabberd配置模块分析](http://www.just4coding.com/blog/2014/12/09/ejabberd-config/)
[zlx_star - Ejabberd 启动过程](http://blog.zlxstar.me/blog/2013/07/20/ejabberd-starting-process/)
[木头人 ejabberd Modules development](http://allran.github.io/2015/04/16/ejabberd-Modules-development/)
[Ejabberd中hook机制分析](http://www.just4coding.com/blog/2014/12/07/ejabberd-hooks/)

### 收藏博客文章

[Worktile中的实时消息推送服务实现](http://segmentfault.com/a/1190000000665676)
[木头人 - ejabberd install](http://allran.github.io/2015/04/15/ejabberd-install/)
[编译Ejabberd遇到的问题](http://developerworks.github.io/2014/09/25/ejabberd-compile-issues/)

********************************************************************************************************************************************************************************************************

## 常见的 `Ejabberd` 服务器管理命令

* 调试 `Ejabberd` 配置文件并打印日志信息

``` bash 
sudo ejabberdctl live    
```

* 启动 `Ejabberd` 服务器

``` bash 
sudo ejabberdctl start   
```

* 重启 `Ejabberd` 服务器

``` bash 
sudo ejabberdctl restart 
```

* 查看 `Ejabberd` 服务器运行状态

``` bash 
#sudo ejabberdctl status
```

* 查看 `Ejabberd` 服务器运行状态

``` bash 
sudo ejabberdctl debug  
```

* 添加注册新用户

``` bash 
ejabberdctl register zyfmix coam.co ****** 
```

********************************************************************************************************************************************************************************************************

## XMPP协议的命名空间:

```
jabber:iq:private   -- 私有数据存储,用于本地用户私人设置信息,比如用户备注等.
jabber:iq:conference  -- 一般会议,用于多个用户之间的信息共享
jabber:x:encrypted -- 加密的消息,用于发送加密消息
jabber:x:expire  -- 消息终止
jabber:iq:time  -- 客户端时间
jabber:iq:auth  -- 简单用户认证,一般用于服务器之间或者服务器和客户端之间的认证
jabber:x:roster  -- 内部花名册
jabber:x:signed  -- 标记的在线状态
jabber:iq:search -- 用户数据库查询,用于向服务器发送查询请求
jabber:iq:register -- 注册请求,用于用户注册相关信息
jabber:x:iq:roster -- 花名册管理
jabber:x:conference -- 会议邀请,用于向参加会议用户发送开会通知
jabber:x:event  -- 消息事件
vcard-temp  -- 临时的vCard,用于设置用户的头像以及昵称等
```

********************************************************************************************************************************************************************************************************

### 模块化

只装在你想要的模块.
在你自己的自定义模块扩展ejabberd.
安全性
支持c2s和s2s连接的SASL和STARTTLS.
支持s2s连接的STARTTLS和Dialback.

支持虚拟主机.
XML流压缩 (XEP-0138).
统计 (XEP-0039).
支持IPv6的c2s和s2s连接.
支持集群和HTML日志的多用户聊天模块.
基于用户vCards的用户目录.
支持基于PubSub的个人事件的发行-订阅组件.
支持web客户端: HTTP轮询和HTTP绑定(BOSH)服务.
IRC网关.
组件支持: 安装特定网关之后和外部网络的接口,如 AIM, ICQ 和 MSN.

### 模块一览,下表列出 `Ejabberd` 里的所有模块

模块 功能 依赖

mod_adhoc 特定命令 (XEP-0050)
mod_announce 管理公告
推荐 mod_adhoc
mod_caps 实体能力 (XEP-0115)
mod_configure 使用特定命令配置服务器
mod_adhoc
mod_disco 服务发现 (XEP-0030)
mod_echo XMPP节回音
mod_irc IRC网关   
mod_last 最后活动 (XEP-0012)
mod_last_odbc 最后活动 (XEP-0012) 支持的数据库 (*)
mod_muc 多用户聊天 (XEP-0045)
mod_muc_log 多用户聊天室记录
mod_muc
mod_offline 离线消息存储 (XEP-0160)
mod_offline_odbc 离线消息存储 (XEP-0160) 支持的数据库 (*)
mod_ping XMPP Ping 和定期保持连接 (XEP-0199)
mod_privacy 禁止通讯 (XMPP IM)
mod_privacy_odbc 禁止通讯 ((XMPP IM) 支持的数据库 (*)
mod_private 私有XML存储 (XEP-0049)
mod_private_odbc 私有XML存储 (XEP-0049) 支持的数据库 (*)
mod_proxy65 SOCKS5字节流 (XEP-0065)
mod_pubsub 发行-订阅 (XEP-0060), PEP (XEP-0163)
mod_caps
mod_pubsub_odbc 发行-订阅 (XEP-0060), PEP (XEP-0163) 支持的数据库 (*) 和 mod_caps
mod_register I带内注册 (XEP-0077)
mod_roster 名册管理 (XMPP IM)
mod_roster_odbc 名册管理 (XMPP IM) 支持的数据库 (*)
mod_service_log 拷贝用户消息到日志服务
mod_shared_roster 共享名册管理
mod_roster 或 mod_roster_odbc
mod_sic Server IP检查 (XEP-0279)
mod_stats 统计信息收集 (XEP-0039)
mod_time 实体时间 (XEP-0202)
mod_vcard 电子名片 (XEP-0054)
mod_vcard_ldap 电子名片 (XEP-0054) LDAP服务器
mod_vcard_odbc 电子名片 (XEP-0054) 支持的数据库 (*)
mod_vcard_xupdate 基于vCard的头像 (XEP-0153)
mod_vcard 或 mod_vcard_odbc
mod_version 软件版本 (XEP-0092)

********************************************************************************************************************************************************************************************************

### Ejabberd 修改列表

~/src/ejabberd_oauth.erl // 修改 301 问题 参见 https://github.com/barabansheg/ejabberd/blob/master/src/ejabberd_oauth.erl
~/src/mod_sunshine.erl // 增加,测试 参见 http://developerworks.github.io/2014/09/18/ejabberd-modules-presence-storms/

********************************************************************************************************************************************************************************************************
