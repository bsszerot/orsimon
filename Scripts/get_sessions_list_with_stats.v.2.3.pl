#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_sessions_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ;
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.SID\" TARGET=\"cont\">Сессии списком все</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sessions_list_with_stats.cgi?order_field=s.SID\" TARGET=\"cont\">Сессии со статистиками</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.SID\" TARGET=\"cont\">Сессии с блокировками (от v.10)</A></TD>
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
                                                                                                                                                             
sub print_head_ancor($$) { $a_order_field = $_[0] ; $a_title_field = $_[1] ; $order_symbol = "&nbsp;" ;
    if ( $pv{order_field} !~ /^$a_order_field/ ) { $a_order_field .= " DESC" ; }
    if ( $pv{order_field} =~ /^$a_order_field\sASC/ || $pv{order_field} eq "$a_order_field" ) { $a_order_field .= " DESC" ; $order_symbol = "&#9650;" ; }
    if ( $pv{order_field} =~ /^$a_order_field\sDESC/ ) { $a_order_field .= " ASC" ; $order_symbol = "&#9660;" ; }
    print "<TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" ALIGN=\"center\"><TR><TD>&nbsp;</TD>
           <TD STYLE=\"text-align: center;\"><A HREF=\"$base_url/cgi/get_sessions_list_with_stats.cgi?order_field=$a_order_field&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">$a_title_field</A></TD>
           <TD STYLE=\"color: navy;\">&nbsp;$order_symbol</TD></TR></TABLE>" ;
    }

use DBI;
require "/var/www/oracle/cgi/omon.cfg" ;

# - ДЛЯ ВСЕХ МОДУЛЕЙ - инициализировать значения сессии из cookie, если есть, или же использовать значения по умолчанию
$current_connector = "none" ; if ( $ENV{HTTP_COOKIE} =~ /.*[;\s]*current_connector=([^;]+)[;\s]*.*/ ) { $current_connector = $1 ; }
# - вытащить из URL запроса значения уточняющих полей
#$pv{order_field} = "s.SID" ;
&get_forms_param() ;

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');

print "Content-Type: text/html\n\n"; 
&print_html_head("Сессии со статистиками") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_sessions_navigation(2) ;

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

print "<FORM ACTION=\"$base_url/cgi/get_sessions_list_with_stats.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
print "<TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки не требует обязательного указания дополнительных условий --<BR>
-- текущая версия обрабатывает только показатели реального времени (не коллектор) -- </DIV></TD></TR>" ;
&print_select_data_source() ;
print "<TR><TD>&nbsp;ID&nbsp;сессии: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"sid_filter\" VALUE=\"$pv{sid_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Статус&nbsp;сессии: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"status_filter\" VALUE=\"$pv{status_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Пользователь&nbsp;Oracle: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"user_filter\" VALUE=\"$pv{user_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
$checked_is_view_bgr = "" ; if ( $pv{is_view_bgr} eq "on" ) { $checked_is_view_bgr = " CHECKED " ; } else { $pv{is_view_bgr} = "off" ; }
print "<TR><TD>&nbsp;выводить BGR: </TD><TD><INPUT TYPE=\"checkbox\" NAME=\"is_view_bgr\" $checked_is_view_bgr STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD COLSPAN=\"2\">
       <INPUT TYPE=\"hidden\" NAME=\"order_field\" VALUE=\"$pv{order_field}\">
       <INPUT TYPE=\"hidden\" NAME=\"is_view_sources\" VALUE=\"$pv{is_view_sources}\"></TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

# сформировать уточняющие фильтры для запроса статистики
$where_ext = "" ; 
if ( $pv{sid_filter} ne "" ) { $where_ext .= " AND s.SID = '$pv{sid_filter}' " ; }
if ( $pv{status_filter} ne "" ) { $where_ext .= " AND s.STATUS = '$pv{status_filter}' " ; }
if ( $pv{user_filter} ne "" ) { $where_ext .= " AND s.USERNAME = '$pv{user_filter}' " ; }
if ( $pv{is_view_bgr} ne "on" ) { $where_ext .= " AND ( p.BACKGROUND IS NULL OR NOT p.BACKGROUND = '1') " ; }

