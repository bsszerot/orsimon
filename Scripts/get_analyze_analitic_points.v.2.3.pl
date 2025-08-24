#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_system_stats_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_system_stats.cgi?order_field=NAME\" TARGET=\"cont\">Срез&nbsp;данных<BR>текущих&nbsp;или<BR>из Statspack+</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=NAME\" TARGET=\"cont\">Коллектор<BR>статистик<BR>экземпляра</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_analyze_analitic_points.cgi?order_field=CR_SNAP_ID\" TARGET=\"cont\">Основные<BR>аналитические<BR>показатели</A></TD>
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
$pv{order_field} = "CR_SNAP_ID" ;
&get_forms_param() ;

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
$ENV{NLS_DATE_FORMAT} = "YYYY-MM-DD H24:MI:SS" ;

print "Content-Type: text/html\n\n"; 
&print_html_head("Основные аналитические показатели") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_system_stats_navigation(3) ;

print "</TD><TD STYLE=\" padding: 0pt; height: 100%;\">
       <TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; height: 100%;\">
              <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none; height: 100%;\">&nbsp;</TD></TR>
       </TABLE>
       </TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"padding: 0pt;\">" ;

# это начало контейнерной таблицы контента
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">" ;
print "<TR><TD>" ;

# вывести форму выбора дополнительного фильтра отчета 
$is_incltype_single_checked = "" ; if ( $pv{incltype} eq "single" ) { $is_incltype_single_checked = "CHECKED" ; }
$is_incltype_group_checked = "" ; if ( $pv{incltype} eq "group" || $pv{incltype} eq "" ) { $is_incltype_group_checked = "CHECKED" ; }
$is_excltype_single_checked = "" ; if ( $pv{excltype} eq "single" ) { $is_excltype_single_checked = "CHECKED" ; }
$is_excltype_group_checked = "" ; if ( $pv{excltype} eq "group" || $pv{excltype} eq "" ) { $is_excltype_group_checked = "CHECKED" ; }

$is_snglinc_selected_all = "" ; if ( $pv{snglstatsinc} eq "all" || $pv{snglstatsinc} eq "" ) { $is_snglinc_selected_all = "CHECKED" ; }
$is_inc_selected_all = "" ; if ( $pv{statsinc} eq "all" || $pv{statsinc} eq "" ) { $is_inc_selected_all = "CHECKED" ; }
$is_snglexcl_selected_none = "" ; if ( $pv{snglstatsexcl} eq "none" || $pv{snglstatsexcl} eq "" ) { $is_snglexcl_selected_none = "CHECKED" ; }
$is_excl_selected_none = "" ; if ( $pv{statsexcl} eq "none" || $pv{statsexcl} eq "" ) { $is_excl_selected_none = "CHECKED" ; }
                                                                                                                                                            
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); $year += 1900 ; $mon += 1 ;
if ( $pv{from_range} eq "" ) { $pv{from_range} = "$year-$mon-$mday 00:00:00" ; }
if ( $pv{to_range} eq "" ) { $pv{to_range} = "$year-$mon-$mday $hour:$min:$sec" ; }

$is_selected_raw = "" ; if ( $pv{report_type} eq "raw" ) { $is_selected_raw = "SELECTED" ; }
$is_selected_perhours = "" ; if ( $pv{report_type} eq "perhours" ) { $is_selected_perhours = "SELECTED" ; }
$is_selected_perdays = "" ; if ( $pv{report_type} eq "perdays" ) { $is_selected_perdays = "SELECTED" ; }
$is_selected_permonths = "" ; if ( $pv{report_type} eq "permonths" ) { $is_selected_permonths = "SELECTED" ; }

@statistics_group_keys_nosort = keys %statistics_group_members ; @statistics_group_keys = sort(@statistics_group_keys_nosort) ;
# получить хэш статистик с их ID и именем
my $extdbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
$req_stats_list = 'select STATISTIC# id_stat, NAME from v$statname ORDER BY NAME' ;
my $extsth = $extdbh->prepare($req_stats_list) ; $extsth->execute();
$i = 0 ; while (my ($stat_id,$name) = $extsth->fetchrow_array() ) { $stats_name_list[$i] = $name ; $i++ ; $stats_list_id{$name} = $stat_id ; }
$extsth->finish(); $extdbh->disconnect();                                        

