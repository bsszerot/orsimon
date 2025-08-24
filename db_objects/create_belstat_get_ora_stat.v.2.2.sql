
-- SELECT CLC_STATISTIC_POINTS_SEQ.NEXTVAL INTO POINT_ID FROM DUAL ;
--SELECT NAME INTO DB_NAME FROM V$DATABASE  ;
--INSERT INTO CLC_STATISTIC_POINTS VALUES (0,'from statspack','local dbs','127.0.0.1','TEST1','TEST1',0,0,'yes','in db','','','','','','','yes') ;

CREATE OR REPLACE PROCEDURE BELSTAT_GET_ORA_STAT AS
V_POINT_ID         INTEGER := 0 ;
V_CURR_MAX_SNAP_ID INTEGER := 0 ;
V_PREV_MAX_SNAP_ID INTEGER := 0 ;
V_NEW_MAX_SNAP_ID  INTEGER := 0 ;

V_ALL_WAIT         INTEGER := 0 ;
V_NOIDLE_WAIT      INTEGER := 0 ;
V_TOTAL_TIME       INTEGER := 0 ;
V_ENQUEUE_TIM_STAT INTEGER := 0 ;

BEGIN
--
-- ВНИМАНИМЕ Настоящая процедура является частью коммерческого программного продукта ОрСиМОН БЕССТ (С) Sergey S. Belonin Все права защищены.
-- Использование настоящего кода без заключения письменного лицензионного соглашения с правообладателем или правомочным сублицензиаром ЗАПРЕЩЕНО
-- ATTENTION This procedure are part of commercial software product OrSiMON BESST (C) Sergey S. Belonin All rights reserved
-- Before use this procedure you must sign license agreement with owner or sublicensear
--
SELECT MAX(CURR_MAX_SNAP_ID) INTO V_CURR_MAX_SNAP_ID FROM CLC_STATISTIC_POINTS ;
SELECT MAX(SNAP_ID) INTO V_NEW_MAX_SNAP_ID FROM STATS$SNAPSHOT ;
--SELECT MAX(SNAP_ID) FROM STATS$SNAPSHOT ;

