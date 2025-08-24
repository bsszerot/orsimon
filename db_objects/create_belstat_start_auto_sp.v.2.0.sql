
spool spauto_enable.log
-- разлочить пользователя принудительно
-- --alter user perfstat account unlock identified by пароль_пользователя_perfstat ;
-- --commit ;
-- добавить место в табличном пространстве
-- --alter database datafile '.../statspack00.dbf' autoextend on maxsize 4096m ;
variable jobno number;
variable instno number;
-- добавить периодический съём снапшотов
begin
select instance_number into :instno from v$instance;
dbms_job.submit(:jobno, 'statspack.snap(10);', sysdate+15/1440, 'SYSDATE+30/1440', TRUE, :instno);
commit;
end;
/
-- добавить удаление старых снапшотов
select job, next_date, next_sec from user_jobs where job = :jobno;
begin
select instance_number into :instno from v$instance;
dbms_job.submit(:jobno, 'delete from perfstat.stats$snapshot where snap_time<sysdate-7;', 
         sysdate+1, 'SYSDATE+1', TRUE, :instno);
commit;
end;
/
-- просмотреть содержимое заданий
select job, next_date, next_sec from user_jobs where job = :jobno;
spool off;
col WHAT for a60
col NLS_ENV for a30
col INTERVAL for a30
col MISC_ENV for a30
set linesize 300
select JOB,LOG_USER,PRIV_USER,SCHEMA_USER,LAST_DATE,LAST_SEC,THIS_DATE,THIS_SEC,NEXT_DATE,NEXT_SEC,
        TOTAL_TIME,INTERVAL,FAILURES,WHAT from dba_jobs ;
-- просмотреть размер табличного пространства под хранение снапшотов
col TABLESPACE_NAME for a30
col FILE_NAME for a60
select TABLESPACE_NAME,FILE_NAME,BYTES,MAXBYTES,AUTOEXTENSIBLE,INCREMENT_BY 
       from dba_data_files where tablespace_name = 'STATSPACK_DATA' ;
select USERNAME,DEFAULT_TABLESPACE,TEMPORARY_TABLESPACE,CREATED,PROFILE from dba_users where username = 'PERFSTAT' ;
exit
