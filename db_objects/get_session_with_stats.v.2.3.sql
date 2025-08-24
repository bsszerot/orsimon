--
-- ВНИМАНИМЕ Настоящая процедура является частью коммерческого программного продукта ОрСиМОН БЕССТ (С) Sergey S. Belonin Все права защищены.
-- Использование настоящего кода без заключения письменного лицензионного соглашения с правообладателем или правомочным сублицензиаром ЗАПРЕЩЕНО
-- ATTENTION This procedure are part of commercial software product OrSiMON BESST (C) Sergey S. Belonin All rights reserved
-- Before use this procedure you must sign license agreement with owner or sublicensear
--


CREATE OR REPLACE PACKAGE BESTAT_UTIL AS
TYPE T_REC_SESSION_WITH_STATS IS RECORD (
     SID                        NUMBER,
     SERIAL_N                   NUMBER,
-- байты и операции физического чтения, в т.ч. прямых и прямых lob
     PHYS_READS_BYTES           NUMBER,
     PHYS_READS                 NUMBER,
     PHYS_READS_DIRECT          NUMBER,
     PHYS_READS_DIR_LOB         NUMBER,
     PHYS_READS_DIR_TEMP        NUMBER,
-- байты и операции и физической записи
     PHYS_WRITE_BYTES           NUMBER,
     PHYS_WRITE_TOTAL_BYTES     NUMBER,
     PHYS_WRITES                NUMBER,
     PHYS_WRITES_DIRECT         NUMBER,
     PHYS_WRITES_DIR_LOB        NUMBER,
     PHYS_WRITES_DIR_TEMP       NUMBER,
-- операции логического чтения (в т.ч. консистентные и неизменные)
     DB_BLOCK_GETS              NUMBER,
     DB_BLOCK_GETS_DIR          NUMBER,
     DB_BLOCK_GETS_FROM_CACHE   NUMBER,
     CONSISTENT_GETS            NUMBER,
     CONSISTENT_GETS_DIRECT     NUMBER,
     CONSISTENT_GETS_FROM_CACHE NUMBER,
     SESSION_LOGICAL_READS      NUMBER,
-- операции логических записей (изменения блоков)
     CONSISTENT_CHANGES         NUMBER,
     DB_BLOCK_CHANGES           NUMBER,
-- утилизация процессора 
     CPU_USED_BY_SESSION        NUMBER,
-- обработка SQL запросов
     PARSE_COUNT_HARD           NUMBER,
     PARSE_COUNT_TOTAL          NUMBER,
     PARSE_TIME_CPU             NUMBER,
     PARSE_TIME_ELAPSED         NUMBER,
     RECURSIVE_CALLS            NUMBER,
     RECURSIVE_CPU_USAGE        NUMBER,
     EXECUTE_COUNT              NUMBER,
     USER_CALLS                 NUMBER,
     USER_COMMITS               NUMBER,
     USER_ROLLBACKS             NUMBER,
     COMMIT_BATCH_PERFORMED     NUMBER,
     COMMIT_BATCH_REQUESTED     NUMBER,
-- чтение и запись через SqlNet 
     SQLNET_RECV_BYTES          NUMBER,
     SQLNET_SENT_BYTES          NUMBER,
-- чтение и запись через dblink
     DBLINK_RECV_BYTES          NUMBER,
     DBLINK_SENT_BYTES          NUMBER,
-- сортировки и обработки
     SORTS_DISK                 NUMBER,
     SORTS_MEMORY               NUMBER,
     SORTS_ROWS                 NUMBER,
     WORKAREA_EXEC_MULTIPASS    NUMBER,
     WORKAREA_EXEC_ONEPASS      NUMBER,
     WORKAREA_EXEC_OPTIMAL      NUMBER,
-- Ожидания
     APPLICATION_WAIT_TIME      NUMBER,
     CONCURRENCY_WAIT_TIME      NUMBER,
     FILE_IO_WAIT_TIME          NUMBER,
     ENQUEUE_REQUESTS           NUMBER,
     ENQUEUE_TIMEOUTS           NUMBER,
     ENQUEUE_WAITS              NUMBER,
-- LOB обработки
     LOB_READS                  NUMBER,
     LOB_WRITES                 NUMBER,
-- REDO информация
     REDO_BLOCK_WRITTEN         NUMBER,
     REDO_SIZE                  NUMBER,
-- Память PGA
     SESSION_PGA_MEMORY         NUMBER,
     SESSION_PGA_MEMORY_MAX     NUMBER,
-- Общие
     SESSION_CONNECT_TIME       NUMBER ) ;