print "<FORM ACTION=\"$base_url/cgi/get_analyze_analitic_points.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --</DIV></TD></TR> " ;
#&print_select_data_source() ;
print "<TR><TD>&nbsp;Диапазон выборки: </TD>
           <TD STYLE=\"width: 75%\">с&nbsp;<INPUT TYPE=\"input\" NAME=\"from_range\" VALUE=\"$pv{from_range}\">
               по&nbsp;<INPUT TYPE=\"input\" NAME=\"to_range\" VALUE=\"$pv{to_range}\">&nbsp;формат \"YYYY-MM-DD HH24:MI:SS\"
               <BR>с&nbsp;<INPUT TYPE=\"input\" NAME=\"from_snap\" VALUE=\"$pv{from_snap}\">
               по&nbsp;<INPUT TYPE=\"input\" NAME=\"to_snap\" VALUE=\"$pv{to_snap}\">&nbsp;дополнительный фильтр \"SNAP ID\"</TD></TR>" ;

#       <TR><TD>&nbsp;Группировка: </TD>
#           <TD STYLE=\"width: 75%\">
#               <SELECT NAME=\"report_type\" STYLE=\"width: 100%\" VALUE=\"$report_type\">
#               <OPTION VALUE=\"raw\" $is_selected_raw>Записи коллектора статистик без обработки</OPTION>
#               <OPTION VALUE=\"perhours\" $is_selected_perhours>Часовая группировка</OPTION>
#               <OPTION VALUE=\"perdays\" $is_selected_perdays>Дневная группировка</OPTION>
#               <OPTION VALUE=\"permonths\" $is_selected_permonths>Месячная группировка</OPTION>
#               </SELECT></TD></TR>

print "<INPUT TYPE=\"hidden\" NAME=\"order_field\" VALUE=\"$pv{order_field}\"><INPUT TYPE=\"hidden\" NAME=\"is_second\" VALUE=\"yes\">
       <INPUT TYPE=\"hidden\" NAME=\"is_view_sources\" VALUE=\"$pv{is_view_sources}\"></TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