if ( $pv{srcptr} eq "0" || $pv{srcptr} eq "" ) { 
   $request = 'select CASE p.BACKGROUND WHEN \'1\' THEN \'BGR\' ELSE \'FRG\' END BACKGROUND,s.STATUS,s.LOCKWAIT,s.SID,s.SERIAL# SERIAL,
                      TO_CHAR(s.LOGON_TIME,\'YYYY-MM-DD HH24:MI:SS\'),(SYSDATE - s.LOGON_TIME) as SESSION_DURATION,s.USERNAME,s.OSUSER,s.PROCESS,s.TERMINAL,
                      s.PROGRAM,p.USERNAME,p.TERMINAL,p.PROGRAM,p.SPID,
                      stat.PHYS_READS_BYTES PHYS_READS_BYTES, CASE WHEN (SUM(stat.PHYS_READS_BYTES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_READS_BYTES * 100 / (SUM(stat.PHYS_READS_BYTES) OVER ()), 2 ) END PHYS_READS_BYTES_PR,
                      stat.PHYS_READS PHYS_READS, CASE WHEN (SUM(stat.PHYS_READS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_READS * 100 / (SUM(stat.PHYS_READS) OVER ()), 2 ) END PHYS_READS_PR,
                      stat.PHYS_READS_DIRECT PHYS_READS_DIRECT, CASE WHEN (SUM(stat.PHYS_READS_DIRECT) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_READS_DIRECT * 100 / (SUM(stat.PHYS_READS_DIRECT) OVER ()), 2 ) END PHYS_READS_DIRECT_PR,
                      stat.PHYS_READS_DIR_LOB PHYS_READS_DIR_LOB, CASE WHEN (SUM(stat.PHYS_READS_DIR_LOB) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_READS_DIR_LOB * 100 / (SUM(stat.PHYS_READS_DIR_LOB) OVER ()), 2 ) END PHYS_READS_DIR_LOB_PR,
                      stat.PHYS_READS_DIR_TEMP PHYS_READS_DIR_TEMP, CASE WHEN (SUM(stat.PHYS_READS_DIR_TEMP) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_READS_DIR_TEMP * 100 / (SUM(stat.PHYS_READS_DIR_TEMP) OVER ()), 2 ) END PHYS_READS_DIR_TEMP_PR,
                      stat.PHYS_WRITE_BYTES PHYS_WRITE_BYTES, CASE WHEN (SUM(stat.PHYS_WRITE_BYTES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_WRITE_BYTES * 100 / (SUM(stat.PHYS_WRITE_BYTES) OVER ()), 2 ) END PHYS_WRITE_BYTES_PR,
                      stat.PHYS_WRITE_TOTAL_BYTES PHYS_WRITE_TOTAL_BYTES, CASE WHEN (SUM(stat.PHYS_WRITE_TOTAL_BYTES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_WRITE_TOTAL_BYTES * 100 / (SUM(stat.PHYS_WRITE_TOTAL_BYTES) OVER ()), 2 ) END PHYS_WRITE_TOTAL_BYTES_PR,
                      stat.PHYS_WRITES PHYS_WRITES, CASE WHEN (SUM(stat.PHYS_WRITES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_WRITES * 100 / (SUM(stat.PHYS_WRITES) OVER ()), 2 ) END PHYS_WRITES_PR,
                      stat.PHYS_WRITES_DIRECT PHYS_WRITES_DIRECT, CASE WHEN (SUM(stat.PHYS_WRITES_DIRECT) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_WRITES_DIRECT * 100 / (SUM(stat.PHYS_WRITES_DIRECT) OVER ()), 2 ) END PHYS_WRITES_DIRECT_PR,
                      stat.PHYS_WRITES_DIR_LOB PHYS_WRITES_DIR_LOB, CASE WHEN (SUM(stat.PHYS_WRITES_DIR_LOB) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_WRITES_DIR_LOB * 100 / (SUM(stat.PHYS_WRITES_DIR_LOB) OVER ()), 2 ) END PHYS_WRITES_DIR_LOB_PR,
                      stat.PHYS_WRITES_DIR_TEMP PHYS_WRITES_DIR_TEMP, CASE WHEN (SUM(stat.PHYS_WRITES_DIR_TEMP) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PHYS_WRITES_DIR_TEMP * 100 / (SUM(stat.PHYS_WRITES_DIR_TEMP) OVER ()), 2 ) END PHYS_WRITES_DIR_TEMP_PR,
                      stat.DB_BLOCK_GETS DB_BLOCK_GETS, CASE WHEN (SUM(stat.DB_BLOCK_GETS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.DB_BLOCK_GETS * 100 / (SUM(stat.DB_BLOCK_GETS) OVER ()), 2 ) END DB_BLOCK_GETS_PR,
                      stat.DB_BLOCK_GETS_DIR DB_BLOCK_GETS_DIR, CASE WHEN (SUM(stat.DB_BLOCK_GETS_DIR) OVER ()) = 0 THEN 0 ELSE ROUND( stat.DB_BLOCK_GETS_DIR * 100 / (SUM(stat.DB_BLOCK_GETS_DIR) OVER ()), 2 ) END DB_BLOCK_GETS_DIR_PR,
                      stat.DB_BLOCK_GETS_FROM_CACHE DB_BLOCK_GETS_FROM_CACHE, CASE WHEN (SUM(stat.DB_BLOCK_GETS_FROM_CACHE) OVER ()) = 0 THEN 0 ELSE ROUND( stat.DB_BLOCK_GETS_FROM_CACHE * 100 / (SUM(stat.DB_BLOCK_GETS_FROM_CACHE) OVER ()), 2 ) END DB_BLOCK_GETS_FROM_CACHE_PR,
                      stat.CONSISTENT_GETS CONSISTENT_GETS,CASE WHEN (SUM(stat.CONSISTENT_GETS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.CONSISTENT_GETS * 100 / (SUM(stat.CONSISTENT_GETS) OVER ()), 2 ) END CONSISTENT_GETS_PR,
                      stat.CONSISTENT_GETS_DIRECT CONSISTENT_GETS_DIRECT, CASE WHEN (SUM(stat.CONSISTENT_GETS_DIRECT) OVER ()) = 0 THEN 0 ELSE ROUND( stat.CONSISTENT_GETS_DIRECT * 100 / (SUM(stat.CONSISTENT_GETS_DIRECT) OVER ()), 2 ) END CONSISTENT_GETS_DIRECT_PR,
                      stat.CONSISTENT_GETS_FROM_CACHE CONSISTENT_GETS_FROM_CACHE, CASE WHEN (SUM(stat.CONSISTENT_GETS_FROM_CACHE) OVER ()) = 0 THEN 0 ELSE ROUND( stat.CONSISTENT_GETS_FROM_CACHE * 100 / (SUM(stat.CONSISTENT_GETS_FROM_CACHE) OVER ()), 2 ) END CONSISTENT_GETS_FROM_CACHE_PR,
                      stat.SESSION_LOGICAL_READS SESSION_LOGICAL_READS, CASE WHEN (SUM(stat.SESSION_LOGICAL_READS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.SESSION_LOGICAL_READS * 100 / (SUM(stat.SESSION_LOGICAL_READS) OVER ()), 2 ) END SESSION_LOGICAL_READS_PR,
                      stat.CONSISTENT_CHANGES CONSISTENT_CHANGES,CASE WHEN (SUM(stat.CONSISTENT_CHANGES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.CONSISTENT_CHANGES * 100 / (SUM(stat.CONSISTENT_CHANGES) OVER ()), 2 ) END CONSISTENT_CHANGES_PR,
                      stat.DB_BLOCK_CHANGES DB_BLOCK_CHANGES, CASE WHEN (SUM(stat.DB_BLOCK_CHANGES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.DB_BLOCK_CHANGES * 100 / (SUM(stat.DB_BLOCK_CHANGES) OVER ()), 2 ) END DB_BLOCK_CHANGES_PR,
                      stat.CPU_USED_BY_SESSION CPU_USED_BY_SESSION, CASE WHEN (SUM(stat.CPU_USED_BY_SESSION) OVER ()) = 0 THEN 0 ELSE ROUND( stat.CPU_USED_BY_SESSION * 100 / (SUM(stat.CPU_USED_BY_SESSION) OVER ()), 2 ) END CPU_USED_BY_SESSION_PR,
                      stat.PARSE_COUNT_HARD PARSE_COUNT_HARD, CASE WHEN (SUM(stat.PARSE_COUNT_HARD) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PARSE_COUNT_HARD * 100 / (SUM(stat.PARSE_COUNT_HARD) OVER ()), 2 ) END PARSE_COUNT_HARD_PR,
                      stat.PARSE_COUNT_TOTAL PARSE_COUNT_TOTAL, CASE WHEN (SUM(stat.PARSE_COUNT_TOTAL) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PARSE_COUNT_TOTAL * 100 / (SUM(stat.PARSE_COUNT_TOTAL) OVER ()), 2 ) END PARSE_COUNT_TOTAL_PR,
                      stat.PARSE_TIME_CPU PARSE_TIME_CPU, CASE WHEN (SUM(stat.PARSE_TIME_CPU) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PARSE_TIME_CPU * 100 / (SUM(stat.PARSE_TIME_CPU) OVER ()), 2 ) END PARSE_TIME_CPU_PR,
                      stat.PARSE_TIME_ELAPSED PARSE_TIME_ELAPSED, CASE WHEN (SUM(stat.PARSE_TIME_ELAPSED) OVER ()) = 0 THEN 0 ELSE ROUND( stat.PARSE_TIME_ELAPSED * 100 / (SUM(stat.PARSE_TIME_ELAPSED) OVER ()), 2 ) END PARSE_TIME_ELAPSED_PR,
                      stat.RECURSIVE_CALLS RECURSIVE_CALLS, CASE WHEN (SUM(stat.RECURSIVE_CALLS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.RECURSIVE_CALLS * 100 / (SUM(stat.RECURSIVE_CALLS) OVER ()), 2 ) END RECURSIVE_CALLS_PR,
                      stat.RECURSIVE_CPU_USAGE RECURSIVE_CPU_USAGE, CASE WHEN (SUM(stat.RECURSIVE_CPU_USAGE) OVER ()) = 0 THEN 0 ELSE ROUND( stat.RECURSIVE_CPU_USAGE * 100 / (SUM(stat.RECURSIVE_CPU_USAGE) OVER ()), 2 ) END RECURSIVE_CPU_USAGE_PR,
                      stat.EXECUTE_COUNT EXECUTE_COUNT, CASE WHEN (SUM(stat.EXECUTE_COUNT) OVER ()) = 0 THEN 0 ELSE ROUND( stat.EXECUTE_COUNT * 100 / (SUM(stat.EXECUTE_COUNT) OVER ()), 2 ) END EXECUTE_COUNT_PR,
                      stat.USER_CALLS USER_CALLS, CASE WHEN (SUM(stat.USER_CALLS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.USER_CALLS * 100 / (SUM(stat.USER_CALLS) OVER ()), 2 ) END USER_CALLS_PR,
                      stat.USER_COMMITS USER_COMMITS, CASE WHEN (SUM(stat.USER_COMMITS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.USER_COMMITS * 100 / (SUM(stat.USER_COMMITS) OVER ()), 2 ) END USER_COMMITS_PR,
                      stat.USER_ROLLBACKS USER_ROLLBACKS, CASE WHEN (SUM(stat.USER_ROLLBACKS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.USER_ROLLBACKS * 100 / (SUM(stat.USER_ROLLBACKS) OVER ()), 2 ) END USER_ROLLBACKS_PR,
                      stat.COMMIT_BATCH_PERFORMED COMMIT_BATCH_PERFORMED, CASE WHEN (SUM(stat.COMMIT_BATCH_PERFORMED) OVER ()) = 0 THEN 0 ELSE ROUND( stat.COMMIT_BATCH_PERFORMED * 100 / (SUM(stat.COMMIT_BATCH_PERFORMED) OVER ()), 2 ) END COMMIT_BATCH_PERFORMED_PR,
                      stat.COMMIT_BATCH_REQUESTED COMMIT_BATCH_REQUESTED, CASE WHEN (SUM(stat.COMMIT_BATCH_REQUESTED) OVER ()) = 0 THEN 0 ELSE ROUND( stat.COMMIT_BATCH_REQUESTED * 100 / (SUM(stat.COMMIT_BATCH_REQUESTED) OVER ()), 2 ) END COMMIT_BATCH_REQUESTED_PR,
                      stat.SQLNET_RECV_BYTES SQLNET_RECV_BYTES, CASE WHEN (SUM(stat.SQLNET_RECV_BYTES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.SQLNET_RECV_BYTES * 100 / (SUM(stat.SQLNET_RECV_BYTES) OVER ()), 2 ) END SQLNET_RECV_BYTES_PR,
                      stat.SQLNET_SENT_BYTES SQLNET_SENT_BYTES, CASE WHEN (SUM(stat.SQLNET_SENT_BYTES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.SQLNET_SENT_BYTES * 100 / (SUM(stat.SQLNET_SENT_BYTES) OVER ()), 2 ) END SQLNET_SENT_BYTES_PR,
                      stat.DBLINK_RECV_BYTES DBLINK_RECV_BYTES, CASE WHEN (SUM(stat.DBLINK_RECV_BYTES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.DBLINK_RECV_BYTES * 100 / (SUM(stat.DBLINK_RECV_BYTES) OVER ()), 2 ) END DBLINK_RECV_BYTES_PR,
                      stat.DBLINK_SENT_BYTES DBLINK_SENT_BYTES, CASE WHEN (SUM(stat.DBLINK_SENT_BYTES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.DBLINK_SENT_BYTES * 100 / (SUM(stat.DBLINK_SENT_BYTES) OVER ()), 2 ) END DBLINK_SENT_BYTES_PR,
                      stat.SORTS_DISK SORTS_DISK, CASE WHEN (SUM(stat.SORTS_DISK) OVER ()) = 0 THEN 0 ELSE ROUND( stat.SORTS_DISK * 100 / (SUM(stat.SORTS_DISK) OVER ()), 2 ) END SORTS_DISK_PR,
                      stat.SORTS_MEMORY SORTS_MEMORY, CASE WHEN (SUM(stat.SORTS_MEMORY) OVER ()) = 0 THEN 0 ELSE ROUND( stat.SORTS_MEMORY * 100 / (SUM(stat.SORTS_MEMORY) OVER ()), 2 ) END SORTS_MEMORY_PR,
                      stat.SORTS_ROWS SORTS_ROWS, CASE WHEN (SUM(stat.SORTS_ROWS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.SORTS_ROWS * 100 / (SUM(stat.SORTS_ROWS) OVER ()), 2 ) END SORTS_ROWS_PR,
                      stat.WORKAREA_EXEC_MULTIPASS WORKAREA_EXEC_MULTIPASS, CASE WHEN (SUM(stat.WORKAREA_EXEC_MULTIPASS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.WORKAREA_EXEC_MULTIPASS * 100 / (SUM(stat.WORKAREA_EXEC_MULTIPASS) OVER ()), 2 ) END WORKAREA_EXEC_MULTIPASS_PR,
                      stat.WORKAREA_EXEC_ONEPASS WORKAREA_EXEC_ONEPASS, CASE WHEN (SUM(stat.WORKAREA_EXEC_ONEPASS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.WORKAREA_EXEC_ONEPASS * 100 / (SUM(stat.WORKAREA_EXEC_ONEPASS) OVER ()), 2 ) END WORKAREA_EXEC_ONEPASS_PR,
                      stat.WORKAREA_EXEC_OPTIMAL WORKAREA_EXEC_OPTIMAL, CASE WHEN (SUM(stat.WORKAREA_EXEC_OPTIMAL) OVER ()) = 0 THEN 0 ELSE ROUND( stat.WORKAREA_EXEC_OPTIMAL * 100 / (SUM(stat.WORKAREA_EXEC_OPTIMAL) OVER ()), 2 ) END WORKAREA_EXEC_OPTIMAL_PR,
                      stat.APPLICATION_WAIT_TIME APPLICATION_WAIT_TIME, CASE WHEN (SUM(stat.APPLICATION_WAIT_TIME) OVER ()) = 0 THEN 0 ELSE ROUND( stat.APPLICATION_WAIT_TIME * 100 / (SUM(stat.APPLICATION_WAIT_TIME) OVER ()), 2 ) END APPLICATION_WAIT_TIME_PR,
                      stat.CONCURRENCY_WAIT_TIME CONCURRENCY_WAIT_TIME, CASE WHEN (SUM(stat.CONCURRENCY_WAIT_TIME) OVER ()) = 0 THEN 0 ELSE ROUND( stat.CONCURRENCY_WAIT_TIME * 100 / (SUM(stat.CONCURRENCY_WAIT_TIME) OVER ()), 2 ) END CONCURRENCY_WAIT_TIME_PR,
                      stat.FILE_IO_WAIT_TIME , CASE WHEN (SUM(stat.FILE_IO_WAIT_TIME) OVER ()) = 0 THEN 0 ELSE ROUND( stat.FILE_IO_WAIT_TIME * 100 / (SUM(stat.FILE_IO_WAIT_TIME) OVER ()), 2 ) END FILE_IO_WAIT_TIME_PR,
                      stat.ENQUEUE_REQUESTS ENQUEUE_REQUESTS, CASE WHEN (SUM(stat.ENQUEUE_REQUESTS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.ENQUEUE_REQUESTS * 100 / (SUM(stat.ENQUEUE_REQUESTS) OVER ()), 2 ) END ENQUEUE_REQUESTS_PR,
                      stat.ENQUEUE_TIMEOUTS ENQUEUE_TIMEOUTS, CASE WHEN (SUM(stat.ENQUEUE_TIMEOUTS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.ENQUEUE_TIMEOUTS * 100 / (SUM(stat.ENQUEUE_TIMEOUTS) OVER ()), 2 ) END ENQUEUE_TIMEOUTS_PR,
                      stat.ENQUEUE_WAITS ENQUEUE_WAITS, CASE WHEN (SUM(stat.ENQUEUE_WAITS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.ENQUEUE_WAITS * 100 / (SUM(stat.ENQUEUE_WAITS) OVER ()), 2 ) END ENQUEUE_WAITS_PR,
                      stat.LOB_READS LOB_READS, CASE WHEN (SUM(stat.LOB_READS) OVER ()) = 0 THEN 0 ELSE ROUND( stat.LOB_READS * 100 / (SUM(stat.LOB_READS) OVER ()), 2 ) END LOB_READS_PR,
                      stat.LOB_WRITES LOB_WRITES, CASE WHEN (SUM(stat.LOB_WRITES) OVER ()) = 0 THEN 0 ELSE ROUND( stat.LOB_WRITES * 100 / (SUM(stat.LOB_WRITES) OVER ()), 2 ) END LOB_WRITES_PR,
                      stat.REDO_BLOCK_WRITTEN REDO_BLOCK_WRITTEN, CASE WHEN (SUM(stat.REDO_BLOCK_WRITTEN) OVER ()) = 0 THEN 0 ELSE ROUND( stat.REDO_BLOCK_WRITTEN * 100 / (SUM(stat.REDO_BLOCK_WRITTEN) OVER ()), 2 ) END REDO_BLOCK_WRITTEN_PR,
                      stat.REDO_SIZE , CASE WHEN (SUM(stat.REDO_SIZE) OVER ()) = 0 THEN 0 ELSE ROUND( stat.REDO_SIZE * 100 / (SUM(stat.REDO_SIZE) OVER ()), 2 ) END REDO_SIZE_PR,
                      stat.SESSION_PGA_MEMORY SESSION_PGA_MEMORY, CASE WHEN (SUM(stat.SESSION_PGA_MEMORY) OVER ()) = 0 THEN 0 ELSE ROUND( stat.SESSION_PGA_MEMORY * 100 / (SUM(stat.SESSION_PGA_MEMORY) OVER ()), 2 ) END SESSION_PGA_MEMORY_PR,
                      stat.SESSION_PGA_MEMORY_MAX SESSION_PGA_MEMORY_MAX, CASE WHEN (SUM(stat.SESSION_PGA_MEMORY_MAX) OVER ()) = 0 THEN 0 ELSE ROUND( stat.SESSION_PGA_MEMORY_MAX * 100 / (SUM(stat.SESSION_PGA_MEMORY_MAX) OVER ()), 2 ) END SESSION_PGA_MEMORY_MAX_PR,
                      stat.SESSION_CONNECT_TIME SESSION_CONNECT_TIME, CASE WHEN (SUM(stat.SESSION_CONNECT_TIME) OVER ()) = 0 THEN 0 ELSE ROUND( stat.SESSION_CONNECT_TIME * 100 / (SUM(stat.SESSION_CONNECT_TIME) OVER ()), 2 ) END SESSION_CONNECT_TIME_PR
                      from v$session s, v$process p, table(bestat_util.F_SESSION_WITH_STATS) stat
                      where s.paddr = p.addr AND stat.sid = s.sid AND stat.SERIAL_N = s.SERIAL# ' . $where_ext . " order by $pv{order_field}" ; }
# не доделано для статистик из коллектора
else { $request = 'select CASE p.BACKGROUND WHEN \'1\' THEN \'BGR\' ELSE \'FRG\' END BACKGROUND,s.STATUS,s.LOCKWAIT,s.SID,s.SERIAL# SERIAL,TO_CHAR(s.LOGON_TIME,\'YYYY-MM-DD HH24:MI:SS\'),(SYSDATE - s.LOGON_TIME) SESSION_DURATION,s.USERNAME,s.OSUSER,s.PROCESS,s.TERMINAL,s.PROGRAM,p.USERNAME,p.TERMINAL,p.PROGRAM,p.SPID from BESTAT_SESSIONS s, BESTAT_PROCESSES p where s.paddr = p.addr AND ' . "s.POINT = $pv{srcptr} AND p.POINT = $pv{srcptr} " . $where_ext . "order by $pv{order_field} asc" ; }
my $sth = $dbh->prepare($request) ; $sth->execute() ;

# вывести непосредственно контент
print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
print "<TR><TD CLASS=\"HEAD\" COLSPAN=\"11\">Сессия</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"4\">Серверный процесс</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"10\">Физические чтения</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"12\">Физические записи</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"14\">Логические чтения</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"4\">Логические записи</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">Утилизация CPU</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"24\">Обработки SQL</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"4\">Обмен SQLNet</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"4\">Обмен BD link</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"12\">Сортировки</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"12\">Ожидания</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"4\">LOB</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"4\">REDO</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"4\">PGA</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">Общие</TD>
           </TR>" ;

# второй уровень заголовков
print "<TR><TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("p.BACKGROUND","Тип") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("s.STATUS","Статус") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("s.LOCKWAIT","Ожидание блокировки") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("s.SID","ID сессии (SID,SERIAL#)") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("s.LOGON_TIME","Начало сессии") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("SESSION_DURATION","Длительность сессии") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("s.USERNAME","Oracle user") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("s.OSUSER","ОС user") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("s.PROCESS","OS&nbsp;PID client") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("s.TERMINAL","session TERMINAL") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("s.PROGRAM","session program") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("p.USERNAME","process user name") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("p.TERMINAL","process terminal") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("p.PROGRAM","process program") ;
print "    <TD CLASS=\"HEAD\" ROWSPAN=\"2\">" ; print_head_ancor("p.SPID","OS&nbsp;PID server") ;
print "    <TD CLASS=\"HEAD\" COLSPAN=\"4\">всего</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">прямые</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">прямые LOB</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">прямые TEMP</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"6\">всего</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">прямые</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">прямые LOB</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">прямые TEMP</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">DB BLOCK GETS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">DB BLOCK GETS DIR</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">DB BLOCK GETS FROM CACHE</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">CONSISTENT GETS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">CONSISTENT GETS DIRECT</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">CONSISTENT GETS FROM CACHE</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">SESSION LOGICAL READS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">CONSISTENT CHANGES</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">DB BLOCK CHANGES</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">CPU USED BY SESSION</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">PARSE COUNT HARD</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">PARSE COUNT TOTAL</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">PARSE TIME CPU</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">PARSE TIME ELAPSED</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">RECURSIVE CALLS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">RECURSIVE CPU USAGE</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">EXECUTE COUNT</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">USER CALLS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">USER COMMITS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">USER ROLLBACKS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">COMMIT BATCH PERFORMED</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">COMMIT BATCH REQUESTED</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">SQLNET RECV BYTES</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">SQLNET SENT BYTES</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">DBLINK RECV BYTES</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">DBLINK SENT BYTES</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">SORTS DISK</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">SORTS MEMORY</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">SORTS ROWS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">WORKAREA EXEC MULTIPASS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">WORKAREA EXEC ONEPASS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">WORKAREA EXEC OPTIMAL</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">APPLICATION WAIT TIME</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">CONCURRENCY WAIT TIME</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">FILE IO WAIT TIME</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">ENQUEUE REQUESTS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">ENQUEUE TIMEOUTS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">ENQUEUE WAITS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">LOB READS</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">LOB WRITES</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">REDO BLOCK WRITTEN</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">REDO SIZE</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">SESSION PGA MEMORY</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">SESSION PGA MEMORY MAX</TD>
           <TD CLASS=\"HEAD\" COLSPAN=\"2\">SESSION CONNECT TIME</TD>
           </TR>" ;


# третий уровень заголовков
print "<TR><TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_READS_BYTES","байт") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_READS_BYTES_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_READS","операций") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_READS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_READS_DIRECT","операций") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_READS_DIRECT_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_READS_DIR_LOB","операций") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_READS_DIR_LOB_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_READS_DIR_TEMP","операций") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_READS_DIR_TEMP_PR","%") ;

print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITE_BYTES","байт") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITE_BYTES_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITE_TOTAL_BYTES","TOTAL&nbsp;байт") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITE_TOTAL_BYTES_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITES","операций") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITES_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITES_DIRECT","операций") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITES_DIRECT_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITES_DIR_LOB","операций") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITES_DIR_LOB_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITES_DIR_TEMP","операций") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PHYS_WRITES_DIR_TEMP_PR","%") ;

print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DB_BLOCK_GETS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DB_BLOCK_GETS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DB_BLOCK_GETS_DIR","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DB_BLOCK_GETS_DIR_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DB_BLOCK_GETS_FROM_CACHE","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DB_BLOCK_GETS_FROM_CACHE_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CONSISTENT_GETS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CONSISTENT_GETS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CONSISTENT_GETS_DIRECT","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CONSISTENT_GETS_DIRECT_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CONSISTENT_GETS_FROM_CACHE","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CONSISTENT_GETS_FROM_CACHE_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SESSION_LOGICAL_READS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SESSION_LOGICAL_READS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CONSISTENT_CHANGES","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CONSISTENT_CHANGES_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DB_BLOCK_CHANGES","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DB_BLOCK_CHANGES_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CPU_USED_BY_SESSION","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CPU_USED_BY_SESSION_PR","%") ;

print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PARSE_COUNT_HARD","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PARSE_COUNT_HARD_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PARSE_COUNT_TOTAL","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PARSE_COUNT_TOTAL_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PARSE_TIME_CPU","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PARSE_TIME_CPU_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PARSE_TIME_ELAPSED","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("PARSE_TIME_ELAPSED_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("RECURSIVE_CALLS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("RECURSIVE_CALLS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("RECURSIVE_CPU_USAGE","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("RECURSIVE_CPU_USAGE_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("EXECUTE_COUNT","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("EXECUTE_COUNT_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("USER_CALLS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("USER_CALLS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("USER_COMMITS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("USER_COMMITS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("USER_ROLLBACKS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("USER_ROLLBACKS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("COMMIT_BATCH_PERFORMED","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("COMMIT_BATCH_PERFORMED_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("COMMIT_BATCH_REQUESTED","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("COMMIT_BATCH_REQUESTED_PR","%") ;

print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SQLNET_RECV_BYTES","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SQLNET_RECV_BYTES_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SQLNET_SENT_BYTES","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SQLNET_SENT_BYTES_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DBLINK_RECV_BYTES","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DBLINK_RECV_BYTES_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DBLINK_SENT_BYTES","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("DBLINK_SENT_BYTES_PR","%") ;

print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SORTS_DISK","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SORTS_DISK_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SORTS_MEMORY","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SORTS_MEMORY_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SORTS_ROWS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SORTS_ROWS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("WORKAREA_EXEC_MULTIPASS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("WORKAREA_EXEC_MULTIPASS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("WORKAREA_EXEC_ONEPASS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("WORKAREA_EXEC_ONEPASS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("WORKAREA_EXEC_OPTIMAL","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("WORKAREA_EXEC_OPTIMAL_PR","%") ;

print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("APPLICATION_WAIT_TIME","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("APPLICATION_WAIT_TIME_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CONCURRENCY_WAIT_TIME","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("CONCURRENCY_WAIT_TIME_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("FILE_IO_WAIT_TIME","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("FILE_IO_WAIT_TIME_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("ENQUEUE_REQUESTS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("ENQUEUE_REQUESTS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("ENQUEUE_TIMEOUTS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("ENQUEUE_TIMEOUTS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("ENQUEUE_WAITS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("ENQUEUE_WAITS_PR","%") ;

print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("LOB_READS","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("LOB_READS_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("LOB_WRITES","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("LOB_WRITES_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("REDO_BLOCK_WRITTEN","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("REDO_BLOCK_WRITTEN_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("REDO_SIZE","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("REDO_SIZE_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SESSION_PGA_MEMORY","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SESSION_PGA_MEMORY_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SESSION_PGA_MEMORY_MAX","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SESSION_PGA_MEMORY_MAX_PR","%") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SESSION_CONNECT_TIME","единиц") ;
print "    <TD CLASS=\"HEAD\">" ; print_head_ancor("SESSION_CONNECT_TIME_PR","%") ;
print "</TR>" ;

$session_count_all = 0 ;
while (my ($background,$status,$lockwait,$sid,$serial,$logon_time,$session_duration,$username,$osuser,$process,$s_terminal,$s_program,$p_username,
          $p_terminal,$p_program,$spid,$phys_reads_bytes, $phys_reads_bytes_pr, $phys_reads, $phys_reads_pr, $phys_read_direct, $phys_read_direct_pr,
          $phys_reads_dir_lob, $phys_reads_dir_lob_pr, $phys_reads_dir_temp, $phys_reads_dir_temp_pr, $phys_write_bytes, $phys_write_bytes_pr,
          $phys_write_total_bytes, $phys_write_total_bytes_pr, $phys_writes, $phys_writes_pr, $phys_writes_direct, $phys_writes_direct_pr,
          $phys_writes_dir_lob, $phys_writes_dir_lob_pr, $phys_writes_dir_temp, $phys_writes_dir_temp_pr, $db_block_gets, $db_block_gets_pr,
          $db_block_gets_dir, $db_block_gets_dir_pr, $db_block_gets_from_cache, $db_block_gets_from_cache_pr, $consistent_gets, $consistent_gets_pr,
          $consistent_gets_direct, $consistent_gets_direct_pr, $consistent_gets_from_cache, $consistent_gets_from_cache_pr,
          $session_logical_reads, $session_logical_reads_pr, $consistent_changes, $consistent_changes_pr, $db_block_changes, $db_block_changes_pr,
          $cpu_used_by_session, $cpu_used_by_session_pr, $parse_count_hard, $parse_count_hard_pr, $parse_count_total, $parse_count_total_pr,
          $parse_time_cpu, $parse_time_cpu_pr, $parse_time_elapsed, $parse_time_elapsed_pr, $recursive_calls, $recursive_calls_pr,
          $recursive_cpu_usage, $recursive_cpu_usage_pr, $execute_count, $execute_count_pr, $user_calls, $user_calls_pr,
          $user_commits, $user_commits_pr, $user_rollbacks, $user_rollbacks_pr, $commit_batch_performed, $commit_batch_performed_pr,
          $commit_batch_requested, $commit_batch_requested_pr, $sqlnet_recv_bytes, $sqlnet_recv_bytes_pr, $sqlnet_sent_bytes, $sqlnet_sent_bytes_pr,
          $dblibk_recv_bytes, $dblibk_recv_bytes_pr, $dblibk_sent_bytes, $dblibk_sent_bytes_pr, $sorts_disk, $sorts_disk_pr, $sorts_memory, $sorts_memory_pr,
          $sorts_row, $sorts_row_pr, $workarea_exec_multipass, $workarea_exec_multipass_pr, $workarea_exec_optimal, $workarea_exec_optimal_pr, 
          $application_wait_time, $application_wait_time_pr, $concerrency_wait_time, $concerrency_wait_time_pr, $file_io_wait_time, $file_io_wait_time_pr,
          $enqueue_requests, $enqueue_requests_pr, $enqueue_timeouts, $enqueue_timeouts_pr, $lob_reads, $lob_reads_pr, $lob_writes, $lob_writes_pr, 
          $redo_block_writen, $redo_block_writen_pr, $redo_size, $redo_size_pr, $session_sga_memory, $session_sga_memory_pr,
          $session_sga_memory_max, $session_sga_memory_max_pr, $session_connect_time, $session_connect_time_pr) = $sth->fetchrow_array() ) {
      if ( $session_count_by_status{$status} eq "" || $session_count_by_status{$status} < 1 ) { $session_count_by_status{$status} = 0 ; } 
      $session_count_all += 1 ; $session_count_by_status{$status} += 1 ;
      if ( $background eq "" ) { $background = "&nbsp;" ; }
      if ( $status eq "" ) { $status = "&nbsp;" ; }
      if ( $lockwait eq "" ) { $lockwait = "-" ; }
      if ( $id eq "" ) { $id = "&nbsp;" ; }
      if ( $logon_time eq "" ) { $logon_time = "&nbsp;" ; } $logon_time =~ s/\s+/&nbsp;/g ;

      if ( $session_duration eq "" ) { $session_duration = "&nbsp;" ; } 
 
     my $dur_sec_all = 0, $dur_day = 0, $dur_hour = 0, $dur_min = 0, $dur_sec = 0 ;

# --- вытащить количество дней
      $dur_day = int($session_duration) ;
# --- пересчитать длительность сессии в секундах
      $dur_sec_all = $session_duration * 86400 ;
# --- вытащить количество секунд (количество секунд - целое количество минут * 60)
      $dur_sec = $dur_sec_all - int($dur_sec_all / 60) * 60 ; 
# --- вытащить количество минут (количество минут - целое количество часов * 60)
      $dur_min = int($dur_sec_all / 60) - int($dur_sec_all / 3600) * 60 ;
# --- вытащить количество часов (количество часов - целое количество дней * 24
      $dur_hour = ($dur_sec_all / 3600) - int($dur_sec_all / 86400) * 24 ;

      if ( $username eq "" ) { $username = "&nbsp;" ; }
      if ( $osuser eq "" ) { $osuser = "&nbsp;" ; }
      if ( $process eq "" ) { $process = "&nbsp;" ; }
      if ( $spid eq "" ) { $spid = "&nbsp;" ; }
      if ( $s_terminal eq "" ) { $s_terminal = "&nbsp;" ; } $s_terminal =~ s/\s+/&nbsp;/g ; 
      if ( $s_program eq "" ) { $s_program = "&nbsp;" ; } $s_program =~ s/\s+/&nbsp;/g ; 
      if ( $p_username eq "" ) { $p_username = "&nbsp;" ; } $p_username =~ s/\s+/&nbsp;/g ; 
      if ( $p_terminal eq "" ) { $p_terminal = "&nbsp;" ; } $p_terminal =~ s/\s+/&nbsp;/g ; 
      if ( $p_program eq "" ) { $p_program = "&nbsp;" ; } $p_program =~ s/\s+/&nbsp;/g ; 
      printf("<TR><TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\"><A HREF=\"$base_url/cgi/get_session_info.cgi?sid=%d&serial=%d\" TARGET=\"cont\">%d,%d</A></TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%d&nbsp;day(s)&nbsp;%02d:%02d:%02d</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>",$background,$status,$lockwait,$sid,$serial,$sid,$serial,$logon_time,$dur_day,$dur_hour,$dur_min,$dur_sec,$username,$osuser,$process,$s_terminal,$s_program,$p_username,$p_terminal,$p_program,$spid) ;

# вывести данные о физических чтениях и записях
      printf("<TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>",&show_razryads($phys_reads_bytes), $phys_reads_bytes_pr, &show_razryads($phys_reads), $phys_reads_pr,
                           &show_razryads($phys_read_direct), $phys_read_direct_pr, &show_razryads($phys_reads_dir_lob), $phys_reads_dir_lob_pr,
                           &show_razryads($phys_reads_dir_temp), $phys_reads_dir_temp_pr, &show_razryads($phys_write_bytes), $phys_write_bytes_pr,
                           &show_razryads($phys_write_total_bytes), $phys_write_total_bytes_pr, &show_razryads($phys_writes), $phys_writes_pr,
                           &show_razryads($phys_writes_direct), $phys_writes_direct_pr, &show_razryads($phys_writes_dir_lob), $phys_writes_dir_lob_pr,
                           &show_razryads($phys_writes_dir_temp), $phys_writes_dir_temp_pr) ;

# вывести данные об операциях логических чтений, записи и утилизации CPU
      printf("<TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>", &show_razryads($db_block_gets), $db_block_gets_pr, 
                  &show_razryads($db_block_gets_dir), $db_block_gets_dir_pr, &show_razryads($db_block_gets_from_cache), $db_block_gets_from_cache_pr, 
                  &show_razryads($consistent_gets), $consistent_gets_pr, &show_razryads($consistent_gets_direct), $consistent_gets_direct_pr,
                  &show_razryads($consistent_gets_from_cache), $consistent_gets_from_cache_pr, 
                  &show_razryads($session_logical_reads), $session_logical_reads_pr, &show_razryads($consistent_changes), $consistent_changes_pr,
                  &show_razryads($db_block_changes), $db_block_changes_pr, &show_razryads($cpu_used_by_session), $cpu_used_by_session_pr) ;

# вывести данные об обработках SQL 
      printf("<TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>", &show_razryads($parse_count_hard), $parse_count_hard_pr, 
                  &show_razryads($parse_count_total), $parse_count_total_pr, &show_razryads($parse_time_cpu), $parse_time_cpu_pr,
                  &show_razryads($parse_time_elapsed), $parse_time_elapsed_pr, &show_razryads($recursive_calls), $recursive_calls_pr,
                  &show_razryads($recursive_cpu_usage), $recursive_cpu_usage_pr, &show_razryads($execute_count), $execute_count_pr, 
                  &show_razryads($user_calls), $user_calls_pr, &show_razryads($user_commits), $user_commits_pr, 
                  &show_razryads($user_rollbacks), $user_rollbacks_pr, &show_razryads($commit_batch_performed), $commit_batch_performed_pr,
                  &show_razryads($commit_batch_requested), $commit_batch_requested_pr) ;

# вывести данные о SQLNet и DB links
      printf("<TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>",
                  &show_razryads($sqlnet_recv_bytes), $sqlnet_recv_bytes_pr, &show_razryads($sqlnet_sent_bytes), $sqlnet_sent_bytes_pr,
                  &show_razryads($dblibk_recv_bytes), $dblibk_recv_bytes_pr, &show_razryads($dblibk_sent_bytes), $dblibk_sent_bytes_pr) ;

# вывести данные о сортировках
      printf("<TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>",
                  &show_razryads($sorts_disk), $sorts_disk_pr, &show_razryads($sorts_memory), $sorts_memory_pr, &show_razryads($sorts_row), $sorts_row_pr,
                  &show_razryads($workarea_exec_multipass), $workarea_exec_multipass_pr, &show_razryads($workarea_exec_optimal), $workarea_exec_optimal_pr) ;

# вывести данные об ожиданиях
      printf("<TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>", 
                  &show_razryads($application_wait_time), $application_wait_time_pr, &show_razryads($concerrency_wait_time), $concerrency_wait_time_pr,
                  &show_razryads($file_io_wait_time), $file_io_wait_time_pr, &show_razryads($enqueue_requests), $enqueue_requests_pr,
                  &show_razryads($enqueue_timeouts), $enqueue_timeouts_pr) ;

# вывести данные о LOB
      printf("<TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>", 
                  &show_razryads($lob_reads), $lob_reads_pr, &show_razryads($lob_writes), $lob_writes_pr) ;

# вывести данные о REDO
      printf("<TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>", 
                  &show_razryads($redo_block_writen), $redo_block_writen_pr, &show_razryads($redo_size), $redo_size_pr) ;

# вывести данные о PGA
      printf("<TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>", 
                  &show_razryads($session_sga_memory), $session_sga_memory_pr, &show_razryads($session_sga_memory_max), $session_sga_memory_max_pr) ;

# вывести данные прочие
      printf("<TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%0.2f</TD>",
                  &show_razryads($session_connect_time), $session_connect_time_pr) ;

      print "</TR>\n" ;
      }
print "<TR><TD COLSPAN=\"127\">
           <TABLE BORDER=\"0\"><TR><TD>Сессий всего:</TD><TD>$session_count_all, в т.ч.</TD></TR>" ;
@session_count_by_status_keys_nosort = keys %session_count_by_status ; @session_count_by_status_keys_sort = sort @session_count_by_status_keys_nosort ;
for ($i=0;$i<=$#session_count_by_status_keys_sort;$i++) {
    print "<TR><TD>&nbsp;&nbsp;&nbsp;$session_count_by_status_keys_sort[$i]:</TD><TD>$session_count_by_status{$session_count_by_status_keys_sort[$i]}</TD></TR>" ;
    }
print "</TABLE></TD></TR>" ;
print "</TABLE>" ;

# это конец контейнерной таблицы контента
print "</TD></TR></TABLE>" ;

# это конец общей контейнерной таблицы
print "</TD></TR></TABLE>" ;

$sth->finish();
$dbh->disconnect();                                        

if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n<BR>$request</P>\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
