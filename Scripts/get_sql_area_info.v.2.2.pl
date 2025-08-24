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
&print_html_head("Информация о запросах SQL (агрегированная)") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_sqlarea_navigation(1) ;

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
print "<FORM ACTION=\"$base_url/cgi/get_sql_area_info.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
print "<TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --</DIV></TD></TR>" ;
&print_select_data_source() ;

print "<TR><TD>&nbsp;Кол-во&nbsp;значений: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"scope_num\" VALUE=\"$pv{scope_num}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Первый&nbsp;пользователь: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"first_user\" VALUE=\"$pv{first_user}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;SQL&nbsp;ID: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"sql_id\" VALUE=\"$pv{sql_id}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Hash&nbsp;плана&nbsp;исполнения: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"plan_hash_value\" VALUE=\"$pv{plan_hash_value}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Модуль LIKE: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"module_filter\" VALUE=\"$pv{module_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Действие LIKE: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"action_filter\" VALUE=\"$pv{action_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
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
   $where_sql_id = "" ; if ( $pv{sql_id} ne "" ) { $where_user = "AND s.SQL_ID = '$pv{sql_id}'" ; }
   $where_plan_hash_value = "" ; if ( $pv{plan_hash_value} ne "" ) { $where_user = "AND s.PLAN_HASH_VALUE = '$pv{plan_hash_value}'" ; }
   $where_module = "" ; if ( $pv{module_filter} ne "" ) { $where_module = "AND s.MODULE LIKE '%$pv{module_filter}%'" ; }
   $where_action = "" ; if ( $pv{action_filter} ne "" ) { $where_action = "AND s.ACTION LIKE '%$pv{action_filter}%'" ; }
   $where_cost = "" ; if ( $pv{order_field} =~ /s.OPTIMIZER_COST*/ ) { $where_cost = "AND s.OPTIMIZER_COST IS NOT NULL" ; }
   if ( $pv{srcptr} eq "" || $pv{srcptr} eq "0" ) {
      $request = 'select * from (select s.SQL_ID,SUBSTR(s.SQL_TEXT,1,64) SQL_TEXT, s.PLAN_HASH_VALUE,s.ADDRESS,s.HASH_VALUE,s.VERSION_COUNT,s.LOADED_VERSIONS,
                      s.OPEN_VERSIONS,
                      s.CPU_TIME,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.CPU_TIME/s.EXECUTIONS,2) END CPU_TIME_PER_EXEC,
                      s.ELAPSED_TIME,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.ELAPSED_TIME/s.EXECUTIONS,2) END ELAPSED_TIME_PER_EXEC,
                      s.SHARABLE_MEM,s.PERSISTENT_MEM,s.RUNTIME_MEM,
                      s.SORTS,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.SORTS/s.EXECUTIONS,2) END SORTS_PER_EXEC,
                      s.DISK_READS,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DISK_READS/s.EXECUTIONS,2) END DISK_READS_PER_EXEC,
                      s.BUFFER_GETS,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.BUFFER_GETS/s.EXECUTIONS,2) END BUFFER_GETS_PER_EXEC,
                      s.ROWS_PROCESSED,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.ROWS_PROCESSED/s.EXECUTIONS,2) END ROWS_PROCESSED_PER_EXEC,
                      s.PARSE_CALLS,s.EXECUTIONS, CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE 100 - (s.PARSE_CALLS * 100 / s.EXECUTIONS ) END SOFT_PARSE,
                      s.FETCHES,lu.USERNAME PARSING_USER,lc.USERNAME PARSING_SCHEMA,s.KEPT_VERSIONS,s.USERS_OPENING,s.USERS_EXECUTING,
                      s.FIRST_LOAD_TIME,s.LOADS,s.INVALIDATIONS,s.COMMAND_TYPE,s.OPTIMIZER_MODE,s.OPTIMIZER_COST,s.MODULE,s.ACTION,s.SERIALIZABLE_ABORTS,s.IS_OBSOLETE,s.CHILD_LATCH 
                      from v$sqlarea s, dba_users lu, dba_users lc where s.PARSING_USER_ID = lu.USER_ID AND s.PARSING_SCHEMA_ID = lc.USER_ID ' .
                      " $where_user $where_sql_id $where_plan_hash_value $where_cost $where_module $where_action ORDER BY $pv{order_field}) X where ROWNUM <= $pv{scope_num} " ; }
   else {
      $request = 'select * from (select s.SQL_ID,SUBSTR(s.SQL_TEXT,1,64) SQL_TEXT, s.PLAN_HASH_VALUE,s.ADDRESS,s.HASH_VALUE,s.VERSION_COUNT,s.LOADED_VERSIONS,
                      s.OPEN_VERSIONS,
                      s.CPU_TIME,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.CPU_TIME/s.EXECUTIONS,2) END CPU_TIME_PER_EXEC,
                      s.ELAPSED_TIME,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.ELAPSED_TIME/s.EXECUTIONS,2) END ELAPSED_TIME_PER_EXEC,
                      s.SHARABLE_MEM,s.PERSISTENT_MEM,s.RUNTIME_MEM,
                      s.SORTS,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.SORTS/s.EXECUTIONS,2) END SORTS_PER_EXEC,
                      s.DISK_READS,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.DISK_READS/s.EXECUTIONS,2) END DISK_READS_PER_EXEC,
                      s.BUFFER_GETS,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.BUFFER_GETS/s.EXECUTIONS,2) END BUFFER_GETS_PER_EXEC,
                      s.ROWS_PROCESSED,CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE ROUND(s.ROWS_PROCESSED/s.EXECUTIONS,2) END ROWS_PROCESSED_PER_EXEC,
                      s.PARSE_CALLS,s.EXECUTIONS, CASE WHEN s.EXECUTIONS = 0 THEN 0 ELSE 100 - (s.PARSE_CALLS * 100 / s.EXECUTIONS ) END SOFT_PARSE,
                      s.FETCHES,lu.USERNAME PARSING_USER,lc.USERNAME PARSING_SCHEMA,s.KEPT_VERSIONS,s.USERS_OPENING,s.USERS_EXECUTING,
                      s.FIRST_LOAD_TIME,s.LOADS,s.INVALIDATIONS,s.COMMAND_TYPE,s.OPTIMIZER_MODE,s.OPTIMIZER_COST,s.MODULE,s.ACTION,s.SERIALIZABLE_ABORTS,s.IS_OBSOLETE,s.CHILD_LATCH 
                      from BESTAT_SQLAREA s, dba_users lu, dba_users lc where s.PARSING_USER_ID = lu.USER_ID AND s.PARSING_SCHEMA_ID = lc.USER_ID ' .
                      " AND s.POINT_ID = '$pv{srcptr}' $where_user $where_sql_id $where_plan_hash_value $where_cost $where_module $where_action ORDER BY $pv{order_field}) X where ROWNUM <= $pv{scope_num} " ; }