if ( $pv{is_second} eq "yes" ) {
# - сформировать уточняющие фильтры для запроса статистики
   $where_term = "" ; 
   if ( $pv{incltype} eq "group" && $pv{statsinc} ne "all" && $pv{statsinc} ne "" ) { $where_term = " AND sn.NAME IN ($statistics_group_members{$pv{statsinc}}) " ; }
   if ( $pv{incltype} eq "single" && $pv{snglstatsinc} ne "all" && $pv{snglstatsinc} ne "" ) { $where_term = ' AND ss.STATISTIC# = ' . "'$pv{snglstatsinc}' " ; }
   if ( $pv{excltype} eq "group" && $pv{statsexcl} ne "none" && $pv{statsexcl} ne "" ) { $where_term .= " AND sn.NAME NOT IN ($statistics_group_members{$pv{statsexcl}}) " ; } 
   if ( $pv{excltype} eq "single" && $pv{snglstatsexcl} ne "none" && $pv{snglstatsexcl} ne "" ) { $where_term .= ' AND ss.STATISTIC# <> ' . "$pv{snglstatsexcl} " ; }
   if ( $pv{from_snap} ne "" && $pv{to_snap} ne "" ) { $where_term .= " AND ss.CR_SNAP_ID >= $pv{from_snap} AND ss.CR_SNAP_ID <= $pv{to_snap} " ; }
                                                                                                                                                            
   if ( $pv{report_type} eq "raw" ) {                                                                                                                       
      $request = "SELECT POINT_ID,SNAP_LEVEL,CR_SNAP_ID,TO_CHAR(CR_SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),PR_SNAP_ID,
                         TO_CHAR(PR_SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),CPU_USED_BTSES,PARSE_TIME_CPU,PARSE_TIME_ELAPSED,
                         PARSE_COUNT_TOTAL,PARSE_COUNT_HARD,LIBCACHE_DIFF_GETS,LIBCACHE_DIFF_GETHITS,LIBCACHE_DIFF_PINS,LIBCACHE_DIFF_PINHITS,
                         LIBCACHE_DIFF_RELOADS,LIBCACHE_DIFF_INVALIDT,EXECUTE_COUNT,USER_CALLS,USER_COMMITS,USER_ROLLBACKS,SUM_TRANS_COUNT,SUM_UNDOBLOCKS,
                         AVG_UNDOBLOCKS,MAX_UNDOBLOCKS,MAX_TRANS_TIMELEN,MAX_CONCURRENCY,PHYSICAL_READS,PHYSICAL_RD_DIRECT,PHYSICAL_RD_DIRLOB,
                         PHYSCL_RD_INTO_BFCACHE,PHYSICAL_WRITES,DB_BLOCK_GETS,CONSISTENT_GETS,SESSION_LOGICAL_READS,DB_BLOCK_CHANGES,FREE_BUFFER_WAIT,
                         WRITE_COMPLETE_WAIT,BUFFER_BUSY_WAIT,REDO_BUFF_ALLOC_ENTR,REDO_SIZE,REDOLOG_AVG_PERMIN,REDOLOG_MAX_PERMIN,ARCHIVE_LOG_SIZE,
                         FREEMEM_SHPL_START,FREEMEM_SHPL_END,SHPOOL_REQUEST_MISSES,SHPOOL_REQUEST_FAIL,DIC_DIFF_GETS,DIC_DIFF_GETMISSES,
                         DIC_DIFF_MODIFICATIONS,DIC_DIFF_FLUSHES,SORTS_MEMORY,SORTS_DISK,SORTS_OPTIMAL,SORTS_ONEPASS,SORTS_MULTIPASS,GET_FROM_SQLNET,
                         SEND_TO_SQLNET,PERIOD,LOGONS 
                         FROM CLC_ANALITICA_POINTS
                         WHERE CR_SNAP_TIME <= TO_DATE('$pv{to_range}','YYYY-MM-DD HH24:MI:SS') AND
                               CR_SNAP_TIME >= TO_DATE('$pv{from_range}','YYYY-MM-DD HH24:MI:SS') 
                         ORDER BY $pv{order_field} " ;
      }
   else {
      $group_string = "" ;
      if ( $pv{report_type} eq "perhours" ) { $group_string = "YYYY-MM-DD HH24" ; }
      if ( $pv{report_type} eq "perdays" ) { $group_string = "YYYY-MM-DD" ; }
      if ( $pv{report_type} eq "permonths" ) { $group_string = "YYYY-MM" ; }

      $request = "SELECT POINT_ID,SNAP_LEVEL,CR_SNAP_ID,TO_CHAR(CR_SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),PR_SNAP_ID,
                         TO_CHAR(PR_SNAP_TIME,'YYYY-MM-DD HH24:MI:SS'),CPU_USED_BTSES,PARSE_TIME_CPU,PARSE_TIME_ELAPSED,
                         PARSE_COUNT_TOTAL,PARSE_COUNT_HARD,LIBCACHE_DIFF_GETS,LIBCACHE_DIFF_GETHITS,LIBCACHE_DIFF_PINS,LIBCACHE_DIFF_PINHITS,
                         LIBCACHE_DIFF_RELOADS,LIBCACHE_DIFF_INVALIDT,EXECUTE_COUNT,USER_CALLS,USER_COMMITS,USER_ROLLBACKS,SUM_TRANS_COUNT,SUM_UNDOBLOCKS,
                         AVG_UNDOBLOCKS,MAX_UNDOBLOCKS,MAX_TRANS_TIMELEN,MAX_CONCURRENCY,PHYSICAL_READS,PHYSICAL_RD_DIRECT,PHYSICAL_RD_DIRLOB,
                         PHYSCL_RD_INTO_BFCACHE,PHYSICAL_WRITES,DB_BLOCK_GETS,CONSISTENT_GETS,SESSION_LOGICAL_READS,DB_BLOCK_CHANGES,FREE_BUFFER_WAIT,
                         WRITE_COMPLETE_WAIT,BUFFER_BUSY_WAIT,REDO_BUFF_ALLOC_ENTR,REDO_SIZE,REDOLOG_AVG_PERMIN,REDOLOG_MAX_PERMIN,ARCHIVE_LOG_SIZE,
                         FREEMEM_SHPL_START,FREEMEM_SHPL_END,SHPOOL_REQUEST_MISSES,SHPOOL_REQUEST_FAIL,DIC_DIFF_GETS,DIC_DIFF_GETMISSES,
                         DIC_DIFF_MODIFICATIONS,DIC_DIFF_FLUSHES,SORTS_MEMORY,SORTS_DISK,SORTS_OPTIMAL,SORTS_ONEPASS,SORTS_MULTIPASS,GET_FROM_SQLNET,
                         SEND_TO_SQLNET,PERIOD,LOGONS 
                         FROM CLC_ANALITICA_POINTS
                         WHERE CR_SNAP_TIME <= TO_DATE('$pv{to_range}','YYYY-MM-DD HH24:MI:SS') AND
                               CR_SNAP_TIME >= TO_DATE('$pv{from_range}','YYYY-MM-DD HH24:MI:SS') 
                         ORDER BY $pv{order_field} " ;
      }                                                                                                                                                     

#print "<BR>$request<BR>" ;

#   if ( $pv{srcptr} eq "0" || $pv{srcptr} eq "" ) { 
#$request = 'select ss.STATISTIC# id_stat,ss.NAME,sn.CLASS,ss.VALUE 
# from v$sysstat ss, v$statname sn WHERE ss.STATISTIC# = sn.STATISTIC# ' . $where_term . " order by $pv{order_field} asc" ; }
#   else { $request = 'select ss.STATISTIC#,ss.NAME,sn.CLASS,ss.VALUE from STATS$SYSSTAT ss, v$statname sn WHERE  ss.STATISTIC# = sn.STATISTIC# AND SNAP_ID = ' . "$pv{srcptr} " . $where_term . " order by $pv{order_field} asc" ; }

   my $sth = $dbh->prepare($request) ; $sth->execute() ;
   print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
   print "<TR>
          <TD CLASS=\"HEAD\" ROWSPAN=\"2\">ID объекта контроля (POINT ID)</TD>
          <TD CLASS=\"HEAD\" ROWSPAN=\"2\">Уровень детализации среза</TD>
          <TD CLASS=\"HEAD\" ROWSPAN=\"2\">ID текущего среза</TD>
          <TD CLASS=\"HEAD\" ROWSPAN=\"2\">Дата текущего среза</TD>
          <TD CLASS=\"HEAD\" ROWSPAN=\"2\">ID предыдущего среза</TD>
          <TD CLASS=\"HEAD\" ROWSPAN=\"2\">Дата предыдущего среза</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"3\">Утилизация CPU, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"4\">Обработки SQL запросов, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"10\">Библиотечный кэш, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"10\">Транзакции и UNDO, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"5\">Физический ввод/вывод, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"5\">Логический ввод/вывод, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"5\">Утилизация кэша буферов, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"2\">Буфер оперативных журналов, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"3\">Ввод/вывод оперативные журналы, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"2\">Ввод/вывод архивных журналов, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"2\">Свободная память в shared pool</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"2\">Резервный пул, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"5\">Кэш словаря, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"8\">Сортировки, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"2\">Сетевой ввод/ввод, за период</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"2\">Временные табличные пространства</TD>
          <TD CLASS=\"HEAD\" COLSPAN=\"2\">Дополнительно, за период</TD>
          </TR>" ;

# - вывести информацию использования CPU
   print "<TR><TD CLASS=\"HEAD\">CPU использовано сессиями</TD>
              <TD CLASS=\"HEAD\">CPU разборов (чистое)</TD>
              <TD CLASS=\"HEAD\">CPU разборов с ожиданиями</TD>" ;

# - вывести информацию по разборам SQL
   print "    <TD CLASS=\"HEAD\">Разборов всего</TD>
              <TD CLASS=\"HEAD\">Разборов полных</TD>
              <TD CLASS=\"HEAD\">Вес мягких разборов</TD>
              <TD CLASS=\"HEAD\">Вес ожиданий при разборах</TD>" ;

# - вывести информацию по утилизации библиотечного кэша
   print "    <TD CLASS=\"HEAD\">Запросов GETS</TD>
              <TD CLASS=\"HEAD\">Попаданий GETS</TD>
              <TD CLASS=\"HEAD\">Коэффициент попадания GETS</TD>
              <TD CLASS=\"HEAD\">Запросов PINS</TD>
              <TD CLASS=\"HEAD\">Попаданий PINS</TD>
              <TD CLASS=\"HEAD\">Коэффициент попадания PINS</TD>
              <TD CLASS=\"HEAD\">Перезагрузок</TD>
              <TD CLASS=\"HEAD\">Перезагрузок, % от GETS</TD>
              <TD CLASS=\"HEAD\">Инвалидаций</TD>
              <TD CLASS=\"HEAD\">Инвалидаций, % от GETS</TD>" ;

# транзакции и UNDO
   print "    <TD CLASS=\"HEAD\">Всего вызовов пользовательских и рекурсивных</TD>
              <TD CLASS=\"HEAD\">Пользовательских вызовов</TD>
              <TD CLASS=\"HEAD\">Пользовательских COMMITS</TD>
              <TD CLASS=\"HEAD\">Пользовательских ROLLBACKS</TD>
              <TD CLASS=\"HEAD\">Транзакций всего</TD>
              <TD CLASS=\"HEAD\">Блоков UNDO, всего</TD>
              <TD CLASS=\"HEAD\">Скорость генерации UNDO средняя, блоков в минуту</TD>
              <TD CLASS=\"HEAD\">Скорость генерации UNDO максимальная, блоков в минуту</TD>
              <TD CLASS=\"HEAD\">Длительность инспользования курсора максимальная, секунд</TD>
              <TD CLASS=\"HEAD\">Конкурировавших транзакций максимально</TD>" ;

# - вывести информацию по физическому вводу/выводу
   print "    <TD CLASS=\"HEAD\">Физических чтений всего</TD>
              <TD CLASS=\"HEAD\">Физических чтений прямых</TD>
              <TD CLASS=\"HEAD\">Физических чтений LOB прямых</TD>
              <TD CLASS=\"HEAD\">Физических чтений в кэш буферов</TD>
              <TD CLASS=\"HEAD\">Физических записей</TD>" ;

# - вывести информацию по логическому вводу/выводу
   print "    <TD CLASS=\"HEAD\">db block gets</TD>
              <TD CLASS=\"HEAD\">consistent gets</TD>
              <TD CLASS=\"HEAD\">session logical reads</TD>
              <TD CLASS=\"HEAD\">консистентных чтений, %</TD>
              <TD CLASS=\"HEAD\">db block changes</TD>" ;

# - вывести информацию по утилизации кэша буферов
   print "    <TD CLASS=\"HEAD\">Коэффициент попадания в кэш буферов</TD>
              <TD CLASS=\"HEAD\">Логических чтений (контроль)</TD>
              <TD CLASS=\"HEAD\">FREE BUFFER WAIT</TD>
              <TD CLASS=\"HEAD\">WRITE COMPLETE WAIT</TD>
              <TD CLASS=\"HEAD\">BUFFER BUSY WAIT</TD>" ;

# - вывести информацию по утилизации буфера оперативных журналов
   print "    <TD CLASS=\"HEAD\">redo buffer allocation retries</TD>
              <TD CLASS=\"HEAD\">---</TD>" ;

# - вывести информацию по вводу/выводу оперативных журналов
   print "    <TD CLASS=\"HEAD\">REDO size</TD>
              <TD CLASS=\"HEAD\">Скорость роста средняя в минуту</TD>
              <TD CLASS=\"HEAD\">Скорость роста максимальная в минуту</TD>" ;

# - вывести информацию по вводу/выводу архивных журналов
   print "    <TD CLASS=\"HEAD\">Размер архивной информации, байт</TD>
              <TD CLASS=\"HEAD\">---</TD>" ;

# - вывести информацию по утилизации shared pool
   print "    <TD CLASS=\"HEAD\">Свободная память на начало периода</TD>
              <TD CLASS=\"HEAD\">Свободная память на конец периода</TD>" ;

# - вывести информацию по утилизации резервного пула
   print "    <TD CLASS=\"HEAD\">request misses</TD>
              <TD CLASS=\"HEAD\">request failures</TD>" ;

# - вывести информацию по утилизации кэша словаря
   print "    <TD CLASS=\"HEAD\">запросов (gets)</TD>
              <TD CLASS=\"HEAD\">промахов (misses)</TD>
              <TD CLASS=\"HEAD\">коэффициент попаданий</TD>
              <TD CLASS=\"HEAD\">модификаций</TD>
              <TD CLASS=\"HEAD\">сбросов на диск</TD>" ;

# - вывести информацию по утилизации PGA
   print "    <TD CLASS=\"HEAD\">Сортировок всего</TD>
              <TD CLASS=\"HEAD\">Сортировок дисковых</TD>
              <TD CLASS=\"HEAD\">Вес дисковых сортировок session</TD>
              <TD CLASS=\"HEAD\">Сортировок оптимальных</TD>
              <TD CLASS=\"HEAD\">Сортировок однопроходных</TD>
              <TD CLASS=\"HEAD\">Вес однопроходных сортировок</TD>
              <TD CLASS=\"HEAD\">Сортировок многопроходных</TD>
              <TD CLASS=\"HEAD\">Вес многопроходных сортировок</TD>" ;

# - вывести информацию по сетевому вводу/выводу
   print "    <TD CLASS=\"HEAD\">Принято через SQLNet, байт</TD>
              <TD CLASS=\"HEAD\">Отдано через SQLNet, байт</TD>" ;

# - вывести информацию по временным табличным пространствам
   print "    <TD CLASS=\"HEAD\">---</TD>
              <TD CLASS=\"HEAD\">---</TD>" ;

# - вывести информацию по дополнительным параметрам
   print "    <TD CLASS=\"HEAD\">Длительность периода, микросекунд</TD>
              <TD CLASS=\"HEAD\">Пользовательских LOGONS, раз</TD>" ;
   
   $system_stat_count_all = 0 ;
   while (my ( $POINT_ID,$SNAP_LEVEL,$CR_SNAP_ID,$CR_SNAP_TIME,$PR_SNAP_ID,$PR_SNAP_TIME,$CPU_USED_BTSES,$PARSE_TIME_CPU,$PARSE_TIME_ELAPSED,
                         $PARSE_COUNT_TOTAL,$PARSE_COUNT_HARD,$LIBCACHE_DIFF_GETS,$LIBCACHE_DIFF_GETHITS,$LIBCACHE_DIFF_PINS,$LIBCACHE_DIFF_PINHITS,
                         $LIBCACHE_DIFF_RELOADS,$LIBCACHE_DIFF_INVALIDT,$EXECUTE_COUNT,$USER_CALLS,$USER_COMMITS,$USER_ROLLBACKS,$SUM_TRANS_COUNT,
                         $SUM_UNDOBLOCKS,$AVG_UNDOBLOCKS,$MAX_UNDOBLOCKS,$MAX_TRANS_TIMELEN,$MAX_CONCURRENCY,$PHYSICAL_READS,$PHYSICAL_RD_DIRECT,
                         $PHYSICAL_RD_DIRLOB,$PHYSCL_RD_INTO_BFCACHE,$PHYSICAL_WRITES,$DB_BLOCK_GETS,$CONSISTENT_GETS,$SESSION_LOGICAL_READS,
                         $DB_BLOCK_CHANGES,$FREE_BUFFER_WAIT,$WRITE_COMPLETE_WAIT,$BUFFER_BUSY_WAIT,$REDO_BUFF_ALLOC_ENTR,$REDO_SIZE,$REDOLOG_AVG_PERMIN,
                         $REDOLOG_MAX_PERMIN,$ARCHIVE_LOG_SIZE,$FREEMEM_SHPL_START,$FREEMEM_SHPL_END,$SHPOOL_REQUEST_MISSES,$SHPOOL_REQUEST_FAIL,
                         $DIC_DIFF_GETS,$DIC_DIFF_GETMISSES,$DIC_DIFF_MODIFICATIONS,$DIC_DIFF_FLUSHES,$SORTS_MEMORY,$SORTS_DISK,$SORTS_OPTIMAL,
                         $SORTS_ONEPASS,$SORTS_MULTIPASS,$GET_FROM_SQLNET,$SEND_TO_SQLNET,$PERIOD,$LOGONS ) = $sth->fetchrow_array() ) {

         printf("<TR>") ;
# ------ вывести общие показатели
         $CR_SNAP_TIME =~ s/\s/&nbsp;/g ; $PR_SNAP_TIME =~ s/\s/&nbsp;/g ;
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"SZDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"SZDATA\">%s</TD>", 
                 $POINT_ID,$SNAP_LEVEL,&show_razryads($CR_SNAP_ID),$CR_SNAP_TIME,&show_razryads($PR_SNAP_ID),$PR_SNAP_TIME ) ;

# ------ вывести показатели CPU
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($CPU_USED_BTSES),&show_razryads($PARSE_TIME_CPU),&show_razryads($PARSE_TIME_ELAPSED)) ;


