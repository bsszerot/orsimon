#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_system_events_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_system_events.cgi?order_field=NAME\" TARGET=\"cont\">Срез&nbsp;данных<BR>текущих&nbsp;или<BR>из Statspack+</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_system_events_from_collector.cgi?order_field=CR_SNAP_ID,EVENT_N\" TARGET=\"cont\">Коллектор<BR>статистик<BR>событий</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sysevents_top_from_collector.cgi?order_field=SUM_TWM\" TARGET=\"cont\">Аналитика<BR>топовых<BR>событий</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=CR_SNAP_ID\" TARGET=\"cont\">Суммарная<BR>аналитика<BR>событий</A></TD>
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
$pv{order_field} = "se.EVENT" ;
&get_forms_param() ;

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');

print "Content-Type: text/html\n\n"; 
&print_html_head("События экземпляра") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_system_events_navigation(1) ;

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

$is_snglinc_selected_all = "" ; if ( $pv{sngleventsinc} eq "all" || $pv{sngleventsinc} eq "" ) { $is_snglinc_selected_all = "CHECKED" ; }
$is_inc_selected_all = "" ; if ( $pv{eventsinc} eq "all" || $pv{eventsinc} eq "" ) { $is_inc_selected_all = "CHECKED" ; }
$is_snglexcl_selected_none = "" ; if ( $pv{sngleventsexcl} eq "none" || $pv{sngleventsexcl} eq "" ) { $is_snglexcl_selected_none = "CHECKED" ; }
$is_excl_selected_none = "" ; if ( $pv{eventsexcl} eq "none" || $pv{eventsexcl} eq "" ) { $is_excl_selected_none = "CHECKED" ; }

@events_group_keys_nosort = keys %events_group_members ; @events_group_keys = sort(@events_group_keys_nosort) ;
# получить хэш статистик с их ID и именем
my $extdbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
$req_events_list = 'select EVENT#,NAME from v$event_name ORDER BY NAME' ;
my $extsth = $extdbh->prepare($req_events_list) ; $extsth->execute();
$i = 0 ; while (my ($event_id,$name) = $extsth->fetchrow_array() ) { $events_name_list[$i] = $name ; $i++ ; $events_list_id{$name} = $event_id ; }
$extsth->finish(); $extdbh->disconnect();                                        

print "<FORM ACTION=\"$base_url/cgi/get_system_events.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
&print_select_data_source() ;
print "<TR><TD><INPUT TYPE=\"radio\" NAME=\"incltype\" VALUE=\"single\" $is_incltype_single_checked>&nbsp;Включить&nbsp;опцию: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"sngleventsinc\" STYLE=\"width: 100%\" VALUE=\"$pv{eventsinc}\">
               <OPTION VALUE=\"all\" $is_snglinc_selected_all>Все доступные события</OPTION>" ;
