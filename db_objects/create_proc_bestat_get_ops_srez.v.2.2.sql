
set verify off linesize 1000 hea off ;

-- ####################################################################################################################################
-- процедура заполнения среза ОПЕРАТИВНОЙ статистики
-- ####################################################################################################################################
DROP PROCEDURE BESTAT_GET_OPS_SREZ ;
CREATE OR REPLACE PROCEDURE BESTAT_GET_OPS_SREZ AS
MY_POINT_ID NUMBER ;
MY_STAT_RANGE_ID NUMBER ;
MY_COUNT_STAT_RANGE_ID NUMBER ;
MY_RESETLOGS_CHANGE NUMBER ;
MY_RESETLOGS_TIME DATE ;
MY_START_INSTANCE DATE ;
MY_STAMP_RECORD DATE ;
-- 20110125
MY_PREV_POINT_ID NUMBER ;
BEGIN
--
-- ВНИМАНИМЕ Настоящая процедура является частью коммерческого программного продукта ОрСиМОН БЕССТ (С) Sergey S. Belonin Все права защищены.
-- Использование настоящего кода без заключения письменного лицензионного соглашения с правообладателем или правомочным сублицензиаром ЗАПРЕЩЕНО
-- ATTENTION This procedure are part of commercial software product OrSiMON BESST (C) Sergey S. Belonin All rights reserved
-- Before use this procedure you must sign license agreement with owner or sublicensear
--
-- вытащить общие данные
SELECT BESTAT_SEQ_COLLE_POINTS.NEXTVAL INTO MY_POINT_ID FROM DUAL ;
SELECT CURRENT_DATE INTO MY_STAMP_RECORD FROM DUAL ;
SELECT RESETLOGS_CHANGE#, RESETLOGS_TIME INTO MY_RESETLOGS_CHANGE, MY_RESETLOGS_TIME FROM v$database ;
SELECT STARTUP_TIME INTO MY_START_INSTANCE FROM v$instance ;
-- 20110125
SELECT MAX(POINT_ID) INTO MY_PREV_POINT_ID FROM BESTAT_COLLECTOR_POINTS WHERE POINT_TYPE = 'OPS' ;
-- определить существование записей для текущего статистического диапазона. При наличии - вытащить номер из существующих записей, 
-- при отсутствии - следующий номер из последовательности
SELECT COUNT(POINT_ID) INTO MY_COUNT_STAT_RANGE_ID 
       FROM BESTAT_COLLECTOR_POINTS 
       WHERE ROWNUM = 1 AND RESETLOGS_CHANGE# = MY_RESETLOGS_CHANGE AND RESETLOGS_TIME = MY_RESETLOGS_TIME AND START_INSTANCE = MY_START_INSTANCE ;
IF MY_COUNT_STAT_RANGE_ID > 0 THEN 
   SELECT STAT_RANGE_ID INTO MY_STAT_RANGE_ID 
          FROM BESTAT_COLLECTOR_POINTS 
          WHERE ROWNUM = 1 AND RESETLOGS_CHANGE# = MY_RESETLOGS_CHANGE AND RESETLOGS_TIME = MY_RESETLOGS_TIME AND START_INSTANCE = MY_START_INSTANCE ;
ELSE 
   SELECT BESTAT_SEQ_COLLE_STATS_RANGE.NEXTVAL INTO MY_STAT_RANGE_ID FROM DUAL ;