# ------ вывести показатели разборов SQL
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%0.2f</TD>
                 <TD CLASS=\"NUMDATA\">%0.2f</TD>",
                 &show_razryads($PARSE_COUNT_TOTAL),&show_razryads($PARSE_COUNT_HARD),($PARSE_COUNT_TOTAL - $PARSE_COUNT_HARD)*100/($PARSE_COUNT_TOTAL+0.0000001),
                 ($PARSE_TIME_ELAPSED-$PARSE_TIME_CPU)*100/($PARSE_TIME_ELAPSED+0.0000001)) ;

# ------ вывести показатели библиотечного кеша
         printf("<TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику библиотечного кеша\" CLASS=\"NUMDATA\">%s</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику библиотечного кеша\" CLASS=\"NUMDATA\">%s</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику библиотечного кеша\" CLASS=\"NUMDATA\">%0.2f</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику библиотечного кеша\" CLASS=\"NUMDATA\">%s</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику библиотечного кеша\" CLASS=\"NUMDATA\">%s</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику библиотечного кеша\" CLASS=\"NUMDATA\">%0.2f</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику библиотечного кеша\" CLASS=\"NUMDATA\">%s</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику библиотечного кеша\" CLASS=\"NUMDATA\">%0.2f</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику библиотечного кеша\" CLASS=\"NUMDATA\">%s</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику библиотечного кеша\" CLASS=\"NUMDATA\">%0.2f</TD>",
                 &show_razryads($LIBCACHE_DIFF_GETS),&show_razryads($LIBCACHE_DIFF_GETHITS),$LIBCACHE_DIFF_GETHITS*100/($LIBCACHE_DIFF_GETS+0.0000001),
                 &show_razryads($LIBCACHE_DIFF_PINS),&show_razryads($LIBCACHE_DIFF_PINHITS),$LIBCACHE_DIFF_PINHITS*100/($LIBCACHE_DIFF_PINS+0.0000001),
                 &show_razryads($LIBCACHE_DIFF_RELOADS),$LIBCACHE_DIFF_RELOADS*100/$LIBCACHE_DIFF_GETS,&show_razryads($LIBCACHE_DIFF_INVALIDT),
                 $LIBCACHE_DIFF_INVALIDT*100/$LIBCACHE_DIFF_GETS) ;