# AND s.MODULE LIKE IN '$pv{module_filter}' AND s.ACTION LIKE IN '$pv{action_filter}' 
   
   my $sth = $dbh->prepare($request) ;
   $sth->execute();
# вывести непосредственно контент

sub print_head_ancor($$) { $a_order_field = $_[0] ; $a_title_field = $_[1] ;
    if ( $pv{order_field} !~ /$a_order_field*/ ) { $a_order_field .= " DESC" ; }
    if ( $pv{order_field} =~ /$a_order_field\sASC/ || $pv{order_field} eq "$a_order_field" ) { $a_order_field .= " DESC" ; }
    if ( $pv{order_field} =~ /$a_order_field\sDESC/ ) { $a_order_field .= " ASC" ; }
    print "<A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=$a_order_field&is_view_result=yes&scope_num=$pv{scope_num}&first_user=$pv{first_user}&srcptr=$pv{srcptr}\" TARGET=\"cont\">$a_title_field</A>" ;
#<A HREF=\"$base_url/cgi/get_sysevents_top_from_collector.cgi?order_field=$a_order_field&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">$a_title_field</A>" ;
    }

   print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
   print "<TR><TD ROWSPAN=\"2\" CLASS=\"HEAD\">";       &print_head_ancor("s.SQL_ID", "SQL ID") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.SQL_TEXT", "Начало запроса") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.PLAN_HASH_VALUE", "HASH плана выполнения") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.ADDRESS", "Address, HASH") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.VERSION_COUNT", "Всего курсоров") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.LOADED_VERSIONS", "Загружено курсоров") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.OPEN_VERSIONS", "Открыто сейчас") ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("lu.ISER_ID", "Первый пользователь") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("lc.ISER_ID", "Первая схема") ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.PARSE_CALLS", "Количество разборов") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.EXECUTIONS", "Количество выполнений") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("SOFT_PARSE", "Мягких выполнений, %") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.FETCHES", "Возвратов данных") ;

   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Время процессора" ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Время всего" ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.SHARABLE_MEM", "Памяти, байт всего") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.PERSISTENT_MEM", "Памяти, байт постоянной") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.RUNTIME_MEM", "Памяти, байт runtime") ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Завершенных сортировок" ;

   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Физических чтений" ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Логических чтений" ;
   print "    </TD><TD COLSPAN=\"2\" CLASS=\"HEAD\">Обработано строк" ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.KEPT_VERSIONS", "Маркированных курсоров") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.USERS_OPENING", "Пользователей открывало") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.USERS_EXECUTING", "Пользователей исполняло") ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.FIRST_LOAD_TIME", "Время первой загрузки") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.LOADS", "Загрузок и перезагрузок") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.INVALIDATIONS", "INVALIDATIONS") ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.COMMAND_TYPE", "Тип команды") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.OPTIMIZER_MODE", "Режим оптимизатора") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.OPTIMIZER_COST", "Стоимость запроса (cost)") ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.MODULE", "MODULE") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.ACTION", "ACTION") ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.SERIALIZABLE_ABORTS", "SERIALIZABLE ABORTS") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.IS_OBSOLETE", "IS OBSOLETE") ;
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("s.CHILD_LATCH", "CHILD LATCH") ;
   print "</TR>" ;

   print "<TR><TD CLASS=\"HEAD\">" ; &print_head_ancor("s.CPU_TIME", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("CPU_TIME_PER_EXEC", "на запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("s.ELAPSED_TIME", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("ELAPSED_TIME_PER_EXEC", "на запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("s.SORTS", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("SORTS_PER_EXEC", "на запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("s.DISK_READS", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("DISK_READS_PER_EXEC", "на запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("s.BUFFER_GETS", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("BUFFER_GETS_PER_EXEC", "на запрос") ;

   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("s.ROWS_PROCESSED", "всего") ;
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("ROWS_PROCESSED_PER_EXEC", "на запрос") ;
   print "</TR>" ;

   
   $count_rows = 0 ;
   while (my ($sql_id,$sql_text,$plan_hash_value,$address,$hash_value,$version_count,$loaded_versions,$open_versions,$cpu_time,$cpu_time_per_exec,$eplased_time,$eplased_time_per_exec,$sharable_mem,$persistent_mem,$runtime_mem,$sorts,$sorts_per_exec,$disk_reads,$disk_reads_per_exec,$buffer_gets,$buffer_gets_per_exec,$rows_processed,$rows_processed_per_exec,$parse_calls,$executions,$soft_parse,$fetches,$parsibg_user_id,$parsing_chema_id,$kept_versions,$users_opening,$users_executing,$first_load_time,$loads,$invalidations,$command_type,$optimizer_mode,$optimizer_cost,$module,$action,$serializable_aborts,$is_obsolete,$child_latch) = $sth->fetchrow_array() ) {
         $count_rows += 1 ; 
         if ( $module eq "" ) { $module = "&nbsp;" ; } $module =~ s/\s/&nbsp;/g ;
         if ( $action eq "" ) { $action = "&nbsp;" ; } $action =~ s/\s/&nbsp;/g ;
         if ( $sql_text eq "" ) { $sql_text = "&nbsp;" ; } $sql_text =~ s/\s/&nbsp;/g ;
         if ( $optimizer_mode eq "" ) { $optimizer_mode = "&nbsp;" ; } $optimizer_mode =~ s/\s/&nbsp;/g ;
         if ( $optimizer_cost eq "" ) { $optimizer_cost = "&nbsp;" ; } $optimizer_cost =~ s/\s/&nbsp;/g ;
         printf("<TR><TD CLASS=\"SZDATA\"><A HREF=\"$base_url/cgi/get_sql_info_by_id.cgi?sql_id=%s&srcptr=%s\">%s</A></TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\"><A HREF=\"$base_url/cgi/get_sql_info.cgi?address=%s&hash_value=%s\">%s,&nbsp;%s</A></TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"CENTERDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"CENTERDATA\">%s</TD>
                     <TD CLASS=\"CENTERDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"CENTERDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                 </TR>\n",$sql_id,$pv{srcptr},$sql_id,$sql_text,$plan_hash_value,$address,$hash_value,$address,$hash_value,$version_count,$loaded_versions,$open_versions,
                          $parsibg_user_id,$parsing_chema_id,&show_razryads($parse_calls),&show_razryads($executions),$soft_parse,&show_razryads($fetches),
                          &show_razryads($cpu_time),$cpu_time_per_exec,&show_razryads($eplased_time),$eplased_time_per_exec,&show_razryads($sharable_mem),
                          &show_razryads($persistent_mem),&show_razryads($runtime_mem),&show_razryads($sorts),$sorts_per_exec,&show_razryads($disk_reads),
                          $disk_reads_per_exec,&show_razryads($buffer_gets),$buffer_gets_per_exec,&show_razryads($rows_processed),$rows_processed_per_exec,
                          &show_razryads($kept_versions),&show_razryads($users_opening),&show_razryads($users_executing),$first_load_time,
                          &show_razryads($loads),&show_razryads($invalidations),$command_type,$optimizer_mode,$optimizer_cost,$module,$action,
                          $serializable_aborts,$is_obsolete,$child_latch) ;
         }
   print "<TR><TD CLASS=\"SZDATA\">Итого</TD><TD CLASS=\"NUMDATA\" COLSPAN=\"41\">$count_rows</TD></TR>\n" ;
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