END IF ;
-- занести запись о создаваемом срезе данных с типом - ОПЕРАТИВНАЯ СТАТИСТИКА
INSERT INTO BESTAT_COLLECTOR_POINTS VALUES (MY_POINT_ID, MY_STAT_RANGE_ID, 'OPS', 'NONE', MY_RESETLOGS_CHANGE, MY_RESETLOGS_TIME, MY_START_INSTANCE, MY_STAMP_RECORD, '') ;
-- занести записи в таблицу среза информации о сессияи
FOR curr_ses_info_data IN (select * from v$session) LOOP
    INSERT INTO BESTAT_SESSIONS VALUES ( MY_POINT_ID, curr_ses_info_data.SADDR, curr_ses_info_data.SID, curr_ses_info_data.SERIAL#, 
           curr_ses_info_data.AUDSID, curr_ses_info_data.PADDR, curr_ses_info_data.USER#, curr_ses_info_data.USERNAME, curr_ses_info_data.COMMAND, 
           curr_ses_info_data.OWNERID, curr_ses_info_data.TADDR, curr_ses_info_data.LOCKWAIT, curr_ses_info_data.STATUS, curr_ses_info_data.SERVER, 
           curr_ses_info_data.SCHEMA#, curr_ses_info_data.SCHEMANAME, curr_ses_info_data.OSUSER, curr_ses_info_data.PROCESS, curr_ses_info_data.MACHINE, 
           curr_ses_info_data.TERMINAL, curr_ses_info_data.PROGRAM, curr_ses_info_data.TYPE, curr_ses_info_data.SQL_ADDRESS, 
           curr_ses_info_data.SQL_HASH_VALUE, curr_ses_info_data.PREV_SQL_ADDR, curr_ses_info_data.PREV_HASH_VALUE, curr_ses_info_data.MODULE, 
           curr_ses_info_data.MODULE_HASH, curr_ses_info_data.ACTION, curr_ses_info_data.ACTION_HASH, curr_ses_info_data.CLIENT_INFO, 
           curr_ses_info_data.FIXED_TABLE_SEQUENCE, curr_ses_info_data.ROW_WAIT_OBJ#, curr_ses_info_data.ROW_WAIT_FILE#, 
           curr_ses_info_data.ROW_WAIT_BLOCK#, curr_ses_info_data.ROW_WAIT_ROW#, curr_ses_info_data.LOGON_TIME, curr_ses_info_data.LAST_CALL_ET, 
           curr_ses_info_data.PDML_ENABLED, curr_ses_info_data.FAILOVER_TYPE, curr_ses_info_data.FAILOVER_METHOD, curr_ses_info_data.FAILED_OVER, 
           curr_ses_info_data.RESOURCE_CONSUMER_GROUP, curr_ses_info_data.PDML_STATUS, curr_ses_info_data.PDDL_STATUS, curr_ses_info_data.PQ_STATUS, 
           curr_ses_info_data.CURRENT_QUEUE_DURATION, curr_ses_info_data.CLIENT_IDENTIFIER ) ;
    END LOOP ;
-- занести записи в таблицу среза информации о серверных процессах
FOR curr_processes_data IN (select * from v$process) LOOP
    INSERT INTO BESTAT_PROCESSES VALUES ( MY_POINT_ID, curr_processes_data.ADDR, curr_processes_data.PID, curr_processes_data.SPID, 
           curr_processes_data.USERNAME, curr_processes_data.SERIAL#, curr_processes_data.TERMINAL, curr_processes_data.PROGRAM, 
           curr_processes_data.TRACEID, curr_processes_data.BACKGROUND, curr_processes_data.LATCHWAIT, curr_processes_data.LATCHSPIN, 
           curr_processes_data.PGA_USED_MEM, curr_processes_data.PGA_ALLOC_MEM, curr_processes_data.PGA_FREEABLE_MEM, 
           curr_processes_data.PGA_MAX_MEM ) ;
    END LOOP ;