# ------ вывести показатели транзакций и UNDO
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($EXECUTE_COUNT),&show_razryads($USER_CALLS),&show_razryads($USER_COMMITS),&show_razryads($USER_ROLLBACKS),
                 &show_razryads($SUM_TRANS_COUNT),&show_razryads($SUM_UNDOBLOCKS),$AVG_UNDOBLOCKS,&show_razryads($MAX_UNDOBLOCKS),
                 &show_razryads($MAX_TRANS_TIMELEN),&show_razryads($MAX_CONCURRENCY)) ;

# ------ вывести показатели физического ввода/вывода
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($PHYSICAL_READS),&show_razryads($PHYSICAL_RD_DIRECT),&show_razryads($PHYSICAL_RD_DIRLOB),
                 &show_razryads($PHYSCL_RD_INTO_BFCACHE),&show_razryads($PHYSICAL_WRITES)) ;

# ------ вывести показатели логического ввода/вывода
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%0.2f</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($DB_BLOCK_GETS),&show_razryads($CONSISTENT_GETS),&show_razryads($SESSION_LOGICAL_READS),
                 $CONSISTENT_GETS*100/$SESSION_LOGICAL_READS,&show_razryads($DB_BLOCK_CHANGES)) ;

# ------ вывести показатели кэша буферов
         printf("<TD CLASS=\"NUMDATA\">%0.2f</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 ( 100 - ( $PHYSCL_RD_INTO_BFCACHE * 100 / $SESSION_LOGICAL_READS )),
                 &show_razryads($DB_BLOCK_GETS + $CONSISTENT_GETS), &show_razryads($DB_BLOCK_GETS),&show_razryads($CONSISTENT_GETS),
                 &show_razryads($FREE_BUFFER_WAIT),&show_razryads($WRITE_COMPLETE_WAIT),&show_razryads($BUFFER_BUSY_WAIT)) ;
