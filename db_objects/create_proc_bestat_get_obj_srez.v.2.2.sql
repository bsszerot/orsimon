
set hea on
-- ####################################################################################################################################
-- процедура заполнения среза ОБЪЕКТНОЙ статистики
-- ####################################################################################################################################
DROP PROCEDURE BESTAT_GET_OBJ_SREZ ;
CREATE OR REPLACE PROCEDURE BESTAT_GET_OBJ_SREZ AS
MY_POINT_ID NUMBER ;
MY_STAT_RANGE_ID NUMBER ;
MY_COUNT_STAT_RANGE_ID NUMBER ;
MY_RESETLOGS_CHANGE NUMBER ;
MY_RESETLOGS_TIME DATE ;
MY_START_INSTANCE DATE ;
MY_STAMP_RECORD DATE ;
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
INSERT INTO BESTAT_COLLECTOR_POINTS VALUES (MY_POINT_ID, MY_STAT_RANGE_ID, 'OBJ', 'NONE', MY_RESETLOGS_CHANGE, MY_RESETLOGS_TIME, MY_START_INSTANCE, MY_STAMP_RECORD, '') ;
-- занести записи в таблицу среза информации об объектах
FOR curr_objects_data IN (select * from DBA_OBJECTS) LOOP
    INSERT INTO BESTAT_DBA_OBJECTS VALUES ( MY_POINT_ID, curr_objects_data.OWNER, curr_objects_data.OBJECT_NAME, curr_objects_data.SUBOBJECT_NAME, 
           curr_objects_data.OBJECT_ID, curr_objects_data.DATA_OBJECT_ID, curr_objects_data.OBJECT_TYPE, curr_objects_data.CREATED, 
           curr_objects_data.LAST_DDL_TIME, curr_objects_data.TIMESTAMP, curr_objects_data.STATUS, curr_objects_data.TEMPORARY, 
           curr_objects_data.GENERATED, curr_objects_data.SECONDARY ) ;
    END LOOP ;
-- занести записи в таблицу среза информации о сегментоах
FOR curr_dba_segments_data IN (select * from DBA_SEGMENTS) LOOP
    INSERT INTO BESTAT_DBA_SEGMENTS VALUES ( MY_POINT_ID, curr_dba_segments_data.OWNER, curr_dba_segments_data.SEGMENT_NAME,
           curr_dba_segments_data.PARTITION_NAME, curr_dba_segments_data.SEGMENT_TYPE,curr_dba_segments_data.TABLESPACE_NAME,
           curr_dba_segments_data.HEADER_FILE, curr_dba_segments_data.HEADER_BLOCK, curr_dba_segments_data.BYTES, curr_dba_segments_data.BLOCKS, 
           curr_dba_segments_data.EXTENTS, curr_dba_segments_data.INITIAL_EXTENT, curr_dba_segments_data.NEXT_EXTENT, curr_dba_segments_data.MIN_EXTENTS, 
           curr_dba_segments_data.MAX_EXTENTS, curr_dba_segments_data.PCT_INCREASE, curr_dba_segments_data.FREELISTS, 
           curr_dba_segments_data.FREELIST_GROUPS, curr_dba_segments_data.RELATIVE_FNO, curr_dba_segments_data.BUFFER_POOL ) ;
    END LOOP ;
-- занести записи в таблицу среза информации о статистиках сегментов - заносится процедурой частой статистики
COMMIT ;
END BESTAT_GET_OBJ_SREZ ;
/

show errors
spool off ;
exit ;