-- важно, что дельта высчитывается только между значениями с совпадающим временем старта экземпляра - иначе бессмысленно
--UPDATE CLC_STATISTIC_POINTS SET PREV_MAX_SNAP_ID = _PREV_MAX_SNAP_ID, CURR_MAX_SNAP_ID = _CURR_MAX_SNAP_ID 
INSERT INTO CLC_DELTA_SYSSTAT 
       SELECT V_POINT_ID, cr.SNAP_LEVEL, cr.SNAP_ID, TO_DATE(TO_CHAR(cr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'), pr.SNAP_ID,
              TO_DATE(TO_CHAR(pr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'), cr.STATISTIC#, cr.VALUE, pr.VALUE, (cr.VALUE - pr.VALUE)
              FROM
              (select ROWNUM rn, ns_cr.* from
                      (select ss.SNAP_ID,ss.DBID,ss.INSTANCE_NUMBER,ss.STATISTIC#,ss.NAME,ss.VALUE,sn.STARTUP_TIME,sn.SNAP_TIME,sn.SNAP_LEVEL
                              from perfstat.STATS$SYSSTAT ss, perfstat.STATS$SNAPSHOT sn
                              where ss.SNAP_ID = sn.SNAP_ID AND ss.DBID = sn.DBID AND ss.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND 
                                    sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                              order by ss.STATISTIC#,ss.NAME,sn.SNAP_TIME,ss.SNAP_ID) ns_cr ) cr,
               (select ROWNUM rn, ns_pr.* from
                       (select ss.SNAP_ID,ss.DBID,ss.INSTANCE_NUMBER,ss.STATISTIC#,ss.NAME,ss.VALUE,sn.STARTUP_TIME,sn.SNAP_TIME,sn.SNAP_LEVEL
                               from perfstat.STATS$SYSSTAT ss, perfstat.STATS$SNAPSHOT sn
                               where ss.SNAP_ID = sn.SNAP_ID AND ss.DBID = sn.DBID AND ss.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND 
                                     sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                               order by ss.STATISTIC#,ss.NAME,sn.SNAP_TIME,ss.SNAP_ID) ns_pr ) pr
               WHERE cr.rn - 1 = pr.rn AND cr.DBID = pr.DBID AND cr.INSTANCE_NUMBER = pr.INSTANCE_NUMBER AND cr.STARTUP_TIME = pr.STARTUP_TIME
                     AND cr.SNAP_LEVEL = pr.SNAP_LEVEL AND cr.STATISTIC# = pr.STATISTIC# AND cr.NAME = pr.NAME
               ORDER BY cr.SNAP_ID,cr.STATISTIC#,cr.SNAP_TIME ;

-- важно, что дельта высчитывается только между значениями с совпадающим временем старта экземпляра - иначе бессмысленно
INSERT INTO CLC_DELTA_SYSEVENT 
       SELECT V_POINT_ID, cr.SNAP_LEVEL, cr.SNAP_ID, TO_DATE(TO_CHAR(cr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'), pr.SNAP_ID,
              TO_DATE(TO_CHAR(pr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'), cr.EVENT#, cr.TOTAL_WAITS, cr.TOTAL_TIMEOUTS,
              cr.TIME_WAITED_MICRO,pr.TOTAL_WAITS, pr.TOTAL_TIMEOUTS, pr.TIME_WAITED_MICRO, (cr.TOTAL_WAITS - pr.TOTAL_WAITS),
              (cr.TOTAL_TIMEOUTS - pr.TOTAL_TIMEOUTS), (cr.TIME_WAITED_MICRO - pr.TIME_WAITED_MICRO), 0, 0
              FROM
              (select ROWNUM rn, ns_cr.* from
                      (select sn.SNAP_TIME,sn.SNAP_LEVEL,se.SNAP_ID,se.DBID,se.INSTANCE_NUMBER,sn.STARTUP_TIME,en.EVENT#,se.TOTAL_WAITS,se.TOTAL_TIMEOUTS,
                              se.TIME_WAITED_MICRO from perfstat.STATS$SYSTEM_EVENT se, v$event_name en, perfstat.STATS$SNAPSHOT sn
                              where se.SNAP_ID = sn.SNAP_ID AND se.DBID = sn.DBID AND se.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND se.EVENT = en.NAME AND
                                    sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                              order by en.EVENT#,se.EVENT,sn.SNAP_TIME,se.SNAP_ID ) ns_cr ) cr,
              (select ROWNUM rn, ns_pr.* from
                      (select sn.SNAP_TIME,sn.SNAP_LEVEL,se.SNAP_ID,se.DBID,se.INSTANCE_NUMBER,sn.STARTUP_TIME,en.EVENT#,se.TOTAL_WAITS,se.TOTAL_TIMEOUTS,
                              se.TIME_WAITED_MICRO from perfstat.STATS$SYSTEM_EVENT se, v$event_name en, perfstat.STATS$SNAPSHOT sn
                              where se.SNAP_ID = sn.SNAP_ID AND se.DBID = sn.DBID AND se.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND se.EVENT = en.NAME AND
                                    sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                              order by en.EVENT#,se.EVENT,sn.SNAP_TIME,se.SNAP_ID ) ns_pr ) pr
              WHERE cr.rn - 1 = pr.rn AND cr.DBID = pr.DBID AND cr.INSTANCE_NUMBER = pr.INSTANCE_NUMBER AND cr.STARTUP_TIME = pr.STARTUP_TIME
                    AND cr.SNAP_LEVEL = pr.SNAP_LEVEL AND cr.EVENT# = pr.EVENT# 
              ORDER BY cr.SNAP_ID,cr.EVENT#,cr.SNAP_TIME ; 

-- важно, что дельта высчитывается только между значениями с совпадающим временем старта экземпляра - иначе бессмысленно
INSERT INTO CLC_DELTA_LIBRARYCACHE 
       SELECT V_POINT_ID,cr.SNAP_LEVEL,cr.SNAP_ID,TO_DATE(TO_CHAR(cr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'),pr.SNAP_ID, 
              TO_DATE(TO_CHAR(pr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'),CR.NAMESPACE,CR.GETS,PR.GETS,(CR.GETS - PR.GETS),
              CR.GETHITS,PR.GETHITS,(CR.GETHITS - PR.GETHITS),CR.PINS,PR.PINS,(CR.PINS - PR.PINS),CR.PINHITS,PR.PINHITS,(CR.PINHITS - PR.PINHITS),
              CR.RELOADS,PR.RELOADS,(CR.RELOADS - PR.RELOADS),CR.INVALIDATIONS,PR.INVALIDATIONS,(CR.INVALIDATIONS - PR.INVALIDATIONS),
              CR.DLM_LOCK_REQUESTS,PR.DLM_LOCK_REQUESTS,(CR.DLM_LOCK_REQUESTS - PR.DLM_LOCK_REQUESTS),CR.DLM_PIN_REQUESTS,PR.DLM_PIN_REQUESTS,
              (CR.DLM_PIN_REQUESTS - PR.DLM_PIN_REQUESTS),CR.DLM_PIN_RELEASES,PR.DLM_PIN_RELEASES,(CR.DLM_PIN_RELEASES - PR.DLM_PIN_RELEASES),
              CR.DLM_INVALIDATION_REQUESTS,PR.DLM_INVALIDATION_REQUESTS,(CR.DLM_INVALIDATION_REQUESTS - PR.DLM_INVALIDATION_REQUESTS),
              CR.DLM_INVALIDATIONS,PR.DLM_INVALIDATIONS,(CR.DLM_INVALIDATIONS - PR.DLM_INVALIDATIONS)
              FROM (SELECT ROWNUM rn, ns_cr.* from
                           (SELECT slc.SNAP_ID, slc.DBID, slc.INSTANCE_NUMBER, slc.NAMESPACE, slc.GETS, slc.GETHITS, slc.PINS, slc.PINHITS, slc.RELOADS,
                                   slc.INVALIDATIONS, slc.DLM_LOCK_REQUESTS, slc.DLM_PIN_REQUESTS, slc.DLM_PIN_RELEASES, slc.DLM_INVALIDATION_REQUESTS,
                                   slc.DLM_INVALIDATIONS, sn.STARTUP_TIME,sn.SNAP_TIME, sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$LIBRARYCACHE slc, PERFSTAT.STATS$SNAPSHOT sn
                                   where slc.SNAP_ID = sn.SNAP_ID AND slc.DBID = sn.DBID AND slc.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by slc.NAMESPACE,sn.SNAP_TIME,sn.SNAP_ID) ns_cr ) cr,
                   (SELECT ROWNUM rn, ns_pr.* from
                           (SELECT slc.SNAP_ID, slc.DBID, slc.INSTANCE_NUMBER, slc.NAMESPACE, slc.GETS, slc.GETHITS, slc.PINS, slc.PINHITS, slc.RELOADS,
                                   slc.INVALIDATIONS, slc.DLM_LOCK_REQUESTS, slc.DLM_PIN_REQUESTS, slc.DLM_PIN_RELEASES, slc.DLM_INVALIDATION_REQUESTS,
                                   slc.DLM_INVALIDATIONS, sn.STARTUP_TIME, sn.SNAP_TIME, sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$LIBRARYCACHE slc, PERFSTAT.STATS$SNAPSHOT sn
                                   where slc.SNAP_ID = sn.SNAP_ID AND slc.DBID = sn.DBID AND slc.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by slc.NAMESPACE,sn.SNAP_TIME,sn.SNAP_ID) ns_pr ) pr
              WHERE cr.rn - 1 = pr.rn AND cr.DBID = pr.DBID AND cr.INSTANCE_NUMBER = pr.INSTANCE_NUMBER AND cr.STARTUP_TIME = pr.STARTUP_TIME
                    AND cr.SNAP_LEVEL = pr.SNAP_LEVEL AND cr.NAMESPACE = pr.NAMESPACE
              ORDER BY cr.SNAP_ID,cr.NAMESPACE,cr.SNAP_TIME ;

-- важно, что дельта высчитывается только между значениями с совпадающим временем старта экземпляра - иначе бессмысленно
INSERT INTO CLC_DELTA_BUFF_POOL_STAT
       SELECT V_POINT_ID,cr.SNAP_LEVEL,cr.SNAP_ID,TO_DATE(TO_CHAR(cr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'),pr.SNAP_ID, 
              TO_DATE(TO_CHAR(pr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'),CR.ID,CR.NAME,CR.BLOCK_SIZE,CR.SET_MSIZE,PR.SET_MSIZE,
              (CR.SET_MSIZE-PR.SET_MSIZE),CR.CNUM_REPL,PR.CNUM_REPL,(CR.CNUM_REPL-PR.CNUM_REPL),CR.CNUM_WRITE,PR.CNUM_WRITE,(CR.CNUM_WRITE-PR.CNUM_WRITE),
              CR.CNUM_SET,PR.CNUM_SET,(CR.CNUM_SET-PR.CNUM_SET),CR.BUF_GOT,PR.BUF_GOT,(CR.BUF_GOT-PR.BUF_GOT),CR.SUM_WRITE,PR.SUM_WRITE,
              (CR.SUM_WRITE-PR.SUM_WRITE),CR.SUM_SCAN,PR.SUM_SCAN,(CR.SUM_SCAN-PR.SUM_SCAN),CR.FREE_BUFFER_WAIT,PR.FREE_BUFFER_WAIT,
              (CR.FREE_BUFFER_WAIT-PR.FREE_BUFFER_WAIT),CR.WRITE_COMPLETE_WAIT,PR.WRITE_COMPLETE_WAIT,(CR.WRITE_COMPLETE_WAIT-PR.WRITE_COMPLETE_WAIT),
              CR.BUFFER_BUSY_WAIT,PR.BUFFER_BUSY_WAIT,(CR.BUFFER_BUSY_WAIT-PR.BUFFER_BUSY_WAIT),CR.FREE_BUFFER_INSPECTED,PR.FREE_BUFFER_INSPECTED,
              (CR.FREE_BUFFER_INSPECTED-PR.FREE_BUFFER_INSPECTED),CR.DIRTY_BUFFERS_INSPECTED,PR.DIRTY_BUFFERS_INSPECTED,
              (CR.DIRTY_BUFFERS_INSPECTED-PR.DIRTY_BUFFERS_INSPECTED),CR.DB_BLOCK_CHANGE,PR.DB_BLOCK_CHANGE,(CR.DB_BLOCK_CHANGE-PR.DB_BLOCK_CHANGE),
              CR.DB_BLOCK_GETS,PR.DB_BLOCK_GETS,(CR.DB_BLOCK_GETS-PR.DB_BLOCK_GETS),CR.CONSISTENT_GETS,PR.CONSISTENT_GETS,
              (CR.CONSISTENT_GETS-PR.CONSISTENT_GETS),CR.PHYSICAL_READS,PR.PHYSICAL_READS,(CR.PHYSICAL_READS-PR.PHYSICAL_READS),CR.PHYSICAL_WRITES,
              PR.PHYSICAL_WRITES,(CR.PHYSICAL_WRITES-PR.PHYSICAL_WRITES)
              FROM (SELECT ROWNUM rn, ns_cr.* from 
                           (SELECT bps.SNAP_ID, bps.DBID, bps.INSTANCE_NUMBER, bps.ID, bps.NAME, bps.BLOCK_SIZE, bps.SET_MSIZE, bps.CNUM_REPL,
                                   bps.CNUM_WRITE,bps.CNUM_SET, bps.BUF_GOT, bps.SUM_WRITE, bps.SUM_SCAN, bps.FREE_BUFFER_WAIT, bps.WRITE_COMPLETE_WAIT,
                                   bps.BUFFER_BUSY_WAIT, bps.FREE_BUFFER_INSPECTED, bps.DIRTY_BUFFERS_INSPECTED, bps.DB_BLOCK_CHANGE, bps.DB_BLOCK_GETS,
                                   bps.CONSISTENT_GETS, bps.PHYSICAL_READS, bps.PHYSICAL_WRITES, sn.STARTUP_TIME, sn.SNAP_TIME, sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$BUFFER_POOL_STATISTICS bps, PERFSTAT.STATS$SNAPSHOT sn
                                   where bps.SNAP_ID = sn.SNAP_ID AND bps.DBID = sn.DBID AND bps.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by bps.ID,bps.NAME,sn.SNAP_TIME,sn.SNAP_ID) ns_cr ) cr,
                   (SELECT ROWNUM rn, ns_pr.* from
                           (SELECT bps.SNAP_ID, bps.DBID, bps.INSTANCE_NUMBER, bps.ID, bps.NAME, bps.BLOCK_SIZE, bps.SET_MSIZE, bps.CNUM_REPL,
                                   bps.CNUM_WRITE, bps.CNUM_SET, bps.BUF_GOT, bps.SUM_WRITE, bps.SUM_SCAN, bps.FREE_BUFFER_WAIT, bps.WRITE_COMPLETE_WAIT,
                                   bps.BUFFER_BUSY_WAIT, bps.FREE_BUFFER_INSPECTED, bps.DIRTY_BUFFERS_INSPECTED, bps.DB_BLOCK_CHANGE, bps.DB_BLOCK_GETS,
                                   bps.CONSISTENT_GETS, bps.PHYSICAL_READS, bps.PHYSICAL_WRITES, sn.STARTUP_TIME, sn.SNAP_TIME, sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$BUFFER_POOL_STATISTICS bps, PERFSTAT.STATS$SNAPSHOT sn
                                   where bps.SNAP_ID = sn.SNAP_ID AND bps.DBID = sn.DBID AND bps.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by bps.ID,bps.NAME,sn.SNAP_TIME,sn.SNAP_ID) ns_pr ) pr
              WHERE cr.rn - 1 = pr.rn AND cr.DBID = pr.DBID AND cr.INSTANCE_NUMBER = pr.INSTANCE_NUMBER AND cr.STARTUP_TIME = pr.STARTUP_TIME
                    AND cr.SNAP_LEVEL = pr.SNAP_LEVEL AND cr.ID = pr.ID AND cr.NAME = pr.NAME
              ORDER BY cr.SNAP_ID,cr.ID,cr.NAME,cr.SNAP_TIME ;

-- важно, что дельта высчитывается только между значениями с совпадающим временем старта экземпляра - иначе бессмысленно
INSERT INTO CLC_DELTA_PGASTAT
       SELECT V_POINT_ID,cr.SNAP_LEVEL,cr.SNAP_ID,TO_DATE(TO_CHAR(cr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'),pr.SNAP_ID,
              TO_DATE(TO_CHAR(pr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'),CR.NAME,CR.VALUE,PR.VALUE,(CR.VALUE-PR.VALUE)
              FROM (SELECT ROWNUM rn, ns_cr.*      from
                           (SELECT ps.SNAP_ID, ps.DBID, ps.INSTANCE_NUMBER, ps.NAME, ps.VALUE, sn.STARTUP_TIME, sn.SNAP_TIME, sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$PGASTAT ps, PERFSTAT.STATS$SNAPSHOT sn
                                   where ps.SNAP_ID = sn.SNAP_ID AND ps.DBID = sn.DBID AND ps.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by ps.NAME,sn.SNAP_TIME,sn.SNAP_ID) ns_cr ) cr,
                   (SELECT ROWNUM rn, ns_pr.* from
                           (SELECT ps.SNAP_ID, ps.DBID, ps.INSTANCE_NUMBER, ps.NAME, ps.VALUE, sn.STARTUP_TIME, sn.SNAP_TIME, sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$PGASTAT ps, PERFSTAT.STATS$SNAPSHOT sn
                                   where ps.SNAP_ID = sn.SNAP_ID AND ps.DBID = sn.DBID AND ps.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by ps.NAME,sn.SNAP_TIME,sn.SNAP_ID) ns_pr ) pr
              WHERE cr.rn - 1 = pr.rn AND cr.DBID = pr.DBID AND cr.INSTANCE_NUMBER = pr.INSTANCE_NUMBER AND cr.STARTUP_TIME = pr.STARTUP_TIME
                    AND cr.SNAP_LEVEL = pr.SNAP_LEVEL AND cr.NAME = pr.NAME
              ORDER BY cr.SNAP_ID,cr.SNAP_TIME,cr.NAME ;

-- SELECT 'INSERT INTO CLC_POINT_SGA VALUES(__POINT_ID__,'||sn.SNAP_LEVEL||','||ss.SNAP_ID||',TO_DATE('''||
--                TO_CHAR(sn.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS')||''',''YYYY-MM-DD HH24:MI:SS''),'''||
--                ss.NAME||''','||ss.VALUE||','''||ss.PARALLEL||''','''||ss.VERSION||''');'
--        FROM PERFSTAT.STATS$SGA ss, PERFSTAT.STATS$SNAPSHOT sn
--        where ss.SNAP_ID = sn.SNAP_ID AND ss.DBID = sn.DBID AND ss.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND sn.SNAP_ID >= 7
--        order by sn.SNAP_TIME,sn.SNAP_ID,ss.NAME ;

-- важно, что дельта высчитывается только между значениями с совпадающим временем старта экземпляра - иначе бессмысленно
INSERT INTO CLC_DELTA_SGA
       SELECT V_POINT_ID,cr.SNAP_LEVEL,cr.SNAP_ID,TO_DATE(TO_CHAR(cr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'),pr.SNAP_ID,
              TO_DATE(TO_CHAR(pr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'),CR.NAME,CR.VALUE,PR.VALUE,(CR.VALUE-PR.VALUE)
              FROM (SELECT ROWNUM rn, ns_cr.* from
                           (SELECT ss.SNAP_ID, ss.DBID, ss.INSTANCE_NUMBER, ss.NAME, ss.VALUE, ss.PARALLEL, ss.VERSION, sn.STARTUP_TIME, sn.SNAP_TIME,
                                   sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$SGA ss, PERFSTAT.STATS$SNAPSHOT sn
                                   where ss.SNAP_ID = sn.SNAP_ID AND ss.DBID = sn.DBID AND ss.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by ss.NAME,sn.SNAP_TIME,sn.SNAP_ID) ns_cr ) cr,
                   (SELECT ROWNUM rn, ns_pr.* from
                           (SELECT ss.SNAP_ID, ss.DBID, ss.INSTANCE_NUMBER, ss.NAME, ss.VALUE, ss.PARALLEL, ss.VERSION, sn.STARTUP_TIME, sn.SNAP_TIME,
                                   sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$SGA ss, PERFSTAT.STATS$SNAPSHOT sn
                                   where ss.SNAP_ID = sn.SNAP_ID AND ss.DBID = sn.DBID AND ss.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by ss.NAME,sn.SNAP_TIME,sn.SNAP_ID) ns_pr ) pr
              WHERE cr.rn - 1 = pr.rn AND cr.DBID = pr.DBID AND cr.INSTANCE_NUMBER = pr.INSTANCE_NUMBER AND cr.STARTUP_TIME = pr.STARTUP_TIME
                    AND cr.SNAP_LEVEL = pr.SNAP_LEVEL AND cr.NAME = pr.NAME
              ORDER BY cr.SNAP_ID,cr.SNAP_TIME,cr.NAME ;

-- важно, что дельта высчитывается только между значениями с совпадающим временем старта экземпляра - иначе бессмысленно
INSERT INTO CLC_DELTA_SGASTAT
       SELECT V_POINT_ID,cr.SNAP_LEVEL,cr.SNAP_ID,TO_DATE(TO_CHAR(cr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'),pr.SNAP_ID,
              TO_DATE(TO_CHAR(pr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'), CR.POOL,CR.NAME,CR.BYTES,PR.BYTES,(CR.BYTES-PR.BYTES)
              FROM (SELECT ROWNUM rn, ns_cr.* from
                           (SELECT ss.SNAP_ID, ss.DBID, ss.INSTANCE_NUMBER, ss.NAME, ss.POOL, ss.BYTES, sn.STARTUP_TIME, sn.SNAP_TIME, sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$SGASTAT ss, PERFSTAT.STATS$SNAPSHOT sn
                                   where ss.SNAP_ID = sn.SNAP_ID AND ss.DBID = sn.DBID AND ss.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by ss.NAME,sn.SNAP_TIME,sn.SNAP_ID) ns_cr ) cr,
                   (SELECT ROWNUM rn, ns_pr.* from
                           (SELECT ss.SNAP_ID, ss.DBID, ss.INSTANCE_NUMBER, ss.NAME, ss.POOL, ss.BYTES, sn.STARTUP_TIME, sn.SNAP_TIME, sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$SGASTAT ss, PERFSTAT.STATS$SNAPSHOT sn
                                   where ss.SNAP_ID = sn.SNAP_ID AND ss.DBID = sn.DBID AND ss.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by ss.NAME,sn.SNAP_TIME,sn.SNAP_ID) ns_pr ) pr
              WHERE cr.rn - 1 = pr.rn AND cr.DBID = pr.DBID AND cr.INSTANCE_NUMBER = pr.INSTANCE_NUMBER AND cr.STARTUP_TIME = pr.STARTUP_TIME
                    AND cr.SNAP_LEVEL = pr.SNAP_LEVEL AND cr.NAME = pr.NAME
              ORDER BY cr.SNAP_ID,cr.SNAP_TIME,cr.NAME ;

-- важно, что дельта высчитывается только между значениями с совпадающим временем старта экземпляра - иначе бессмысленно
INSERT INTO CLC_DELTA_ROWCACHE
       SELECT V_POINT_ID,cr.SNAP_LEVEL,cr.SNAP_ID,TO_DATE(TO_CHAR(cr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'),pr.SNAP_ID,
              TO_DATE(TO_CHAR(pr.SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS'), CR.PARAMETER,CR.TOTAL_USAGE,PR.TOTAL_USAGE,
              (CR.TOTAL_USAGE-PR.TOTAL_USAGE),CR.USAGE,PR.USAGE,(CR.USAGE-PR.USAGE),CR.GETS,PR.GETS,(CR.GETS-PR.GETS),CR.GETMISSES,PR.GETMISSES,
              (CR.GETMISSES-PR.GETMISSES),CR.SCANS,PR.SCANS,(CR.SCANS-PR.SCANS),CR.SCANMISSES,PR.SCANMISSES,(CR.SCANMISSES-PR.SCANMISSES),
              CR.SCANCOMPLETES,PR.SCANCOMPLETES,(CR.SCANCOMPLETES-PR.SCANCOMPLETES),CR.MODIFICATIONS,PR.MODIFICATIONS,(CR.MODIFICATIONS-PR.MODIFICATIONS),
              CR.FLUSHES,PR.FLUSHES,(CR.FLUSHES-PR.FLUSHES),CR.DLM_REQUESTS,PR.DLM_REQUESTS,(CR.DLM_REQUESTS-PR.DLM_REQUESTS),CR.DLM_CONFLICTS,
              PR.DLM_CONFLICTS,(CR.DLM_CONFLICTS-PR.DLM_CONFLICTS),CR.DLM_RELEASES,PR.DLM_RELEASES,(CR.DLM_RELEASES-PR.DLM_RELEASES)
              FROM (SELECT ROWNUM rn, ns_cr.* from
                           (SELECT rs.SNAP_ID, rs.DBID, rs.INSTANCE_NUMBER, rs.PARAMETER, rs.TOTAL_USAGE, rs.USAGE, rs.GETS, rs.GETMISSES, rs.SCANS,
                                   rs.SCANMISSES, rs.SCANCOMPLETES, rs.MODIFICATIONS, rs.FLUSHES, rs.DLM_REQUESTS, rs.DLM_CONFLICTS, rs.DLM_RELEASES,
                                   sn.STARTUP_TIME, sn.SNAP_TIME, sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$ROWCACHE_SUMMARY rs, PERFSTAT.STATS$SNAPSHOT sn
                                   where rs.SNAP_ID = sn.SNAP_ID AND rs.DBID = sn.DBID AND rs.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by rs.PARAMETER,sn.SNAP_TIME,sn.SNAP_ID) ns_cr ) cr,
                   (SELECT ROWNUM rn, ns_pr.* from
                           (SELECT rs.SNAP_ID, rs.DBID, rs.INSTANCE_NUMBER, rs.PARAMETER, rs.TOTAL_USAGE, rs.USAGE, rs.GETS, rs.GETMISSES, rs.SCANS,
                                   rs.SCANMISSES, rs.SCANCOMPLETES, rs.MODIFICATIONS, rs.FLUSHES, rs.DLM_REQUESTS, rs.DLM_CONFLICTS, rs.DLM_RELEASES,
                                   sn.STARTUP_TIME, sn.SNAP_TIME, sn.SNAP_LEVEL
                                   FROM PERFSTAT.STATS$ROWCACHE_SUMMARY rs, PERFSTAT.STATS$SNAPSHOT sn
                                   where rs.SNAP_ID = sn.SNAP_ID AND rs.DBID = sn.DBID AND rs.INSTANCE_NUMBER = sn.INSTANCE_NUMBER AND
                                         sn.SNAP_ID >= V_CURR_MAX_SNAP_ID AND sn.SNAP_ID <= V_NEW_MAX_SNAP_ID
                                   order by rs.PARAMETER,sn.SNAP_TIME,sn.SNAP_ID) ns_pr ) pr
                WHERE cr.rn - 1 = pr.rn AND cr.DBID = pr.DBID AND cr.INSTANCE_NUMBER = pr.INSTANCE_NUMBER AND cr.STARTUP_TIME = pr.STARTUP_TIME
                      AND cr.SNAP_LEVEL = pr.SNAP_LEVEL AND cr.PARAMETER = pr.PARAMETER
                ORDER BY cr.SNAP_ID,cr.PARAMETER,cr.SNAP_TIME ;

UPDATE CLC_STATISTIC_POINTS SET PREV_MAX_SNAP_ID = V_CURR_MAX_SNAP_ID, CURR_MAX_SNAP_ID = V_NEW_MAX_SNAP_ID ;
COMMIT ;
                                                                                                                                                            
-- дополнить таблицу информации об архивных журналах
INSERT INTO CLC_ARCHIVED_LOG SELECT * FROM V$ARCHIVED_LOG
       WHERE SEQUENCE# > ( SELECT CASE WHEN MAX(SEQUENCE#) IS NULL THEN 0 ELSE MAX(SEQUENCE#) END
                                  FROM CLC_ARCHIVED_LOG ) ;
-- дополнить таблицу информации о статистике UNDO
INSERT INTO CLC_UNDOSTAT SELECT * FROM V$UNDOSTAT
       WHERE BEGIN_TIME > ( SELECT CASE WHEN MAX(BEGIN_TIME) IS NULL THEN TO_DATE('1970-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS') ELSE MAX(BEGIN_TIME) END
                                  FROM CLC_UNDOSTAT ) ;
COMMIT ;

-- здесь нужно запускать процедуру, которая будет проходится по обработанным данным и вычислять единожды, дабы не повторяться
-- веса событий ожидания
-- формализованные статистические показатели за каждый новый диапазон дельт
-- профиль загрузки

-- подразумевается запуск в составе общей процедуры после начального съёма информации и обновления указателей
SELECT PREV_MAX_SNAP_ID, CURR_MAX_SNAP_ID INTO V_PREV_MAX_SNAP_ID, V_CURR_MAX_SNAP_ID FROM CLC_STATISTIC_POINTS ;
FOR I IN ( SELECT CR_SNAP_ID, CR_SNAP_TIME, PR_SNAP_ID, PR_SNAP_TIME
                  FROM CLC_DELTA_SYSEVENT  
                  WHERE CR_SNAP_ID > V_PREV_MAX_SNAP_ID AND 
                        CR_SNAP_ID <= V_CURR_MAX_SNAP_ID 
                  GROUP BY CR_SNAP_ID, CR_SNAP_TIME, PR_SNAP_ID, PR_SNAP_TIME 
                  ORDER BY CR_SNAP_ID ) LOOP

    V_TOTAL_TIME := ((I.CR_SNAP_TIME - I.PR_SNAP_TIME) * 24 * 60 * 60 * 1000000) ;

-- получить значение ожиданий блокировок из статистик
    SELECT ss.DIFFERENCE INTO V_ENQUEUE_TIM_STAT 
           FROM CLC_DELTA_SYSSTAT ss, V$STATNAME sn
           WHERE CR_SNAP_ID = I.CR_SNAP_ID AND
                 ss.STATISTIC# = sn.STATISTIC# AND
                 sn.NAME = 'enqueue timeouts' ;

-- получить значение всех ожиданий из статистик - мало применимо, ибо фиктивные ожидания суммируются и становятся больше времени интервала
--select sum(diff_twm) INTO V_ALL_WAIT
--       from CLC_DELTA_SYSEVENT 
--       WHERE CR_SNAP_ID = I.CR_SNAP_ID
--       group by POINT_ID,CR_SNAP_ID,PR_SNAP_ID 
--       ORDER BY CR_SNAP_ID ;

-- получить значение нефиктивных ожиданий из статистик
    SELECT sum(diff_twm) INTO V_NOIDLE_WAIT
           FROM CLC_DELTA_SYSEVENT se, v$event_name en
           WHERE CR_SNAP_ID = I.CR_SNAP_ID AND
                 se.EVENT# = en.EVENT# AND
                 en.NAME NOT IN ( select * from stats$idle_event )
           GROUP BY POINT_ID,CR_SNAP_ID,PR_SNAP_ID 
           ORDER BY CR_SNAP_ID ;

-- добавить запись о сумарных показателях событий ожидания за срез
    INSERT INTO CLC_SUMEVENTS_TIMING 
           VALUES(0, I.CR_SNAP_ID, I.CR_SNAP_TIME, I.PR_SNAP_ID, I.PR_SNAP_TIME, V_TOTAL_TIME, V_NOIDLE_WAIT,
                 (V_NOIDLE_WAIT/(V_TOTAL_TIME/100)),V_ENQUEUE_TIM_STAT,(V_ENQUEUE_TIM_STAT/(V_TOTAL_TIME/100))) ;

-- для каждой записи о конкретном нефиктивном событии ожидания соответствующего среза вычислить и установить вес
-- относительно общего времени охваченного периода
-- и относительно времени суммарного нефиктивного ожидания охвачиваемого периода
    UPDATE CLC_DELTA_SYSEVENT 
           SET PERALL_WT_PERCENT = ROUND(DIFF_TWM / (V_TOTAL_TIME / 100),'999999.999'),
               PER_NOF_WT_PERCENT = ROUND(DIFF_TWM / (V_NOIDLE_WAIT / 100),'999999.999') 
           WHERE CR_SNAP_ID = I.CR_SNAP_ID AND 
                 EVENT# IN ( SELECT se.EVENT# FROM clc_delta_sysevent se, v$event_name en
                                    WHERE se.EVENT# = en.EVENT# AND
                                          en.NAME NOT IN ( select * from stats$idle_event )) ;
/*
UPDATE CLC_DELTA_SYSEVENT SET PERALL_WT_PERCENT =0, PER_NOF_WT_PERCENT = 0;

set linesize 300 pagesize 4000
col a0 for 999999999999999
col a1 for 999.999
col a2 for 999.999
select en.NAME, se.diff_twm a0, se.PERALL_WT_PERCENT a1, se.PER_NOF_WT_PERCENT a2
       from CLC_DELTA_SYSEVENT se, V$EVENT_NAME en
       WHERE se.EVENT# = en.EVENT# AND se.PER_NOF_WT_PERCENT > 60
       ORDER BY se.CR_SNAP_ID,se.EVENT# ;
*/
    END LOOP ;
COMMIT ;

-- запустить обработку по аналитики по собранным дельтам
SELECT MAX(CURR_MAX_SNAP_ID) INTO V_CURR_MAX_SNAP_ID FROM CLC_STATISTIC_POINTS ;
SELECT MAX(SNAP_ID) INTO V_NEW_MAX_SNAP_ID FROM STATS$SNAPSHOT ;
CALCK_ANALITICA_POINTS(V_PREV_MAX_SNAP_ID, V_CURR_MAX_SNAP_ID) ;
DBMS_OUTPUT.PUT_LINE('Proc BELSTAT_GET_EVENT_STAT stop message. Value of range: PREV = '||V_PREV_MAX_SNAP_ID||', CURR = '||V_CURR_MAX_SNAP_ID) ;

END ;
/
                                                                                                                                                            
show errors ;                                                                                                                                               
exit ;                                                                                                                                                      
