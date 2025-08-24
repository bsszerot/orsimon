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
$pv{order_field} = "se3.CR_SNAP_ID,se3.EVENT_N" ;
&get_forms_param() ;

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');

print "Content-Type: text/html\n\n"; 
&print_html_head("Аналитика топовых событий ожидания экземпляра") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_system_events_navigation(3) ;

print "</TD><TD STYLE=\" padding: 0pt; height: 100%;\">
       <TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; height: 100%;\">
              <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none; height: 100%;\">&nbsp;</TD></TR>
       </TABLE>
       </TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"padding: 0pt;\">" ;

# это начало контейнерной таблицы контента
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">" ;
print "<TR><TD>" ;

# заранее подготовить дополнительные параметры и вывести форму выбора дополнительного фильтра отчета 
$is_incltype_single_checked = "" ; if ( $pv{incltype} eq "single" ) { $is_incltype_single_checked = "CHECKED" ; }
$is_incltype_group_checked = "" ; if ( $pv{incltype} eq "group" || $pv{incltype} eq "" ) { $is_incltype_group_checked = "CHECKED" ; }
$is_excltype_single_checked = "" ; if ( $pv{excltype} eq "single" ) { $is_excltype_single_checked = "CHECKED" ; }
$is_excltype_group_checked = "" ; if ( $pv{excltype} eq "group" || $pv{excltype} eq "" ) { $is_excltype_group_checked = "CHECKED" ; }

$is_snglinc_selected_all = "" ; if ( $pv{sngleventsinc} eq "all" || $pv{sngleventsinc} eq "" ) { $is_snglinc_selected_all = "CHECKED" ; }
$is_inc_selected_all = "" ; if ( $pv{eventsinc} eq "all" || $pv{eventsinc} eq "" ) { $is_inc_selected_all = "CHECKED" ; }
$is_snglexcl_selected_none = "" ; if ( $pv{sngleventsexcl} eq "none" || $pv{sngleventsexcl} eq "" ) { $is_snglexcl_selected_none = "CHECKED" ; }
$is_excl_selected_none = "" ; if ( $pv{eventsexcl} eq "none" || $pv{eventsexcl} eq "" ) { $is_excl_selected_none = "CHECKED" ; }

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); $year += 1900 ; $mon += 1 ;
if ( $pv{from_range} eq "" ) { $pv{from_range} = "$year-$mon-$mday 00:00:00" ; }
if ( $pv{to_range} eq "" ) { $pv{to_range} = "$year-$mon-$mday $hour:$min:$sec" ; }

$is_selected_raw = "" ; if ( $pv{report_type} eq "raw" ) { $is_selected_raw = "SELECTED" ; }
$is_selected_perhours = "" ; if ( $pv{report_type} eq "perhours" ) { $is_selected_perhours = "SELECTED" ; }
$is_selected_perdays = "" ; if ( $pv{report_type} eq "perdays" ) { $is_selected_perdays = "SELECTED" ; }
$is_selected_permonths = "" ; if ( $pv{report_type} eq "permonths" ) { $is_selected_permonths = "SELECTED" ; }

@events_group_keys_nosort = keys %events_group_members ; @events_group_keys = sort(@events_group_keys_nosort) ;
# получить хэш статистик с их ID и именем
my $extdbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
$req_events_list = 'select EVENT#,NAME from v$event_name ORDER BY NAME' ;
my $extsth = $extdbh->prepare($req_events_list) ; $extsth->execute();
$i = 0 ; while (my ($event_id,$name) = $extsth->fetchrow_array() ) { $events_name_list[$i] = $name ; $i++ ; $events_list_id{$name} = $event_id ; }
$extsth->finish(); $extdbh->disconnect();                                        

print "<FORM ACTION=\"$base_url/cgi/get_sysevents_top_from_collector.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --
           <BR> -- в этой версии включение фиктивных ожиданий не поддерживается -- </DIV></TD></TR> " ;
#&print_select_data_source() ;
print "<TR><TD>&nbsp;Диапазон выборки: </TD>
           <TD STYLE=\"width: 75%\">с&nbsp;<INPUT TYPE=\"input\" NAME=\"from_range\" VALUE=\"$pv{from_range}\">
               по&nbsp;<INPUT TYPE=\"input\" NAME=\"to_range\" VALUE=\"$pv{to_range}\">&nbsp;формат \"YYYY-MM-DD HH24:MI:SS\"</TD></TR>
       <TR><TD TITLE=\"количество топовых событий ожидания, выбираемых из каждого диапазона для последующей аналитики\">&nbsp;Величина выборки: </TD>" ;