-- занести записи в таблицу среза оперативной статистики статистик сессий
FOR curr_ses_stats_data IN (select * from v$sesstat) LOOP
    INSERT INTO BESTAT_SESSION_STATS VALUES (MY_POINT_ID, curr_ses_stats_data.SID, curr_ses_stats_data.STATISTIC#, curr_ses_stats_data.VALUE) ;
    END LOOP ;
-- занести записи в таблицу среза оперативной статистики статистик экземпляра
FOR curr_sys_stats_data IN (select * from v$sysstat) LOOP
    INSERT INTO BESTAT_SYSTEM_STATS VALUES (MY_POINT_ID, curr_sys_stats_data.STATISTIC#, curr_sys_stats_data.NAME, 
           curr_sys_stats_data.CLASS, curr_sys_stats_data.VALUE) ;
    END LOOP ;
-- занести записи в таблицу среза оперативной статистики событий сессий
FOR curr_ses_events_data IN (select * from v$session_event) LOOP
    INSERT INTO BESTAT_SESSION_EVENTS VALUES (MY_POINT_ID, curr_ses_events_data.SID, curr_ses_events_data.EVENT, curr_ses_events_data.TOTAL_WAITS,
           curr_ses_events_data.TOTAL_TIMEOUTS, curr_ses_events_data.TIME_WAITED, curr_ses_events_data.AVERAGE_WAIT, curr_ses_events_data.MAX_WAIT,
           curr_ses_events_data.TIME_WAITED_MICRO) ;
    END LOOP ;
-- занести записи в таблицу среза оперативной статистики событий экземпляра
FOR curr_sys_events_data IN (select * from v$system_event) LOOP
    INSERT INTO BESTAT_SYSTEM_EVENTS VALUES (MY_POINT_ID, curr_sys_events_data.EVENT, curr_sys_events_data.TOTAL_WAITS,
           curr_sys_events_data.TOTAL_TIMEOUTS,curr_sys_events_data.TIME_WAITED,curr_sys_events_data.AVERAGE_WAIT,
           curr_sys_events_data.TIME_WAITED_MICRO) ;
    END LOOP ;
-- занести записи в таблицу среза оперативной статистики ожиданий сессии
FOR curr_ses_waits_data IN (select * from v$session_wait) LOOP
    INSERT INTO BESTAT_SESSION_WAITS VALUES (MY_POINT_ID, curr_ses_waits_data.SID, curr_ses_waits_data.SEQ#, curr_ses_waits_data.EVENT, 
           curr_ses_waits_data.P1TEXT, curr_ses_waits_data.P1, curr_ses_waits_data.P1RAW, curr_ses_waits_data.P2TEXT, curr_ses_waits_data.P2, 
           curr_ses_waits_data.P2RAW, curr_ses_waits_data.P3TEXT, curr_ses_waits_data.P3, curr_ses_waits_data.P3RAW, curr_ses_waits_data.WAIT_TIME,
           curr_ses_waits_data.SECONDS_IN_WAIT, curr_ses_waits_data.STATE) ;
    END LOOP ;
-- занести записи в таблицу среза данных о ТС (из контролфайла)
FOR curr_ctf_ts_data IN (select * from V$TABLESPACE) LOOP
    INSERT INTO BESTAT_V$TABLESPACE VALUES (MY_POINT_ID, curr_ctf_ts_data.TS#, curr_ctf_ts_data.NAME, curr_ctf_ts_data.INCLUDED_IN_DATABASE_BACKUP) ;
    END LOOP ;
-- занести записи в таблицу среза данных о ТС (из словаря)
FOR curr_dic_ts_data IN (select * from DBA_TABLESPACES) LOOP
    INSERT INTO BESTAT_DBA_TABLESPACES VALUES (MY_POINT_ID, curr_dic_ts_data.TABLESPACE_NAME, curr_dic_ts_data.BLOCK_SIZE, 
           curr_dic_ts_data.INITIAL_EXTENT, curr_dic_ts_data.NEXT_EXTENT, curr_dic_ts_data.MIN_EXTENTS, curr_dic_ts_data.MAX_EXTENTS, 
           curr_dic_ts_data.PCT_INCREASE, curr_dic_ts_data.MIN_EXTLEN, curr_dic_ts_data.STATUS, curr_dic_ts_data.CONTENTS, 
           curr_dic_ts_data.LOGGING, curr_dic_ts_data.FORCE_LOGGING, curr_dic_ts_data.EXTENT_MANAGEMENT, curr_dic_ts_data.ALLOCATION_TYPE, 
           curr_dic_ts_data.PLUGGED_IN, curr_dic_ts_data.SEGMENT_SPACE_MANAGEMENT, curr_dic_ts_data.DEF_TAB_COMPRESSION ) ;
    END LOOP ;
-- занести записи в таблицу среза данных свободном месте в ТС
FOR curr_free_space_data IN (select * from DBA_FREE_SPACE) LOOP
    INSERT INTO BESTAT_DBA_FREE_SPACE VALUES (MY_POINT_ID, curr_free_space_data.TABLESPACE_NAME, curr_free_space_data.FILE_ID, 
           curr_free_space_data.BLOCK_ID, curr_free_space_data.BYTES, curr_free_space_data.BLOCKS, curr_free_space_data.RELATIVE_FNO ) ;
    END LOOP ;
-- занести записи в таблицу среза файлов данных (из контролфайла)
FOR curr_ctf_df_data IN (select * from V$DATAFILE) LOOP
    INSERT INTO BESTAT_V$DATAFILE VALUES (MY_POINT_ID, curr_ctf_df_data.FILE#, curr_ctf_df_data.CREATION_CHANGE#, curr_ctf_df_data.CREATION_TIME, 
           curr_ctf_df_data.TS#, curr_ctf_df_data.RFILE#, curr_ctf_df_data.STATUS, curr_ctf_df_data.ENABLED, curr_ctf_df_data.CHECKPOINT_CHANGE#, 
           curr_ctf_df_data.CHECKPOINT_TIME, curr_ctf_df_data.UNRECOVERABLE_CHANGE#, curr_ctf_df_data.UNRECOVERABLE_TIME, curr_ctf_df_data.LAST_CHANGE#,
           curr_ctf_df_data.LAST_TIME, curr_ctf_df_data.OFFLINE_CHANGE#, curr_ctf_df_data.ONLINE_CHANGE#, curr_ctf_df_data.ONLINE_TIME, 
           curr_ctf_df_data.BYTES, curr_ctf_df_data.BLOCKS, curr_ctf_df_data.CREATE_BYTES, curr_ctf_df_data.BLOCK_SIZE, curr_ctf_df_data.NAME,
           curr_ctf_df_data.PLUGGED_IN, curr_ctf_df_data.BLOCK1_OFFSET, curr_ctf_df_data.AUX_NAME ) ;
    END LOOP ;
-- занести записи в таблицу среза файлов данных (из словаря)
FOR curr_dic_df_data IN (select * from DBA_DATA_FILES) LOOP
    INSERT INTO BESTAT_DBA_DATA_FILES VALUES (MY_POINT_ID, curr_dic_df_data.FILE_NAME, curr_dic_df_data.FILE_ID, curr_dic_df_data.TABLESPACE_NAME, 
           curr_dic_df_data.BYTES, curr_dic_df_data.BLOCKS, curr_dic_df_data.STATUS, curr_dic_df_data.RELATIVE_FNO, curr_dic_df_data.AUTOEXTENSIBLE, 
           curr_dic_df_data.MAXBYTES, curr_dic_df_data.MAXBLOCKS, curr_dic_df_data.INCREMENT_BY, curr_dic_df_data.USER_BYTES, 
           curr_dic_df_data.USER_BLOCKS ) ;
    END LOOP ;
-- занести записи в таблицу среза временных файлов (из контролфайла)
FOR curr_ctf_tf_data IN (select * from V$TEMPFILE) LOOP
    INSERT INTO BESTAT_V$TEMPFILE VALUES (MY_POINT_ID, curr_ctf_tf_data.FILE#, curr_ctf_tf_data.CREATION_CHANGE#, curr_ctf_tf_data.CREATION_TIME, 
           curr_ctf_tf_data.TS#, curr_ctf_tf_data.RFILE#, curr_ctf_tf_data.STATUS, curr_ctf_tf_data.ENABLED, curr_ctf_tf_data.BYTES, 
           curr_ctf_tf_data.BLOCKS, curr_ctf_tf_data.CREATE_BYTES, curr_ctf_tf_data.BLOCK_SIZE, curr_ctf_tf_data.NAME ) ;
    END LOOP ;
-- занести записи в таблицу среза временных файлов (из словаря)
FOR curr_dic_tf_data IN (select * from DBA_TEMP_FILES) LOOP
    INSERT INTO BESTAT_DBA_TEMP_FILES VALUES (MY_POINT_ID, curr_dic_tf_data.FILE_NAME, curr_dic_tf_data.FILE_ID, curr_dic_tf_data.TABLESPACE_NAME, 
           curr_dic_tf_data.BYTES, curr_dic_tf_data.BLOCKS, curr_dic_tf_data.STATUS, curr_dic_tf_data.RELATIVE_FNO, curr_dic_tf_data.AUTOEXTENSIBLE, 
           curr_dic_tf_data.MAXBYTES, curr_dic_tf_data.MAXBLOCKS, curr_dic_tf_data.INCREMENT_BY, curr_dic_tf_data.USER_BYTES, 
           curr_dic_tf_data.USER_BLOCKS ) ;
    END LOOP ;
-- занести записи в таблицу среза статистики файлов
FOR curr_filestat_data IN (select * from V$FILESTAT) LOOP
    INSERT INTO BESTAT_V$FILESTAT VALUES (MY_POINT_ID, curr_filestat_data.FILE#, curr_filestat_data.PHYRDS, curr_filestat_data.PHYWRTS, 
           curr_filestat_data.PHYBLKRD, curr_filestat_data.PHYBLKWRT, curr_filestat_data.SINGLEBLKRDS, curr_filestat_data.READTIM, 
           curr_filestat_data.WRITETIM, curr_filestat_data.SINGLEBLKRDTIM, curr_filestat_data.AVGIOTIM, curr_filestat_data.LSTIOTIM, 
           curr_filestat_data.MINIOTIM, curr_filestat_data.MAXIORTM, curr_filestat_data.MAXIOWTM ) ;
    END LOOP ;
-- занести записи в таблицу среза информации о статистиках сегментов
FOR curr_segstat_data IN (select * from V$SEGSTAT) LOOP
    INSERT INTO BESTAT_V$SEGSTAT VALUES ( MY_POINT_ID, curr_segstat_data.TS#, curr_segstat_data.OBJ#, curr_segstat_data.DATAOBJ#, 
           curr_segstat_data.STATISTIC_NAME, curr_segstat_data.STATISTIC#, curr_segstat_data.VALUE ) ;
    END LOOP ;

-- занести записи в таблицу среза информации SQLAREA
FOR curr_sqlarea_data IN (select * from V$SQLAREA) LOOP
    INSERT INTO BESTAT_SQLAREA VALUES ( MY_POINT_ID, curr_sqlarea_data.SQL_TEXT, curr_sqlarea_data.SQL_FULLTEXT, curr_sqlarea_data.SQL_ID,
           curr_sqlarea_data.SHARABLE_MEM, curr_sqlarea_data.PERSISTENT_MEM, curr_sqlarea_data.RUNTIME_MEM, curr_sqlarea_data.SORTS,
           curr_sqlarea_data.VERSION_COUNT, curr_sqlarea_data.LOADED_VERSIONS, curr_sqlarea_data.OPEN_VERSIONS, curr_sqlarea_data.USERS_OPENING,
           curr_sqlarea_data.FETCHES, curr_sqlarea_data.EXECUTIONS, curr_sqlarea_data.PX_SERVERS_EXECUTIONS, curr_sqlarea_data.END_OF_FETCH_COUNT,
           curr_sqlarea_data.USERS_EXECUTING, curr_sqlarea_data.LOADS, curr_sqlarea_data.FIRST_LOAD_TIME, curr_sqlarea_data.INVALIDATIONS,
           curr_sqlarea_data.PARSE_CALLS, curr_sqlarea_data.DISK_READS, curr_sqlarea_data.DIRECT_WRITES, curr_sqlarea_data.BUFFER_GETS,
           curr_sqlarea_data.APPLICATION_WAIT_TIME, curr_sqlarea_data.CONCURRENCY_WAIT_TIME, curr_sqlarea_data.CLUSTER_WAIT_TIME,
           curr_sqlarea_data.USER_IO_WAIT_TIME, curr_sqlarea_data.PLSQL_EXEC_TIME, curr_sqlarea_data.JAVA_EXEC_TIME, curr_sqlarea_data.ROWS_PROCESSED,
           curr_sqlarea_data.COMMAND_TYPE, curr_sqlarea_data.OPTIMIZER_MODE, curr_sqlarea_data.OPTIMIZER_COST, curr_sqlarea_data.OPTIMIZER_ENV,
           curr_sqlarea_data.OPTIMIZER_ENV_HASH_VALUE, curr_sqlarea_data.PARSING_USER_ID, curr_sqlarea_data.PARSING_SCHEMA_ID, 
           curr_sqlarea_data.PARSING_SCHEMA_NAME, curr_sqlarea_data.KEPT_VERSIONS, curr_sqlarea_data.ADDRESS, curr_sqlarea_data.HASH_VALUE,
           curr_sqlarea_data.OLD_HASH_VALUE, curr_sqlarea_data.PLAN_HASH_VALUE, curr_sqlarea_data.MODULE, curr_sqlarea_data.MODULE_HASH,
           curr_sqlarea_data.ACTION, curr_sqlarea_data.ACTION_HASH, curr_sqlarea_data.SERIALIZABLE_ABORTS, curr_sqlarea_data.OUTLINE_CATEGORY,
           curr_sqlarea_data.CPU_TIME, curr_sqlarea_data.ELAPSED_TIME, curr_sqlarea_data.OUTLINE_SID, curr_sqlarea_data.LAST_ACTIVE_CHILD_ADDRESS,
           curr_sqlarea_data.REMOTE, curr_sqlarea_data.OBJECT_STATUS, curr_sqlarea_data.LITERAL_HASH_VALUE, curr_sqlarea_data.LAST_LOAD_TIME,
           curr_sqlarea_data.IS_OBSOLETE, curr_sqlarea_data.CHILD_LATCH, curr_sqlarea_data.SQL_PROFILE, curr_sqlarea_data.PROGRAM_ID,
           curr_sqlarea_data.PROGRAM_LINE#, curr_sqlarea_data.EXACT_MATCHING_SIGNATURE, curr_sqlarea_data.FORCE_MATCHING_SIGNATURE,
           curr_sqlarea_data.LAST_ACTIVE_TIME, curr_sqlarea_data.BIND_DATA) ;
           END LOOP ;
-- так как это срез планов, и он не предназначен для расчёта дельт, можно просто загнать значения                                                           
INSERT INTO BESTAT_V$SQL_PLAN SELECT MY_POINT_ID, p.* FROM V$SQL_PLAN p ;                                                                                   
INSERT INTO BESTAT_V$SQLTEXT_WITH_NEWLINES SELECT MY_POINT_ID, t.* FROM V$SQLTEXT_WITH_NEWLINES t ;                                                         
COMMIT ;   
-- важно, фиксация позволяет отлавливать новые значения
COMMIT ;

-- расчитать дельты и занести записи в таблицу дельт SQLAREA
-- так как возможны перезагрузки и инвалидации, а при перезагрузках, как показывает опыт, кумулятивная статистика по SQL запросу сбивается, это нужно
-- проверять, чтобы новое значение было больше старого. Конечно потери хвостов неизбежны при большом количестве перезагрузок, но сигнальная картина в целом
-- верная, а следить за достаточностью библиотечного кэша (где перезагрузки и инвалидации как раз показательны) нужно в любом случае
INSERT INTO BESTAT_DELTA_SQLAREA
       SELECT CR.POINT_ID,CR.STAMP_RECORD,PR.POINT_ID,PR.STAMP_RECORD,CR.SQL_ID,PR.SQL_ID,CR.PLAN_HASH_VALUE,PR.PLAN_HASH_VALUE,CR.PARSING_USER_ID,PR.PARSING_USER_ID,
              CR.MODULE,PR.MODULE,CR.ACTION,PR.ACTION,
              CR.SHARABLE_MEM,  CASE WHEN CR.SHARABLE_MEM < PR.SHARABLE_MEM THEN 0 ELSE PR.SHARABLE_MEM END,
                 CASE WHEN CR.SHARABLE_MEM < PR.SHARABLE_MEM THEN CR.SHARABLE_MEM ELSE CR.SHARABLE_MEM - PR.SHARABLE_MEM END, 
              CR.PERSISTENT_MEM, CASE WHEN CR.PERSISTENT_MEM < PR.PERSISTENT_MEM THEN 0 ELSE PR.PERSISTENT_MEM END, 
                 CASE WHEN CR.PERSISTENT_MEM < PR.PERSISTENT_MEM THEN  CR.PERSISTENT_MEM ELSE CR.PERSISTENT_MEM - PR.PERSISTENT_MEM END,
              CR.RUNTIME_MEM, CASE WHEN CR.RUNTIME_MEM < PR.RUNTIME_MEM THEN 0 ELSE PR.RUNTIME_MEM END,
                 CASE WHEN CR.RUNTIME_MEM < PR.RUNTIME_MEM THEN CR.RUNTIME_MEM ELSE CR.RUNTIME_MEM - PR.RUNTIME_MEM END,
              CR.SORTS, CASE WHEN CR.SORTS < PR.SORTS THEN 0 ELSE PR.SORTS END, 
                 CASE WHEN CR.SORTS < PR.SORTS THEN CR.SORTS ELSE CR.SORTS - PR.SORTS END,
              CR.USERS_OPENING, CASE WHEN CR.USERS_OPENING < PR.USERS_OPENING THEN 0 ELSE PR.USERS_OPENING END,
                 CASE WHEN CR.USERS_OPENING < PR.USERS_OPENING THEN CR.USERS_OPENING ELSE CR.USERS_OPENING - PR.USERS_OPENING END,
              CR.FETCHES, CASE WHEN CR.FETCHES < PR.FETCHES THEN 0 ELSE PR.FETCHES END,
                 CASE WHEN CR.FETCHES < PR.FETCHES THEN CR.FETCHES ELSE CR.FETCHES - PR.FETCHES END,
              CR.EXECUTIONS, CASE WHEN CR.EXECUTIONS < PR.EXECUTIONS THEN PR.EXECUTIONS END,
                 CASE WHEN CR.EXECUTIONS < PR.EXECUTIONS THEN CR.EXECUTIONS ELSE CR.EXECUTIONS - PR.EXECUTIONS END,
              CR.PX_SERVERS_EXECUTIONS, CASE WHEN CR.PX_SERVERS_EXECUTIONS < PR.PX_SERVERS_EXECUTIONS THEN 0 ELSE PR.PX_SERVERS_EXECUTIONS END,
                 CASE WHEN CR.PX_SERVERS_EXECUTIONS < PR.PX_SERVERS_EXECUTIONS THEN CR.PX_SERVERS_EXECUTIONS ELSE CR.PX_SERVERS_EXECUTIONS - PR.PX_SERVERS_EXECUTIONS END,
              CR.END_OF_FETCH_COUNT, CASE WHEN CR.END_OF_FETCH_COUNT < PR.END_OF_FETCH_COUNT THEN 0 ELSE PR.END_OF_FETCH_COUNT END,
                 CASE WHEN CR.END_OF_FETCH_COUNT < PR.END_OF_FETCH_COUNT THEN CR.END_OF_FETCH_COUNT ELSE CR.END_OF_FETCH_COUNT - PR.END_OF_FETCH_COUNT END,
              CR.USERS_EXECUTING, CASE WHEN CR.USERS_EXECUTING < PR.USERS_EXECUTING THEN 0 ELSE PR.USERS_EXECUTING END,
                 CASE WHEN CR.USERS_EXECUTING < PR.USERS_EXECUTING THEN CR.USERS_EXECUTING ELSE CR.USERS_EXECUTING - PR.USERS_EXECUTING END,
              CR.LOADS, CASE WHEN CR.LOADS < PR.LOADS THEN 0 ELSE PR.LOADS END, 
                 CASE WHEN CR.LOADS < PR.LOADS THEN CR.LOADS ELSE CR.LOADS - PR.LOADS END,
              CR.INVALIDATIONS, CASE WHEN CR.INVALIDATIONS < PR.INVALIDATIONS THEN 0 ELSE PR.INVALIDATIONS END,
                 CASE WHEN CR.INVALIDATIONS < PR.INVALIDATIONS THEN CR.INVALIDATIONS ELSE CR.INVALIDATIONS - PR.INVALIDATIONS END,
              CR.PARSE_CALLS, CASE WHEN CR.PARSE_CALLS < PR.PARSE_CALLS THEN 0 ELSE PR.PARSE_CALLS END, 
                 CASE WHEN CR.PARSE_CALLS < PR.PARSE_CALLS THEN CR.PARSE_CALLS ELSE CR.PARSE_CALLS - PR.PARSE_CALLS END,
              CR.DISK_READS, CASE WHEN CR.DISK_READS < PR.DISK_READS THEN 0 ELSE PR.DISK_READS END,
                 CASE WHEN CR.DISK_READS < PR.DISK_READS THEN CR.DISK_READS ELSE CR.DISK_READS - PR.DISK_READS END,
              CR.DIRECT_WRITES, CASE WHEN CR.DIRECT_WRITES < PR.DIRECT_WRITES THEN 0 ELSE PR.DIRECT_WRITES END,
                 CASE WHEN CR.DIRECT_WRITES < PR.DIRECT_WRITES THEN CR.DIRECT_WRITES ELSE CR.DIRECT_WRITES - PR.DIRECT_WRITES END,
              CR.BUFFER_GETS, CASE WHEN CR.BUFFER_GETS < PR.BUFFER_GETS THEN 0 ELSE PR.BUFFER_GETS END,
                 CASE WHEN CR.BUFFER_GETS < PR.BUFFER_GETS THEN CR.BUFFER_GETS ELSE CR.BUFFER_GETS - PR.BUFFER_GETS END,
              CR.APPLICATION_WAIT_TIME, CASE WHEN CR.APPLICATION_WAIT_TIME < PR.APPLICATION_WAIT_TIME THEN 0 ELSE PR.APPLICATION_WAIT_TIME END,
                 CASE WHEN CR.APPLICATION_WAIT_TIME < PR.APPLICATION_WAIT_TIME THEN CR.APPLICATION_WAIT_TIME ELSE CR.APPLICATION_WAIT_TIME - PR.APPLICATION_WAIT_TIME END,
              CR.CONCURRENCY_WAIT_TIME, CASE WHEN CR.CONCURRENCY_WAIT_TIME < PR.CONCURRENCY_WAIT_TIME THEN 0 ELSE PR.CONCURRENCY_WAIT_TIME END,
                 CASE WHEN CR.CONCURRENCY_WAIT_TIME < PR.CONCURRENCY_WAIT_TIME THEN CR.CONCURRENCY_WAIT_TIME ELSE CR.CONCURRENCY_WAIT_TIME - PR.CONCURRENCY_WAIT_TIME END,
              CR.CLUSTER_WAIT_TIME, CASE WHEN CR.CLUSTER_WAIT_TIME < PR.CLUSTER_WAIT_TIME THEN 0 ELSE PR.CLUSTER_WAIT_TIME END,
                 CASE WHEN CR.CLUSTER_WAIT_TIME < PR.CLUSTER_WAIT_TIME THEN CR.CLUSTER_WAIT_TIME ELSE CR.CLUSTER_WAIT_TIME - PR.CLUSTER_WAIT_TIME END,
              CR.USER_IO_WAIT_TIME, CASE WHEN CR.USER_IO_WAIT_TIME < PR.USER_IO_WAIT_TIME THEN 0 ELSE PR.USER_IO_WAIT_TIME END,
                 CASE WHEN CR.USER_IO_WAIT_TIME < PR.USER_IO_WAIT_TIME THEN CR.USER_IO_WAIT_TIME ELSE CR.USER_IO_WAIT_TIME - PR.USER_IO_WAIT_TIME END,
              CR.PLSQL_EXEC_TIME, CASE WHEN CR.PLSQL_EXEC_TIME < PR.PLSQL_EXEC_TIME THEN 0 ELSE PR.PLSQL_EXEC_TIME END,
                 CASE WHEN CR.PLSQL_EXEC_TIME < PR.PLSQL_EXEC_TIME THEN CR.PLSQL_EXEC_TIME ELSE CR.PLSQL_EXEC_TIME - PR.PLSQL_EXEC_TIME END,
              CR.JAVA_EXEC_TIME, CASE WHEN CR.JAVA_EXEC_TIME < PR.JAVA_EXEC_TIME THEN 0 ELSE PR.JAVA_EXEC_TIME END,
                 CASE WHEN CR.JAVA_EXEC_TIME < PR.JAVA_EXEC_TIME THEN CR.JAVA_EXEC_TIME ELSE CR.JAVA_EXEC_TIME - PR.JAVA_EXEC_TIME END,
              CR.ROWS_PROCESSED, CASE WHEN CR.ROWS_PROCESSED < PR.ROWS_PROCESSED THEN 0 ELSE PR.ROWS_PROCESSED END,
                 CASE WHEN CR.ROWS_PROCESSED < PR.ROWS_PROCESSED THEN CR.ROWS_PROCESSED ELSE CR.ROWS_PROCESSED - PR.ROWS_PROCESSED END,
              CR.SERIALIZABLE_ABORTS, CASE WHEN CR.SERIALIZABLE_ABORTS < PR.SERIALIZABLE_ABORTS THEN 0 ELSE PR.SERIALIZABLE_ABORTS END,
                 CASE WHEN CR.SERIALIZABLE_ABORTS < PR.SERIALIZABLE_ABORTS THEN CR.SERIALIZABLE_ABORTS ELSE CR.SERIALIZABLE_ABORTS - PR.SERIALIZABLE_ABORTS END,
              CR.CPU_TIME, CASE WHEN CR.CPU_TIME < PR.CPU_TIME THEN 0 ELSE PR.CPU_TIME END,
                 CASE WHEN CR.CPU_TIME < PR.CPU_TIME THEN CR.CPU_TIME ELSE CR.CPU_TIME - PR.CPU_TIME END,
              CR.ELAPSED_TIME, CASE WHEN CR.ELAPSED_TIME < PR.ELAPSED_TIME THEN 0 ELSE PR.ELAPSED_TIME END,
                 CASE WHEN CR.ELAPSED_TIME < PR.ELAPSED_TIME THEN CR.ELAPSED_TIME ELSE CR.ELAPSED_TIME - PR.ELAPSED_TIME END,
              CR.CHILD_LATCH, CASE WHEN CR.CHILD_LATCH < PR.CHILD_LATCH THEN 0 ELSE PR.CHILD_LATCH END,
                 CASE WHEN CR.CHILD_LATCH < PR.CHILD_LATCH THEN CR.CHILD_LATCH ELSE CR.CHILD_LATCH - PR.CHILD_LATCH END,
              CR.OPTIMIZER_COST, PR.OPTIMIZER_COST
              FROM (SELECT ROWNUM rn, CR2.* FROM ( SELECT cr1.*, bcp.STAT_RANGE_ID, bcp.POINT_TYPE, bcp.STAMP_RECORD from BESTAT_SQLAREA cr1, BESTAT_COLLECTOR_POINTS bcp 
                           WHERE cr1.POINT_ID = bcp.POINT_ID AND bcp.POINT_TYPE = 'OPS' AND cr1.POINT_ID >= MY_PREV_POINT_ID ORDER BY cr1.SQL_ID,cr1.POINT_ID) CR2 ) CR,
                   (SELECT ROWNUM rn, PR2.* FROM ( SELECT pr1.*, bcp.STAT_RANGE_ID, bcp.POINT_TYPE, bcp.STAMP_RECORD from BESTAT_SQLAREA pr1, BESTAT_COLLECTOR_POINTS bcp 
                           WHERE pr1.POINT_ID = bcp.POINT_ID AND bcp.POINT_TYPE = 'OPS' AND pr1.POINT_ID >= MY_PREV_POINT_ID ORDER BY pr1.SQL_ID,pr1.POINT_ID) PR2 ) PR
              WHERE CR.rn - 1 = PR.rn AND CR.SQL_ID = PR.SQL_ID AND CR.STAT_RANGE_ID = PR.STAT_RANGE_ID AND cr.POINT_ID > MY_PREV_POINT_ID ;
--                    AND CR.POINT_ID > ( SELECT CASE WHEN MAX(CR_POINT_ID) IS NULL THEN 0 ELSE MAX(CR_POINT_ID) END FROM BESTAT_DELTA_SQLAREA ) ;
       
COMMIT ;
END BESTAT_GET_OPS_SREZ ;
/

show errors
set hea on
exit ;

