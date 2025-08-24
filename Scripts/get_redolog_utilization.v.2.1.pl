#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_redologs_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_redolog_group_info.cgi?order_field=GROUPNUM\" TARGET=\"cont\">Журнальные группы</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_redolog_file_info.cgi?order_field=GROUPNUM\" TARGET=\"cont\">Файлы групп</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=POINT\" TARGET=\"cont\">Утилизация</A></TD>
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
$order_field = "" ; $report_type = "" ;
if ( $ENV{REQUEST_METHOD} eq "GET" && $ENV{QUERY_STRING} =~ /^order_field=([^&]*)$/ ) { $order_field = $1 ;
     $order_field =~ s/[\r\n]+//g ; $order_field =~ s/%(..)/pack("c",hex($1))/ge ; }
else {
     if ( $ENV{REQUEST_METHOD} eq "GET" && $ENV{QUERY_STRING} =~ /^report_type=([^&]*)&period=([^&]*)&period_from=([^&]*)&period_to=([^&]*)/ ) { 
        $report_type = $1 ; $report_type =~ s/[\r\n]+//g ; $report_type =~ s/%(..)/pack("c",hex($1))/ge ;
        $period = $2 ; $period =~ s/[\r\n]+//g ; $period =~ s/%(..)/pack("c",hex($1))/ge ;
        $period_from = $3 ; $period_from =~ s/[\r\n]+//g ; $period_from =~ s/%(..)/pack("c",hex($1))/ge ;
        $period_to = $4 ; $period_to =~ s/[\r\n]+//g ; $period_to =~ s/%(..)/pack("c",hex($1))/ge ; }
     else {
          if ( $ENV{REQUEST_METHOD} eq "GET" && $ENV{QUERY_STRING} =~ /^order_field=([^&]*)&report_type=([^&]*)&period=([^&]*)&period_from=([^&]*)&period_to=([^&]*)/ ) { 
             $order_field = $1 ; $order_field =~ s/[\r\n]+//g ; $order_field =~ s/%(..)/pack("c",hex($1))/ge ;
             $report_type = $2 ; $report_type =~ s/[\r\n]+//g ; $report_type =~ s/%(..)/pack("c",hex($1))/ge ;
             $period = $3 ; $period =~ s/[\r\n]+//g ; $period =~ s/%(..)/pack("c",hex($1))/ge ;
             $period_from = $4 ; $period_from =~ s/[\r\n]+//g ; $period_from =~ s/%(..)/pack("c",hex($1))/ge ;
             $period_to = $5 ; $period_to =~ s/[\r\n]+//g ; $period_to =~ s/%(..)/pack("c",hex($1))/ge ; }
          else { die "No valid request data $ENV{QUERY_STRING}" ; }
          }
     }

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
                                 
print "Content-Type: text/html\n\n"; 
&print_html_head("Утилизация оперативных журналов") ;

# добавить определение навигационно - оформительского механизма закладок
&print_redologs_navigation(3) ;

print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">" ;
print "<TR><TD>" ;

# вывести форму выбора отчета ( raw v$log_history, нормализация количества изменений почасово, подневно, понедельно, помесячно )
$is_selected_raw = "" ; if ( $report_type eq "raw" ) { $is_selected_raw = "SELECTED" ;}
$is_selected_perhours = "" ; if ( $report_type eq "perhours" ) { $is_selected_perhours = "SELECTED" ;}
$is_selected_perdays = "" ; if ( $report_type eq "perdays" ) { $is_selected_perdays = "SELECTED" ;}
$is_selected_permonths = "" ; if ( $report_type eq "permonths" ) { $is_selected_permonths = "SELECTED" ;}
$is_checked_period_default = "" ; if ( $period eq "default" || $period eq "" ) { $is_checked_period_default = "CHECKED" ; }
$is_checked_period_manual = "" ; if ( $period eq "manual" ) { $is_checked_period_manual = "CHECKED" ; }
$curr_date = `date "+%Y-%m-%d"` ; chomp($curr_date) ; 
if ( $period_from eq "" ) { $period_from = "$curr_date" ; } if ( $period_to eq "" ) { $period_to = "$curr_date" ; } 
print "<FORM ACTION=\"$base_url/cgi/get_redolog_utilization.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --</DIV></TD></TR>
       <TR><TD>Отчет: </TD>
           <TD STYLE=\"width: 90%\">
               <SELECT NAME=\"report_type\" STYLE=\"width: 100%\" VALUE=\"$report_type\">
               <OPTION VALUE=\"raw\" $is_selected_raw>Записи log_history без обработки</OPTION>
               <OPTION VALUE=\"perhours\" $is_selected_perhours>Изменений за час (текущие сутки по умолчанию)</OPTION>
               <OPTION VALUE=\"perdays\" $is_selected_perdays>Изменений за день (текущий месяц по умолчанию)</OPTION>
               <OPTION VALUE=\"permonths\" $is_selected_permonths>Изменений за месяц (текущий год по умолчанию)</OPTION>
               </SELECT></TD></TR>
       <TR><TD>За период: </TD>
           <TD><INPUT TYPE=\"radio\" NAME=\"period\" VALUE=\"default\" $is_checked_period_default>по умолчанию&nbsp;&nbsp;&nbsp;&nbsp;
               <INPUT TYPE=\"radio\" NAME=\"period\" VALUE=\"manual\" $is_checked_period_manual>указанный (YYYY-MM-DD) с 
                      &nbsp;<INPUT TYPE=\"input\" NAME=\"period_from\" VALUE=\"$period_from\" LENGHT=\"10\">
                      &nbsp;по&nbsp;<INPUT TYPE=\"input\" NAME=\"period_to\" VALUE=\"$period_to\">
       </TD></TR>        
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: center;\"><BR>&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

if ( $report_type eq "raw" || $report_type eq "perhours" || $report_type eq "perdays" || $report_type eq "permonths" ) {
   if ( $report_type eq "raw" ) {
      if ( $order_field eq "" ) { $order_field = "RECID" ; }
# --- вычислить диапазон выводимых значений при необходимости
      $where_class = "" ; if ( $period eq "manual" ) { $where_class = ' WHERE FIRST_TIME >= ' . "TO_DATE('$period_from 00:00:00','YYYY-MM-DD HH24:MI:SS') AND " . 'FIRST_TIME < ' . "TO_DATE('$period_to 23:59:59','YYYY-MM-DD HH24:MI:SS') " ; }
      $request = 'select RECID,STAMP,THREAD# THREAD,SEQUENCE# SEQUENCE,FIRST_CHANGE# FIRST_CHANGE,TO_CHAR(FIRST_TIME,\'YYYY-MM-DD HH:MI:SS\'),NEXT_CHANGE# NEXT_CHANGE, NEXT_CHANGE# - FIRST_CHANGE# AS DIFFERENCE from v$log_history ' . $where_class . 'ORDER BY ' . $order_field ;
      my $sth = $dbh->prepare($request) ;
      $sth->execute();
# вывести непосредственно контент
      print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
      print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=RECID\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">RECID</A></TD>
                 <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=STAMP\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">STAMP</A></TD>
                 <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=THREAD\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">THREAD\#</A></TD>
                 <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=SEQUENCENUM\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">SEQUENCE\#</A></TD>
                 <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=FIRST_CHANGE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">FIRST CHANGE\#</A></TD>
                 <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=FIRST_TIME\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">FIRST TIME</A></TD>
                 <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=NEXT_CHANGE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">NEXT CHANGE\#</A></TD>
                 <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=DIFFERENCE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">DIFF</A></TD>
                 </TR>" ;
      $count_rows = 0 ;
      while (my ($recid,$stamp,$thread,$sequence,$first_change,$first_time,$next_change,$difference) = $sth->fetchrow_array() ) {
            $count_rows += 1 ;
            printf("<TR><TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                    </TR>\n",$recid,$stamp,$thread,&show_razryads($sequence),&show_razryads($first_change),$first_time,&show_razryads($next_change),&show_razryads($difference)) ;
            }
        print "<TR><TD CLASS=\"SZDATA\">Итого</TD><TD CLASS=\"NUMDATA\" COLSPAN=\"7\">$count_rows</TD></TR>\n" ;
        print "</TABLE>" ;
        $sth->finish();
        $dbh->disconnect();
        }
   if ( $report_type eq "perhours" || $report_type eq "perdays" ||$report_type eq "permonths" ) { if ( $order_field eq "" ) { $order_field = "POINT" ; }
# --- вычислить диапазон выводимых значений при необходимости
      $where_class = "" ; if ( $period eq "manual" ) { $where_class = ' WHERE FIRST_TIME >= ' . "TO_DATE('$period_from 00:00:00','YYYY-MM-DD HH24:MI:SS') AND " . 'FIRST_TIME < ' . "TO_DATE('$period_to 23:59:59','YYYY-MM-DD HH24:MI:SS') " ; }
      if ( $report_type eq "perhours" ) { $request = 'SELECT TO_CHAR(FIRST_TIME,\'YYYY-MM-DD HH24\') POINT, SUM(NEXT_CHANGE#-FIRST_CHANGE#) DIFFERENCE FROM V$LOG_HISTORY ' . $where_class . ' GROUP BY TO_CHAR(FIRST_TIME,\'YYYY-MM-DD HH24\') ORDER BY ' . $order_field ; }
      if ( $report_type eq "perdays" ) { $request = 'SELECT TO_CHAR(FIRST_TIME,\'YYYY-MM-DD\') POINT, SUM(NEXT_CHANGE#-FIRST_CHANGE#) DIFFERENCE FROM V$LOG_HISTORY ' . $where_class . ' GROUP BY TO_CHAR(FIRST_TIME,\'YYYY-MM-DD\') ORDER BY ' . $order_field ; }
      if ( $report_type eq "permonths" ) { $request = 'SELECT TO_CHAR(FIRST_TIME,\'YYYY-MM\') POINT, SUM(NEXT_CHANGE#-FIRST_CHANGE#) DIFFERENCE FROM V$LOG_HISTORY ' . $where_class . ' GROUP BY TO_CHAR(FIRST_TIME,\'YYYY-MM\') ORDER BY ' . $order_field ; }

      my $sth = $dbh->prepare($request) ;
      $sth->execute();
# вывести непосредственно контент
      print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
      print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=POINT\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Период выборки</A></TD>
                 <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_redolog_utilization.cgi?order_field=DIFFERENCE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Значение счетчика</A></TD>
                 </TR>" ;
      $count_rows = 0 ;
      while (my ($point,$cnt_value) = $sth->fetchrow_array() ) {
            $count_rows += 1 ;
            printf("<TR><TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                    </TR>\n",$point,&show_razryads($cnt_value)) ;
            }
        print "<TR><TD CLASS=\"SZDATA\">Итого</TD><TD CLASS=\"NUMDATA\">$count_rows</TD></TR>\n" ;
        print "</TABLE>" ;
        $sth->finish();
        $dbh->disconnect();
        }
    }
print "</TD></TR></TABLE>" ;
      
if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n$request\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
