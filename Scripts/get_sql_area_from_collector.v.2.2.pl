#!/usr/bin/perl 

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_sqlarea_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ADDRESS\" TARGET=\"cont\">Срезы<BR>данных<BR>SQLAREA</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_area_from_collector.cgi?order_field=CR_SQL_ID\" TARGET=\"cont\">Коллектор<BR>SQLAREA</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ADDRESS\" TARGET=\"cont\">Аналитика<BR>ТОПов<BR>SQLAREA</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ADDRESS\" TARGET=\"cont\">Срезы<BR>планов&nbsp;SQL<BR>запросов</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{5}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_cursors_info.cgi?order_field=s.ADDRESS\" TARGET=\"cont\">Срезы<BR>курсоров</A></TD>
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
    $req_exsist_slaces_obj = "SELECT COUNT(*) from DBA_OBJECTS WHERE OBJECT_NAME = 'BESTAT_COLLECTOR_POINTS' AND OBJECT_TYPE = 'TABLE' " ;
    my $slices_sth = $slices_dbh->prepare($req_exsist_slaces_obj) ; $slices_sth->execute() ; my ($exsist_slaces_obj_count) = $slices_sth->fetchrow_array() ;
    if ( $exsist_slaces_obj_count > 0 ) {
       $req_slaces_list = "SELECT POINT_ID,STAT_RANGE_ID,POINT_TYPE,TO_CHAR(STAMP_RECORD,'YYYY-MM-DD HH24:MI:SS') FROM BESTAT_COLLECTOR_POINTS WHERE POINT_TYPE = 'OPS' ORDER BY POINT_ID" ;
       my $slices_sth = $slices_dbh->prepare($req_slaces_list) ; $slices_sth->execute() ;
       while (my ($point_id,$stat_range_id,$point_type,$stamp_record) = $slices_sth->fetchrow_array() ) { 
             $is_source_current = "" ; if ( $pv{srcptr} eq "$point_id" ) { $is_source_current = "SELECTED" ; } 
             printf("<OPTION VALUE=\"%s\" %s>BESTAT snap %07d, stat_range %07d, type %s, от %s</OPTION>",$point_id,$is_source_current,$point_id,$stat_range_id,$point_type,$stamp_record) ; 
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
&get_forms_param() ;
if ( $pv{scope_num} == "" ) { $pv{scope_num} = "15" ; } 
if ( $pv{order_field} eq "" ) { $pv{order_field} = "s.CPU_TIMES" ; }

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
                                 
print "Content-Type: text/html\n\n"; 
&print_html_head("Коллектор SQLAREA") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_sqlarea_navigation(2) ;

print "</TD><TD STYLE=\" padding: 0pt; height: 100%;\">
       <TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; height: 100%;\">
              <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none; height: 100%;\">&nbsp;</TD></TR>
       </TABLE>
       </TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"padding: 0pt;\">" ;

# это начало контейнерной таблицы контента
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">" ;
print "<TR><TD>" ;

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); $year += 1900 ; $mon += 1 ;
if ( $pv{from_range} eq "" ) { $pv{from_range} = "$year-$mon-$mday 00:00:00" ; }
if ( $pv{to_range} eq "" ) { $pv{to_range} = "$year-$mon-$mday $hour:$min:$sec" ; }
$is_selected_raw = "" ; if ( $pv{report_type} eq "raw" ||  $pv{report_type} eq "" ) { $is_selected_raw = "SELECTED" ; }
$is_selected_perhours = "" ; if ( $pv{report_type} eq "perhours" ) { $is_selected_perhours = "SELECTED" ; }
$is_selected_perdays = "" ; if ( $pv{report_type} eq "perdays" ) { $is_selected_perdays = "SELECTED" ; }
$is_selected_permonths = "" ; if ( $pv{report_type} eq "permonths" ) { $is_selected_permonths = "SELECTED" ; }
# вывести форму выбора дополнительного фильтра отчета
print "<FORM ACTION=\"$base_url/cgi/get_sql_area_from_collector.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
print "<TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --</DIV></TD></TR>" ;
print "<TR><TD>&nbsp;Диапазон выборки: </TD>
           <TD STYLE=\"width: 75%\">с&nbsp;<INPUT TYPE=\"input\" NAME=\"from_range\" VALUE=\"$pv{from_range}\">
               по&nbsp;<INPUT TYPE=\"input\" NAME=\"to_range\" VALUE=\"$pv{to_range}\">&nbsp;формат \"YYYY-MM-DD HH24:MI:SS\"
               <BR>с&nbsp;<INPUT TYPE=\"input\" NAME=\"from_snap\" VALUE=\"$pv{from_snap}\">
               по&nbsp;<INPUT TYPE=\"input\" NAME=\"to_snap\" VALUE=\"$pv{to_snap}\">&nbsp;дополнительный фильтр \"POINT ID\"</TD></TR>
       <TR><TD>&nbsp;Группировка: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"report_type\" STYLE=\"width: 100%\" VALUE=\"$report_type\">
               <OPTION VALUE=\"raw\" $is_selected_raw>Записи коллектора статистик без обработки</OPTION>
               <OPTION VALUE=\"perhours\" $is_selected_perhours>Часовая группировка</OPTION>
               <OPTION VALUE=\"perdays\" $is_selected_perdays>Дневная группировка</OPTION>
               <OPTION VALUE=\"permonths\" $is_selected_permonths>Месячная группировка</OPTION>
               </SELECT></TD></TR>" ;
print "<TR><TD>&nbsp;Кол-во&nbsp;значений: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"scope_num\" VALUE=\"$pv{scope_num}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Первый&nbsp;пользователь: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"first_user\" VALUE=\"$pv{first_user}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Текущий&nbsp;SQL&nbsp;ID: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"sql_id\" VALUE=\"$pv{sql_id}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Текущий&nbsp;Hash&nbsp;плана: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"plan_hash_value\" VALUE=\"$pv{plan_hash_value}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Текущий&nbsp;Модуль LIKE: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"module_filter\" VALUE=\"$pv{module_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Текущее&nbsp;Действие LIKE: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"action_filter\" VALUE=\"$pv{action_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD COLSPAN=\"2\">
       <INPUT TYPE=\"hidden\" NAME=\"is_view_result\" VALUE=\"yes\">
       <INPUT TYPE=\"hidden\" NAME=\"order_field\" VALUE=\"$pv{order_field}\">
       <INPUT TYPE=\"hidden\" NAME=\"is_view_sources\" VALUE=\"$pv{is_view_sources}\"></TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR>";

if ( $pv{is_view_result} eq "yes" ) {
   print "<TR><TD>" ;
   $where_user = "" ; if ( $pv{first_user} ne "" ) { $where_user = "AND lu.USERNAME = '$pv{first_user}'" ; }
   $where_sql_id = "" ; if ( $pv{sql_id} ne "" ) { $where_user = "AND s.CR_SQL_ID = '$pv{sql_id}'" ; }
   $where_plan_hash_value = "" ; if ( $pv{plan_hash_value} ne "" ) { $where_user = "AND s.CR_PLAN_HASH_VALUE = '$pv{plan_hash_value}'" ; }
   $where_module = "" ; if ( $pv{module_filter} ne "" ) { $where_module = "AND s.MODULE LIKE '%$pv{module_filter}%'" ; }
   $where_action = "" ; if ( $pv{action_filter} ne "" ) { $where_action = "AND s.ACTION LIKE '%$pv{action_filter}%'" ; }
   $where_snap_range = "" ;if ( $pv{from_snap} ne "" && $pv{to_snap} ne "" ) { $where_snap_range .= " AND s.CR_POINT_ID >= $pv{from_snap} AND s.CR_POINT_ID <= $pv{to_snap} " ; }  

   if ( $pv{report_type} eq "raw" ) {
      $request = 'SELECT * FROM (select SUBSTR(sa.SQL_TEXT,1,64) SQL_TEXT, 
                         s.CR_POINT_ID CR_POINT_ID, TO_CHAR(s.CR_STAMP_RECORD,\'YYYY-MM-DD HH24:MI:SS\') CR_STAMP_RECORD,
                         s.PR_POINT_ID PR_POINT_ID, TO_CHAR(s.PR_STAMP_RECORD,\'YYYY-MM-DD HH24:MI:SS\') PR_STAMP_RECORD,
                         s.CR_SQL_ID CR_SQL_ID, s.PR_SQL_ID PR_SQL_ID, s.CR_PLAN_HASH_VALUE CR_PLAN_HASH_VALUE, s.PR_PLAN_HASH_VALUE PR_PLAN_HASH_VALUE,
                         lu.USERNAME PARSING_USER, s.CR_MODULE CR_MODULE, s.PR_MODULE PR_MODULE, s.CR_ACTION CR_ACTION, s.PR_ACTION PR_ACTION,
                         s.CR_CPU_TIME CR_CPU_TIME, s.PR_CPU_TIME PR_CPU_TIME, s.DIFF_CPU_TIME DIFF_CPU_TIME,
                           CASE WHEN s.DIFF_EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DIFF_CPU_TIME/s.DIFF_EXECUTIONS,2) END CPU_TIME_PER_EXEC,
                         s.CR_ELAPSED_TIME CR_ELAPSED_TIME, s.PR_ELAPSED_TIME PR_ELAPSED_TIME, s.DIFF_ELAPSED_TIME DIFF_ELAPSED_TIME,
                           CASE WHEN s.DIFF_EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DIFF_ELAPSED_TIME/s.DIFF_EXECUTIONS,2) END ELAPSED_TIME_PER_EXEC,
                         s.CR_PLSQL_EXEC_TIME CR_PLSQL_EXEC_TIME, s.PR_PLSQL_EXEC_TIME PR_PLSQL_EXEC_TIME, s.DIFF_PLSQL_EXEC_TIME DIFF_PLSQL_EXEC_TIME,
                           CASE WHEN s.DIFF_EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DIFF_PLSQL_EXEC_TIME/s.DIFF_EXECUTIONS,2) END PLSQL_TIME_PER_EXEC,
                         s.CR_JAVA_EXEC_TIME CR_JAVA_EXEC_TIME, s.PR_JAVA_EXEC_TIME PR_JAVA_EXEC_TIME, s.DIFF_JAVA_EXEC_TIME DIFF_JAVA_EXEC_TIME,
                           CASE WHEN s.DIFF_EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DIFF_JAVA_EXEC_TIME/s.DIFF_EXECUTIONS,2) END JAVA_TIME_PER_EXEC,
                         s.CR_SHARABLE_MEM CR_SHARABLE_MEM, s.PR_SHARABLE_MEM PR_SHARABLE_MEM, s.DIFF_SHARABLE_MEM DIFF_SHARABLE_MEM,
                         s.CR_PERSISTENT_MEM CR_PERSISTENT_MEM, s.PR_PERSISTENT_MEM PR_PERSISTENT_MEM, s.DIFF_PERSISTENT_MEM DIFF_PERSISTENT_MEM,
                         s.CR_RUNTIME_MEM CR_RUNTIME_MEM, s.PR_RUNTIME_MEM PR_RUNTIME_MEM, s.DIFF_RUNTIME_MEM DIFF_RUNTIME_MEM,
                         s.CR_DISK_READS CR_DISK_READS, s.PR_DISK_READS PR_DISK_READS, s.DIFF_DISK_READS DIFF_DISK_READS,
                           CASE WHEN s.DIFF_EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DIFF_DISK_READS/s.DIFF_EXECUTIONS,2) END DISK_READS_PER_EXEC,
                         s.CR_DIRECT_WRITES CR_DIRECT_WRITES, s.PR_DIRECT_WRITES PR_DIRECT_WRITES, s.DIFF_DIRECT_WRITES DIFF_DIRECT_WRITES,
                           CASE WHEN s.DIFF_EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DIFF_DIRECT_WRITES/s.DIFF_EXECUTIONS,2) END DIRECT_WRITES_PER_EXEC,
                         s.CR_BUFFER_GETS CR_BUFFER_GETS, s.PR_BUFFER_GETS PR_BUFFER_GETS, s.DIFF_BUFFER_GETS DIFF_BUFFER_GETS,
                           CASE WHEN s.DIFF_EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DIFF_BUFFER_GETS/s.DIFF_EXECUTIONS,2) END BUFFER_GETS_PER_EXEC,
                         s.CR_ROWS_PROCESSED CR_ROWS_PROCESSED, s.PR_ROWS_PROCESSED PR_ROWS_PROCESSED, s.DIFF_ROWS_PROCESSED DIFF_ROWS_PROCESSED,
                           CASE WHEN s.DIFF_EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DIFF_ROWS_PROCESSED/s.DIFF_EXECUTIONS,2) END ROWS_PROC_PER_EXEC,
                         s.CR_SORTS CR_SORTS, s.PR_SORTS PR_SORTS, s.DIFF_SORTS DIFF_SORTS,
                           CASE WHEN s.DIFF_EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DIFF_SORTS/s.DIFF_EXECUTIONS,2) END SORTS_PER_EXEC,
                         s.CR_LOADS CR_LOADS, s.PR_LOADS PR_LOADS, s.DIFF_LOADS DIFF_LOADS,
                         s.CR_INVALIDATIONS CR_INVALIDATIONS, s.PR_INVALIDATIONS PR_INVALIDATIONS, s.DIFF_INVALIDATIONS DIFF_INVALIDATIONS,
                         s.CR_USERS_OPENING CR_USERS_OPENING, s.PR_USERS_OPENING PR_USERS_OPENING, s.DIFF_USERS_OPENING DIFF_USERS_OPENING,
                         s.CR_PARSE_CALLS CR_PARSE_CALLS, s.PR_PARSE_CALLS PR_PARSE_CALLS, s.DIFF_PARSE_CALLS DIFF_PARSE_CALLS,
                         s.CR_EXECUTIONS CR_EXECUTIONS, s.PR_EXECUTIONS PR_EXECUTIONS, s.DIFF_EXECUTIONS DIFF_EXECUTIONS,
                         CASE WHEN s.DIFF_EXECUTIONS = 0 THEN 0 ELSE 100 - (s.DIFF_PARSE_CALLS * 100 / s.DIFF_EXECUTIONS ) END SOFT_PARSE,
                         s.CR_USERS_EXECUTING CR_USERS_EXECUTING, s.PR_USERS_EXECUTING PR_USERS_EXECUTING, s.DIFF_USERS_EXECUTING DIFF_USERS_EXECUTING,
                         s.CR_PX_SERVERS_EXECUTIONS CR_PX_SERVERS_EXECUTIONS, s.PR_PX_SERVERS_EXECUTIONS PR_PX_SERVERS_EXECUTIONS, s.DIFF_PX_SERVERS_EXECUTIONS DIFF_PX_SERVERS_EXECUTIONS,
                         s.CR_FETCHES CR_FETCHES, s.PR_FETCHES PR_FETCHES, s.DIFF_FETCHES DIFF_FETCHES,
                         s.CR_END_OF_FETCH_COUNT CR_END_OF_FETCH_COUNT, s.PR_END_OF_FETCH_COUNT PR_END_OF_FETCH_COUNT, s.DIFF_END_OF_FETCH_COUNT DIFF_END_OF_FETCH_COUNT,
                         s.CR_APPLICATION_WAIT_TIME CR_APPLICATION_WAIT_TIME, s.PR_APPLICATION_WAIT_TIME PR_APPLICATION_WAIT_TIME, s.DIFF_APPLICATION_WAIT_TIME DIFF_APPLICATION_WAIT_TIME,
                         s.CR_CONCURRENCY_WAIT_TIME CR_CONCURRENCY_WAIT_TIME, s.PR_CONCURRENCY_WAIT_TIME PR_CONCURRENCY_WAIT_TIME, s.DIFF_CONCURRENCY_WAIT_TIME DIFF_CONCURRENCY_WAIT_TIME,
                         s.CR_CLUSTER_WAIT_TIME CR_CLUSTER_WAIT_TIME, s.PR_CLUSTER_WAIT_TIME PR_CLUSTER_WAIT_TIME, s.DIFF_CLUSTER_WAIT_TIME DIFF_CLUSTER_WAIT_TIME,
                         s.CR_USER_IO_WAIT_TIME CR_USER_IO_WAIT_TIME, s.PR_USER_IO_WAIT_TIME PR_USER_IO_WAIT_TIME, s.DIFF_USER_IO_WAIT_TIME DIFF_USER_IO_WAIT_TIME,
                         s.CR_SERIALIZABLE_ABORTS CR_SERIALIZABLE_ABORTS, s.PR_SERIALIZABLE_ABORTS PR_SERIALIZABLE_ABORTS, s.DIFF_SERIALIZABLE_ABORTS DIFF_SERIALIZABLE_ABORTS,
                         s.CR_CHILD_LATCH CR_CHILD_LATCH, s.PR_CHILD_LATCH PR_CHILD_LATCH, s.DIFF_CHILD_LATCH DIFF_CHILD_LATCH,
                         s.CR_OPTIMIZER_COST,s.PR_OPTIMIZER_COST
                         FROM BESTAT_DELTA_SQLAREA s, dba_users lu, BESTAT_SQLAREA sa
                         WHERE s.CR_PARSING_USER_ID = lu.USER_ID AND s.CR_POINT_ID = sa.POINT_ID AND s.CR_SQL_ID = sa.SQL_ID AND 
                               s.CR_STAMP_RECORD <= TO_DATE(' . "'$pv{to_range}','YYYY-MM-DD HH24:MI:SS') AND
                               s.CR_STAMP_RECORD >= TO_DATE('$pv{from_range}','YYYY-MM-DD HH24:MI:SS')
                               $where_user $where_sql_id $where_plan_hash_value $where_module $where_action $where_snap_range
                         ORDER BY $pv{order_field}) x 
                         where ROWNUM <= $pv{scope_num}" ; }

   else {
# !!! добавить в аналитику вычисление процента от суммы значений показателя
      $group_string = "" ;                                                                                                                                  
      if ( $pv{report_type} eq "perhours" ) { $group_string = "YYYY-MM-DD HH24" ; }                                                                         
      if ( $pv{report_type} eq "perdays" ) { $group_string = "YYYY-MM-DD" ; }                                                                               
      if ( $pv{report_type} eq "permonths" ) { $group_string = "YYYY-MM" ; }                                                                                
# GROUP BY    TO_CHAR(ss.CR_STAMP_RECORD,'$group_string')    
# всвязи с тем, что проявился эффект сброса статистик SQL запроса при перезагрузках и инвалидациях, для режима группировки теряет смысл вычисление наиболее малого и наиболее
# большого значения - так как счётчики НЕ ИМЕЮТ кумулятивной природы. Поэтому запрос для группировочного режима переписан
      $request = 'select * FROM ( SELECT SUBSTR(sa.SQL_TEXT,1,64) SQL_TEXT,
                         MAX(s.CR_POINT_ID) CR_POINT_ID, TO_CHAR(MAX(s.CR_STAMP_RECORD),\'YYYY-MM-DD HH24:MI:SS\') CR_STAMP_RECORD,
                         MIN(s.PR_POINT_ID) PR_POINT_ID, TO_CHAR(MIN(s.PR_STAMP_RECORD),\'YYYY-MM-DD HH24:MI:SS\') PR_STAMP_RECORD,
                         s.CR_SQL_ID CR_SQL_ID, s.PR_SQL_ID PR_SQL_ID, 0 a1, 0 a2,
                         lu.USERNAME PARSING_USER, s.CR_MODULE CR_MODULE, s.PR_MODULE PR_MODULE, s.CR_ACTION CR_ACTION, s.PR_ACTION PR_ACTION,
                         0 a3, 0 a4, SUM(s.DIFF_CPU_TIME) DIFF_CPU_TIME,
                           CASE WHEN SUM(s.DIFF_EXECUTIONS) = 0 THEN 0 ELSE ROUND(SUM(s.DIFF_CPU_TIME)/SUM(s.DIFF_EXECUTIONS),2) END CPU_TIME_PER_EXEC,
                         0 a5, 0 a6, SUM(s.DIFF_ELAPSED_TIME) DIFF_ELAPSED_TIME,
                           CASE WHEN SUM(s.DIFF_EXECUTIONS) = 0 THEN 0 ELSE ROUND(SUM(s.DIFF_ELAPSED_TIME)/SUM(s.DIFF_EXECUTIONS),2) END ELAPSED_TIME_PER_EXEC,
                         0 a7, 0 a8, SUM(s.DIFF_PLSQL_EXEC_TIME)  DIFF_PLSQL_EXEC_TIME,
                           CASE WHEN SUM(s.DIFF_EXECUTIONS) = 0 THEN 0 ELSE ROUND(SUM(s.DIFF_PLSQL_EXEC_TIME)/SUM(s.DIFF_EXECUTIONS),2) END PLSQL_TIME_PER_EXEC,
                         0 a9, 0 a10, SUM(s.DIFF_JAVA_EXEC_TIME) DIFF_JAVA_EXEC_TIME,
                           CASE WHEN SUM(s.DIFF_EXECUTIONS) = 0 THEN 0 ELSE ROUND(SUM(s.DIFF_JAVA_EXEC_TIME)/SUM(s.DIFF_EXECUTIONS),2) END JAVA_TIME_PER_EXEC,
                         MAX(s.CR_SHARABLE_MEM) CR_SHARABLE_MEM, MAX(s.PR_SHARABLE_MEM) PR_SHARABLE_MEM, SUM(s.DIFF_SHARABLE_MEM) DIFF_SHARABLE_MEM,
                         MAX(s.CR_PERSISTENT_MEM) CR_PERSISTENT_MEM, MAX(s.PR_PERSISTENT_MEM) PR_PERSISTENT_MEM, SUM(s.DIFF_PERSISTENT_MEM) DIFF_PERSISTENT_MEM,
                         MAX(s.CR_RUNTIME_MEM) CR_RUNTIME_MEM, MAX(s.PR_RUNTIME_MEM) PR_RUNTIME_MEM, SUM(s.DIFF_RUNTIME_MEM) DIFF_RUNTIME_MEM,
                         0 a17, 0 a18, SUM(s.DIFF_DISK_READS) DIFF_DISK_READS,
                           CASE WHEN SUM(s.DIFF_EXECUTIONS) = 0 THEN 0 ELSE ROUND(SUM(s.DIFF_DISK_READS)/SUM(s.DIFF_EXECUTIONS),2) END DISK_READS_PER_EXEC,
                         0 a19, 0 a20, SUM(s.DIFF_DIRECT_WRITES) DIFF_DIRECT_WRITES,
                           CASE WHEN SUM(s.DIFF_EXECUTIONS) = 0 THEN 0 ELSE ROUND(SUM(s.DIFF_DIRECT_WRITES)/SUM(s.DIFF_EXECUTIONS),2) END DIRECT_WRITES_PER_EXEC,
                         0 a21, 0 a22, SUM(s.DIFF_BUFFER_GETS) DIFF_BUFFER_GETS,
                           CASE WHEN SUM(s.DIFF_EXECUTIONS) = 0 THEN 0 ELSE ROUND(SUM(s.DIFF_BUFFER_GETS)/SUM(s.DIFF_EXECUTIONS),2) END BUFFER_GETS_PER_EXEC,
                         0 a23, 0 a24, SUM(s.DIFF_ROWS_PROCESSED) DIFF_ROWS_PROCESSED,
                           CASE WHEN SUM(s.DIFF_EXECUTIONS) = 0 THEN 0 ELSE ROUND(SUM(s.DIFF_ROWS_PROCESSED)/SUM(s.DIFF_EXECUTIONS),2) END ROWS_PROC_PER_EXEC,
                         0 a25, 0 a26, SUM(s.DIFF_SORTS) DIFF_SORTS,
                           CASE WHEN SUM(s.DIFF_EXECUTIONS) = 0 THEN 0 ELSE ROUND(SUM(s.DIFF_SORTS)/SUM(s.DIFF_EXECUTIONS),2) END SORTS_PER_EXEC,
                         0 a27, 0 a28, SUM(s.DIFF_LOADS) DIFF_LOADS,
                         0 a29, 0 a30, SUM(s.DIFF_INVALIDATIONS) DIFF_INVALIDATIONS,
                         0 a31, 0 a32, SUM(s.DIFF_USERS_OPENING) DIFF_USERS_OPENING,
                         0 a33, 0 a34, SUM(s.DIFF_PARSE_CALLS) DIFF_PARSE_CALLS,
                         0 a35, 0 a36, SUM(s.DIFF_EXECUTIONS) DIFF_EXECUTIONS,
                         CASE WHEN SUM(s.DIFF_EXECUTIONS) = 0 THEN 0 ELSE 100 - (SUM(s.DIFF_PARSE_CALLS) * 100 / SUM(s.DIFF_EXECUTIONS) ) END SOFT_PARSE,
                         0 a37, 0 a38, SUM(s.DIFF_USERS_EXECUTING) DIFF_USERS_EXECUTING,
                         0 a39, 0 a40, SUM(s.DIFF_PX_SERVERS_EXECUTIONS) DIFF_PX_SERVERS_EXECUTIONS,
                         0 a41, 0 a42, SUM(s.DIFF_FETCHES) DIFF_FETCHES,
                         0 a43, 0 a44, SUM(s.DIFF_END_OF_FETCH_COUNT) DIFF_END_OF_FETCH_COUNT,
                         0 a45, 0 a46, SUM(s.DIFF_APPLICATION_WAIT_TIME) DIFF_APPLICATION_WAIT_TIME,
                         0 a47, 0 a48, SUM(s.DIFF_CONCURRENCY_WAIT_TIME) DIFF_CONCURRENCY_WAIT_TIME,
                         0 a49, 0 a50, SUM(s.DIFF_CLUSTER_WAIT_TIME) DIFF_CLUSTER_WAIT_TIME,
                         0 a51, 0 a52, SUM(s.DIFF_USER_IO_WAIT_TIME) DIFF_USER_IO_WAIT_TIME,
                         0 a53, 0 a54, SUM(s.DIFF_SERIALIZABLE_ABORTS) DIFF_SERIALIZABLE_ABORTS,
                         0 a55, 0 a56, SUM(s.DIFF_CHILD_LATCH) DIFF_CHILD_LATCH,
                         MAX(s.CR_OPTIMIZER_COST) CR_OPTIMIZER_COST,MIN(s.PR_OPTIMIZER_COST) PR_OPTIMIZER_COST
                         FROM BESTAT_DELTA_SQLAREA s, dba_users lu, BESTAT_SQLAREA sa
                         WHERE s.CR_PARSING_USER_ID = lu.USER_ID AND s.CR_POINT_ID = sa.POINT_ID AND s.CR_SQL_ID = sa.SQL_ID AND
                               s.CR_STAMP_RECORD <= TO_DATE(' . "'$pv{to_range}','YYYY-MM-DD HH24:MI:SS') AND
                               s.CR_STAMP_RECORD >= TO_DATE('$pv{from_range}','YYYY-MM-DD HH24:MI:SS')
                               $where_user $where_sql_id $where_plan_hash_value $where_module $where_action $where_snap_range
                         GROUP BY TO_CHAR(s.CR_STAMP_RECORD,'$group_string'), s.CR_SQL_ID, s.PR_SQL_ID, lu.USERNAME, s.CR_MODULE, s.PR_MODULE,
                               s.CR_ACTION, s.PR_ACTION, sa.SQL_TEXT
                         ORDER BY $pv{order_field}) x
                         where ROWNUM <= $pv{scope_num} " ; }
  
   my $sth = $dbh->prepare($request) ;
   $sth->execute();
# вывести непосредственно контент

sub print_head_ancor($$) { $a_order_field = $_[0] ; $a_title_field = $_[1] ;
    if ( $pv{order_field} !~ /$a_order_field*/ ) { $a_order_field .= " DESC" ; }
    if ( $pv{order_field} =~ /$a_order_field\sASC/ || $pv{order_field} eq "$a_order_field" ) { $a_order_field .= " DESC" ; }
    if ( $pv{order_field} =~ /$a_order_field\sDESC/ ) { $a_order_field .= " ASC" ; }
    print "<A HREF=\"$base_url/cgi/get_sql_area_from_collector.cgi?order_field=$a_order_field&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&sql_id=$pv{sql_id}&plan_hash_value=$pv{plan_hash_value}&module_filter=$pv{module_filter}&action_filter=$pv{action_filter}&is_view_sources=$pv{is_view_sources}&is_view_result=yes&scope_num=$pv{scope_num}&first_user=$pv{first_user}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">$a_title_field</A>" ;
    }

   print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
   print "<TR><TD ROWSPAN=\"2\" CLASS=\"HEAD\">";       &print_head_ancor("CR_POINT_ID", "ID текущего среза") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("CR_STAMP_RECORD", "Дата текущего среза") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("PR_POINT_ID", "ID прошлого среза") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("PR_STAMP_RECORD", "Дата прошлого среза") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("CR_SQL_ID", "SQL ID") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("SQL_TEXT", "Начало SQL") ;
#   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.PR_SQL_ID", "SQL_ID плана прошлого среза") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("CR_PLAN_HASH_VALUE", "HASH плана текущего среза") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("CR_PLAN_HASH_VALUE", "HASH плана прошлого среза") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("PARSING_USER", "Первый пользователь") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("CR_MODULE", "Модуль") ;
#   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.CR_MODULE", "Модуль (прошлый срез)") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("CR_ACTION", "Действие") ;
#   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.CR_ACTION", "Действие (прошлый срез)") ;

   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Время процессора" ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Время всего" ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Время PLSQL" ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Время JAVA" ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("CR_SHARABLE_MEM", "Памяти, байт всего") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("CR_PERSISTENT_MEM", "Памяти, байт постоянной") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("CR_RUNTIME_MEM", "Памяти, байт runtime") ;

   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Физических чтений" ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Прямых записей" ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Логических чтений" ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Обработано строк" ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Завершенных сортировок" ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_LOADS", "Загрузок и перезагрузок") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_INVALIDATIONS", "INVALIDATIONS") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_USERS_OPENING", "Пользователей открывало") ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_PARSE_CALLS", "Количество разборов") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_EXECUTIONS", "Количество выполнений") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("SOFT_PARSE", "Мягких выполнений, %") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_USER_EXECUTIONS", "Выполнений пользователем") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_PX_SERVER_EXECUTIONS", "Параллельных выполнений") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_FETCHES", "Возвратов данных") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_END_OF_FETCH_COUNT", "END OF FETCH COUNT") ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_APPLICATION_WAIT_TIME", "Ожиданий приложения") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_CONCURRENCY_WAIT_TIME", "Ожиданий конкуренции") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_CLUSTER_WAIT_TIME", "Ожиданий кластерных") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_USER_IO_WAIT_TIME", "Ожиданий I/O пользователя") ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_SERIALIZABLE_ABORTS", "SERIALIZABLE ABORTS") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_CHILD_LATCH", "CHILD LATCH") ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("CR_OPTIMIZER_COST", "Текущая стоимость выполнения запроса") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("PR_OPTIMIZER_COST", "Прежняя стоимость выполнения запроса") ;
   print "</TR>" ;

   print "<TR><TD CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_CPU_TIME", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("CPU_TIME_PER_EXEC", "на один запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_ELAPSED_TIME", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("ELAPSED_TIME_PER_EXEC", "на один запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_PLSQL_EXEC_TIME", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("PLSQL_TIME_PER_EXEC", "на один запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_JAVA_EXEC_TIME", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("JAVA_TIME_PER_EXEC", "на один запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_DISK_READS", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DISK_READS_PER_EXEC", "на один запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_DIRECT_WRITE", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DIRECT_WRITE_PER_EXEC", "на один запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_BUFFER_GETS", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("BUFFER_GETS_PER_EXEC", "на один запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_ROWS_PROCESSED", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("ROWS_PROCESSED_PER_EXEC", "на один запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_SORTS", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("SORTS_PER_EXEC", "на один запрос") ;

   print "</TR>" ;

   
   $count_rows = 0 ;
   while (my ($cr_sql_text,$cr_point_id,$cr_stamp_record,$pr_point_id,$pr_stamp_record,$cr_sql_id,$pr_sql_id,
              $cr_plan_hash_value,$pr_plan_hash_value,$cr_parsing_user,
              $cr_module,$pr_module,$cr_action,$pr_action,
              $cr_cpu_time,$pr_cpu_time,$diff_cpu_time,$cpu_time_per_exec,
              $cr_elapsed_time,$pr_elapsed_time,$diff_elapsed_time,$elapsed_time_perexec,
              $cr_plsql_exec_time,$pr_plsql_exec_time,$diff_plsql_exec_time,$plsql_time_per_exec,
              $cr_java_exec_time,$pr_java_exec_time,$diff_java_exec_time,$java_time_per_exec,
              $cr_sharable_mem,$pr_sharable_mem,$diff_sharable_mem,
              $cr_persistent_mem,$pr_persistent_mem,$diff_persistent_mem,
              $cr_runtime_mem,$pr_runtime_mem,$diff_runtime_mem,
              $cr_disk_reads,$pr_disk_reads,$diff_disk_reads,$disk_reads_per_exec,
              $cr_direct_writes,$pr_direct_writes,$diff_direct_writes,$direct_writes_per_exec,
              $cr_buffer_gets,$pr_buffer_gets,$diff_buffer_gets,$buffer_gets_per_exec,
              $cr_rows_processed,$pr_rows_processed,$diff_rows_processed,$rows_processed_per_exec,
              $cr_sorts,$pr_sorts,$diff_sorts,$sorts_per_exec,
              $cr_loads,$pr_loads,$diff_loads,
              $cr_invalidations, $pr_invalidations,$diff_invalidations,
              $cr_users_opening, $pr_users_opening,$diff_users_opening,
              $cr_parse_calls, $pr_parse_calls,$diff_parse_calls,
              $cr_executions, $pr_executions,$diff_executions,$soft_parse,
              $cr_user_executing, $pr_user_executing,$diff_user_executing,
              $cr_px_server_executions, $pr_px_server_executions,$diff_px_server_executions,
              $cr_fetches, $pr_fetches,$diff_fetches,
              $cr_end_of_fetch_count, $pr_end_of_fetch_count,$diff_end_of_fetch_count,
              $cr_application_wait_time, $pr_application_wait_time,$diff_application_wait_time,
              $cr_concurency_wait_time, $pr_concurency_wait_time,$diff_concurency_wait_time,
              $cr_cluster_wait_time, $pr_cluster_wait_time,$diff_cluster_wait_time,
              $cr_user_io_wait_time, $pr_user_io_wait_time,$diff_user_io_wait_time,
              $cr_serializable_aborts, $pr_serializable_aborts,$diff_serializable_aborts,
              $cr_child_latch, $pr_child_latch,$diff_child_latch,$cr_optimizer_cost,$pr_optimizer_cost) = $sth->fetchrow_array() ) {

         $count_rows += 1 ; 
         if ( $cr_module eq "" ) { $cr_module = "&nbsp;" ; } $cr_module =~ s/\s/&nbsp;/g ;
         if ( $pr_module eq "" ) { $pr_module = "&nbsp;" ; } $pr_module =~ s/\s/&nbsp;/g ;
         if ( $cr_action eq "" ) { $cr_action = "&nbsp;" ; } $cr_action =~ s/\s/&nbsp;/g ;
         if ( $pr_action eq "" ) { $pr_action = "&nbsp;" ; } $pr_action =~ s/\s/&nbsp;/g ;
         if ( $cr_sql_text eq "" ) { $cr_sql_text = "&nbsp;" ; } $cr_sql_text =~ s/\s/&nbsp;/g ;
         if ( $cr_stamp_record eq "" ) { $cr_stamp_record = "&nbsp;" ; } $cr_stamp_record =~ s/\s/&nbsp;/g ;
         if ( $pr_stamp_record eq "" ) { $pr_stamp_record = "&nbsp;" ; } $pr_stamp_record =~ s/\s/&nbsp;/g ;
         if ( $cr_optimizer_cost eq "" ) { $cr_optimizer_cost = "&nbsp;" ; }
         if ( $pr_optimizer_cost eq "" ) { $pr_optimizer_cost = "&nbsp;" ; }
         printf("<TR><TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\" TITLE=\"curr = %s, perv = %s\"><A HREF=\"$base_url/cgi/get_sql_info_by_id.cgi?sql_id=%s&srcptr=%s\">%s</A></TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"SZDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>",
                     $cr_point_id,$cr_stamp_record,$pr_point_id,$pr_stamp_record,$cr_sql_id,$pr_sql_id,$cr_sql_id,$cr_point_id,$cr_sql_id,$cr_sql_text,
                     $cr_plan_hash_value,$pr_plan_hash_value,$cr_parsing_user,$cr_module,$pr_module,$cr_module,$cr_action,$pr_action,$cr_action) ;

         printf("    <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD><TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD><TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD><TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD><TD CLASS=\"NUMDATA\">%s</TD>",
                     $cr_cpu_time,$pr_cpu_time,&show_razryads($diff_cpu_time),$cpu_time_per_exec,
                     $cr_elapsed_time,$pr_elapsed_time,&show_razryads($diff_elapsed_time),$elapsed_time_perexec,
                     $cr_plsql_exec_time,$pr_plsql_exec_time,&show_razryads($diff_plsql_exec_time),$plsql_time_per_exec,
                     $cr_java_exec_time,$pr_java_exec_time,&show_razryads($diff_java_exec_time),$java_time_per_exec ) ;

         printf("    <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>",
                     $cr_sharable_mem,$pr_sharable_mem,&show_razryads($cr_sharable_mem),
                     $cr_persistent_mem,$pr_persistent_mem,&show_razryads($cr_persistent_mem),
                     $cr_runtime_mem,$pr_runtime_mem,&show_razryads($cr_runtime_mem) ) ;

         printf("    <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD><TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD><TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD><TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD><TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD><TD CLASS=\"NUMDATA\">%s</TD>",
                     $cr_disk_reads,$pr_disk_reads,&show_razryads($diff_disk_reads),$disk_reads_per_exec,
                     $cr_direct_writes,$pr_direct_writes,&show_razryads($diff_direct_writes),$direct_writes_per_exec,
                     $cr_buffer_gets,$pr_buffer_gets,&show_razryads($diff_buffer_gets),$buffer_gets_per_exec,
                     $cr_rows_processed,$pr_rows_processed,&show_razryads($diff_rows_processed),$rows_processed_per_exec,
                     $cr_sorts,$pr_sorts,&show_razryads($diff_sorts),$sorts_per_exec ) ;

         printf("    <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>",
                     $cr_loads,$pr_loads,&show_razryads($diff_loads),
                     $cr_invalidations, $pr_invalidations,&show_razryads($diff_invalidations),
                     $cr_users_opening, $pr_users_opening,&show_razryads($diff_users_opening) ) ;

         printf("    <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>",
                     $cr_parse_calls, $pr_parse_calls,&show_razryads($diff_parse_calls),
                     $cr_executions, $pr_executions,&show_razryads($diff_executions),$soft_parse,
                     $cr_user_executing, $pr_user_executing,&show_razryads($diff_user_executing),
                     $cr_px_server_executions, $pr_px_server_executions,&show_razryads($diff_px_server_executions),
                     $cr_fetches, $pr_fetches,&show_razryads($diff_fetches),
                     $cr_end_of_fetch_count, $pr_end_of_fetch_count,&show_razryads($diff_end_of_fetch_count) ) ;

         printf("    <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>",
                     $cr_application_wait_time, $pr_application_wait_time,&show_razryads($diff_application_wait_time),
                     $cr_concurency_wait_time, $pr_concurency_wait_time,&show_razryads($diff_concurency_wait_time),
                     $cr_cluster_wait_time, $pr_cluster_wait_time,&show_razryads($diff_cluster_wait_time),
                     $cr_user_io_wait_time, $pr_user_io_wait_time,&show_razryads($diff_user_io_wait_time) ) ;

         printf("    <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>
                     <TD CLASS=\"NUMDATA\" TITLE=\"curr = %s, perv = %s\">%s</TD>",
                     $cr_serializable_aborts, $pr_serializable_aborts,&show_razryads($diff_serializable_aborts),
                     $cr_child_latch, $pr_child_latch,&show_razryads($diff_child_latch) ) ;

         printf("    <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>", 
                     $cr_optimizer_cost,$pr_optimizer_cost ) ;

         printf("</TR>\n") ;
         }
   print "<TR><TD CLASS=\"SZDATA\">Итого</TD><TD CLASS=\"NUMDATA\" COLSPAN=\"50\">$count_rows</TD></TR>\n" ;
   print "</TABLE>" ;
   $sth->finish();
   $dbh->disconnect();
   print "</TD></TR>" ;
   }
# это конец контейнерной таблицы контента
print "</TABLE>" ;

# это конец общей контейнерной таблицы
print "</TD></TR></TABLE>" ;
      
if ( $is_view_request eq "yes" &&  $pv{is_view_result} eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n<PRE>$request</PRE>\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
