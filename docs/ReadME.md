
# Ejabberd 二次开发规范

> Fork -> git clone ... -> git remote add upstream -> git fetch upstream -> ...

********************************************************************************************************************************************************************************************************

## [processone/ejabberd] 项目

*. Fork [processone/ejabberd](https://github.com/processone/ejabberd) 项目

``` bash 
git clone https://github.com/coam/ejabberd.git
git remote add upstream https://github.com/processone/ejabberd.git
git fetch upstream
git remote -v
git fetch upstream 16.01:16.01
git checkout 16.01
git checkout -b rebuild
git checkout -b rebuild_16.01
// todo...
git push origin rebuild_16.01
```

*. 以后每次更新版本 `VNO`

``` bash 
git fetch upstream $VNO:$VNO
git checkout $VNO
git checkout -b rebuild_$VNO
git merge rebuild
git push origin rebuild_$VNO
```

********************************************************************************************************************************************************************************************************

# 同步 ejabberd 项目...

1. 删除 Fork [coam/ejabberd](https://github.com/coam/ejabberd) 项目
2. 重新 Fork [processone/ejabberd](https://github.com/processone/ejabberd) 项目
3. 拉取到本地

``` bash 
git clone https://github.com/coam/ejabberd.git
git checkout tags/16.01
git checkout -b rebuild_16.01
```

4. 同步远程(upstream)项目

``` bash 
git remote add upstream https://github.com/processone/ejabberd.git
git fetch upstream
git remote -v
```

5. 手动合并代码

//todo...

6. 推送分支...

``` bash
git push origin rebuild_19.05
```

********************************************************************************************************************************************************************************************************

## 同步 Fork 远程分支

> 同步远程(upstream)分支 `19.05` 到本地(origin) 

``` bash 
git remote add upstream https://github.com/processone/ejabberd.git
git fetch upstream
git fetch upstream 19.05:19.05
```

********************************************************************************************************************************************************************************************************

* 增加 `Emysql` 依赖库,详见 `rebar.config`

> 修改 `Ejabberd` 依赖配置文件 `rebar.config` 修改部分如下

``` erlang
{emysql, ".*", {git, "https://github.com/coam/Emysql.git"}}
```

********************************************************************************************************************************************************************************************************

## 新建数据库 IM_Ejabberd 按官方的源码,导入 `/sql/mysql.sql `

``` bash 
cd ejabberd/sql/
mysql -u zhangyanxi -p
...
mysql:> use IM_Ejabberd;
mysql:>source mysql.sql;
```

********************************************************************************************************************************************************************************************************

## `Ejabberd` 扩展 `ejabberd_contrib` 模块相关

``` bash 
ejabberdctl modules_available
```

********************************************************************************************************************************************************************************************************

## 常用命令

* 注册用户后,发现数据库表 users 已经有了新添加的用户记录:

```
sudo ejabberdctl register zyfmix coopens.com ******
```

********************************************************************************************************************************************************************************************************

## `Ejabberd` 服务器运营常见问题解决

## 使用命令 `sudo ejabberdctl status` 查看 ejabberd 运行状态或是运行其它命令 `sudo ejabberdctl modules_available`,发现老是提示错误:

```
Failed RPC connection to the node 'ejabberd@coopens.com': nodedown
```

一般是 ejabberd 服务未运行,启动 ejabberd 服务即可.

也有一种情况是 ejabberdctl.cfg 配置 不正确(不是 *@coopens.com ).或者 `/etc/ejabberd/ejabberdctl.cfg` 已经是配置的 `coopens.com`,
并且当前 ejabberd 服务器节点正在运行,估计未销毁之前的 ejabberd 关联 epmd 进程,检查并关闭如下端口的进程:

``` bash 
sudo netstat -antup | grep epmd
sudo kill pid
sudo netstat -antup | grep beam.smp
sudo kill pid
```

其中 epmd 是 Erlang Port Mapper Daemon 的缩写,全称足够明确表达它的功能了(相比之下,OTP就是一个难以从字面理解的名字);epmd 完成 Erlang 节点和IP,端口的映射关系,比如在我的测试机上

再使用命令 sudo ejabberdctl restart 重启即可重新打开 ejabberd 进程服务即可

## 修改 `ERLANG_NODE` 后使用命令 `ejabberdctl live` 启动 `ejabberd` 会报如下错误: 

``` bash 
[critical] Node name mismatch: I'm [ejabberd@coopens.com], the database is owned by [ejabberd@localhost]
```

原因是 `Mnesia` 和 新配置的 `node` 名称不匹配,如果刚安装没有重要数据的话,可以将 `/var/lib/ejabberd/*` 下的所有 `spool` 文件全部删除,使用重启即可重新生成新的数据文件

[Mysql config problem](https://www.ejabberd.im/node/21288)
[How to change bydefault node name of ejabberd which is ejabberd@localhost?](http://stackoverflow.com/questions/17471021/how-to-change-bydefault-node-name-of-ejabberd-which-is-ejabberdlocalhost)

********************************************************************************************************************************************************************************************************