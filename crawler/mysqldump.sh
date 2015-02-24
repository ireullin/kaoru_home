#! /bin/sh
FILE_SQL=/tmp/kaoru_home_sqldump_`date +%Y%m%d`.sql
FILE_7Z=$FILE_SQL.7z
mysqldump -h192.168.1.203 -uremote -pletmedie kaoru_home > $FILE_SQL
7z a $FILE_7Z $FILE_SQL
rm $FILE_SQL
mv $FILE_7Z /mnt/sql_dump
