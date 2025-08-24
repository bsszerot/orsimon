#!/bin/bash

sqlplus "/ as sysdba" <<EOF
set serveroutput on
exec DBMS_OUTPUT.ENABLE(2000000) ;
exec SYS.BELSTAT_GET_ORA_STAT ;
exit ;
EOF
