#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_objects_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_objects_list_all.cgi?order_field=OBJECT_NAME\" TARGET=\"cont\">Объекты все</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=TABLE_NAME\" TARGET=\"cont\">Таблицы</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_objects_list_all.cgi?order_field=OBJECT_NAME\" TARGET=\"cont\">Представления</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_objects_list_all.cgi?order_field=OBJECT_NAME\" TARGET=\"cont\">Индексы</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_objects_list_all.cgi?order_field=OBJECT_NAME\" TARGET=\"cont\">Синонимы</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_objects_list_all.cgi?order_field=OBJECT_NAME\" TARGET=\"cont\">Триггеры</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_objects_list_all.cgi?order_field=OBJECT_NAME\" TARGET=\"cont\">Процедуры</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_objects_list_all.cgi?order_field=OBJECT_NAME\" TARGET=\"cont\">Тела</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_objects_list_all.cgi?order_field=OBJECT_NAME\" TARGET=\"cont\">DB линки</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           </TR></TABLE>" ;
    }
  
# - общие функции в закрытом варианте
sub print_html_head($) {
    print "<HTML><HEAD><TITLE>Монитор Oracle</TITLE>
           <META HTTP-EQUIV=Content-Type content=\"text/html; charset=utf8\">
           </HEAD><BODY>" ;
    print "<STYLE>
           BODY { text-align: jystify; font-size: 10pt; font-family: sans-serif ; }
           TD { font-size: 10pt; font-family: sans-serif ; padding: 2pt; text-align: left; }
           TD.HEAD { font-size: 10pt; font-family: sans-serif ; padding: 2pt; text-align: center; }
           TD.NUMDATA { font-size: 10pt; font-family: sans-serif ; padding: 2pt; text-align: right; }
           TD.SZDATA { font-size: 10pt; font-family: sans-serif ; padding: 2pt; text-align: left; }
           TD.CENTERDATA { font-size: 10pt; font-family: sans-serif ; padding: 2pt; text-align: center; }
           A:link { color: navy; text-decoration: none; font-weight: normal; font-size: 10pt; font-family: sans-serif; }
           A:active { color: navy; text-decoration: none; font-weight: normal; font-size: 10pt; font-family: sans-serif; }
           A:visited { color: navy; text-decoration: none; font-weight: normal; font-size: 10pt; font-family: sans-serif; }
           A:hover { color: navy; text-decoration: underline; font-weight: normal; font-size: 10pt; font-family: sans-serif; }
           </STYLE>" ;
    print "<TABLE CELLPADDING=\"3pt\" CELLSPACING=\"3pt\" BORDER=\"2\" STYLE=\"border: 2pt solid navy; width: 100%;\">
           <TR><TD STYLE=\"text-align: center; font-size: 14pt; border: none; color: white; background-color: navy ; \">$_[0]</TD></TR>
           <TR><TD STYLE=\"text-align: left; font-size: 12pt; border: none; color: navy; background-color: white ; \">Коннектор:&nbsp;$current_connector</TD></TR>
           </TABLE><BR>" ;
    }

