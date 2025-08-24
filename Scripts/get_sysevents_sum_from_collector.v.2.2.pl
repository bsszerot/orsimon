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
&print_html_head("Суммарная аналитика событий ожидания экземпляра") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_system_events_navigation(4) ;

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

print "<FORM ACTION=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --
                                                          <BR> -- в силу суммаризации сессионных значений показатели не абсолютные, но сигнальные --</DIV></TD></TR> " ;
#&print_select_data_source() ;
print "<TR><TD>&nbsp;Диапазон выборки: </TD>
           <TD STYLE=\"width: 75%\">с&nbsp;<INPUT TYPE=\"input\" NAME=\"from_range\" VALUE=\"$pv{from_range}\">
               по&nbsp;<INPUT TYPE=\"input\" NAME=\"to_range\" VALUE=\"$pv{to_range}\">&nbsp;формат \"YYYY-MM-DD HH24:MI:SS\"</TD></TR>
       <TR><TD>&nbsp;Группировка: </TD>
           <TD STYLE=\"width: 75%\">
               <SELECT NAME=\"report_type\" STYLE=\"width: 100%\" VALUE=\"$report_type\">
               <OPTION VALUE=\"raw\" $is_selected_raw>Записи коллектора событий без обработки</OPTION>
               <OPTION VALUE=\"perhours\" $is_selected_perhours>Часовая группировка</OPTION>
               <OPTION VALUE=\"perdays\" $is_selected_perdays>Дневная группировка</OPTION>
               <OPTION VALUE=\"permonths\" $is_selected_permonths>Месячная группировка</OPTION>
               </SELECT></TD></TR>
       <INPUT TYPE=\"hidden\" NAME=\"order_field\" VALUE=\"$pv{order_field}\"><INPUT TYPE=\"hidden\" NAME=\"is_second\" VALUE=\"yes\"></TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

