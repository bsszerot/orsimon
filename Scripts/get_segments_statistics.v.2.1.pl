#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_segments_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_segments_definition.cgi?order_field=SEGMENT_NAME\" TARGET=\"cont\">Определения</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_segments_statistics.cgi?order_field=ds.SEGMENT_NAME\" TARGET=\"cont\">Статистики</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_segments_utilization.cgi?order_field=FREE_EXT_PERCENT\" TARGET=\"cont\">Утилизация</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_segments_stats.cgi?order_field=NAME\" TARGET=\"cont\">Динамика</A></TD>
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
$pv{order_field} = "ds.SEGMENT_NAME" ;
&get_forms_param() ;

$ENV{ORACLE_SID} = $current_connector ;

print "Content-Type: text/html\n\n"; 
&print_html_head("Статистика сегментов данных") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_segments_navigation(2) ;

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
$is_intype_single_checked = "" ; if ( $pv{intype} eq "single" ) { $is_intype_single_checked = "CHECKED" ; }
$is_intype_group_checked = "" ; if ( $pv{intype} eq "group" || $pv{intype} eq "" ) { $is_intype_group_checked = "CHECKED" ; }
$is_extype_single_checked = "" ; if ( $pv{extype} eq "single" ) { $is_extype_single_checked = "CHECKED" ; }
$is_extype_group_checked = "" ; if ( $pv{extype} eq "group" || $pv{extype} eq "" ) { $is_extype_group_checked = "CHECKED" ; }

$is_snglinc_selected_all = "" ; if ( $pv{snstin} eq "all" || $pv{snstin} eq "" ) { $is_snglinc_selected_all = "CHECKED" ; }
$is_inc_selected_all = "" ; if ( $pv{stin} eq "all" || $pv{stin} eq "" ) { $is_inc_selected_all = "CHECKED" ; }
$is_snglexcl_selected_none = "" ; if ( $pv{snstex} eq "none" || $pv{snstex} eq "" ) { $is_snglexcl_selected_none = "CHECKED" ; }
$is_excl_selected_none = "" ; if ( $pv{stex} eq "none" || $pv{stex} eq "" ) { $is_excl_selected_none = "CHECKED" ; }

@statistics_group_keys_nosort = keys %statistics_group_members ; @statistics_group_keys = sort(@statistics_group_keys_nosort) ;
# получить хэш статистик с их ID и именем
my $extdbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
$req_stats_list = 'select STATISTIC# id_stat, NAME from v$segstat_name ORDER BY NAME' ;
my $extsth = $extdbh->prepare($req_stats_list) ; $extsth->execute();
$i = 0 ; while (my ($stat_id,$name) = $extsth->fetchrow_array() ) { $stats_name_list[$i] = $name ; $i++ ; $stats_list_id{$name} = $stat_id ; }
$extsth->finish(); $extdbh->disconnect();                                        

print "<FORM ACTION=\"$base_url/cgi/get_segments_statistics.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --</DIV></TD></TR>" ;
&print_select_data_source() ;
print "<TR><TD>&nbsp;Владелец: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"flowner\" VALUE=\"$pv{flowner}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Имя&nbsp;содержит: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"flname\" VALUE=\"$pv{flname}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Тип&nbsp;сегмента: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"fltype\" VALUE=\"$pv{fltype}\" STYLE=\"width: 100%\"></TD></TR>" ;
print "<TR><TD>&nbsp;Табличные&nbsp;пространства: </TD><TD><INPUT TYPE=\"INPUT\" NAME=\"fltbs\" VALUE=\"$pv{fltbs}\" STYLE=\"width: 100%\"></TD></TR>" ;
# вывести поля выбора статистик
print "<TR><TD><INPUT TYPE=\"radio\" NAME=\"intype\" VALUE=\"single\" $is_intype_single_checked>&nbsp;Включить&nbsp;опцию: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"snstin\" STYLE=\"width: 100%\">
               <OPTION VALUE=\"all\" $is_snglinc_selected_all>Все доступные статистики</OPTION>" ;
