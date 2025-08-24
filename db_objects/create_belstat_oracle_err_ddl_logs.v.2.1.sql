
--
-- ВНИМАНИМЕ Настоящая процедура является частью коммерческого программного продукта ОрСиМОН БЕССТ (С) Sergey S. Belonin Все права защищены.
-- Использование настоящего кода без заключения письменного лицензионного соглашения с правообладателем или правомочным сублицензиаром ЗАПРЕЩЕНО
-- ATTENTION This procedure are part of commercial software product OrSiMON BESST (C) Sergey S. Belonin All rights reserved
-- Before use this procedure you must sign license agreement with owner or sublicensear
--

grant create TRIGGER to bestat ;
grant ADMINISTER DATABASE TRIGGER to bestat ;

DROP TRIGGER BESTAT_ERROR_LOGGER ;
DROP TABLE BESTAT_ERROR_LOGS ;

CREATE TABLE BESTAT_ERROR_LOGS ( TMST_RECORD date, USERNAME VARCHAR2(30), INSTANCE NUMBER, DBNAME VARCHAR2(50), ERROR_STACK VARCHAR2(2000) ) ;
CREATE OR REPLACE TRIGGER BESTAT_ERROR_LOGGER AFTER SERVERERROR ON DATABASE
BEGIN
INSERT INTO BESTAT_ERROR_LOGS VALUES ( SYSDATE, ORA_LOGIN_USER, ORA_INSTANCE_NUM, ORA_DATABASE_NAME, DBMS_UTILITY.FORMAT_ERROR_STACK ) ;
END BESTAT_ERROR_LOGGER ;
/

SET LINESIZE 300
SET PAGESIZE 300
COL ERROR_STACK FORMAT A90
SELECT TO_CHAR(TMST_RECORD,'YYYY-MM-DD HH24:MI:SS') TM_STAMP, USERNAME, ERROR_STACK from BESTAT_ERROR_LOGS ;


DROP TRIGGER BESTAT_DDL_LOGGER ;
DROP TABLE BESTAT_DDL_LOGS ;
CREATE TABLE BESTAT_DDL_LOGS ( TMST_RECORD DATE, EVENT_NAME VARCHAR2(20), LOGIN_USER VARCHAR2(30), OBJECT_OWNER VARCHAR2(30), OBJECT_NAME VARCHAR2(30),
       OBJECT_TYPE VARCHAR2(20)) ;
CREATE OR REPLACE TRIGGER BESTAT_DDL_LOGGER AFTER CREATE OR ALTER OR DROP ON DATABASE
BEGIN
INSERT INTO BESTAT_DDL_LOGS VALUES ( SYSDATE, ORA_SYSEVENT, ORA_LOGIN_USER, ORA_DICT_OBJ_OWNER, ORA_DICT_OBJ_NAME, ORA_DICT_OBJ_TYPE ) ;
END BESTAT_DDL_LOGGER ;
/

SET LINESIZE 300
SET PAGESIZE 300
SELECT TO_CHAR(TMST_RECORD,'YYYY-MM-DD HH24:MI:SS') TM_STAMP, LOGIN_USER, EVENT_NAME, OBJECT_OWNER, OBJECT_NAME, OBJECT_TYPE FROM BESTAT_DDL_LOGS ;

SPOOL clear_bestat_jobs.txt
variable jobno number;
variable instno number;
begin
  select instance_number into :instno from v$instance;
  dbms_job.submit(:jobno, 'delete from BESTAT.BESTAT_DDL_LOGS where TMST_RECORD<sysdate-7;', sysdate+1, 'SYSDATE+1', TRUE, :instno);
  commit;
end;
/
select job, next_date, next_sec from user_jobs where job = :jobno;

begin
  select instance_number into :instno from v$instance;
  dbms_job.submit(:jobno, 'delete from BESTAT.BESTAT_ERROR_LOGS where TMST_RECORD<sysdate-7;', sysdate+1, 'SYSDATE+1', TRUE, :instno);
  commit;
end;
/
select job, next_date, next_sec from user_jobs where job = :jobno;
SPOOL off;

