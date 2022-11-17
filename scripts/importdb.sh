#/usr/bin
#上海宁卫信息技术有限公司数据库导入
 
service postgresql restart

/sbin/chkconfig postgresql on
 
su - postgres -c "psql -c \"create database cloudcc;\""
su - postgres -c "psql -c \"create database cloudcc_web;\""
su - postgres -c "pg_restore -d cloudcc -v '/opt/cloudcc/database/cloudcc.sql'"
su - postgres -c "pg_restore -d cloudcc_web -v '/opt/cloudcc/database/cloudcc.sql'"
sed -i '82 s/ident/md5/g' /db/data/pg_hba.conf
/etc/init.d/postgresql restart
su - postgres -c "psql -U postgres -d postgres -c \"alter user postgres with password 'Nway2017';\""
 
service postgresql restart

 