TYPE T_DSET_SESSION_WITH_STATS IS TABLE OF T_REC_SESSION_WITH_STATS ;
FUNCTION F_SESSION_WITH_STATS RETURN T_DSET_SESSION_WITH_STATS PIPELINED ;
END BESTAT_UTIL ;
/


CREATE OR REPLACE PACKAGE BODY BESTAT_UTIL AS

FUNCTION F_SESSION_WITH_STATS RETURN T_DSET_SESSION_WITH_STATS PIPELINED IS
         SZ_RECORD T_REC_SESSION_WITH_STATS ;
         a NUMBER ;
         BEGIN
         FOR cur_session IN ( SELECT * from V$SESSION ORDER BY SID ) LOOP
         SZ_RECORD.SID := cur_session.SID ;
         SZ_RECORD.SERIAL_N := cur_session.SERIAL# ;
-- -Параметры профиля загрузки (для сессий важно кумулятивное, для экземпляра - поотрезочное)

-- байты и операции физического чтения, в т.ч. прямых и прямых lob
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_READS_BYTES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical read bytes' ;
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_READS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical reads' ;
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_READS_DIRECT FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical reads direct' ;
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_READS_DIR_LOB FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical reads direct (lob)' ;
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_READS_DIR_TEMP FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical reads direct temporary tablespace' ;
-- байты и операции и физической записи
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_WRITE_BYTES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical write bytes' ;
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_WRITE_TOTAL_BYTES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical write total bytes' ;
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_WRITES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical writes' ;
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_WRITES_DIRECT FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical writes direct' ;
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_WRITES_DIR_LOB FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical writes direct (lob)' ;
         SELECT ss.VALUE INTO SZ_RECORD.PHYS_WRITES_DIR_TEMP FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'physical writes direct temporary tablespace' ;
-- операции логического чтения (в т.ч. консистентные и неизменные)
         SELECT ss.VALUE INTO SZ_RECORD.DB_BLOCK_GETS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'db block gets' ;
         SELECT ss.VALUE INTO SZ_RECORD.DB_BLOCK_GETS_DIR FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'db block gets direct' ;
         SELECT ss.VALUE INTO SZ_RECORD.DB_BLOCK_GETS_FROM_CACHE FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'db block gets from cache' ;
         SELECT ss.VALUE INTO SZ_RECORD.CONSISTENT_GETS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'consistent gets' ;
         SELECT ss.VALUE INTO SZ_RECORD.CONSISTENT_GETS_DIRECT FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'consistent gets direct' ;
         SELECT ss.VALUE INTO SZ_RECORD.CONSISTENT_GETS_FROM_CACHE FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'consistent gets from cache' ;
         SELECT ss.VALUE INTO SZ_RECORD.SESSION_LOGICAL_READS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'session logical reads' ;
-- операции логических записей (изменения блоков)
         SELECT ss.VALUE INTO SZ_RECORD.CONSISTENT_CHANGES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'consistent changes' ;
         SELECT ss.VALUE INTO SZ_RECORD.DB_BLOCK_CHANGES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'db block changes' ;
-- утилизация процессора 
         SELECT ss.VALUE INTO SZ_RECORD.CPU_USED_BY_SESSION FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'CPU used by this session' ;
-- обработка SQL запросов
         SELECT ss.VALUE INTO SZ_RECORD.PARSE_COUNT_HARD FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'parse count (hard)' ;
         SELECT ss.VALUE INTO SZ_RECORD.PARSE_COUNT_TOTAL FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'parse count (total)' ;
         SELECT ss.VALUE INTO SZ_RECORD.PARSE_TIME_CPU FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'parse time cpu' ;
         SELECT ss.VALUE INTO SZ_RECORD.PARSE_TIME_ELAPSED FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'parse time elapsed' ;
         SELECT ss.VALUE INTO SZ_RECORD.RECURSIVE_CALLS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'recursive calls' ;
         SELECT ss.VALUE INTO SZ_RECORD.RECURSIVE_CPU_USAGE FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'recursive cpu usage' ;
         SELECT ss.VALUE INTO SZ_RECORD.EXECUTE_COUNT FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'execute count' ;
         SELECT ss.VALUE INTO SZ_RECORD.USER_CALLS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'user calls' ;
         SELECT ss.VALUE INTO SZ_RECORD.USER_COMMITS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'user commits' ;
         SELECT ss.VALUE INTO SZ_RECORD.USER_ROLLBACKS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'user rollbacks' ;
         SELECT ss.VALUE INTO SZ_RECORD.COMMIT_BATCH_PERFORMED FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'commit batch performed' ;
         SELECT ss.VALUE INTO SZ_RECORD.COMMIT_BATCH_REQUESTED FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'commit batch requested' ;