sub print_html_head_refresh($$$) {
    print "<HTML><HEAD><TITLE>Монитор Oracle</TITLE>
           <META HTTP-EQUIV=Content-Type content=\"text/html; charset=utf8\">
           <META HTTP-EQUIV=\"refresh\" CONTENT=\"$_[1],$base_url/cgi/$_[2]\">
           </HEAD><BODY>" ;
    print "<STYLE>
           BODY { text-align: jystify; font-size: 10pt; font-family: sans-serif ; }
           TD { font-size: 10pt; font-family: sans-serif ; padding: 2pt; text-align: left; }
           TD.HEAD { font-size: 10pt; font-family: sans-serif ; padding: 2pt; text-align: center; }
           TD.NUMDATA { font-size: 10pt; font-family: sans-serif ; padding: 2pt; text-align: right; }
           TD.SZDATA { font-size: 10pt; font-family: sans-serif ; padding: 2pt; text-align: left; }
           TD.CENTERDATA { font-size: 10pt; font-family: sans-serif ; padding: 2pt; text-align: center; }
           A:link { color: navy; text-decoration: none; font-weight: normal; font-size: 10pt; font-family: sans-serif; }
           A:active { color: navy; text-decoration: none; font-weight: normal; font-size: 10pt; font-family: sans-serif; }
           A:visited { color: navy; text-decoration: none; font-weight: normal; font-size: 10pt; font-family: sans-serif; }
           A:hover { color: navy; text-decoration: underline; font-weight: normal; font-size: 10pt; font-family: sans-serif; }
           </STYLE>" ;
    print "<TABLE CELLPADDING=\"3pt\" CELLSPACING=\"3pt\" BORDER=\"2\" STYLE=\"border: 2pt solid navy; width: 100%;\">
           <TR><TD STYLE=\"text-align: center; font-size: 14pt; border: none; color: white; background-color: navy ; \" COLSPAN=\"2\">$_[0]</TD></TR>
           <TR>
           <TD STYLE=\"text-align: left; font-size: 12pt; border: none; color: navy; background-color: white ; \">Коннектор:&nbsp;$current_connector</TD>
           <TD STYLE=\"text-align: right; font-size: 10pt; padding: 0pt; margin: 0pt; border: none; color: black; background-color: white ; \">
           <FORM STYLE=\"padding: 0pt; margin: 0pt; border: none;\">
                 обновлять:&nbsp;<SELECT NAME=\"rft\">
                 <OPTION VALUE=\"none\" SELECTED>не обновлять</OPTION>
                 <OPTION VALUE=\"5\">5 секунд</OPTION>
                 <OPTION VALUE=\"10\">10 секунд</OPTION>
                 <OPTION VALUE=\"30\">30 секунд</OPTION>
                 <OPTION VALUE=\"60\">60 секунд</OPTION>
                 <OPTION VALUE=\"300\">5 минут</OPTION>
                 <OPTION VALUE=\"600\">10 минут</OPTION>
                 <OPTION VALUE=\"1800\">30 минут</OPTION>
                 </SELECT>
           </FORM>
           </TD>
           </TR>
           </TABLE><BR>" ;
    }

sub show_razryads($) { $sz_value = $_[0] ; $singl = "" ; 
    if ( $sz_value < 0 ) { $singl = "-" ; $sz_value *= -1 ; } $sz_length =  length($sz_value) - 1  ; $rev_value = "" ;
    for ($i = $sz_length; $i >= 0; $i--) { $rev_value .= substr($sz_value,$i,1) ; }
    $rev_value =~ m/(\w{0,3})(\w{0,3})(\w{0,3})(\w{0,3})(\w{0,3})(\w{0,3})(\w{0,3})(\w{0,3})(\w{0,3})/ ;
    $trpl1 = $1 ; $trpl2 = $2 ; $trpl3 = $3 ; $trpl4 = $4 ; $trpl5 = $5 ; $trpl6 = $6 ; $trpl7 = $7 ; $trpl8 = $8 ; $trpl9 = $9 ;
    if ( $trpl1 =~ /\w{3}/ ) { $trpl1 =~ s/(\w)(\w)(\w)/\3\2\1/ ; } else { if ( $trpl1 =~ /\w{2}$/ ) { $trpl1 =~ s/(\w)(\w)/\2\1/ ; } }
    if ( $trpl2 =~ /\w{3}/ ) { $trpl2 =~ s/(\w)(\w)(\w)/\3\2\1/ ; } else { if ( $trpl2 =~ /\w{2}$/ ) { $trpl2 =~ s/(\w)(\w)/\2\1/ ; } }
    if ( $trpl3 =~ /\w{3}/ ) { $trpl3 =~ s/(\w)(\w)(\w)/\3\2\1/ ; } else { if ( $trpl3 =~ /\w{2}$/ ) { $trpl3 =~ s/(\w)(\w)/\2\1/ ; } }
    if ( $trpl4 =~ /\w{3}/ ) { $trpl4 =~ s/(\w)(\w)(\w)/\3\2\1/ ; } else { if ( $trpl4 =~ /\w{2}$/ ) { $trpl4 =~ s/(\w)(\w)/\2\1/ ; } }
    if ( $trpl5 =~ /\w{3}/ ) { $trpl5 =~ s/(\w)(\w)(\w)/\3\2\1/ ; } else { if ( $trpl5 =~ /\w{2}$/ ) { $trpl5 =~ s/(\w)(\w)/\2\1/ ; } }
    if ( $trpl6 =~ /\w{3}/ ) { $trpl6 =~ s/(\w)(\w)(\w)/\3\2\1/ ; } else { if ( $trpl6 =~ /\w{2}$/ ) { $trpl6 =~ s/(\w)(\w)/\2\1/ ; } }
    if ( $trpl7 =~ /\w{3}/ ) { $trpl7 =~ s/(\w)(\w)(\w)/\3\2\1/ ; } else { if ( $trpl7 =~ /\w{2}$/ ) { $trpl7 =~ s/(\w)(\w)/\2\1/ ; } }
    if ( $trpl8 =~ /\w{3}/ ) { $trpl8 =~ s/(\w)(\w)(\w)/\3\2\1/ ; } else { if ( $trpl8 =~ /\w{2}$/ ) { $trpl8 =~ s/(\w)(\w)/\2\1/ ; } }
    if ( $trpl9 =~ /\w{3}/ ) { $trpl9 =~ s/(\w)(\w)(\w)/\3\2\1/ ; } else { if ( $trpl9 =~ /\w{2}$/ ) { $trpl9 =~ s/(\w)(\w)/\2\1/ ; } }
    $res = $singl . " " . $trpl9 . " " . $trpl8 . " " . $trpl7 . " " . $trpl6 . " " . $trpl5 . " " . $trpl4 . " " . $trpl3 . " " . $trpl2 . " " . $trpl1 ; $res =~ s/^\s+//g ;
    $res =~ s/\s/&nbsp;/g ;
    return $res ;
    }

