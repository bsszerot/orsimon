#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_undo_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=BEGIN_TIME\" TARGET=\"cont\">UNDOSTAT</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_undo_rollstat.cgi?order_field=USN\" TARGET=\"cont\">ROLLSTAT</A></TD>
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
$pv{order_field} = "BEGIN_TIME" ; $pv{report_type} = "" ;
get_forms_param() ;

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
                                 
print "Content-Type: text/html\n\n"; 
&print_html_head("Статистика пространства отмены UNDOSTAT") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_undo_navigation(1) ;

print "</TD><TD STYLE=\" padding: 0pt; height: 100%;\">
       <TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; height: 100%;\">
              <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none; height: 100%;\">&nbsp;</TD></TR>
       </TABLE>
       </TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"padding: 0pt;\">" ;

# это начало контейнерной таблицы контента
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">" ;
print "<TR><TD>" ;

# вывести форму выбора отчета ( raw v$log_history, нормализация количества изменений почасово, подневно, понедельно, помесячно )
$is_selected_raw = "" ; if ( $pv{report_type} eq "raw" || $pv{report_type} eq "" ) { $is_selected_raw = "SELECTED" ; }
$is_selected_hourly = "" ; if ( $pv{report_type} eq "hourly" ) { $is_selected_hourly = "SELECTED" ; }
$is_checked_period_default = "" ; if ( $pv{period} eq "default" ) { $is_checked_period_default = "CHECKED" ; }
$is_checked_period_manual = "" ; if ( $pv{period} eq "manual" || $pv{period} eq "" ) { $is_checked_period_manual = "CHECKED" ; }
$curr_date = `date "+%Y-%m-%d"` ; chomp($curr_date) ; 
if ( $pv{period_from} eq "" ) { $pv{period_from} = "$curr_date" ; } if ( $pv{period_to} eq "" ) { $pv{period_to} = "$curr_date" ; } 
print "<FORM ACTION=\"$base_url/cgi/get_undo_undostat.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --</DIV></TD></TR>
       <TR><TD>Отчет: </TD>
           <TD STYLE=\"width: 90%\">
               <SELECT NAME=\"report_type\" STYLE=\"width: 100%\">
               <OPTION VALUE=\"raw\" $is_selected_raw>Записи undostat без обработки (текущий день по умолчанию)</OPTION>
               <OPTION VALUE=\"hourly\" $is_selected_hourly>Записи undostat с почасовой группирповкой (текущий день по умолчанию)</OPTION>
               </SELECT></TD></TR>
       <TR><TD>За период: </TD>
           <TD><INPUT TYPE=\"radio\" NAME=\"period\" VALUE=\"default\" $is_checked_period_default>по умолчанию&nbsp;&nbsp;&nbsp;&nbsp;
               <INPUT TYPE=\"radio\" NAME=\"period\" VALUE=\"manual\" $is_checked_period_manual>указанный (YYYY-MM-DD) с 
                      &nbsp;<INPUT TYPE=\"input\" NAME=\"period_from\" VALUE=\"$pv{period_from}\" LENGHT=\"10\">
                      &nbsp;по&nbsp;<INPUT TYPE=\"input\" NAME=\"period_to\" VALUE=\"$pv{period_to}\">
       </TD></TR>        
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