# если повторный вызов - считаем, что условия заданы и организуем отображение выборки
if ( $pv{is_second} eq "yes" ) {
   if ( $pv{report_type} eq "raw" ) { 
      $request = 'SELECT POINT_ID, CR_SNAP_ID, TO_CHAR(CR_SNAP_TIME,\'YYYY-MM-DD HH24:MI:SS\'), 
                         PR_SNAP_ID, TO_CHAR(PR_SNAP_TIME,\'YYYY-MM-DD HH24:MI:SS\'), 
                         TOTAL_TIME_MICRO, TOTAL_NOIDLE_WAIT, TOTAL_NOIDLE_PRCNT, QUEUE_WAIT_VAL, QUEUE_WAIT_PRCNT
                         FROM CLC_SUMEVENTS_TIMING
                         WHERE ' . " CR_SNAP_TIME <= TO_DATE('$pv{to_range}','YYYY-MM-DD HH24:MI:SS') AND 
                                     CR_SNAP_TIME >= TO_DATE('$pv{from_range}','YYYY-MM-DD HH24:MI:SS')
                         ORDER BY $pv{order_field}" ;
      }
   else {
      $group_string = "" ;
      if ( $pv{report_type} eq "perhours" ) { $group_string = "YYYY-MM-DD HH24" ; }
      if ( $pv{report_type} eq "perdays" ) { $group_string = "YYYY-MM-DD" ; }
      if ( $pv{report_type} eq "permonths" ) { $group_string = "YYYY-MM" ; }

      $request = "SELECT POINT_ID, MAX(CR_SNAP_ID) CR_SNAP_ID, TO_CHAR(MAX(CR_SNAP_TIME),\'YYYY-MM-DD HH24:MI:SS\') CR_SNAP_TIME, 
                         MIN(PR_SNAP_ID) PR_SNAP_ID, TO_CHAR(MIN(PR_SNAP_TIME),\'YYYY-MM-DD HH24:MI:SS\') PR_SNAP_TIME, 
                         SUM(TOTAL_TIME_MICRO) TOTAL_TIME_MICRO, SUM(TOTAL_NOIDLE_WAIT) TOTAL_NOIDLE_WAIT, 
                         SUM(TOTAL_NOIDLE_WAIT)/( SUM(TOTAL_TIME_MICRO)/100) TOTAL_NOIDLE_PRCNT, SUM(QUEUE_WAIT_VAL) QUEUE_WAIT_VAL,
                         SUM(QUEUE_WAIT_VAL)/( SUM(TOTAL_TIME_MICRO)/100) QUEUE_WAIT_PRCNT
                         FROM CLC_SUMEVENTS_TIMING
                         WHERE CR_SNAP_TIME <= TO_DATE('$pv{to_range}','YYYY-MM-DD HH24:MI:SS') AND 
                               CR_SNAP_TIME >= TO_DATE('$pv{from_range}','YYYY-MM-DD HH24:MI:SS')
                         GROUP BY POINT_ID, TO_CHAR(CR_SNAP_TIME,'$group_string')
                         ORDER BY $pv{order_field}" ;
      }
   
   my $sth = $dbh->prepare($request) ;
   $sth->execute();
   print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
   print "<TR><TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=POINT_ID&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">ID объекта контроля (POINT ID)</A></TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=CR_SNAP_ID&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">ID текущего среза</A></TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=CR_SNAP_TIME&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">Дата текущего среза</A></TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=PR_SNAP_ID&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">ID предыдущего среза</A></TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=PR_SNAP_TIME&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">Дата предыдущего среза</A></TD>
              <TD ROWSPAN=\"2\" CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=TOTAL_TIME_MICRO&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">Длительность среза, микросекунд</A></TD>
              <TD COLSPAN=\"2\" CLASS=\"HEAD\">Длительность нефиктивных ожиданий</TD>
              <TD COLSPAN=\"2\" CLASS=\"HEAD\">Длительность очередей (блокировок)</TD>
              </TR><TR>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=TOTAL_NOIDLE_WAIT&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">микросекунд</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=TOTAL_NOIDLE_PRCNT&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">%</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=QUEUE_WAIT_VAL&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">микросекунд</A></TD>
              <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sysevents_sum_from_collector.cgi?order_field=QUEUE_WAIT_PRCNT&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}\" TARGET=\"cont\">%</A></TD>
              </TR>" ;

   $system_events_count_all = 0 ;
   while (my ( $point_id, $cr_snap_id, $cr_snap_time, $pr_snap_id, $pr_snap_time, $total_time_micro, $total_noidle_wait, $total_noidle_prcnt, $queue_wait_val, $queue_wait_prcnt ) = $sth->fetchrow_array() ) {
         $system_events_count_all += 1 ;
         $cr_snap_time =~ s/\s/&nbsp;/g ; $pr_snap_time =~ s/\s/&nbsp;/g ;
         printf("<TR><TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\"><A TARGET=\"cont\" TITLE=\"показать динамику всех событий за выбранный срез\"
                         HREF=\"$base_url/cgi/get_system_events_from_collector.cgi?order_field=PER_NOF_WT_PERCENT&incltype=single&sngleventsinc=all&eventsinc=$pv{eventsinc}&excltype=$pv{excltype}&sngleventsexcl=$pv{sngleventsexcl}&eventsexcl=$pv{eventsexcl}&srcptr=$pv{srcptr}&is_no_idle=$pv{is_no_idle}&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}&from_snap=%d&to_snap=%d\">%s</A></TD>
                     <TD CLASS=\"SZDATA\"><A TARGET=\"cont\" TITLE=\"показать динамику всех событий за выбранный срез\"
                         HREF=\"$base_url/cgi/get_system_events_from_collector.cgi?order_field=PER_NOF_WT_PERCENT&incltype=single&sngleventsinc=all&eventsinc=$pv{eventsinc}&excltype=$pv{excltype}&sngleventsexcl=$pv{sngleventsexcl}&eventsexcl=$pv{eventsexcl}&srcptr=$pv{srcptr}&is_no_idle=$pv{is_no_idle}&from_range=$pv{from_range}&to_range=$pv{to_range}&report_type=$pv{report_type}&is_second=$pv{is_second}&from_snap=%d&to_snap=%d\">%s</A></TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"SZDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     <TD CLASS=\"NUMDATA\">%s</TD>
                     <TD CLASS=\"NUMDATA\">%0.2f</TD>
                     </TR>\n",
                     $point_id, $cr_snap_id, $cr_snap_id, $cr_snap_id, $cr_snap_id, $cr_snap_id, $cr_snap_time, $pr_snap_id, $pr_snap_time,
                     &show_razryads($total_time_micro), &show_razryads($total_noidle_wait), $total_noidle_prcnt, &show_razryads($queue_wait_val), 
                     $queue_wait_prcnt ) ;
         }
   print "<TR><TD COLSPAN=\"19\">
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