for ($i1=0;$i1<=$#events_name_list;$i1++) { $is_selected = "" ; if ( $pv{sngleventsinc} eq $events_list_id{$events_name_list[$i1]} ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$events_list_id{$events_name_list[$i1]}\" $is_selected>$events_name_list[$i1]</OPTION>" ; }
print "</SELECT>
       </TD></TR>
       <TR><TD><INPUT TYPE=\"radio\" NAME=\"incltype\" VALUE=\"group\" $is_incltype_group_checked>&nbsp;Включить&nbsp;группу: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"eventsinc\" STYLE=\"width: 100%\" VALUE=\"$pv{eventsinc}\">
               <OPTION VALUE=\"all\" $is_inc_selected_all>Все доступные события</OPTION>" ;
for ($i1=0;$i1<=$#events_group_keys;$i1++) { $is_selected = "" ; if ( $pv{eventsinc} eq $events_group_keys[$i1] ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$events_group_keys[$i1]\" $is_selected>$events_group_description{$events_group_keys[$i1]}</OPTION>" ; }
print "</SELECT></TD></TR>
       <TR><TD><INPUT TYPE=\"radio\" NAME=\"excltype\" VALUE=\"single\" $is_excltype_single_checked>&nbsp;Исключить опцию: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"sngleventsexcl\" STYLE=\"width: 100%\" VALUE=\"$pv{eventsexcl}\">
               <OPTION VALUE=\"none\" $is_snglexcl_selected_none>Ничего не исключать</OPTION>" ;
for ($i1=0;$i1<=$#events_name_list;$i1++) { $is_selected = "" ; if ( $pv{sngleventsexcl} eq $events_list_id{$events_name_list[$i1]} ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$events_list_id{$events_name_list[$i1]}\" $is_selected>$events_name_list[$i1]</OPTION>" ; }
print "</SELECT>
       </TD></TR>
       <TR><TD><INPUT TYPE=\"radio\" NAME=\"excltype\" VALUE=\"group\" $is_excltype_group_checked>&nbsp;Исключить группу: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"eventsexcl\" STYLE=\"width: 100%\" VALUE=\"$pv{eventsexcl}\">
               <OPTION VALUE=\"none\" $is_excl_selected_none>Ничего не исключать</OPTION>" ;
for ($i1=0;$i1<=$#events_group_keys;$i1++) { $is_selected = "" ; if ( $pv{eventsexcl} eq $events_group_keys[$i1] ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$events_group_keys[$i1]\" $is_selected>$events_group_description{$events_group_keys[$i1]}</OPTION>" ; }
print "</SELECT></TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\">
       <INPUT TYPE=\"checkbox\" NAME=\"is_no_idle\" " ;
if ( $pv{is_no_idle} eq "on" ) { print "CHECKED" ; }
print "\">&nbsp;включить фиктивные события ожидания
       <INPUT TYPE=\"hidden\" NAME=\"order_field\" VALUE=\"$pv{order_field}\"></TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

# сформировать уточняющие фильтры для запроса событий
$ext_where_term = "" ; 
if ( $pv{incltype} eq "group" && $pv{eventsinc} ne "all" && $pv{eventsinc} ne "" ) { $ext_where_term = " AND se.EVENT IN ($events_group_members{$pv{eventsinc}}) " ; }
if ( $pv{incltype} eq "single" && $pv{sngleventsinc} ne "all" && $pv{sngleventsinc} ne "" ) { $ext_where_term = ' AND en.EVENT# = ' . "$pv{sngleventsinc} " ; }
if ( $pv{excltype} eq "group" && $pv{eventsexcl} ne "none" && $pv{eventsexcl} ne "" ) { $ext_where_term .= " AND se.EVENT NOT IN ($events_group_members{$pv{eventsexcl}}) " ; } 
if ( $pv{excltype} eq "single" && $pv{sngleventsexcl} ne "none" && $pv{sngleventsexcl} ne "" ) { $ext_where_term .= ' AND en.EVENT# <> ' . "$pv{sngleventsexcl} " ; }
if ( $pv{is_no_idle} ne "on" ) { $ext_where_term .= ' AND en.NAME NOT IN ( SELECT EVENT FROM STATS$IDLE_EVENT ) ' ; }

if ( $pv{srcptr} eq "0" || $pv{srcptr} eq "" ) { $request = 'select se.EVENT,se.TOTAL_WAITS,se.TOTAL_TIMEOUTS,se.TIME_WAITED,se.AVERAGE_WAIT,se.TIME_WAITED_MICRO from v$system_event se, v$event_name en WHERE se.EVENT = en.NAME ' . $ext_where_term . " order by $pv{order_field} asc" ; }
else { $request = 'select se.EVENT,se.TOTAL_WAITS,se.TOTAL_TIMEOUTS,ROUND(se.TIME_WAITED_MICRO/1000) TIME_WAITED,ROUND(se.TIME_WAITED_MICRO / (1000*se.TOTAL_WAITS)) AVERAGE_WAIT, se.TIME_WAITED_MICRO from PERFSTAT.STATS$SYSTEM_EVENT se, v$event_name en WHERE se.EVENT = en.NAME AND se.SNAP_ID = ' . "$pv{srcptr} " . $ext_where_term . " order by $pv{order_field} asc" ; }

my $sth = $dbh->prepare($request) ;
$sth->execute();
print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_events.cgi?order_field=se.EVENT&incltype=$pv{incltype}&sngleventsinc=$pv{sngleventsinc}&eventsinc=$pv{eventsinc}&excltype=$pv{excltype}&sngleventsexcl=$pv{sngleventsexcl}&eventsexcl=$pv{eventsexcl}&srcptr=$pv{srcptr}&is_no_idle=$pv{is_no_idle}\" TARGET=\"cont\">Событие ожидания</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_events.cgi?order_field=se.TOTAL_WAITS&incltype=$pv{incltype}&sngleventsinc=$pv{sngleventsinc}&eventsinc=$pv{eventsinc}&excltype=$pv{excltype}&sngleventsexcl=$pv{sngleventsexcl}&eventsexcl=$pv{eventsexcl}&srcptr=$pv{srcptr}&is_no_idle=$pv{is_no_idle}\" TARGET=\"cont\">Количество ожиданий</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_events.cgi?order_field=se.TOTAL_TIMEOUTS&incltype=$pv{incltype}&sngleventsinc=$pv{sngleventsinc}&eventsinc=$pv{eventsinc}&excltype=$pv{excltype}&sngleventsexcl=$pv{sngleventsexcl}&eventsexcl=$pv{eventsexcl}&srcptr=$pv{srcptr}&is_no_idle=$pv{is_no_idle}\" TARGET=\"cont\">Количество дополнительных таймаутов</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_events.cgi?order_field=se.TIME_WAITED&incltype=$pv{incltype}&sngleventsinc=$pv{sngleventsinc}&eventsinc=$pv{eventsinc}&excltype=$pv{excltype}&sngleventsexcl=$pv{sngleventsexcl}&eventsexcl=$pv{eventsexcl}&srcptr=$pv{srcptr}&is_no_idle=$pv{is_no_idle}\" TARGET=\"cont\">Общее время ожидания (сек/100)</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_events.cgi?order_field=se.AVERAGE_WAIT&incltype=$pv{incltype}&sngleventsinc=$pv{sngleventsinc}&eventsinc=$pv{eventsinc}&excltype=$pv{excltype}&sngleventsexcl=$pv{sngleventsexcl}&eventsexcl=$pv{eventsexcl}&srcptr=$pv{srcptr}&is_no_idle=$pv{is_no_idle}\" TARGET=\"cont\">Среднее время ожидания (сек/100)</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_events.cgi?order_field=se.TIME_WAITED_MICRO&incltype=$pv{incltype}&sngleventsinc=$pv{sngleventsinc}&eventsinc=$pv{eventsinc}&excltype=$pv{excltype}&sngleventsexcl=$pv{sngleventsexcl}&eventsexcl=$pv{eventsexcl}&srcptr=$pv{srcptr}&is_no_idle=$pv{is_no_idle}\" TARGET=\"cont\">Время ожидания (сек/1&nbsp;000&nbsp;000)</A></TD>
           </TR>" ;

$system_events_count_all = 0 ;
while (my ($event,$total_waits,$total_timeouts,$time_waited,$average_wait,$time_waited_micro) = $sth->fetchrow_array() ) {
      $system_events_count_all += 1 ;
      if ( $event eq "" ) { $event = "&nbsp;" ; }
      if ( $total_waits eq "" ) { $total_waits = "&nbsp;" ; }
      if ( $total_timeouts eq "" ) { $total_timeouts = "&nbsp;" ; }
      if ( $time_waited eq "" ) { $time_waited = "&nbsp;" ; }
      if ( $average_wait eq "" ) { $average_wait = "&nbsp;" ; }
      if ( $time_waited_micro eq "" ) { $time_waited_micro = "&nbsp;" ; }
      printf("<TR><TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  </TR>\n",$event,&show_razryads($total_waits),&show_razryads($total_timeouts),&show_razryads($time_waited),&show_razryads($average_wait),
                           &show_razryads($time_waited_micro)) ;
      }
print "<TR><TD COLSPAN=\"6\">
           <TABLE BORDER=\"0\"><TR><TD>Различных событий ожидания всего:</TD><TD>$system_events_count_all</TD></TR>" ;
print "</TABLE>" ;

# это конец контейнерной таблицы контента
print "</TD></TR></TABLE>" ;

# это конец общей контейнерной таблицы
print "</TD></TR></TABLE>" ;

$sth->finish();
$dbh->disconnect();                                        

if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n<P>$request</P>\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