if ( $pv{report_type} eq "raw" || $pv{report_type} eq "hourly" ) {
# === ОТЧЕТ - полный список полей v$archive_log
   $where_class = "" ; if ( $pv{period} eq "manual" ) { $where_class = ' AND BEGIN_TIME >= ' . "TO_DATE('$pv{period_from} 00:00:00','YYYY-MM-DD HH24:MI:SS') AND " . 'END_TIME < ' . "TO_DATE('$pv{period_to} 23:59:59','YYYY-MM-DD HH24:MI:SS') " ; }
   if ( $pv{report_type} eq "raw" ) { if ( $pv{order_field} eq "" ) { $pv{order_field} = "BEGIN_TIME" ; }
      $request = 'select TO_CHAR(us.BEGIN_TIME,\'YYYY-MM-DD HH24-MI-SS\') BEGIN_TIME, TO_CHAR(us.END_TIME,\'YYYY-MM-DD HH24-MI-SS\') END_TIME, ts.NAME NAME,
                         us.UNDOBLKS UNDOBLKS, us.TXNCOUNT TXNCOUNT, us.MAXQUERYLEN MAXQUERYLEN, us.MAXCONCURRENCY MAXCONCURRENCY, us.UNXPSTEALCNT UNXPSTEALCNT,
                         us.UNXPBLKRELCNT UNXPBLKRELCNT, us.UNXPBLKREUCNT UNXPBLKREUCNT , us.EXPSTEALCNT EXPSTEALCNT, us.EXPBLKRELCNT EXPBLKRELCNT, 
                         us.EXPBLKREUCNT EXPBLKREUCNT, us.SSOLDERRCNT SSOLDERRCNT, us.NOSPACEERRCNT NOSPACEERRCNT from v$undostat us, v$tablespace ts 
                         WHERE ts.ts# = us.UNDOTSN ' . $where_class . ' ORDER BY ' . $pv{order_field} ;
      }
   if ( $pv{report_type} eq "hourly" ) { if ( $pv{order_field} eq "" ) { $pv{order_field} = "BEGIN_TIME" ; }
      $request = 'select TO_CHAR(MIN(us.BEGIN_TIME),\'YYYY-MM-DD HH24-MI-SS\') BEGIN_TIME, TO_CHAR(MAX(us.END_TIME),\'YYYY-MM-DD HH24-MI-SS\') END_TIME, 
                         ts.NAME NAME, SUM(us.UNDOBLKS) UNDOBLKS, SUM(us.TXNCOUNT) TXNCOUNT, SUM(us.MAXQUERYLEN) MAXQUERYLEN, SUM(us.MAXCONCURRENCY) MAXCONCURRENCY,
                         SUM(us.UNXPSTEALCNT) UNXPSTEALCNT, SUM(us.UNXPBLKRELCNT) UNXPBLKRELCNT, SUM(us.UNXPBLKREUCNT) UNXPBLKREUCNT, SUM(us.EXPSTEALCNT) EXPSTEALCNT,
                         SUM(us.EXPBLKRELCNT) EXPBLKRELCNT, SUM(us.EXPBLKREUCNT) EXPBLKREUCNT, SUM(us.SSOLDERRCNT) SSOLDERRCNT, SUM(us.NOSPACEERRCNT) NOSPACEERRCNT 
                         from v$undostat us, v$tablespace ts WHERE ts.ts# = us.UNDOTSN ' . $where_class . ' GROUP BY TO_CHAR(us.BEGIN_TIME,\'YYYY-MM-DD HH24\'), ts.NAME ORDER BY ' . $pv{order_field} ;
      }
# --- вычислить диапазон выводимых значений при необходимости
      my $sth = $dbh->prepare($request) ;
      $sth->execute();
# вывести непосредственно контент
      print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
      print "<TR>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=BEGIN_TIME\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">Начало диапазона</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=END_TIME\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">Конец диапазона</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=NAME\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">TBS\#</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=UNDOBLKS\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">Сгенерировано блоков</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=TXNCOUNT\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">Проведено транзакций</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=MAXQUERYLEN\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">Максимальная транзакция, секунд</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=MAXCONCURRENCY\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">Максимально конкурировавших транзакций</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=UNXPSTEALCNT\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">UNXPSTEALCNT</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=UNXPBLKRELCNT\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">UNXPBLKRELCNT</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=UNXPBLKREUCNT\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">UNXPBLKREUCNT</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=EXPSTEALCNT\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">EXPSTEALCNT</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=EXPBLKRELCNT\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">EXPBLKRELCNT</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=EXPBLKREUCNT\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">EXPBLKREUCNT</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=SSOLDERRCNT\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">SSOLDERRCNT</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_undo_undostat.cgi?order_field=NOSPACEERRCNT\&report_type=$pv{report_type}\&period=$pv{period}\&period_from=$pv{period_from}\&period_to=$pv{period_to}\" TARGET=\"cont\">NOSPACEERRCNT</A></TD>
           </TR>" ;
      $count_rows = 0 ;
      while (my ($begin_time,$end_time,$undotsn,$undoblks,$txncount,$maxquerylen,$maxconcurency,$unxpstealcnt,$unxblkrelcnt,$unxpblkreucnt,$expstealcnt,$expblkrelcnt,$expblkreucnt,$ssolderrcnt,$nospaceerrcnt) = $sth->fetchrow_array() ) {
            $count_rows += 1 ; $begin_time =~ s/\s/&nbsp;/g ; $end_time =~ s/\s/&nbsp;/g ;
            printf("<TR><TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                    </TR>\n",$begin_time,$end_time,$undotsn,&show_razryads($undoblks),&show_razryads($txncount),&show_razryads($maxquerylen),
                             &show_razryads($maxconcurency),&show_razryads($unxpstealcnt),&show_razryads($unxblkrelcnt),&show_razryads($unxpblkreucnt),
                             &show_razryads($expstealcnt),&show_razryads($expblkrelcnt),&show_razryads($expblkreucnt),&show_razryads($ssolderrcnt),
                             &show_razryads($nospaceerrcnt)) ;
            }
        print "<TR><TD CLASS=\"SZDATA\">Итого</TD><TD CLASS=\"NUMDATA\" COLSPAN=\"27\">$count_rows</TD></TR>\n" ;
        print "</TABLE>" ;
        $sth->finish();
        $dbh->disconnect();
# это конец контейнерной таблицы контента
    print "</TD></TR></TABLE>" ;
# это конец общей контейнерной таблицы
print "</TD></TR></TABLE>" ;
    if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n$request\n" ; }
    }
# в случае начального отображения исключить вывод текста запроса
else { print "</TD></TR></TABLE>" ; print "</TD></TR></TABLE>" ; }

print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
