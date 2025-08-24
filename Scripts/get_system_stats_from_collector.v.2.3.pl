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
$pv{order_field} = "NAME" ;
&get_forms_param() ;

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');

print "Content-Type: text/html\n\n"; 
&print_html_head("Коллектор статистик экземпляра") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_system_stats_navigation(2) ;

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

print "<FORM ACTION=\"$base_url/cgi/get_system_stats_from_collector.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --</DIV></TD></TR> " ;
#&print_select_data_source() ;
print "<TR><TD>&nbsp;Диапазон выборки: </TD>
           <TD STYLE=\"width: 75%\">с&nbsp;<INPUT TYPE=\"input\" NAME=\"from_range\" VALUE=\"$pv{from_range}\">
               по&nbsp;<INPUT TYPE=\"input\" NAME=\"to_range\" VALUE=\"$pv{to_range}\">&nbsp;формат \"YYYY-MM-DD HH24:MI:SS\"
               <BR>с&nbsp;<INPUT TYPE=\"input\" NAME=\"from_snap\" VALUE=\"$pv{from_snap}\">
               по&nbsp;<INPUT TYPE=\"input\" NAME=\"to_snap\" VALUE=\"$pv{to_snap}\">&nbsp;дополнительный фильтр \"SNAP ID\"</TD></TR>
       <TR><TD>&nbsp;Группировка: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"report_type\" STYLE=\"width: 100%\" VALUE=\"$report_type\">
               <OPTION VALUE=\"raw\" $is_selected_raw>Записи коллектора статистик без обработки</OPTION>
               <OPTION VALUE=\"perhours\" $is_selected_perhours>Часовая группировка</OPTION>
               <OPTION VALUE=\"perdays\" $is_selected_perdays>Дневная группировка</OPTION>
               <OPTION VALUE=\"permonths\" $is_selected_permonths>Месячная группировка</OPTION>
               </SELECT></TD></TR>" ;

print "<TR><TD><INPUT TYPE=\"radio\" NAME=\"incltype\" VALUE=\"single\" $is_incltype_single_checked>&nbsp;Включить&nbsp;опцию: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"snglstatsinc\" STYLE=\"width: 100%\">
               <OPTION VALUE=\"all\" $is_snglinc_selected_all>Все доступные статистики</OPTION>" ;
