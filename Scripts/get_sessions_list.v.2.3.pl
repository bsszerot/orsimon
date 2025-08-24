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

use DBI;
require "/var/www/oracle/cgi/omon.cfg" ;

# - ДЛЯ ВСЕХ МОДУЛЕЙ - инициализировать значения сессии из cookie, если есть, или же использовать значения по умолчанию
$current_connector = "none" ; if ( $ENV{HTTP_COOKIE} =~ /.*[;\s]*current_connector=([^;]+)[;\s]*.*/ ) { $current_connector = $1 ; }
# - вытащить из URL запроса значения уточняющих полей
$pv{order_field} = "s.SID" ;
&get_forms_param() ;

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');

print "Content-Type: text/html\n\n"; 
&print_html_head("Сессии") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_sessions_navigation(1) ;

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

print "<FORM ACTION=\"$base_url/cgi/get_sessions_list.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
print "<TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки не требует обязательного указания дополнительных условий -- </DIV></TD></TR>" ;
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
if ( $pv{srcptr} eq "0" || $pv{srcptr} eq "" ) { $request = 'select CASE p.BACKGROUND WHEN \'1\' THEN \'BGR\' ELSE \'FRG\' END BACKGROUND,s.STATUS,s.LOCKWAIT,s.SID,s.SERIAL# SERIAL,TO_CHAR(s.LOGON_TIME,\'YYYY-MM-DD HH24:MI:SS\'),(SYSDATE - s.LOGON_TIME) as SESSION_DURATION,s.USERNAME,s.OSUSER,s.PROCESS,s.TERMINAL,s.PROGRAM,p.USERNAME,p.TERMINAL,p.PROGRAM,p.SPID from v$session s, v$process p where s.paddr = p.addr ' . $where_ext . " order by $pv{order_field} asc" ; }
else { $request = 'select CASE p.BACKGROUND WHEN \'1\' THEN \'BGR\' ELSE \'FRG\' END BACKGROUND,s.STATUS,s.LOCKWAIT,s.SID,s.SERIAL# SERIAL,TO_CHAR(s.LOGON_TIME,\'YYYY-MM-DD HH24:MI:SS\'),(SYSDATE - s.LOGON_TIME) SESSION_DURATION,s.USERNAME,s.OSUSER,s.PROCESS,s.TERMINAL,s.PROGRAM,p.USERNAME,p.TERMINAL,p.PROGRAM,p.SPID from BESTAT_SESSIONS s, BESTAT_PROCESSES p where s.paddr = p.addr AND ' . "s.POINT = $pv{srcptr} AND p.POINT = $pv{srcptr} " . $where_ext . "order by $pv{order_field} asc" ; }
my $sth = $dbh->prepare($request) ; $sth->execute() ;

# вывести непосредственно контент
print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=p.BACKGROUND&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">Тип</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.STATUS&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">Статус</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.LOCKWAIT&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">Ожидание блокировки</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.SID&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">ID сессии (SID,SERIAL#)</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.LOGON_TIME&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">Начало сессии</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=SESSION_DURATION&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">Длительность сессии</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.USERNAME&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">Oracle user</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.OSUSER&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">ОС user</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.PROCESS&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">OS&nbsp;PID client</A></TD>           
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.TERMINAL&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">session TERMINAL</A></TD>           
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=s.PROGRAM&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">session program</A></TD>           
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=p.USERNAME&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">process user name</A></TD>           
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=p.TERMINAL&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">process terminal</A></TD>           
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=p.PROGRAM&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">process program</A></TD>           
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sessions_list.cgi?order_field=p.SPID&srcptr=$pv{srcptr}&sid_filter=$pv{sid_filter}&status_filter=$pv{status_filter}&user_filter=$pv{user_filter}&is_view_bgr=$pv{is_view_bgr}\" TARGET=\"cont\">OS&nbsp;PID server</A></TD>
           </TR>" ;

$session_count_all = 0 ;
while (my ($background,$status,$lockwait,$sid,$serial,$logon_time,$session_duration,$username,$osuser,$process,$s_terminal,$s_program,$p_username,$p_terminal,$p_program,$spid) = $sth->fetchrow_array() ) {
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
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  </TR>\n",$background,$status,$lockwait,$sid,$serial,$sid,$serial,$logon_time,$dur_day,$dur_hour,$dur_min,$dur_sec,$username,$osuser,$process,$s_terminal,$s_program,$p_username,$p_terminal,$p_program,$spid) ;
      }
print "<TR><TD COLSPAN=\"15\">
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