sub get_forms_param() { 
    if ( $ENV{REQUEST_METHOD} eq "GET" ) { 
       @paramvalues = split (/&/, $ENV{QUERY_STRING}) ;
       foreach $pv (@paramvalues) { ($param,$val) = split (/=/,$pv) ; chomp($param) ; chomp($val) ; 
               $val =~ s/%(..)/pack("c",hex($1))/ge ; $param =~ s/%(..)/pack("c",hex($1))/ge ; 
               $val =~ s/\+/ /g ; $param =~ s/\+/ /g ;
               $pv{$param} = $val ; }
       }
    } 

sub print_select_data_source() {
# вывести поле выбора источника - или текущие данные, или доступный сохраненный срез
    if ( $pv{srcptr} eq "0" || $pv{srcptr} eq "" ) { $is_source_current = "" ; $is_source_current = "SELECTED" ; } 
    print "<TR><TD STYLE=\"width: 15%;\">&nbsp;Источник&nbsp;данных: </TD>
               <TD><SELECT NAME=\"srcptr\" STYLE=\"width: 100%\">
                   <OPTION VALUE=\"0\" $is_source_current>Текущие значения счетчиков в базе</OPTION>" ;
# важно, что запрос к записям о срезах статистики предваряется проверкой существования таблицы со списком срезов, что позволяет делать запросы даже в базы 
# с неустановленными объектами для хранения срезов статистики
# - получить список срезов статистики
    my $slices_dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
    $req_exsist_slaces_obj = "SELECT COUNT(*) from DBA_OBJECTS WHERE OBJECT_NAME = 'STATS\$SNAPSHOT' AND OBJECT_TYPE = 'TABLE' AND OWNER = 'PERFSTAT'" ;
    my $slices_sth = $slices_dbh->prepare($req_exsist_slaces_obj) ; $slices_sth->execute() ; my ($exsist_slaces_obj_count) = $slices_sth->fetchrow_array() ;
    if ( $exsist_slaces_obj_count eq "1" ) {
       $req_slaces_list = "SELECT SNAP_ID,DBID,TO_CHAR(SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),SNAP_LEVEL FROM PERFSTAT.STATS\$SNAPSHOT ORDER BY SNAP_ID" ;
       my $slices_sth = $slices_dbh->prepare($req_slaces_list) ; $slices_sth->execute() ;
       while (my ($snap_id,$dbid,$snap_time,$snap_level) = $slices_sth->fetchrow_array() ) { 
             $is_source_current = "" ; if ( $pv{srcptr} eq "$snap_id" ) { $is_source_current = "SELECTED" ; } 
             printf("<OPTION VALUE=\"%s\" %s>STATSPACK dbid %s, snap %07d, level %03d, от %s</OPTION>",$snap_id,$is_source_current,$dbid,$snap_id,$snap_level,$snap_time) ; 
             }
       }
    $slices_sth->finish(); $slices_dbh->disconnect();                                        
    print "</SELECT></TD></TR>" ;
    }

