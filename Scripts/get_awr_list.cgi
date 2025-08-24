#!/usr/bin/perl

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

# (C) 2016 OrSiMON BESST (Monitor of operation system Unix/Linux ans rdbms Oracle from Belonin Sergey Stanislav)
# author Belonin Sergey Stanislav
# license of product - public license GPL v.3
# do not use if not agree license agreement

sub print_awr_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=SPAP_ID\" TARGET=\"cont\">Список снапшотов</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=SPAP_ID\" TARGET=\"cont\">Отдельный отчёт AWR</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=SPAP_ID\" TARGET=\"cont\">Отдельный отчёт ADDM</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=SPAP_ID\" TARGET=\"cont\">Отдельный отчёт ASH</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{5}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=SPAP_ID\" TARGET=\"cont\">Отдельный отчёт SQL</A></TD>
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
$pv{order_field} = "FREE_EXT_PERCENT" ;
&get_forms_param() ;

$ENV{ORACLE_SID} = $current_connector ;

print "Content-Type: text/html\n\n"; 
&print_html_head("Список снапшотов") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_awr_navigation(1) ;

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

print "<FORM ACTION=\"$base_url/cgi/get_segments_utilization.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --</DIV></TD></TR>" ;
####&print_select_data_source() ;
print "<TR><TD>&nbsp;Владелец: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"owner_filter\" VALUE=\"$pv{owner_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Имя&nbsp;содержит: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"name_filter\" VALUE=\"$pv{name_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Тип&nbsp;сегмента: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"type_filter\" VALUE=\"$pv{type_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Табличные&nbsp;пространства: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"tbs_filter\" VALUE=\"$pv{tbs_filter}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD COLSPAN=\"2\">
       <INPUT TYPE=\"hidden\" NAME=\"order_field\" VALUE=\"$pv{order_field}\">
       <INPUT TYPE=\"hidden\" NAME=\"is_view_sources\" VALUE=\"$pv{is_view_sources}\"></TD></TR>
       <INPUT TYPE=\"hidden\" NAME=\"isfirst\" VALUE=\"no\">
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

$request = "select SNAP_ID, DBID, INSTANCE_NUMBER, TO_CHAR(STARTUP_TIME, 'YYYY-MM-DD HH24:MI:SS'),
            TO_CHAR(BEGIN_INTERVAL_TIME, 'YYYY-MM-DD HH24:MI:SS'), TO_CHAR(END_INTERVAL_TIME, 'YYYY-MM-DD HH24:MI:SS'),
            FLUSH_ELAPSED, SNAP_LEVEL, '---'
            from dba_hist_snapshot order by SNAP_ID desc" ;
   my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
   my $sth = $dbh->prepare($request) ; $sth->execute() ;
   print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
   print "<TR><TD CLASS=\"HEAD\" COLSPAN=\"2\">Диапазон&nbsp;1</TD><TD CLASS=\"HEAD\" COLSPAN=\"2\">Диапазон&nbsp;2</TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=DBID&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">DB ID</A></TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=INSTANCE_NUMBER&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">INSTANCE#</A></TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=STARTUP_TIME&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">Старт экземпляра</A></TD>
              <TD ROWSPAN=\"2\" ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=BEGIN_INTERVAL_TIME&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">Начало снапшота</A></TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=END_INTERVAL_TIME&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">Конец снапшота</A></TD>
              <TD ROWSPAN=\"2\" ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=FLUSH_ELAPSEDS&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">FLUSH_ELAPSED</A></TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=SNAP_LEVEL&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">SNAP level</A></TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=CON_IDS&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">CONT ID</A></TD>
              </TR><TR>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=SNAP_ID&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">start<BR>SNAP ID</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=SNAP_ID&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">stop<BR>SNAP ID</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=SNAP_ID&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">start<BR>SNAP ID</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=SNAP_ID&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&tbs_filter=$pv{tbs_filter}&name_filter=$pv{name_filter}&owner_filter=$pv{owner_filter}&type_filter=$pv{type_filter}\" TARGET=\"cont\">stop<BR>SNAP ID</A></TD>
              </TR>" ;

   $count_all = 0 ;

   while (my ( $SNAP_ID, $DBID, $INSTANCE_NUMBER, $STARTUP_TIME, $BEGIN_INTERVAL_TIME, $END_INTERVAL_TIME, $FLUSH_ELAPSED, $SNAP_LEVEL, $CON_ID ) = $sth->fetchrow_array() ) {
         $count_all += 1 ; $count_by_ts{$tablespace_name} += 1 ;
         $STARTUP_TIME =~ s/\s/&nbsp;/g ; $BEGIN_INTERVAL_TIME =~ s/\s/&nbsp;/g ; $END_INTERVAL_TIME =~ s/\s/&nbsp;/g ;
         printf("<TR><TD CLASS=\"NUMDATA\"><A HREF=\"$base_url/cgi/get_awr_one.cgi?start_snap_id=%d&stop_snap_id=%d&dbid=%s&instance_num=%d\">%d</A></TD>
                     <TD CLASS=\"NUMDATA\"><A HREF=\"$base_url/cgi/get_awr_one.cgi?start_snap_id=%d&stop_snap_id=%d&dbid=%s&instance_num=%d\">%d</A></TD>
                     <TD CLASS=\"NUMDATA\"><A HREF=\"$base_url/cgi/get_awr_one.cgi?start_snap_id=%d&stop_snap_id=%d&dbid=%s&instance_num=%d\">%d</A></TD>
                     <TD CLASS=\"NUMDATA\"><A HREF=\"$base_url/cgi/get_awr_one.cgi?start_snap_id=%d&stop_snap_id=%d&dbid=%s&instance_num=%d\">%d</A></TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     </TR>\n", $SNAP_ID, $SNAP_ID, $DBID, $INSTANCE_NUMBER, $SNAP_ID, $SNAP_ID, $SNAP_ID, $DBID, $INSTANCE_NUMBER, $SNAP_ID, $SNAP_ID, $SNAP_ID, $DBID, $INSTANCE_NUMBER, $SNAP_ID, $SNAP_ID, $SNAP_ID, $DBID, $INSTANCE_NUMBER, $SNAP_ID, $DBID, $INSTANCE_NUMBER, $STARTUP_TIME, $BEGIN_INTERVAL_TIME, $END_INTERVAL_TIME, $FLUSH_ELAPSED, $SNAP_LEVEL, $CON_ID) ;
         }
   $sth->finish() ;
   $dbh->disconnect() ;
# это конец контейнерной таблицы контента
   print "</TD></TR></TABLE>" ;
# это конец общей контейнерной таблицы
   print "</TD></TR></TABLE>" ;
  if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n$request\n" ; }
#   }
#else {
# это конец общей контейнерной таблицы
     print "</TD></TR></TABLE>" ;
#      }

print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