for ($i1=0;$i1<=$#stats_name_list;$i1++) { $is_selected = "" ; if ( $pv{snglstatsinc} eq $stats_list_id{$stats_name_list[$i1]} ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$stats_list_id{$stats_name_list[$i1]}\" $is_selected>$stats_name_list[$i1]</OPTION>" ; }
print "</SELECT>
       </TD></TR>
       <TR><TD><INPUT TYPE=\"radio\" NAME=\"incltype\" VALUE=\"group\" $is_incltype_group_checked>&nbsp;Включить&nbsp;группу: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"statsinc\" STYLE=\"width: 100%\">
               <OPTION VALUE=\"all\" $is_inc_selected_all>Все доступные статистики</OPTION>" ;
for ($i1=0;$i1<=$#statistics_group_keys;$i1++) { $is_selected = "" ; if ( $pv{statsinc} eq $statistics_group_keys[$i1] ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$statistics_group_keys[$i1]\" $is_selected>$statistics_group_description{$statistics_group_keys[$i1]}</OPTION>" ; }
print "</SELECT></TD></TR>
       <TR><TD><INPUT TYPE=\"radio\" NAME=\"excltype\" VALUE=\"single\" $is_excltype_single_checked>&nbsp;Исключить опцию: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"snglstatsexcl\" STYLE=\"width: 100%\" VALUE=\"$pv{statsexcl}\">
               <OPTION VALUE=\"none\" $is_snglexcl_selected_none>Ничего не исключать</OPTION>" ;
for ($i1=0;$i1<=$#stats_name_list;$i1++) { $is_selected = "" ; if ( $pv{snglstatsexcl} eq $stats_list_id{$stats_name_list[$i1]} ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$stats_list_id{$stats_name_list[$i1]}\" $is_selected>$stats_name_list[$i1]</OPTION>" ; }
print "</SELECT>
       </TD></TR>
       <TR><TD><INPUT TYPE=\"radio\" NAME=\"excltype\" VALUE=\"group\" $is_excltype_group_checked>&nbsp;Исключить группу: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"statsexcl\" STYLE=\"width: 100%\" VALUE=\"$pv{statsexcl}\">
               <OPTION VALUE=\"none\" $is_excl_selected_none>Ничего не исключать</OPTION>" ;
for ($i1=0;$i1<=$#statistics_group_keys;$i1++) { $is_selected = "" ; if ( $pv{statsexcl} eq $statistics_group_keys[$i1] ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$statistics_group_keys[$i1]\" $is_selected>$statistics_group_description{$statistics_group_keys[$i1]}</OPTION>" ; }
print "</SELECT>
       <INPUT TYPE=\"hidden\" NAME=\"order_field\" VALUE=\"$pv{order_field}\"><INPUT TYPE=\"hidden\" NAME=\"is_second\" VALUE=\"yes\">
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
      $request = 'SELECT ss.POINT_ID POINT_ID, ss.SNAP_LEVEL SNAP_LEVEL, ss.CR_SNAP_ID CR_SNAP_ID, TO_CHAR(ss.CR_SNAP_TIME,\'YYYY-MM-DD HH24:MI:SS\') CR_SNAP_TIME, 
                         ss.PR_SNAP_ID PR_SNAP_ID, TO_CHAR(ss.PR_SNAP_TIME,\'YYYY-MM-DD HH24:MI:SS\') PR_SNAP_TIME, ss.STATISTIC# STATISTIC_N, sn.NAME NAME,
                         sn.CLASS CLASS, ss.CR_VALUE CR_VALUE, ss.PR_VALUE PR_VALUE , ss.DIFFERENCE DIFFERENCE
                         FROM CLC_DELTA_SYSSTAT ss, V$STATNAME sn 
                         WHERE ss.STATISTIC# = sn.STATISTIC# ' . $where_term . " AND CR_SNAP_TIME <= TO_DATE('$pv{to_range}','YYYY-MM-DD HH24:MI:SS') AND
                               CR_SNAP_TIME >= TO_DATE('$pv{from_range}','YYYY-MM-DD HH24:MI:SS') ORDER BY $pv{order_field} " ;
      }
   else {
      $group_string = "" ;
      if ( $pv{report_type} eq "perhours" ) { $group_string = "YYYY-MM-DD HH24" ; }
      if ( $pv{report_type} eq "perdays" ) { $group_string = "YYYY-MM-DD" ; }
      if ( $pv{report_type} eq "permonths" ) { $group_string = "YYYY-MM" ; }

      $request = 'SELECT ss.POINT_ID POINT_ID, ss.SNAP_LEVEL SNAP_LEVEL, 
                         MAX(ss.CR_SNAP_ID) CR_SNAP_ID, TO_CHAR(MAX(ss.CR_SNAP_TIME),\'YYYY-MM-DD HH24:MI:SS\') CR_SNAP_TIME, 
                         MIN(ss.PR_SNAP_ID) PR_SNAP_ID, TO_CHAR(MIN(ss.PR_SNAP_TIME),\'YYYY-MM-DD HH24:MI:SS\') PR_SNAP_TIME, 
                         ss.STATISTIC# STATISTIC_N, sn.NAME NAME,
                         sn.CLASS CLASS, MAX(ss.CR_VALUE) CR_VALUE, MIN(ss.PR_VALUE) PR_VALUE , SUM(ss.DIFFERENCE) DIFFERENCE
                         FROM CLC_DELTA_SYSSTAT ss, V$STATNAME sn 
                         WHERE ss.STATISTIC# = sn.STATISTIC# ' . $where_term . " AND CR_SNAP_TIME <= TO_DATE('$pv{to_range}','YYYY-MM-DD HH24:MI:SS') AND
                               CR_SNAP_TIME >= TO_DATE('$pv{from_range}','YYYY-MM-DD HH24:MI:SS') 
                         GROUP BY ss.POINT_ID, ss.SNAP_LEVEL, TO_CHAR(ss.CR_SNAP_TIME,'$group_string'), ss.STATISTIC#, sn.NAME, sn.CLASS
                         ORDER BY $pv{order_field} " ;
      }                                                                                                                                                     

#print "<BR>$request<BR>" ;

#   if ( $pv{srcptr} eq "0" || $pv{srcptr} eq "" ) { 
#$request = 'select ss.STATISTIC# id_stat,ss.NAME,sn.CLASS,ss.VALUE 
# from v$sysstat ss, v$statname sn WHERE ss.STATISTIC# = sn.STATISTIC# ' . $where_term . " order by $pv{order_field} asc" ; }
#   else { $request = 'select ss.STATISTIC#,ss.NAME,sn.CLASS,ss.VALUE from STATS$SYSSTAT ss, v$statname sn WHERE  ss.STATISTIC# = sn.STATISTIC# AND SNAP_ID = ' . "$pv{srcptr} " . $where_term . " order by $pv{order_field} asc" ; }

   my $sth = $dbh->prepare($request) ; $sth->execute() ;
   print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
   print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=STATISTIC_N&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">ID статистики</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=NAME&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">Статистика</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=DIFFERENCE&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">Приращение счётчика</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=CR_SNAP_ID&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">ID текущего среза</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=CR_SNAP_TIME&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">Дата текущего среза</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=PR_SNAP_ID&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">ID предыдущего среза</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=PS_SNAP_TIME&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">Дата предыдущего среза</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=POINT_ID&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">ID объекта контроля (POINT ID)</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=SNAP_LEVEL&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">Уровень детализации среза</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=CLASS&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">Класс статистики</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=CR_VALUE&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">Текущее значение</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=PR_VALUE&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\" TARGET=\"cont\">Предыдущее значение</A></TD>
              </TR>" ;
   
   $system_stat_count_all = 0 ;
   while (my ( $point_id, $snap_level, $cr_snap_id, $cr_snap_time, $pr_snap_id, $pr_snap_time, $statistic_n, $name, $class, $cr_value, $pr_value, $difference ) = $sth->fetchrow_array() ) {
         if ( $system_stat_count_by_status{$class} eq "" || $system_stat_count_by_status{$class} < 1 ) { $system_stat_count_by_status{$class} = 0 ; } 
         $system_stat_count_all += 1 ; $system_stat_count_by_status{$class} += 1 ;
         if ( $statistic_n eq "" ) { $statistic_n = "&nbsp;" ; }
         if ( $name eq "" ) { $name = "&nbsp;" ; } $name =~ s/\s/&nbsp;/g ;
         if ( $class eq "" ) { $class = "&nbsp;" ; } $class =~ s/\s/&nbsp;/g ;
         $cr_snap_time =~ s/\s/&nbsp;/g ; $pr_snap_time =~ s/\s/&nbsp;/g ;
         if ( $cr_value eq "" ) { $cr_value = "&nbsp;" ; }
         if ( $pr_value eq "" ) { $pr_value = "&nbsp;" ; }
# --- вычислить символьное отображение классов статистики путем перебора вариантов вычисляются попадения и инициализируется эелмент хэша
         $classes_list = "" ; $class_test = 0 ; $tmp_modificator = 0 ;
         if ( $class >= 128 ) { $class_test = $class - $tmp_modificator - 128 ; if ( $class_test >= 0 ) { $tmp_modificator += 128 ; if ( $classes_list ne "" ) { $classes_list .= "," ; } $classes_list .= "&nbsp;Debug" ; } }
         if ( $class >= 64 )  { $class_test = $class - $tmp_modificator - 64  ; if ( $class_test >= 0 ) { $tmp_modificator += 64  ; if ( $classes_list ne "" ) { $classes_list .= "," ; } $classes_list .= "&nbsp;SQL" ; } }
         if ( $class >= 32 )  { $class_test = $class - $tmp_modificator - 32  ; if ( $class_test >= 0 ) { $tmp_modificator += 32  ; if ( $classes_list ne "" ) { $classes_list .= "," ; } $classes_list .= "&nbsp;RAC" ; } }
         if ( $class >= 16 )  { $class_test = $class - $tmp_modificator - 16  ; if ( $class_test >= 0 ) { $tmp_modificator += 16  ; if ( $classes_list ne "" ) { $classes_list .= "," ; } $classes_list .= "&nbsp;OS" ; } }
         if ( $class >= 8 )   { $class_test = $class - $tmp_modificator - 8   ; if ( $class_test >= 0 ) { $tmp_modificator += 8   ; if ( $classes_list ne "" ) { $classes_list .= "," ; } $classes_list .= "&nbsp;Cache" ; } }
         if ( $class >= 4 )   { $class_test = $class - $tmp_modificator - 4   ; if ( $class_test >= 0 ) { $tmp_modificator += 4   ; if ( $classes_list ne "" ) { $classes_list .= "," ; } $classes_list .= "&nbsp;Enqueue" ; } }
         if ( $class >= 2 )   { $class_test = $class - $tmp_modificator - 2   ; if ( $class_test >= 0 ) { $tmp_modificator += 2   ; if ( $classes_list ne "" ) { $classes_list .= "," ; } $classes_list .= "&nbsp;Redo" ; } }
         if ( $class >= 1 )   { $class_test = $class - $tmp_modificator - 1   ; if ( $class_test >= 0 ) { $tmp_modificator += 1   ; if ( $classes_list ne "" ) { $classes_list .= "," ; } $classes_list .= "&nbsp;User" ; } }
         $stat_classes{$class} = $classes_list ;
         printf("<TR><TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\"><A TITLE=\"показать описание выбранной статистики\" TAREGT=\"_blank\"
                         HREF=\"%s\">?</A>&nbsp;<A
                         TITLE=\"показать динамику только этой статистики за выбранный диапазон срезов\" TAREGT=\"cont\"
                         HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=STATISTIC_N&incltype=single&snglstatsinc=%d&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=$pv{from_snap}&to_snap=$pv{to_snap}&is_second=$pv{is_second}&report_type=$pv{report_type}\">%s</A></TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\"><A TITLE=\"показать динамику всех статистик за выбранный срез\" TAREGT=\"cont\"
                         HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=CR_SNAP_TIME&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=%d&to_snap=%d&is_second=$pv{is_second}&report_type=$pv{report_type}\">%s</TD>
                     <TD CLASS=\"SZDATA\"><A TITLE=\"показать динамику всех статистик за выбранный срез\" TAREGT=\"cont\"
                         HREF=\"$base_url/cgi/get_system_stats_from_collector.cgi?order_field=CR_SNAP_TIME&incltype=$pv{incltype}&snglstatsinc=$pv{snglstatsinc}&statsinc=$pv{statsinc}&excltype=$pv{excltype}&snglstatsexcl=$pv{snglstatsexcl}&statsexcl=$pv{statsexcl}&from_range=$pv{from_range}&to_range=$pv{to_range}&from_snap=%d&to_snap=%d&is_second=$pv{is_second}&report_type=$pv{report_type}\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     </TR>\n",
                     $statistic_n, $name, $statistic_n, $name, &show_razryads($difference), $cr_snap_id, $cr_snap_id, $cr_snap_id, $cr_snap_id, 
                     $cr_snap_id, $cr_snap_time, $pr_snap_id, $pr_snap_time, $point_id, $snap_level, $classes_list, &show_razryads($cr_value), 
                     &show_razryads($pr_value) ) ;
         }
   print "<TR><TD COLSPAN=\"12\">
              <TABLE BORDER=\"0\"><TR><TD>Статистик всего:</TD><TD>$system_stat_count_all, в т.ч.</TD></TR>" ;
   @system_stat_count_by_status_keys_nosort = keys %system_stat_count_by_status ; @system_stat_count_by_status_keys_sort = sort @system_stat_count_by_status_keys_nosort ;
   for ($i=0;$i<=$#system_stat_count_by_status_keys_sort;$i++) {
       print "<TR><TD>&nbsp;&nbsp;&nbsp;$stat_classes{$system_stat_count_by_status_keys_sort[$i]}:</TD><TD>$system_stat_count_by_status{$system_stat_count_by_status_keys_sort[$i]}</TD></TR>" ;
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

if ( $is_view_request eq "yes" && $pv{is_second} eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n<P>$request</P>\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
