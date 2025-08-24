#!/bin/bash

#export ORAENV_ASK=NO
#export ORACLE_SID=XXX
#. oraenv
export ORACLE_HOME=/oracle/soft/11.2.0
export ORACLE_SID=TEST1
export NLS_LANG=American_America.UTF8
export PATH=$ORACLE_HOME/bin:$PATH
export NLS_DATE_FORMAT="YYYY-MM-DD HH24:MI:SS"

sqlplus "/ as sysdba" <<EOF
set serveroutput on echo on linesize 300 hea on
select sysdate from dual ;
exec DBMS_STATS.GATHER_DATABASE_STATS(GRANULARITY=>'ALL', METHOD_OPT=>'FOR ALL',CASCADE=>TRUE,OPTIONS=>'GATHER',GATHER_SYS=>FALSE) ;
select sysdate from dual ;
exit ;
EOF