-- чтение и запись через SqlNet 

         SELECT ss.VALUE INTO SZ_RECORD.SQLNET_RECV_BYTES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'bytes received via SQL*Net from client' ;
         SELECT ss.VALUE INTO SZ_RECORD.SQLNET_SENT_BYTES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'bytes sent via SQL*Net to client' ;
-- чтение и запись через dblink
         SELECT ss.VALUE INTO SZ_RECORD.DBLINK_RECV_BYTES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'bytes received via SQL*Net from dblink' ;
         SELECT ss.VALUE INTO SZ_RECORD.DBLINK_SENT_BYTES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'bytes sent via SQL*Net to dblink' ;

-- сортировки и обработки
         SELECT ss.VALUE INTO SZ_RECORD.SORTS_DISK FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'sorts (disk)' ;
         SELECT ss.VALUE INTO SZ_RECORD.SORTS_MEMORY FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'sorts (memory)' ;
         SELECT ss.VALUE INTO SZ_RECORD.SORTS_ROWS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'sorts (rows)' ;
         SELECT ss.VALUE INTO SZ_RECORD.WORKAREA_EXEC_MULTIPASS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'workarea executions - multipass' ;
         SELECT ss.VALUE INTO SZ_RECORD.WORKAREA_EXEC_ONEPASS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'workarea executions - onepass' ;
         SELECT ss.VALUE INTO SZ_RECORD.WORKAREA_EXEC_OPTIMAL FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'workarea executions - optimal' ;
-- Ожидания
         SELECT ss.VALUE INTO SZ_RECORD.APPLICATION_WAIT_TIME FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'application wait time' ;
         SELECT ss.VALUE INTO SZ_RECORD.CONCURRENCY_WAIT_TIME FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'concurrency wait time' ;
         SELECT ss.VALUE INTO SZ_RECORD.FILE_IO_WAIT_TIME FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'file io wait time' ;
         SELECT ss.VALUE INTO SZ_RECORD.ENQUEUE_REQUESTS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'enqueue requests' ;
         SELECT ss.VALUE INTO SZ_RECORD.ENQUEUE_TIMEOUTS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'enqueue timeouts' ;
         SELECT ss.VALUE INTO SZ_RECORD.ENQUEUE_WAITS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'enqueue waits' ;
-- LOB обработки
         SELECT ss.VALUE INTO SZ_RECORD.LOB_READS FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'lob reads' ;
         SELECT ss.VALUE INTO SZ_RECORD.LOB_WRITES FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'lob writes' ;
-- REDO информация
         SELECT ss.VALUE INTO SZ_RECORD.REDO_BLOCK_WRITTEN FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'redo blocks written' ;
         SELECT ss.VALUE INTO SZ_RECORD.REDO_SIZE FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'redo size' ;
-- Память PGA
         SELECT ss.VALUE INTO SZ_RECORD.SESSION_PGA_MEMORY FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'session pga memory' ;
         SELECT ss.VALUE INTO SZ_RECORD.SESSION_PGA_MEMORY_MAX FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'session pga memory max' ;
-- Общие
         SELECT ss.VALUE INTO SZ_RECORD.SESSION_CONNECT_TIME FROM v$sesstat ss, v$statname sn, v$session s WHERE ss.STATISTIC# = sn.STATISTIC# AND ss.SID = s.SID  AND s.SID = cur_session.SID AND sn.NAME = 'session connect time' ;
         PIPE ROW(SZ_RECORD) ;
         END LOOP ;
RETURN ;

END F_SESSION_WITH_STATS ;
END BESTAT_UTIL ;

/

show errors ;

set linesize 400 pagesize 400
select * from table(bestat_util.F_SESSION_WITH_STATS) ;
exit ;