#                 (1 - (($PHYSICAL_READS - $PHYSICAL_RD_DIRECT - $PHYSICAL_RD_DIRLOB) / ($DB_BLOCK_GETS + $CONSISTENT_GETS - $PHYSICAL_RD_DIRECT - $PHYSICAL_RD_DIRLOB + 1))) * 100,

# ------ вывести показатели буфера операьтвных журналов
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($REDO_BUFF_ALLOC_ENTR), "&nbsp;") ;

# ------ вывести показатели оперативных журналов
# - !!! выверить? почему то средняя больше максимальной!!!
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($REDO_SIZE),&show_razryads($REDOLOG_AVG_PERMIN/1),&show_razryads($REDOLOG_MAX_PERMIN/1)) ;

# ------ вывести показатели архивных журналов
         if ( $ARCHIVE_LOG_SIZE eq "" ) { $ARCHIVE_LOG_SIZE = 0 ; }
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($ARCHIVE_LOG_SIZE), "&nbsp;") ;

# ------ вывести показатели свободной памяти shared pool
         if ( $ARCHIVE_LOG_SIZE eq "" ) { $ARCHIVE_LOG_SIZE = 0 ; }
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($FREEMEM_SHPL_START),&show_razryads($FREEMEM_SHPL_END)) ;