use DBI;
require "/var/www/oracle/cgi/omon.cfg" ;

# - ДЛЯ ВСЕХ МОДУЛЕЙ - инициализировать значения сессии из cookie, если есть, или же использовать значения по умолчанию
$current_connector = "none" ; if ( $ENV{HTTP_COOKIE} =~ /.*[;\s]*current_connector=([^;]+)[;\s]*.*/ ) { $current_connector = $1 ; }

# - вытащить из URL запроса значения уточняющих полей
$pv{order_field} = "TABLE_NAME" ; $report_type = "" ;
&get_forms_param() ;

$ENV{ORACLE_SID} = $current_connector ;
                                 
print "Content-Type: text/html\n\n"; 
&print_html_head("Информация о таблицах БД") ;

# добавить определение навигационно - оформительского механизма закладок
&print_objects_navigation(2) ;

print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">" ;
print "<TR><TD>" ;

# вывести форму выбора отчета
$is_checked_view_all = "" ; if ( $pv{is_view_all} eq "on" ) { $is_checked_view_all = "CHECKED" ; }
$is_checked_orf_include = "" ; if ( $pv{obj_range_filter} eq "include" || $pv{obj_range_filter} eq "" ) { $is_checked_orf_include = "CHECKED" ; }
$is_checked_orf_excludel = "" ; if ( $pv{obj_range_filter} eq "exclude" ) { $is_checked_orf_excludel = "CHECKED" ; }
if ( $pv{filter_types_content} eq "" ) { $pv{filter_types_content} = "TABLE,INDEX,VIEW,TRIGGER,PROCEDURE,PROCEDURE BODY" ; }
$is_checked_period_default = "" ; if ( $pv{period} eq "default" || $period eq "" ) { $is_checked_period_default = "CHECKED" ; }
$is_checked_period_created = "" ; if ( $pv{period} eq "created" ) { $is_checked_period_created = "CHECKED" ; }
$is_checked_period_modified = "" ; if ( $pv{period} eq "modified" ) { $is_checked_period_modified = "CHECKED" ; }
$curr_date = `date "+%Y-%m-%d"` ; chomp($curr_date) ; 
if ( $pv{period_from} eq "" ) { $pv{period_from} = "$curr_date" ; } if ( $pv{period_to} eq "" ) { $pv{period_to} = "$curr_date" ; } 
print "<FORM ACTION=\"$base_url/cgi/get_objects_list_tables.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD>Владелец: </TD><TD STYLE=\"width: 85%\"><INPUT TYPE=\"input\" NAME=\"owner\" VALUE=\"$pv{owner}\" STYLE=\"width: 100%\"></TD></TR>
       <TR><TD>Статус: </TD><TD STYLE=\"width: 85%\"><INPUT TYPE=\"input\" NAME=\"status\" VALUE=\"$pv{status}\" STYLE=\"width: 100%\"></TD></TR>
       <TR><TD>Имя содержит: </TD><TD STYLE=\"width: 85%\"><INPUT TYPE=\"input\" NAME=\"name_include\" VALUE=\"$pv{name_include}\" STYLE=\"width: 100%\"></TD></TR></TD></TR>
       <TR><TD>Дата анализа: </TD>
           <TD>с&nbsp;<INPUT TYPE=\"input\" NAME=\"period_from\" VALUE=\"$pv{period_from}\" LENGHT=\"10\">
                &nbsp;по&nbsp;<INPUT TYPE=\"input\" NAME=\"period_to\" VALUE=\"$pv{period_to}\">
       <INPUT TYPE=\"hidden\" NAME=\"isfirst\" VALUE=\"no\">
       </TD></TR>        
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

