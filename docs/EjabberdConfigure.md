---
author: "张亚飞"
date: 2014-09-26
tags: ["Note"]
categories: ["Linux"]
title: Ejabberd 配置相关
---

# `Ejabberd` 配置相关

********************************************************************************************************************************************************************************************************

## 2. `Ejabberd` 配置文件

`Ejabberd` 主要两个配置文件 `/usr/local/etc/ejabberd/ejabberdctl.cfg` 和 `/usr/local/etc/ejabberd/ejabberd.yml`

* 给 `Ejabberd` 添加管理员

使用命令 `sudo ejabberdctl register` 添加用户 `zyf` 后,

使用命令注册用户

``` bash 
sudo ejabberdctl register zyf coopens.com 123456
```

修改 `ejabberd.yml` 以下两段:

``` bash 
acl:
  admin:
    user:
      - "zyf": "coopens.com"
access:
  configure:
    admin: allow
```

访问 `http://coopens.com:5280/admin` 管理 `ejabberd` 服务器

参考 
[Can't set long node name!\nPlease check your configuration](http://langzhe.iteye.com/blog/832792)
[木头人 - erlang use](http://allran.github.io/2015/05/13/erlang-use/)

********************************************************************************************************************************************************************************************************

### 二. 需要引入其它域名,只需在配置文件 /usr/local/etc/ejabberd/ejabberd.yml 里的配置段

``` bash 
hosts:
  - "localhost"
  - "coam.co"
  - "coopens.com"
```

添加其它域名即可使用以下命令添加用户,并可跨域聊天加好友

``` bash 
ejabberdctl register zyfmix coam.co ****** 
```

********************************************************************************************************************************************************************************************************

#### Ejabberd 数据存储配置

> 一般 modules 下的每个模块都有 db_type 的配置选项,默认为 mnesia 可以将他们分别配置成 {mnesia|odbc|riak} 
其中[Session Management] sm_db_type 还可选择配置成 redis 存储
还可以设定全局配置数据存储方式,使用 default_db: odbc 配置 
以下是一个示例:

```
default_db: odbc  #+++# 全局配置使用 odbc 当做数据存储
modules:
   ...
  mod_roster:  #{}
    db_type: odbc  #+++# 使用 Mysql 数据库存储花名册 [rosterusers]
  mod_shared_roster:   #{}
    db_type: odbc  #+++# 使用 Mysql 数据库存储花名册 [***]
  ...

# Session Management
sm_db_type: odbc  #+++# Session Management {mnesia|odbc|redis}
```

#### 开启 XEP-0363 的 HTTP 文件上传

使用 Conversations 查看用户登录账户的服务器信息,发现提示 XEP-0363 的 HTTP 文件上传不支持,需要进行如下配置

```
listen:
  ...
  -
    port: 5443
    module: ejabberd_http
    tls: true
    certfile: "/usr/local/etc/ejabberd/ejabberd.pem"
    request_handlers:
      ...
      "upload": mod_http_upload
      ...
  ...

modules:
  ...
  mod_http_upload:
    docroot: "/data/home/yzhang/ServerCoam/www/public/ejabberd/upload"
    put_url: "https://@HOST@:5443/upload"
    thumbnail: true
```

需要添加一个 ejabberd_http 的监听,并且 request_handlers 添加 使用 mod_http_upload 模块 处理 /upload 的请求

注意:默认 开启 thumbnail: true 压缩图片需要安装 imagemagick ,否则启动 ejabberd 会报错, 
UBUNTU 下通过以下命令安装 ImageMagick

```
sudo apt install imagemagick
```

参考

[rodleviton/imagemagick-install-steps](https://gist.github.com/rodleviton/74e22e952bd6e7e5bee1)
[imagemagick](http://www.imagemagick.org/script/)

#### 开启 XEP-0237 花名册版本控制

```
modules:
...
  mod_roster:  #{}
    versioning: true  #+++# XEP-0237 提供花名册版本控制
...
```

参考
[How to enable XEP-0313 and XEP-0237 in ejabberd 15.03](https://www.lebsanft.org/?p=537)
[Ejabberd模块开发, 简介](http://developerworks.github.io/2014/09/26/ejabberd-modules-development-deep/)

********************************************************************************************************************************************************************************************************

#### 使用 Nginx 反向代理 请求 到 coopens.com:5280

> 默认需要使用 coopens.com:5280 这个端口来访问 ejabberd /http-bind 请求,可以使用 Nginx 反向代理请求到 coopens.com:5280 这样就屏蔽了对端口的请求显示

```
location ~ ^/http-bind/ {
    proxy_pass https://coopens.com:5280;
}
```

参见
[Converse.js Setup and integration](https://conversejs.org/docs/html/setup.html)

********************************************************************************************************************************************************************************************************

### 添加 letsencrypt ssl 证书,支持 Conversations 开源客户端连接

Android 安装 Conversations 客户端后提示 服务器不兼容,怀疑是 ejabberd 没有添加ssl证书提供加密支持的原因,于是首先添加 letsencrypt 域名证书

对 coopens.com 的域名证书获取到后 /etc/letsencrypt/live/coopens.com/ 有如下4个文件
                               
    cert.pem 
    chain.pem
    fullchain.pem
    privkey.pem

直接将任何一个证书文件拷贝到 /usr/local/etc/ejabberd/ 下配置

```
listen:
  -
    port: 5222
    ip: "::"
    module: ejabberd_c2s
    ##
    ## If TLS is compiled in and you installed a SSL
    ## certificate, specify the full path to the
    ## file and uncomment this line:
    ##
    certfile: "/usr/local/etc/ejabberd/cert.pem"  ## cert.pem | chain.pem | fullchain.pem | privkey.pem
    starttls: true
```

启动 ejabberd 后 浏览器 js 客户端能顺利登陆,但是 Conversations 仍提示 服务器不兼容,ejabberdctl live 模式下提示如下错误:

```
10:18:12.106 [error] gen_fsm <0.508.0> in state wait_for_feature_request terminated with reason: no match of right hand value
 {error,<<"SSL_CTX_use_PrivateKey_file failed: error:0906D06C:PEM routines:PEM_read_bio:no start line">>} in ejabberd_socket:starttls/3 line 153
```

怀疑证书有问题,于是使用如下命令合并证书并重启 ejabberd 顺利解决问题, Conversations 能顺利登陆没有再出现其它错误

``` bash 
cat /etc/letsencrypt/live/coopens.com/privkey.pem /etc/letsencrypt/live/coopens.com/fullchain.pem >> /usr/local/etc/ejabberd/ejabberd.pem
```

参考 
[Tutorial on ejabberd, postfix, dovecot and or nginx with letsencrypt](https://community.letsencrypt.org/t/tutorial-on-ejabberd-postfix-dovecot-and-or-nginx-with-letsencrypt/7320)
[Conversations - Incompatible Server](https://github.com/siacs/Conversations/issues/893)

***

总结 让 ejabberd 添加 ssl 证书支持,需要改动的配置有以下地方:

> 修改 ejabberd_c2s 证书配置信息

```
listen: 
  - 
    port: 5222
    module: ejabberd_c2s
    ##
    ## If TLS is compiled in and you installed a SSL
    ## certificate, specify the full path to the
    ## file and uncomment these lines:
    ##
    certfile: "/usr/local/etc/ejabberd/ejabberd.pem"  #+++# 添加 ssl 证书支持
    starttls: true
    ##
    ## To enforce TLS encryption for client connections,
    ## use this instead of the "starttls" option:
    ##
    ## starttls_required: true
    ##
    ## Custom OpenSSL options
    ##
    protocol_options:
      - "no_sslv3"  #+++# 不使用 sslv3
    ##   - "no_tlsv1"
    ...
```

> 取消一下注释 修改 s2s_certfile 证书配置信息 

```
##
## s2s_use_starttls: Enable STARTTLS + Dialback for S2S connections.
## Allowed values are: false optional required required_trusted
## You must specify a certificate file.
##
s2s_use_starttls: optional

##
## s2s_certfile: Specify a certificate file.
##
s2s_certfile: "/usr/local/etc/ejabberd/ejabberd.pem"

## Custom OpenSSL options
##
s2s_protocol_options:
  - "no_sslv3"
##   - "no_tlsv1"
```

虚拟主机单独配置 

```
listen:
  -
    port: 5222
    module: ejabberd_c2s
    certfile: "/etc/ssl/example.com.cert+priv+sub.key"
    starttls: true
    starttls_required: true
    #max_stanza_size: 65536
    max_ack_queue: 32767
    resume_timeout: 1200        # 20 minutes to recover session,
    resend_on_timeout: true     # but it is okay to timeout.
    shaper: c2s_shaper
    access: c2s

host_config:
  "example.com":
    domain_certfile: "/etc/ssl/example.com.cert+priv+sub.key"
  "example.org":
    domain_certfile: "/etc/ssl/example.org.cert+priv+sub.key"
  "example.net":
    domain_certfile: "/etc/ssl/example.net.cert+priv+sub.key"

```
    
参考 
[Conversations Incompatible Server](https://github.com/siacs/Conversations/issues/893)
[ejabberd config to make conversations client on android work perfectly](https://gist.github.com/887/aab3787621901d7a5bd4)

********************************************************************************************************************************************************************************************************