# ------ вывести показатели резервного пула
         if ( $ARCHIVE_LOG_SIZE eq "" ) { $ARCHIVE_LOG_SIZE = 0 ; }
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($SHPOOL_REQUEST_MISSES),&show_razryads($SHPOOL_REQUEST_FAIL)) ;

# ------ вывести показатели кэша словаря
         $dic_tmp1 = $DIC_DIFF_GETS ; if ( "$DIC_DIFF_GETS" eq "0" || "$DIC_DIFF_GETS" eq "" ) { $dic_tmp1 = 1 ; }
         printf("<TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику кеша словаря\" CLASS=\"NUMDATA\">%s</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику кеша словаря\" CLASS=\"NUMDATA\">%s</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику кеша словаря\" CLASS=\"NUMDATA\">%0.2f</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику кеша словаря\" CLASS=\"NUMDATA\">%s</TD>
                 <TD TITLE=\"сигнальный/суммарный показатель, для детализации смотри статистику кеша словаря\" CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($DIC_DIFF_GETS),&show_razryads($DIC_DIFF_GETMISSES),100-($DIC_DIFF_GETMISSES*100/$dic_tmp1),
                 &show_razryads($DIC_DIFF_MODIFICATIONS),&show_razryads($DIC_DIFF_FLUSHES)) ;