#SQL> desc dba_indexes
# Name                                      Null?    Type
# ----------------------------------------- -------- ----------------------------
# OWNER                                     NOT NULL VARCHAR2(30)
# INDEX_NAME                                NOT NULL VARCHAR2(30)
# INDEX_TYPE                                         VARCHAR2(27)
# TABLE_OWNER                               NOT NULL VARCHAR2(30)
# TABLE_NAME                                NOT NULL VARCHAR2(30)
# TABLE_TYPE                                         VARCHAR2(11)
# UNIQUENESS                                         VARCHAR2(9)
# COMPRESSION                                        VARCHAR2(8)
# PREFIX_LENGTH                                      NUMBER
# TABLESPACE_NAME                                    VARCHAR2(30)
# INI_TRANS                                          NUMBER
# MAX_TRANS                                          NUMBER
# INITIAL_EXTENT                                     NUMBER
# NEXT_EXTENT                                        NUMBER
# MIN_EXTENTS                                        NUMBER
# MAX_EXTENTS                                        NUMBER
# PCT_INCREASE                                       NUMBER
# PCT_THRESHOLD                                      NUMBER
# INCLUDE_COLUMN                                     NUMBER
# FREELISTS                                          NUMBER
# FREELIST_GROUPS                                    NUMBER
# PCT_FREE                                           NUMBER
# LOGGING                                            VARCHAR2(3)
# BLEVEL                                             NUMBER
# LEAF_BLOCKS                                        NUMBER
# DISTINCT_KEYS                                      NUMBER
# AVG_LEAF_BLOCKS_PER_KEY                            NUMBER
# AVG_DATA_BLOCKS_PER_KEY                            NUMBER
# CLUSTERING_FACTOR                                  NUMBER
# STATUS                                             VARCHAR2(8)
# NUM_ROWS                                           NUMBER
# SAMPLE_SIZE                                        NUMBER
# LAST_ANALYZED                                      DATE
# DEGREE                                             VARCHAR2(40)
# INSTANCES                                          VARCHAR2(40)
# PARTITIONED                                        VARCHAR2(3)
# TEMPORARY                                          VARCHAR2(1)
# GENERATED                                          VARCHAR2(1)
# SECONDARY                                          VARCHAR2(1)
# BUFFER_POOL                                        VARCHAR2(7)
# USER_STATS                                         VARCHAR2(3)
# DURATION                                           VARCHAR2(15)
# PCT_DIRECT_ACCESS                                  NUMBER
# ITYP_OWNER                                         VARCHAR2(30)
# ITYP_NAME                                          VARCHAR2(30)
# PARAMETERS                                         VARCHAR2(1000)
# GLOBAL_STATS                                       VARCHAR2(3)
# DOMIDX_STATUS                                      VARCHAR2(12)
# DOMIDX_OPSTATUS                                    VARCHAR2(6)
# FUNCIDX_STATUS                                     VARCHAR2(8)
# JOIN_INDEX                                         VARCHAR2(3)
##SQL>

 OWNER,INDEX_NAME,INDEX_TYPE,TABLE_OWNER,TABLE_NAME,TABLE_TYPE,UNIQUENESS,COMPRESSION,PREFIX_LENGTH,TABLESPACE_NAME,INI_TRANS,MAX_TRANS,
 INITIAL_EXTENT,NEXT_EXTENT,MIN_EXTENTS,MAX_EXTENTS,PCT_INCREASE,PCT_THRESHOLD,INCLUDE_COLUMN,FREELISTS,FREELIST_GROUPS,PCT_FREE,LOGGING,
 BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,CLUSTERING_FACTOR,STATUS,NUM_ROWS,SAMPLE_SIZE,LAST_ANALYZED,
 DEGREE,INSTANCES,PARTITIONED,TEMPORARY,GENERATED,SECONDARY,BUFFER_POOL,USER_STATS,DURATION,PCT_DIRECT_ACCESS,ITYP_OWNER,ITYP_NAME,PARAMETERS,
 GLOBAL_STATS,DOMIDX_STATUS,DOMIDX_OPSTATUS,FUNCIDX_STATUS,JOIN_INDEX

 $owner,$index_name,$index_type,$table_owner,$table_name,$table_type,$uniqueness,$compression,$prefix_length,$tablespace_name,$ini_trans,$max_trans,
 $initial_extents,$next_extents,$min_extents,$max_extents,$pct_increase,$pct_treshold,$include_column,$freelists,$freelist_group,$pct_free,$logging,
 $blevel,$leaf_blocks,$distinct_keys,$avg_leaf_blocks_per_key,$avg_data_blocks_per_key,$clustering_factor,$status,$num_rows,$sample_size,$last_analized,
 $degree,$instances,$partitioned,$temporary,$generated,$secondary,$buffer_pool,$user_stats,$duration,$pct_direct_access,$ityp_owner,$ityp_name,$parameters,
 $global_stats,$domidx_status,$domidx_opstatus,$funcidx_status,$join_index