if ( "$pv{scope_ents_len}" eq "" ) { $pv{scope_ents_len} = 30 ; }
print "<TD STYLE=\"width: 75%\"><INPUT TYPE=\"input\" NAME=\"scope_ents_len\" VALUE=\"$pv{scope_ents_len}\"></TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><INPUT TYPE=\"checkbox\" NAME=\"is_no_idle\" " ;
if ( $pv{is_no_idle} eq "on" ) { print "CHECKED" ; }
print "\">&nbsp;включить фиктивные события ожидания 
       <INPUT TYPE=\"hidden\" NAME=\"order_field\" VALUE=\"$pv{order_field}\"><INPUT TYPE=\"hidden\" NAME=\"is_second\" VALUE=\"yes\"></TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

# если повторный вызов - считаем, что условия заданы и организуем отображение выборки
if ( $pv{is_second} eq "yes" ) {
      $request = 'SELECT se4.EVENT_N EVENT_N, se4.NAME NAME, COUNT(se4.NAME) EN_COUNT, SUM(se4.DIFF_TWM) SUM_TWM,
                         ROUND(SUM(se4.DIFF_TWM)*100/SUM(se4.TOTAL_TIME_MICRO ),2) AV1_PERALL_WT_PRCNT, 
                         ROUND(SUM(se4.DIFF_TWM)*100/SUM(se4.TOTAL_NOIDLE_WAIT),2) AV1_NOF_PERCENT,
                         ROUND(MIN(se4.DIFF_TWM),2) MIN_TWM, ROUND(MIN(se4.PERALL_WT_PERCENT),2) MIN_PERALL_WT_PRCNT, ROUND(MIN(se4.PER_NOF_WT_PERCENT),2) MIN_PER_NOF_WT_PRCNT,
                         ROUND(AVG(se4.DIFF_TWM),0) AVG_TWM, ROUND(AVG(se4.PERALL_WT_PERCENT),2) AVG_PERALL_WT_PRCNT, ROUND(AVG(se4.PER_NOF_WT_PERCENT),2) AVG_PER_NOF_WT_PRCNT,
                         ROUND(MAX(se4.DIFF_TWM),2) MAX_TWM, ROUND(MAX(se4.PERALL_WT_PERCENT),2) MAX_PERALL_WT_PRCNT, ROUND(MAX(se4.PER_NOF_WT_PERCENT),2) MAX_PER_NOF_WT_PRCNT,
                         ROUND(SUM(se4.DIFF_TW),2) DIFF_TW,
                         ROUND(SUM(se4.DIFF_TT),2) DIFF_TT
                         FROM ( SELECT  se3.NAME NAME, se3.EVENT# EVENT_N, se3.DIFF_TW DIFF_TW, se3.DIFF_TT DIFF_TT, se3.DIFF_TWM DIFF_TWM, se3.IS_IDLE, 
                                        st.TOTAL_TIME_MICRO TOTAL_TIME_MICRO, st.TOTAL_NOIDLE_WAIT TOTAL_NOIDLE_WAIT,
                                        CASE WHEN ( se3.IS_IDLE = \'YES\' ) THEN 0 ELSE (se3.DIFF_TWM*100/st.TOTAL_TIME_MICRO) END PERALL_WT_PERCENT,
                                        CASE WHEN ( se3.IS_IDLE = \'YES\' ) THEN 0 ELSE (se3.DIFF_TWM*100/st.TOTAL_NOIDLE_WAIT) END PER_NOF_WT_PERCENT,
                                        ROW_NUMBER() OVER ( PARTITION BY se3.POINT_ID, se3.SNAP_LEVEL, se3.CR_SNAP_ID ORDER BY se3.DIFF_TWM DESC) TWM_RANG
                                        FROM ( SELECT se2.*, CASE WHEN (ie.EVENT IS NULL ) THEN \'NO\' ELSE \'YES\' END IS_IDLE
                                                      FROM ( SELECT se.*, en.NAME
                                                                    FROM CLC_DELTA_SYSEVENT se, V$EVENT_NAME en
                                                                    WHERE se.EVENT# = en.EVENT#
                                                                          AND se.CR_SNAP_TIME <= TO_DATE(' . "'$pv{to_range}','YYYY-MM-DD HH24:MI:SS')
                                                                          AND se.CR_SNAP_TIME >= TO_DATE('$pv{from_range}','YYYY-MM-DD HH24:MI:SS')" . ') se2
                                                           LEFT OUTER JOIN
                                                           STATS$IDLE_EVENT ie
                                                           ON se2.NAME = ie.EVENT ) se3,
                                             CLC_SUMEVENTS_TIMING st
                                        WHERE se3.CR_SNAP_ID = st.CR_SNAP_ID ) se4
                         WHERE TWM_RANG < ' . "$pv{scope_ents_len}" . ' AND IS_IDLE = \'NO\'
                         GROUP BY se4.NAME, se4.EVENT_N ' . "ORDER BY $pv{order_field} DESC" ;
   
   my $sth = $dbh->prepare($request) ;
   $sth->execute();

sub print_head_ancor($$) { $a_order_field = $_[0] ; $a_title_field = $_[1] ;
    print "<A HREF=\"$base_url/cgi/get_sysevents_top_from_collector.cgi?order_field=$a_order_field&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">$a_title_field</A>" ;
    }

   print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
   print "<TR><TD ROWSPAN=\"2\" CLASS=\"HEAD\">";       &print_head_ancor("EVENT_N",  "Номер события") ; 
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("NAME",     "Имя события") ; 
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("EN_COUNT", "Количество вхождений события") ; 

   print "    </TD><TD COLSPAN=\"3\" CLASS=\"HEAD\">Суммарные показатели" ;
   print "    </TD><TD COLSPAN=\"3\" CLASS=\"HEAD\">Минимальные показатели" ;
   print "    </TD><TD COLSPAN=\"3\" CLASS=\"HEAD\">Средние показатели" ;
   print "    </TD><TD COLSPAN=\"3\" CLASS=\"HEAD\">Максимальные показатели" ;

   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_TW","Суммарно количество ожиданий") ; 
   print "    </TD><TD ROWSPAN=\"2\" CLASS=\"HEAD\">" ; &print_head_ancor("DIFF_TT","Суммарно повторных таймаутов") ; 

   print "</TD></TR>
              <TR></TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("SUM_TWM",  "ожиданий, микросекунд") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("AV1_PERALL_WT_PRCNT","% от диапазона") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("AV1_NOF_PERCENT","% от нефиктивных") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("MIN_TWM","ожиданий, микросекунд") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("MIN_PERALL_WT_PRCNT","% от диапазона") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("MIN_PER_NOF_WT_PRCNT","% от нефиктивных") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("AVG_TWM","ожиданий, микросекунд") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("AVG_PERALL_WT_PRCNT","% от диапазона") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("AVG_PER_NOF_WT_PRCNT","% от нефиктивных") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("MAX_TWM","ожиданий, микросекунд") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("MAX_PERALL_WT_PRCNT","% от диапазона") ; 
   print "    </TD><TD CLASS=\"HEAD\">" ; &print_head_ancor("MAX_PER_NOF_WT_PRCNT","% от нефиктивных") ; 
   print "</TD></TR>" ;

   $system_events_count_all = 0 ;

   while (my ( $event_n,$name,$en_count,$sum_twm,$av1_perall_wt_prcnt,$av1_nof_prcnt,$min_twm,$min_perall_wt_prcnt,$min_nof_prcnt,$avg_twm,$avg_perall_wt_prcnt,$avg_nof_prcnt,$max_twm,$max_perall_wt_prcnt,$max_nof_prcnt,$diff_tw,$diff_tt ) = $sth->fetchrow_array() ) {
         $system_events_count_all += 1 ;
         $name =~ s/\s/&nbsp;/g ;

#         $evname = $name ; $evname =~ s/\s/_/g ;
         printf("<TR><TD CLASS=\"NUMDATA\">%s</TD>
                 <TD CLASS=\"SZDATA\"><A TARGET=\"_blank\" TITLE=\"описание события ожидания\" HREF=\"$base_url/cgi/get_event_desc.cgi?en=%s\">?</A>&nbsp;<A TARGET=\"cont\" TITLE=\"показать динамику только этого события за выбранный диапазон срезов\"                        
                        HREF=\"$base_url/cgi/get_system_events_from_collector.cgi?order_field=CR_SNAP_ID&incltype=single&sngleventsinc=%d&eventsinc=none&excltype=none&sngleventsexcl=none&eventsexcl=none&srcptr=$pv{srcptr}&is_no_idle=$pv{is_no_idle}&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=raw&is_second=$pv{is_second}\">%s</A></TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     </TR>\n",
                     $event_n,$name,$event_n,$name,&show_razryads($en_count),&show_razryads($sum_twm),$av1_perall_wt_prcnt,$av1_nof_prcnt,
                     &show_razryads($min_twm),$min_perall_wt_prcnt,$min_nof_prcnt,&show_razryads($avg_twm),$avg_perall_wt_prcnt,$avg_nof_prcnt,
                     &show_razryads($max_twm),$max_perall_wt_prcnt,$max_nof_prcnt,$diff_tw,$diff_tt ) ;
         }
   print "<TR><TD COLSPAN=\"17\">
              <TABLE BORDER=\"0\"><TR><TD>Строк всего:</TD><TD>$system_events_count_all</TD></TR>" ;
   print "</TABLE>" ;
   }
# это конец контейнерной таблицы контента
print "</TD></TR></TABLE>" ;

# это конец общей контейнерной таблицы
print "</TD></TR></TABLE>" ;
if ( $is_view_request eq "yes" && $pv{is_second} eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n<P>$request</P>\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-$year Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;

$sth->finish();
$dbh->disconnect();                                        