# ------ вывести показатели PGA
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%0.2f</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($SORTS_MEMORY),&show_razryads($SORTS_DISK),$SORTS_DISK*100/($SORTS_MEMORY+$SORTS_DISK+0.0001),
                 &show_razryads($SORTS_OPTIMAL),
                 &show_razryads($SORTS_ONEPASS),$SORTS_ONEPASS*100/($SORTS_OPTIMAL+$SORTS_ONEPASS+$SORTS_MULTIPASS+0.0001),
                 &show_razryads($SORTS_MULTIPASS),$SORTS_MULTIPASS*100/($SORTS_OPTIMAL+$SORTS_ONEPASS+$SORTS_MULTIPASS+0.0001)) ;

# ------ вывести показатели сетевого ввода/вывода
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($GET_FROM_SQLNET),&show_razryads($SEND_TO_SQLNET)) ;

# ------ вывести показатели временных табличных пространств
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 "&nbsp;","&nbsp;") ;

# ------ вывести показатели дополнительных счётчиков
         printf("<TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"NUMDATA\">%s</TD>",
                 &show_razryads($PERIOD),&show_razryads($LOGONS)) ;

         print("</TR>\n") ;
         }
   print "</TABLE>" ;
   $sth->finish();
   }
# это конец контейнерной таблицы контента
print "</TD></TR></TABLE>" ;

# это конец общей контейнерной таблицы
print "</TD></TR></TABLE>" ;

#$sth->finish();
$dbh->disconnect();                                        

if ( $is_view_request eq "yes" && $pv{is_second} eq "yes"  ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n<P>$request</P>\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