#OWNER,TABLE_NAME,TABLESPACE_NAME,CLUSTER_NAME,IOT_NAME,PCT_FREE,PCT_USED,INI_TRANS,MAX_TRANS,INITIAL_EXTENT,NEXT_EXTENT,MIN_EXTENTS,
# MAX_EXTENTS,PCT_INCREASE,FREELISTS,FREELIST_GROUPS,LOGGING,BACKED_UP,NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_SPACE,CHAIN_CNT,AVG_ROW_LEN,
# AVG_SPACE_FREELIST_BLOCKS,NUM_FREELIST_BLOCKS,DEGREE,INSTANCES,CACHE,TABLE_LOCK,SAMPLE_SIZE,LAST_ANALYZED,PARTITIONED,IOT_TYPE,TEMPORARY,
# SECONDARY,NESTED,BUFFER_POOL,ROW_MOVEMENT,GLOBAL_STATS,USER_STATS,DURATION,SKIP_CORRUPT,MONITORING,CLUSTER_OWNER,DEPENDENCIES,COMPRESSION

#$owner,$table_name,$tablespace_name,$cluster_name,$iot_name,$pct_free,$pct_used,$ini_trans,$max_trans,$initial_extent,$next_extent,$min_extents,
#$max_extents,$pct_increase,$freelists,$freelist_groups,$logging,$backed_up,$num_rows,$blocks,$empty_blocks,$avg_space,$chain_cnt,$avg_row_len,
#$avg_space_freelist_blocks,$num_freelist_blocks,$degree,$instances,$cache,$table_lock,$sample_size,$last_analyzed,$partitioned,$iot_type,$temporary,
#$secondary,$nested,$buffer_pool,$row_movement,$global_stats,$user_stats,$duration,$skip_corrupt,$monitoring,$cluster_owner,$dependencies,$compression

