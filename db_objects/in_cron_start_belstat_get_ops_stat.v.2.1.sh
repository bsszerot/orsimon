#!/bin/bash

#export ORACLE_HOME=/oracle/soft/11.2.0
export ORAENV_ASK=NO
export ORACLE_SID=TEST1
. oraenv
export NLS_LANG=American_America.UTF8
export PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
 
sqlplus bestat/qwe123rt <<EOF
set serveroutput on
exec DBMS_OUTPUT.ENABLE(2000000) ;
exec BESTAT.BESTAT_GET_OPS_SREZ ;
exit ;
EOF
