CloudCC的简要使用说明

 这个应用的主旨是协助大量的使用FreeSWITCH以及OpenSIPS和Kamailio的用户，能通过web去管理和控制这些相关的应用，当然这个版本在用户体验方面不是太成熟，如果有什么意见请发邮件：lihao@nway.com.cn

1. 在centos7+系统中

```
rpm -hiv cloudcc-xxx.rpm #会自动把相关服务安装在/opt下

```
如果未安装postgresql，那么就

```
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

 
sudo yum install -y postgresql12-server

 
sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
sudo systemctl enable postgresql-12
sudo systemctl start postgresql-12
```

然后导入数据库，在/opt/cloudcc/scripts/importdb.sh中
```
service postgresql-12 restart

/sbin/chkconfig postgresql-12 on
 
su - postgres -c "psql -c \"create database cloudcc;\""
su - postgres -c "psql -c \"create database cloudcc_web;\""
su - postgres -c "pg_restore -d cloudcc -v '/opt/cloudcc/database/cloudcc.sql'"
su - postgres -c "pg_restore -d cloudcc_web -v '/opt/cloudcc/database/cloudcc.sql'"
sed -i '82 s/ident/md5/g' /db/data/pg_hba.conf
/etc/init.d/postgresql-12 restart
su - postgres -c "psql -U postgres -d postgres -c \"alter user postgres with password 'Nway2017';\""
 
service postgresql-12 restart
```
切记：
数据库postgres的密码为Nway2017就不需要过多折腾应用中的配置，当然你也可以自己来按自己的想法配置（这里需要注意一下，如果有必要就在/usr/pgsql-12/data/pg_hba.conf中 127.0.0.1 的trust改为md5)
最后，重启服务器，或
```
service cloudcc_web restart
service cloudcc_server restart
service nway_cmd_svr restart
```

2. 在debian等系统中
```

tar zxvf cloudcc.tar.gz /opt/.
```
如果未安装postgresql，那么就
```
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

 
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

 
sudo apt-get update
 
sudo apt-get -y install postgresql-12
```

其它部分同1