if ( $pv{isfirst} eq "no" ) {
# --- вычислить диапазон выводимых значений при необходимости
   $where_class = "" ; 
#--   $where_class = ' WHERE LAST_DDL_TIME >= ' . "TO_DATE('$pv{period_from} 00:00:00','YYYY-MM-DD HH24:MI:SS') AND " . 'LAST_DDL_TIME < ' . "TO_DATE('$pv{period_to} 23:59:59','YYYY-MM-DD HH24:MI:SS') " ; }
   if ( $pv{owner} ne "" ) { if ( $where_class ne "" ) { $where_class .= " AND " } else { $where_class .= " WHERE " } $where_class .= ' OWNER = ' . "'$pv{owner}' " ; }
   if ( $pv{status} ne "" ) { if ( $where_class ne "" ) { $where_class .= " AND " } else { $where_class .= " WHERE " } $where_class .= ' STATUS = ' . "'$pv{status}' " ; }
   if ( $pv{name_include} ne "" ) { if ( $where_class ne "" ) { $where_class .= " AND " } else { $where_class .= " WHERE " } $where_class .= " TABLE_NAME LIKE '%$pv{name_include}%' " ; }
   $request = "select OWNER,TABLE_NAME,TABLESPACE_NAME,CLUSTER_NAME,IOT_NAME,PCT_FREE,PCT_USED,INI_TRANS,MAX_TRANS,INITIAL_EXTENT,NEXT_EXTENT,MIN_EXTENTS,
                      MAX_EXTENTS,PCT_INCREASE,FREELISTS,FREELIST_GROUPS,LOGGING,BACKED_UP,NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_SPACE,CHAIN_CNT,AVG_ROW_LEN,
                      AVG_SPACE_FREELIST_BLOCKS,NUM_FREELIST_BLOCKS,DEGREE,INSTANCES,CACHE,TABLE_LOCK,SAMPLE_SIZE,
                      TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI:SS'),PARTITIONED,IOT_TYPE,TEMPORARY,SECONDARY,NESTED,BUFFER_POOL,ROW_MOVEMENT,GLOBAL_STATS,
                      USER_STATS,DURATION,SKIP_CORRUPT,MONITORING,CLUSTER_OWNER,DEPENDENCIES,COMPRESSION
                      from DBA_TABLES  $where_class ORDER BY $pv{order_field} " ;
   my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
   my $sth = $dbh->prepare($request) ;
   $sth->execute();
# вывести непосредственно контент
   print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
   print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=OWNER\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Владелец</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=TABLE_NAME\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Имя таблицы</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=TABLESPACE_NAME\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Табличное пространство</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=CLUSTER_NAME\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Имя кластера</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=IOT_NAME\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Имя IOT</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=PCT_FREE\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">PCT FREE</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=PCT_USED\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">PCT USED</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=INI_TRANS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Ini trans</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=MAX_TRANS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Max trans</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=INITIAL_EXTENT\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Initial extent</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=NEXT_EXTENT\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Next extent</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=MIN_EXTENTS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Min extents</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=MAX_EXTENTS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Max extents</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=PCT_INCREASE\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">PCT_INCREASE</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=FREELISTS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">FREELISTS</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=FREELIST_GROUPS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">FREELIST_GROUPS</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=LOGGING\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">LOGGING</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=BACKED_UP\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">BACKED_UP</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=NUM_ROWS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Количество строк</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=BLOCKS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Блоков</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=EMPTY_BLOCKS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Пустых блоков</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=AVG_SPACE\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">AVG_SPACE</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=CHAIN_CNT\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Счётчик цепочек</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=AVG_ROW_LEN\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Средняя длина строки</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=AVG_SPACE_FREELIST_BLOCKS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">AVG SPACE FREELIST BLOCKS</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=NUM_FREELIST_BLOCKS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">NUM FREELIST BLOCKS</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=DEGREE\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">DEGREE</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=INSTANCES\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">INSTANCES</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=CACHE\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">CACHE</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=TABLE_LOCK\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">TABLE_LOCK</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=SAMPLE_SIZE\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">SAMPLE_SIZE</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=LAST_ANALYZED\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">Дата анализа</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=PARTITIONED\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">PARTITIONED</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=IOT_TYPE\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">IOT_TYPE</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=TEMPORARY\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">TEMPORARY</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=SECONDARY\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">SECONDARY</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=NESTED\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">NESTED</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=BUFFER_POOL\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">BUFFER_POOL</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=ROW_MOVEMENT\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">ROW_MOVEMENT</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=GLOBAL_STATS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">GLOBAL_STATS</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=USER_STATS\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">USER_STATS</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=DURATION\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">DURATION</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=SKIP_CORRUPT\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">SKIP_CORRUPT</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=MONITORING\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">MONITORING</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=CLUSTER_OWNER\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">CLUSTER_OWNER</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=DEPENDENCIES\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">DEPENDENCIES</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_objects_list_tables.cgi?order_field=COMPRESSION\&report_type=$pv{report_type}\&owner=$pv{owner}\&status=$pv{status}\&name_include=$pv{name_include}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\&isfirst=$pv{isfirst}\" TARGET=\"cont\">COMPRESSION</A></TD>
              </TR>" ;

# ,
   $count_rows = 0 ;
   while (my ($owner,$table_name,$tablespace_name,$cluster_name,$iot_name,$pct_free,$pct_used,$ini_trans,$max_trans,$initial_extent,$next_extent,$min_extents,$max_extents,$pct_increase,$freelists,$freelist_groups,$logging,$backed_up,$num_rows,$blocks,$empty_blocks,$avg_space,$chain_cnt,$avg_row_len,$avg_space_freelist_blocks,$num_freelist_blocks,$degree,$instances,$cache,$table_lock,$sample_size,$last_analyzed,$partitioned,$iot_type,$temporary,$secondary,$nested,$buffer_pool,$row_movement,$global_stats,$user_stats,$duration,$skip_corrupt,$monitoring,$cluster_owner,$dependencies,$compression) = $sth->fetchrow_array() ) {
         $count_rows += 1 ;
         if ( $owner eq "" ) { $owner = "&nbsp;" ; } if ( $table_name eq "" ) { $table_name = "&nbsp;" ; } if ( $tablespace_name eq "" ) { $tablespace_name = "&nbsp;" ; }
         if ( $cluster_name eq "" ) { $cluster_name = "&nbsp;" ; } if ( $iot_name eq "" ) { $iot_name = "&nbsp;" ; } if ( $pct_free eq "" ) { $pct_free = "&nbsp;" ; }
         if ( $pct_used eq "" ) { $pct_used = "&nbsp;" ; } if ( $ini_trans eq "" ) { $ini_trans = "&nbsp;" ; } if ( $max_trans eq "" ) { $max_trans = "&nbsp;" ; }
         if ( $initial_extent eq "" ) { $initial_extent = "&nbsp;" ; } if ( $next_extent eq "" ) { $next_extent = "&nbsp;" ; } if ( $min_extents eq "" ) { $min_extents = "&nbsp;" ; }
         if ( $max_extents eq "" ) { $max_extents = "&nbsp;" ; } if ( $pct_increase eq "" ) { $pct_increase = "&nbsp;" ; } if ( $freelists eq "" ) { $freelists = "&nbsp;" ; }
         if ( $freelist_groups eq "" ) { $freelist_groups = "&nbsp;" ; } if ( $logging eq "" ) { $logging = "&nbsp;" ; } if ( $backed_up eq "" ) { $backed_up = "&nbsp;" ; }
         if ( $num_rows eq "" ) { $num_rows = "&nbsp;" ; } if ( $blocks eq "" ) { $blocks = "&nbsp;" ; } if ( $empty_blocks eq "" ) { $empty_blocks = "&nbsp;" ; }
         if ( $avg_space eq "" ) { $avg_space = "&nbsp;" ; } if ( $chain_cnt eq "" ) { $chain_cnt = "&nbsp;" ; } if ( $avg_row_len eq "" ) { $avg_row_len = "&nbsp;" ; }
         if ( $avg_space_freelist_blocks eq "" ) { $avg_space_freelist_blocks = "&nbsp;" ; } if ( $num_freelist_blocks eq "" ) { $num_freelist_blocks = "&nbsp;" ; } if ( $degree eq "" ) { $degree = "&nbsp;" ; }
         if ( $instances eq "" ) { $instances = "&nbsp;" ; } if ( $cache eq "" ) { $cache = "&nbsp;" ; } if ( $table_lock eq "" ) { $table_lock = "&nbsp;" ; }
         if ( $sample_size eq "" ) { $sample_size = "&nbsp;" ; } if ( $last_analyzed eq "" ) { $last_analyzed = "&nbsp;" ; } $last_analyzed =~ s/\s/&nbsp;/ ; if ( $partitioned eq "" ) { $partitioned = "&nbsp;" ; }
         if ( $iot_type eq "" ) { $iot_type = "&nbsp;" ; } if ( $temporary eq "" ) { $temporary = "&nbsp;" ; } if ( $secondary eq "" ) { $secondary = "&nbsp;" ; }
         if ( $nested eq "" ) { $nested = "&nbsp;" ; } if ( $buffer_pool eq "" ) { $buffer_pool = "&nbsp;" ; } if ( $row_movement eq "" ) { $row_movement = "&nbsp;" ; }
         if ( $global_stats eq "" ) { $global_stats = "&nbsp;" ; } if ( $user_stats eq "" ) { $user_stats = "&nbsp;" ; } if ( $duration eq "" ) { $duration = "&nbsp;" ; }
         if ( $skip_corrupt eq "" ) { $skip_corrupt = "&nbsp;" ; } if ( $monitoring eq "" ) { $monitoring = "&nbsp;" ; } if ( $cluster_owner eq "" ) { $cluster_owner = "&nbsp;" ; }
         if ( $dependencies eq "" ) { $dependencies = "&nbsp;" ; } if ( $compression eq "" ) { $compression = "&nbsp;" ; }
         printf("<TR><TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                 </TR>\n",$owner,$table_name,$tablespace_name,$cluster_name,$iot_name,$pct_free,$pct_used,$ini_trans,$max_trans,$initial_extent,
                          $next_extent,$min_extents,$max_extents,$pct_increase,$freelists,$freelist_groups,$logging,$backed_up,$num_rows,$blocks,
                          $empty_blocks,$avg_space,$chain_cnt,$avg_row_len,$avg_space_freelist_blocks,$num_freelist_blocks,$degree,$instances,$cache,
                          $table_lock,$sample_size,$last_analyzed,$partitioned,$iot_type,$temporary,$secondary,$nested,$buffer_pool,$row_movement,
                          $global_stats,$user_stats,$duration,$skip_corrupt,$monitoring,$cluster_owner,$dependencies,$compression) ;
         }
   print "<TR><TD CLASS=\"SZDATA\">Итого</TD><TD CLASS=\"NUMDATA\" COLSPAN=\"46\">$count_rows</TD></TR>\n" ;
   print "</TABLE>" ;
   $sth->finish();
   $dbh->disconnect();
   print "</TD></TR></TABLE>" ;
   if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n$request\n" ; }
   }
else { print "</TD></TR></TABLE>" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
