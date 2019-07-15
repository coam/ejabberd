---
author: "张亚飞"
date: 2014-09-26
tags: ["Note"]
categories: ["Linux"]
title: XMPP 相关
---

# 关于 XMPP 协议

Jabber 是著名的即时通讯服务服务器,它是一个自由开源软件,能让用户自己架即时通讯服务器,可以在Internet上应用,也可以在局域网中应用.
XMPP(可扩展消息处理现场协议)是基于可扩展标记语言(XML)的协议,它用于即时消息(IM)以及在线现场探测.它在促进服务器之间的准即时操作.
这个协议可能最终允许因特网用户向因特网上的其他任何人发送即时消息,即使其操作系统和浏览器不同.XMPP的技术来自于Jabber,其实它是 Jabber的核心协定,所以XMPP有时被误称为Jabber协议.
Jabber是一个基于XMPP协议的IM应用,除Jabber之外,XMPP还支持很多应用.

[XMPP 扩展协议标准](http://xmpp.org/xmpp-protocols/xmpp-extensions/)
[Ejabberd 中文翻译文档上面的 关于 Ejabberd 使用的协议介绍](http://wiki.jabbercn.org/XEP-0045)

## xmpp 比较好的文章

> 详细 xmpp 流程原理分析
[xmpp协议详解一:xmpp基本概念](http://riverlj.me/2015/07/30/xmpp%E5%8D%8F%E8%AE%AE%E8%AF%A6%E8%A7%A3%E4%B8%80%EF%BC%9Axmpp%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5/)
[XMPP协议详解二:XMPP出席](http://riverlj.me/2015/08/05/XMPP%E5%8D%8F%E8%AE%AE%E8%AF%A6%E8%A7%A3%E4%BA%8C%EF%BC%9AXMPP%E5%87%BA%E5%B8%AD/)
[XMPP协议详解三:即时消息](http://riverlj.me/2015/08/14/XMPP%E5%8D%8F%E8%AE%AE%E8%AF%A6%E8%A7%A3%E4%B8%89%EF%BC%9A%E5%8D%B3%E6%97%B6%E6%B6%88%E6%81%AF/)
[基于XMPP的即时通信系统的建立(四)— 协议详解](http://www.cnblogs.com/jiyuqi/p/5086061.html)

***

[XMPP 免费服务器列表](https://xmpp.net/directory.php)

比较好的公共服务器

[xmpp.jp](https://www.xmpp.jp/signup)

XMPP 客户端

> PC端肯定要推荐一些比较经典的啦,诸如Pidgin. Empathy. Kopete. Miranda IM(只支持Windows)或Adium(只支持Mac OS X)这样的都可以很好的兼容XMPP/Jabber协议,
不过呢还有一些专门的客户端软件,比如 Gajim和Psi+(这是Psi的升级版,增加了更多功能)这样的XMPP专业工具.
类似Pidgin这样大而全的软件可以很好的支持XMPP几乎所有的功能(通过各种插件).
而专有的软件则可以更加专注于协议的实现,更加完善,也更加富有使用的优势,特别是需要加密聊天比如OTR和PGP这样的时候,专攻XMPP协议的这些客户端就更方便可靠了.
当然还有命令行下的软件,mcabber是专门设计给XMPP/Jabber使用的,可以非常方便的提供OTR和PGP加密聊天.

### Android 开源客户端

[Conversations](https://github.com/siacs/Conversations)
[ChatSecureAndroid](https://github.com/guardianproject/ChatSecureAndroid)
[yaxim](https://github.com/pfleidi/yaxim)

***

### 1,XMPP 的三种基本角色:客户端. 服务器和网关
> 通信能够在这三者的任意两个之间双向发生.服务器端同时承担了客户端信息记录. 连接管理和信息路由的功能.网关则承担着与异构系统的互联互通功能.在 RFC 3920 XMPP Core 中对 XMPP 网络结构有一个描述:

    C1----S1---S2—C3
         |
    C2----+--G1===FN1===FC1
   
这里 C1,C2,C3 表示 XMPP 客户端;S1,S2 表示 XMPP 服务器;G1 表示网关,用来负责 XMPP 协议和外部聊天协议的转换;FN1 表示外部消息网络的服务器,FC1 表示外部网络客户端.

### 服务器 充当xmpp通信的一个智能抽象层,负责

> 对受验证的客户端,服务器以及其他实体之间以xml流的形式的连接和会话进行管理.在这些实体间使用xml流对合理编址的xml节进行路由存储和处理客户端使用的数据

#### 基本的XMPP 服务器必须实现以下标准协议

    RFC3920 核心协议Core
    RFC3921 即时消息和出席协议Instant Messaging and Presence
    XEP-0030 服务发现Service Discovery

### 客户端

> 通过TCP连接直接连接到服务器,并通过xmpp获得由服务器以及联合服务器所提供的全部功能.多个不同的客户端可以同时登陆并且并发的连接到一个服务器,每个不同资源的客户端通过xmpp地址的资源标识符来区分.建议的客户端和服务器连接的端口时5222

#### 基本的XMPP 客户端必须实现以下标准协议(XEP-0211):

    RFC3920 核心协议Core
    RFC3921 即时消息和出席协议Instant Messaging and Presence
    XEP-0030 服务发现Service Discovery
    XEP-0115 实体能力Entity Capabilities
    
### 网关
> 网关是一个特殊用途的服务器端的服务,主要功能是把xmpp翻译成外部消息系统,并把返回的消息翻译成xmpp.

大家可能会奇怪,这里为什么需要一个网关呢.这要从 XMPP 的来源说起.1996 年 Mirabilis 公司推出了世界上第一个即时通信系统 ICQ,不到 10 年,IM 就成了最流行的应用之一,MSN. Gtalk. 雅虎即时通. AIM. Adium. Pidgin 等各种软件如雨后春笋般涌现,
但是这些服务之间没有统一的标准,不能互联互通,XMPP 的设计目的就是为了实现整个及时通信服务协议的互通,让 IM 成为继 WEB 和 Email 之后的互联网第三大服务.

### XMPP协议的组成

* RFC 3920 XMPP:核心.定义了XMPP 协议框架下应用的网络架构,引入了XML Stream(XML 流)与XML Stanza(XML 节),并规定XMPP 协议在通信过程中使用的XML 标签.使用XML 标签从根本上说是协议开放性与扩展性的需要.
    此外,在通信的安全方面,把TLS 安全传输机制与SASL 认证机制引入到内核,与XMPP 进行无缝的连接,为协议的安全性. 可靠性奠定了基础.Core 文档还规定了错误的定义及处理. XML 的使用规范. JID(Jabber Identifier,Jabber 标识符)的定义. 命名规范等等.
    所以这是所有基于XMPP 协议的应用都必需支持的文档.

* RFC 3921:用户成功登陆到服务器之后,发布更新自己的在线好友管理. 发送即时聊天消息等业务.所有的这些业务都是通过三种基本的XML 节来完成的:IQ Stanza(IQ 节), Presence Stanza(Presence 节), Message Stanza(Message 节).
    RFC3921 还对阻塞策略进行了定义,定义是多种阻塞方式.可以说,RFC3921 是RFC3920 的充分补充.两个文档结合起来,就形成了一个基本的即时通信协议平台,在这个平台上可以开发出各种各样的应用.

* XEP-0016 XEP-0191:过滤通信.类似于QQ可黑名单机制,可以对某人隐身,不看某人的消息或屏蔽某个域的消息等等;当然也包括对名单的修改.
* XEP-0027	Current Jabber OpenPGP Usage
* XEP-0030: 服务搜索.一个强大的用来测定XMPP 网络中的其它实体所支持特性的协议.
* XEP-0115: 实体性能.XEP-0030 的一个通过即时出席的定制,可以实时改变交变广告功能.
* XEP-0045: 多人聊天.一组定义参与和管理多用户聊天室的协议,类似于Internet 的Relay Chat,具有很高的安全性.
* XEP-0048: Bookmarks
* XEP-0054: vCards.也就是虚拟名片,用户在聊天时可以通过虚拟名片查看相关信息.
* XEP-0084	User Avatar
* XEP-0085: Chat session.状态通知,用于用户频繁交流的情况,这类似于现实情况中的聊天,其建立过程为:双方用户在消息交互中知道了对方的Full JID,因此可以直接通信,响应的机制称为chat session..
* XEP-0096: 文件传输.定义了从一个XMPP 实体到另一个的文件传输.
* XEP-0124: HTTP 绑定.将XMPP 绑定到HTTP 而不是TCP,主要用于不能够持久的维持与服务器TCP 连接的设备.
* XEP-0133: 服务管理 http://developerworks.github.io/2014/09/21/xmpp-xep-0133-service-administration/
* XEP-0166: Jingle.规定了多媒体通信协商的整体架构.
* XEP-0167: Jingle Audio Content Description Format.定义了从一个XMPP 实体到另一个的语音传输过程.
* XEP-0176: Jingle ICE(Interactive Connectivity Establishment)Transport.ICE传输机制,文件解决了如何让防火墙或是NAT(Network Address Translation)保护下的实体建立连接的问题.
* XEP-0177: Jingle Raw UDP Transport.纯UDP 传输机制,文件讲述了如何在没有防火墙且在同一网络下建立连接的.
* XEP-0180: Jingle Video Content Description Format.定义了从一个XMPP 实体到另一个的视频传输过程.
* XEP-0181: Jingle DTMF(Dual Tone Multi-Frequency).
* XEP-0183: Jingle Telepathy Transport Method.
* XEP-0184	Message Delivery Receipts 消息回执-> 客户端层面确认消息是否已经送达 Are your contacts still using old, unreliable clients? Turn on XEP-0184 in the expert settings to make sure your contacts have successfully received your messages.
* XEP-0191: Blocking command->阻塞
* XEP-0198	Stream Management:流管理(http://developerworks.github.io/2014/10/03/xmpp-xep-0198-stream-management/) The XEP-0198 allows Conversations to survive those switches. Instead of having to establish a completely new session the servers gives the client a 5 minute window to resume a previously established session. Messages that arrived in the mean time will be redelivered automatically.
* XEP-0234	Jingle File Transfer
* XEP-0237: Roster Versioning
* XEP-0245	The /me Command
* XEP-0249	Direct MUC Invitations
* XEP-0260	Jingle SOCKS5 Bytestreams Transport Method
* XEP-0261	Jingle In-Band Bytestreams Transport Method
* XEP-0280: Message Carbons
* XEP-0333:	Chat Markers 消息回执:Your contact isn't responding immediately? Conversations uses XEP-0333 to inform you when your messages have been read. 
* XEP-0313	Message Archive Management:fetch the message history from your server.
* XEP-0352	Client State Indication:Using XEP-0352: Conversations communicates to the server whether or not the client is in the background right now. Based on this information, the server can withhold unimportant packages and thus allowing the client to stay in deep sleep for longer.

更多消息扩展

    Extended Stanza Addressing[XEP-0033]
    　　发送一条消息给多个接受者而不通过聊天室
    Advanced Message Processing[XEP-0079]
    　　控制消息过期,避免消息被本地存储以及延时投递等
    Message Archiving[XEP-0136]
    　　在服务器上存储消息,而不是在客户端机器上存储

#### 2,XMPP 的消息格式.

> XMPP 协议的所有消息都是 XML 格式的,这是 XMPP 协议的另一个充满历史意味的选择,想当年 SOA / SOAP 一时间爆发起来,很多消息交换协议都采用了 XML 格式,但是不想 XML 很快就成了「大数据」的代名词.
 在 RFC 3920 XMPP Core 中定义了两个基础概念,XML Stream 和 XML Stanza,XML Stream 是两个节点之间进行数据交换的容器,它定义了顶层的XML节点 ;XML Stanza 则定义了实体消息的具体语义单元,在 XMPP 中定义了 3 个顶层消息:

##### 2.1 Presence 联机状态

> 联机状态,它允许用户广播其在线状态和可用性;</presence>元素用来传递一个用户的存在状态的感知信息.用户可以是"available",要么是"unavailable","Hide"等.当用户连接到即时消息服务器后,好友发给他的消息就立即被传递.
如果用户没有连接到服务器,好友发给他的消息将被服务器存储起来直到用户连接到服务器.
 用户通过即时消息客户端自己控制可用性.但是,如果用户断开了同服务器的连接,服务器将发送给订阅了这个用户的存在信息的用户通知他们用户已经不可用.还包含了两个子元素:和.包含了一个对的文本描述.
> 用于确定用户的状态.消息结构举例如下(每个 XML 的 node 还会有很多其他 attribute,为了简单起见这里省略,下同):

``` bash 
<presence from="abc@jabber.org/contact" to="def@jabber.org/contact">
    <status>online</status>
</presence>
```

##### 2.2 Message 消息传递
> 消息传递,其中数据在有关各方之间传输;一个即时消息系统最基本的功能就是能够在两个用户之间实时交换消息,</message>元素就提供了这个功能.每条消息都有一个或多个属性和子元素.属性"from"和"to"分别表示了消息发送者和接收者的地址.
 也可以包含一个"type"属性,这给接收者一个提示,这个消息是什么样的消息.表3-1给出了"type"属性的可能取值.中也可以包含"id"属性,用来唯一的标识一个输出消息的响应.
> 用于在两个用户之间发送消息.消息结构举例如下:

``` bash 
<message from="abc@jabber.org/contact" to="def@jabber.org/contact" type="chat">
    <body>hello</body>
</message>
```

##### 2.3 IQ 信息/查询请求
> 信息/查询请求,它允许 XMPP 实体发起请求并从另一个实体接收响应.IQ元素是Jabber/XMPP消息协议的第三个顶层元素.IQ代表"Info/Query",用来发送和获取实体之间的信息.IQ消息是通过"请求/响应"机制在实体间进行交换的.
 IQ元素用于不同的目的,它们之间通过不同的命名空间来加以区分.在Jabber/XMPP消息协议里有许多的命名空间,但最常用的命名空间是:"jabber:iq:register","jabber:iq:auth","jabber:iq:roster"
> 信息/请求,是一个请求－响应机制,管理XMPP服务器上两个用户的转换,允许他们通过相应的XML格式进行查询和响应.

``` bash 
<iq from="abc@jabber.org/contact" id="id11" type="result"></iq>
```

#### 3,XMPP 的交互流程.
> XMPP 通过 TCP 传输了什么内容?在 QQ 里面,消息是使用二进制形式发送的,在 MSN 里面是采用纯文本指令加参数加换行符的形式发送的,
而 XMPP 传输的即时通讯指令与他们相仿,只是协议的形式变成了 XML 格式的纯文本,这让解析更容易,方便了开发和查错,但是也带来了数据负载过重的缺点,而被人广为诟病.

XMPP 聊天的过程如下:

所有从一个 client 到另一个 client 的消息和数据都要经过 XMPP Server;

``` bash 
client1 连接到Server;
server 利用本地目录系统的证书对其认证;
client1 指定 client2 目标地址,让 server 告知 client2 目标状态;
server 查找,连接并进行互相认证;
client1 和 client2 进行交互.
```

参考 
[XMPP 协议适合用来做移动 IM 么](http://segmentfault.com/a/1190000000656509)
[XMPP——xmpp客户端. 服务器. 网关以及地址和消息格式详解](http://blog.csdn.net/jessonlv/article/details/44833273)
[XMPP——xmpp协议详解. 优点. 缺点及优化思路](http://blog.csdn.net/jessonlv/article/details/44811253)
[简书-xmpp协议初识](http://www.jianshu.com/p/af87ff15bfe3)

********************************************************************************************************************************************************************************************************

### XMPP 使用 BOSH 越过 HTTP

> 要通过使用 JavaScript 的 XMPP 进行通信的 web 应用程序必须符合一些特殊要求.出于安全考虑,不允许 JavaScript 从 web 页面的域与不同域上的多个服务器通信.
如果您的 web 应用程序界面被托管在 application.mydomain.com,所有 XMPP 通信也必须发生在 application.mydomain.com.

> 防火墙是另一个问题所在.理想情况下,如果您将 XMPP 用作您的 web 界面的实时元素的基础,那么您希望它对防火墙后面的用户有效.
但是,公司防火墙通常只对少数几个协议开放几个端口,以便允许 web 数据. 电子邮件和类似的通信通过.默认情况下,XMPP 使用端口 5222,这很可能是公司防火墙阻止的端口.

> 假设您知道您的用户前面的防火墙在端口 80 上允许 HTTP(这是用于访问 web 的默认协议和端口).理想情况是您的 XMPP 通信能够越过该端口上的 HTTP.但是,HTTP 的设计并不针对持续连接.web 的架构不同于实时数据所需的通信架构.

> 下面我们看看 Bidirectional-streams Over Synchronous HTTP (BOSH) 的标准,该标准为双向同步数据提供一个模拟层.借助这个标准,可以与一个 XMPP 服务器建立一个较长的 HTTP 连接(时长一分钟或两分钟).
如果新数据在那个期间到达,则 HTTP 请求返回数据并关闭;否则,该请求只是失效.不管是哪种情况,一旦一个请求关闭,另一个请求将重新建立.
尽管结果是对一个 web 服务器的一系列重复连接,但它是一个比 Ajax 轮询更有效的数量级,特别是因为连接到的是一个专业服务器而不是直接连接到 web 应用程序.

> BOSH 上的 XMPP 允许 web 应用程序通过一个原生连接持续与 XMPP 服务器通信.客户端通过端口 80 上的 HTTP 上的一个标准 URL 连接.然后,web 服务器将这个连接代理到由 XMPP 服务器操作的一个不同端口 — 通常是 7070 — 上的 HTTP URL.
这样,无论何时数据被发送到 XMPP 服务器,web 应用程序只需使用一些资源,而 web 客户端可以使用通常支持的 web 标准从防火墙后操作.
维持 BOSH 的较长 HTTP 轮询的开销主要由 XMPP 服务器而不是 web 服务器或 web 应用程序承担.web 服务器和 XMPP 服务器都不会受到与使用 JavaScript 进行通信一样的域限制,正是因为这一点,消息才能够被发送到其他 XMPP 服务器和客户端.

> 现在,您理解了 XMPP 如何适合实时 web,可以下载并设置它,以便开始创建这个 Pingstream 应用程序.

********************************************************************************************************************************************************************************************************

##### 参考

[弃用QQ和微信!全面转向基于XMPP(Jabber)的即时聊天](https://tonghuix.io/2015/03/xmpp-chat/)