for ($i1=0;$i1<=$#stats_name_list;$i1++) { $is_selected = "" ; if ( $pv{snstin} eq $stats_list_id{$stats_name_list[$i1]} ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$stats_list_id{$stats_name_list[$i1]}\" $is_selected>$stats_name_list[$i1]</OPTION>" ; }
print "</SELECT>
       </TD></TR>
       <TR><TD><INPUT TYPE=\"radio\" NAME=\"intype\" VALUE=\"group\" $is_intype_group_checked>&nbsp;Включить&nbsp;группу: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"stin\" STYLE=\"width: 100%\">
               <OPTION VALUE=\"all\" $is_inc_selected_all>Все доступные статистики</OPTION>" ;
for ($i1=0;$i1<=$#statistics_group_keys;$i1++) { $is_selected = "" ; if ( $pv{stin} eq $statistics_group_keys[$i1] ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$statistics_group_keys[$i1]\" $is_selected>$statistics_group_description{$statistics_group_keys[$i1]}</OPTION>" ; }
print "</SELECT></TD></TR>
       <TR><TD><INPUT TYPE=\"radio\" NAME=\"extype\" VALUE=\"single\" $is_extype_single_checked>&nbsp;Исключить опцию: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"snstex\" STYLE=\"width: 100%\" VALUE=\"$pv{stex}\">
               <OPTION VALUE=\"none\" $is_snglexcl_selected_none>Ничего не исключать</OPTION>" ;
for ($i1=0;$i1<=$#stats_name_list;$i1++) { $is_selected = "" ; if ( $pv{snstex} eq $stats_list_id{$stats_name_list[$i1]} ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$stats_list_id{$stats_name_list[$i1]}\" $is_selected>$stats_name_list[$i1]</OPTION>" ; }
print "</SELECT>
       </TD></TR>
       <TR><TD><INPUT TYPE=\"radio\" NAME=\"extype\" VALUE=\"group\" $is_extype_group_checked>&nbsp;Исключить группу: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"stex\" STYLE=\"width: 100%\" VALUE=\"$pv{stex}\">
               <OPTION VALUE=\"none\" $is_excl_selected_none>Ничего не исключать</OPTION>" ;
for ($i1=0;$i1<=$#statistics_group_keys;$i1++) { $is_selected = "" ; if ( $pv{stex} eq $statistics_group_keys[$i1] ) { $is_selected = " SELECTED" ; }
    print "<OPTION VALUE=\"$statistics_group_keys[$i1]\" $is_selected>$statistics_group_description{$statistics_group_keys[$i1]}</OPTION>" ; }
print "</SELECT></TD></TR>" ;
# завершить вывод полей выбора статистик
print "<TR><TD COLSPAN=\"2\">
       <INPUT TYPE=\"hidden\" NAME=\"order_field\" VALUE=\"$pv{order_field}\">
       <INPUT TYPE=\"hidden\" NAME=\"is_view_sources\" VALUE=\"$pv{is_view_sources}\"></TD></TR>
       <INPUT TYPE=\"hidden\" NAME=\"isfirst\" VALUE=\"no\">
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

if ( $pv{isfirst} eq "no" ) {
# сформировать уточняющие фильтры для запроса статистики
   $where_ext = "" ; 
   if ( $pv{intype} eq "group" && $pv{stin} ne "all" && $pv{stin} ne "" ) { $where_ext = " AND ss.STATISTIC_NAME IN ($statistics_group_members{$pv{stin}}) " ; }
   if ( $pv{intype} eq "single" && $pv{snstin} ne "all" && $pv{snstin} ne "" ) { $where_ext = ' AND ss.STATISTIC# = ' . "$pv{snstin} " ; }
   if ( $pv{extype} eq "group" && $pv{stex} ne "none" && $pv{stex} ne "" ) { $where_ext .= " AND ss.STATISTIC_NAME NOT IN ($statistics_group_members{$pv{stex}}) " ; } 
   if ( $pv{extype} eq "single" && $pv{snstex} ne "none" && $pv{snstex} ne "" ) { $where_ext .= ' AND ss.STATISTIC# <> ' . "$pv{snstex} " ; }
   if ( $pv{fltbs} ne "" ) { $where_ext .= " AND ds.TABLESPACE_NAME = '$pv{fltbs}' " ; }
   if ( $pv{flname} ne "" ) { $where_ext .= " AND ds.SEGMENT_NAME LIKE '\%$pv{flname}\%' " ; }
   if ( $pv{flowner} ne "" ) { $where_ext .= " AND ds.OWNER = '$pv{flowner}' " ; }
   if ( $pv{fltype} ne "" ) { $tmp_segment_type = $pv{fltype} ; $tmp_segment_type =~ s/[\s\t]+//g ; $tmp_segment_type =~ s/,/','/g ;
                              $where_ext .= " AND ds.SEGMENT_TYPE IN ('$tmp_segment_type') " ; }
   if ( $pv{srcptr} eq "0" || $pv{srcptr} eq "" ) { 
      $request = 'select ds.OWNER, ds.SEGMENT_NAME, ds.SEGMENT_TYPE, ds.TABLESPACE_NAME, ss.STATISTIC_NAME, ss.STATISTIC#, ss.VALUE
                         FROM dba_segments ds, v$segstat ss, dba_objects do WHERE ds.OWNER = do.OWNER AND ds.SEGMENT_NAME = do.OBJECT_NAME 
                              AND ds.SEGMENT_TYPE = do.OBJECT_TYPE AND ss.OBJ# = do.OBJECT_ID AND ss.DATAOBJ# = do.DATA_OBJECT_ID' . $where_ext . " order by $pv{order_field} asc" ; }
   else {  
      $request = 'select ds.OWNER, ds.SEGMENT_NAME, ds.SEGMENT_TYPE, ds.TABLESPACE_NAME, ss.STATISTIC_NAME, ss.STATISTIC#, ss.VALUE
                         FROM BESTAT_dba_segments ds, BESTAT_v$segstat ss, BESTAT_dba_objects do WHERE ' . " ds.POINT = $pv{srcptr} AND ss.POINT = $pv{srcptr} AND do.POINT = $pv{srcptr} " . ' AND
                              ds.OWNER = do.OWNER AND ds.SEGMENT_NAME = do.OBJECT_NAME AND ds.SEGMENT_TYPE = do.OBJECT_TYPE AND ss.OBJ# = do.OBJECT_ID AND ss.DATAOBJ# = do.DATA_OBJECT_ID' . $where_ext . " order by $pv{order_field} asc" ; }
   my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
   my $sth = $dbh->prepare($request) ; $sth->execute() ;
   print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
   print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_segments_statistics.cgi?order_field=OWNER&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&fltbs=$pv{fltbs}&flname=$pv{flname}&flowner=$pv{flowner}&fltype=$pv{fltype}&intype=$pv{intype}&snstin=$pv{snstin}&stin=$pv{stin}&extype=$pv{extype}&snstex=$pv{snstex}&stex=$pv{stex}\" TARGET=\"cont\">Владелец</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_segments_statistics.cgi?order_field=SEGMENT_NAME&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&fltbs=$pv{fltbs}&flname=$pv{flname}&flowner=$pv{flowner}&fltype=$pv{fltype}&intype=$pv{intype}&snstin=$pv{snstin}&stin=$pv{stin}&extype=$pv{extype}&snstex=$pv{snstex}&stex=$pv{stex}\" TARGET=\"cont\">Имя сегмента</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_segments_statistics.cgi?order_field=SEGMENT_TYPE&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&fltbs=$pv{fltbs}&flname=$pv{flname}&flowner=$pv{flowner}&fltype=$pv{fltype}&intype=$pv{intype}&snstin=$pv{snstin}&stin=$pv{stin}&extype=$pv{extype}&snstex=$pv{snstex}&stex=$pv{stex}\" TARGET=\"cont\">Тип сегмента</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_segments_statistics.cgi?order_field=TABLESPACE_NAME&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&fltbs=$pv{fltbs}&flname=$pv{flname}&flowner=$pv{flowner}&fltype=$pv{fltype}&intype=$pv{intype}&snstin=$pv{snstin}&stin=$pv{stin}&extype=$pv{extype}&snstex=$pv{snstex}&stex=$pv{stex}\" TARGET=\"cont\">Имя ТС</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_segments_statistics.cgi?order_field=STATISTIC_NAME&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&fltbs=$pv{fltbs}&flname=$pv{flname}&flowner=$pv{flowner}&fltype=$pv{fltype}&intype=$pv{intype}&snstin=$pv{snstin}&stin=$pv{stin}&extype=$pv{extype}&snstex=$pv{snstex}&stex=$pv{stex}\" TARGET=\"cont\">Статистика</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_segments_statistics.cgi?order_field=VALUE&isfirst=$pv{isfirst}&srcptr=$pv{srcptr}&fltbs=$pv{fltbs}&flname=$pv{flname}&flowner=$pv{flowner}&fltype=$pv{fltype}&intype=$pv{intype}&snstin=$pv{snstin}&stin=$pv{stin}&extype=$pv{extype}&snstex=$pv{snstex}&stex=$pv{stex}\" TARGET=\"cont\">Значение</A></TD>
              </TR>" ;

   $count_all = 0 ;
   while (my ( $owner,$segment_name,$segment_type,$tablespace_name,$statistic_name,$statistic_n,$value ) = $sth->fetchrow_array() ) {
         if ( $count_by_ts{$tablespace_name} eq "" || $count_by_ts{$tablespace_name} < 1 ) { $count_by_ts{$tablespace_name} = 0 ; } 
         $count_all += 1 ; $count_by_ts{$tablespace_name} += 1 ;
         if ( $partition_name eq "" ) { $partition_name = "&nbsp;" ; }
         printf("<TR><TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     </TR>\n",$owner,$segment_name,$segment_type,$tablespace_name,$statistic_name,&show_razryads($value),,$statistic_n ) ;
         }
   print "<TR><TD COLSPAN=\"6\">
              <TABLE BORDER=\"0\"><TR><TD>Файлов всего:</TD><TD>$count_all, в т.ч.</TD></TR>" ;
   @count_by_ts_keys_nosort = keys %count_by_ts ; @count_by_ts_keys_sort = sort @count_by_ts_keys_nosort ;
   for ($i=0;$i<=$#count_by_ts_keys_sort;$i++) {
       print "<TR><TD>&nbsp;&nbsp;&nbsp;$count_by_ts_keys_sort[$i]:</TD><TD>$count_by_ts{$count_by_ts_keys_sort[$i]}</TD></TR>" ;
       }
   print "</TABLE>" ;
   $sth->finish();
   $dbh->disconnect();                                        
# это конец контейнерной таблицы контента
   print "</TD></TR></TABLE>" ;
# это конец общей контейнерной таблицы
   print "</TD></TR></TABLE>" ;
  if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n$request\n" ; }
   }
else {
# это конец общей контейнерной таблицы
     print "</TD></TR></TABLE>" ; }

print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
