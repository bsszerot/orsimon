#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_archivelogs_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%; padding: 0pt;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center; padding: 0pt;\">
               <A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=RECID\" TARGET=\"cont\">Архивные журналы</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none; padding: 0pt;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center; padding: 0pt;\">
               <A HREF=\"$base_url/cgi/get_archive_processes_status.cgi?order_field=PROCESS\" TARGET=\"cont\">Процессы архивирования</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none; padding: 0pt;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center; padding: 0pt;\">
               <A HREF=\"$base_url/cgi/get_archive_dest_info.cgi?order_field=DEST_ID\" TARGET=\"cont\">Archive dest</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none; padding: 0pt;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center; padding: 0pt;\">
               <A HREF=\"$base_url/cgi/get_archive_dest_status.cgi?order_field=DEST_ID\" TARGET=\"cont\">Archive dest status</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none; padding: 0pt;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
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
&print_html_head("Информация об архивных журналах") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_archivelogs_navigation(1) ;

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
$is_selected_raw = "" ; if ( $report_type eq "raw" ) { $is_selected_raw = "SELECTED" ; }
$is_selected_short = "" ; if ( $report_type eq "short" || $report_type eq "" ) { $is_selected_short = "SELECTED" ; }
$is_selected_mxnrm = "" ; if ( $report_type eq "mxnrm" ) { $is_selected_mxnrm = "SELECTED" ; }
$is_checked_period_default = "" ; if ( $period eq "default" ) { $is_checked_period_default = "CHECKED" ; }
$is_checked_period_manual = "" ; if ( $period eq "manual" || $period eq "" ) { $is_checked_period_manual = "CHECKED" ; }
$curr_date = `date "+%Y-%m-%d"` ; chomp($curr_date) ; 
if ( $period_from eq "" ) { $period_from = "$curr_date" ; } if ( $period_to eq "" ) { $period_to = "$curr_date" ; } 
print "<FORM ACTION=\"$base_url/cgi/get_archivelogs_list.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --</DIV></TD></TR>
       <TR><TD>Отчет: </TD>
           <TD STYLE=\"width: 90%\">
               <SELECT NAME=\"report_type\" STYLE=\"width: 100%\" VALUE=\"$report_type\">
               <OPTION VALUE=\"raw\" $is_selected_raw>Записи archive_logs без обработки (текущий день по умолчанию)</OPTION>
               <OPTION VALUE=\"short\" $is_selected_short>Записи archive_logs укороченный список (текущий день по умолчанию)</OPTION>
               <OPTION VALUE=\"mxnrm\" $is_selected_mxnrm>Макисмальные номера последовательности архивных журналов, нормализованные</OPTION>
               </SELECT></TD></TR>
       <TR><TD>За период: </TD>
           <TD><INPUT TYPE=\"radio\" NAME=\"period\" VALUE=\"default\" $is_checked_period_default>по умолчанию&nbsp;&nbsp;&nbsp;&nbsp;
               <INPUT TYPE=\"radio\" NAME=\"period\" VALUE=\"manual\" $is_checked_period_manual>указанный (YYYY-MM-DD) с 
                      &nbsp;<INPUT TYPE=\"input\" NAME=\"period_from\" VALUE=\"$period_from\" LENGHT=\"10\">
                      &nbsp;по&nbsp;<INPUT TYPE=\"input\" NAME=\"period_to\" VALUE=\"$period_to\">
       </TD></TR>        
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;
print "</TD></TR><TR><TD>" ;

if ( $report_type eq "raw" || $report_type eq "short" || $report_type eq "mxnrm" ) {
# === ОТЧЕТ - полный список полей v$archive_log
   if ( $report_type eq "raw" ) { if ( $order_field eq "" ) { $order_field = "RECID" ; }
      $where_class = "" ; if ( $period eq "manual" ) { $where_class = ' WHERE FIRST_TIME >= ' . "TO_DATE('$period_from 00:00:00','YYYY-MM-DD HH24:MI:SS') AND " . 'FIRST_TIME < ' . "TO_DATE('$period_to 23:59:59','YYYY-MM-DD HH24:MI:SS') " ; }
      $request = 'select RECID, STAMP, NAME, DEST_ID, THREAD# THREAD, SEQUENCE# SEQUENCE, RESETLOGS_CHANGE# RESETLOGS_CHANGE, TO_CHAR(RESETLOGS_TIME,\'YYYY-MM-DD HH24:MI:SS\') RESETLOGS_TIME, FIRST_CHANGE# FIRST_CHANGE, TO_CHAR(FIRST_TIME,\'YYYY-MM-DD HH24:MI:SS\') FIRST_TIME,
                  NEXT_CHANGE# NEXT_CHANGE, TO_CHAR(NEXT_TIME,\'YYYY-MM-DD HH24:MI:SS\') NEXT_TIME, BLOCKS, BLOCK_SIZE, CREATOR, REGISTRAR, STANDBY_DEST, ARCHIVED, APPLIED, DELETED, decode(STATUS,\'A\',\'Avaliable\',\'D\',\'Deleted\',\'U\',\'Unavaliable\',STATUS) STATUS, 
                  TO_CHAR(COMPLETION_TIME,\'YYYY-MM-DD HH24:MI:SS\') COMPLETION_TIME, DICTIONARY_BEGIN, DICTIONARY_END, END_OF_REDO, BACKUP_COUNT, ARCHIVAL_THREAD# ARCHIVAL_THREAD, ACTIVATION# ACTIVATION from v$archived_log ' . $where_class . ' ORDER BY ' . $order_field ;
# --- вычислить диапазон выводимых значений при необходимости
      my $sth = $dbh->prepare($request) ;
      $sth->execute();
# вывести непосредственно контент
      print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
      print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=RECID\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">ID записи</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=STAMP\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">STAMP</A></TD>
           <TD CLASS=\"HEAD\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=NAME\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Имя&nbsp;файла&nbsp;архивного&nbsp;журнала</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=DEST_ID\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">DEST_ID</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=THREAD\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">THREAD\#</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=SEQUENCE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">SEQUENCE\#</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=RESETLOGS_CHANGE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">RESETLOGS_CHANGE\#</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=RESETLOGS_TIME\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">RESETLOGS_TIME\#</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=FIRST_CHANGE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">FIRST_CHANGE\#</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=FIRST_TIME\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">FIRST_TIME</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=NEXT_CHANGE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">NEXT_CHANGE\#</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=NEXT_TIME\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">NEXT_TIME</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=BLOCKS\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Количество блоков</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=BLOCK_SIZE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Размер блока</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=CREATOR\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Процесс создатель</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=REGISTRAR\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Регистратор</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=STANDBY_DEST\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">STANDBY_DEST</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=ARCHIVED\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">ARCHIVED</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=APPLIED\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">APPLIED</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=DELETED\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">DELETED</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=STATUS\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Статус</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=COMPLETION_TIME\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Окончание создания</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=DICTIONARY_BEGIN\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">DICTIONARY_BEGIN</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=DICTIONARY_END\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">DICTIONARY_END</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=END_OF_REDO\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">END_OF_REDO</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=BACKUP_COUNT\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">BACKUP_COUNT</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=ARCHIVAL_THREAD\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">ARCHIVAL_THREAD\#</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=ACTIVATION\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">ACTIVATION\#</A></TD>
           </TR>" ;
      $count_rows = 0 ;
      while (my ($recid,$stamp,$name,$dest_id,$thread,$sequence,$resetlogs_change,$resetlogs_time,$first_change,$first_time,$next_change,$next_time,$blocks,$block_size, $creator,$registrar,$standby_dest,$archived,$applied,$deleted,$status,$completion_time,$dictionary_begin,$dicrionary_end,$end_of_redo,$backup_count,$archival_thread,$activation) = $sth->fetchrow_array() ) {
            $count_rows += 1 ;
            $name =~ s/\s/&nbsp;/g ; $resetlogs_time =~ s/\s/&nbsp;/g ; $first_time =~ s/\s/&nbsp;/g ; $next_time =~ s/\s/&nbsp;/g ; $completion_time =~ s/\s/&nbsp;/g ;

            printf("<TR><TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                    </TR>\n",$recid,$stamp,$name,$dest_id,$thread,&show_razryads($sequence),&show_razryads($resetlogs_change),$resetlogs_time,&show_razryads($first_change),$first_time,&show_razryads($next_change),$next_time,&show_razryads($blocks),$block_size, $creator,$registrar,$standby_dest,$archived,$applied,$deleted,$status,$completion_time,$dictionary_begin,$dicrionary_end,$end_of_redo,&show_razryads($backup_count),$archival_thread,$activation) ;
            }
        print "<TR><TD CLASS=\"SZDATA\">Итого</TD><TD CLASS=\"NUMDATA\" COLSPAN=\"27\">$count_rows</TD></TR>\n" ;
        print "</TABLE>" ;
        $sth->finish();
        $dbh->disconnect();
        }

# === ОТЧЕТ - укороченный список полей v$archive_log
   if ( $report_type eq "short" ) { if ( $order_field eq "" ) { $order_field = "RECID" ; }
      $where_class = "" ; if ( $period eq "manual" ) { $where_class = ' WHERE FIRST_TIME >= ' . "TO_DATE('$period_from 00:00:00','YYYY-MM-DD HH24:MI:SS') AND " . 'FIRST_TIME < ' . "TO_DATE('$period_to 23:59:59','YYYY-MM-DD HH24:MI:SS') " ; }
      $request = 'select RECID, NAME, FIRST_CHANGE# FIRST_CHANGE, NEXT_CHANGE# NEXT_CHANGE, BLOCKS, BLOCK_SIZE, STANDBY_DEST, ARCHIVED, APPLIED, DELETED, decode(STATUS,\'A\',\'Avaliable\',\'D\',\'Deleted\',\'U\',\'Unavaliable\',STATUS) STATUS 
                  from v$archived_log ' . $where_class . ' ORDER BY ' . $order_field ;
# --- вычислить диапазон выводимых значений при необходимости
      my $sth = $dbh->prepare($request) ;
      $sth->execute();
# вывести непосредственно контент
      print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
      print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=RECID\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">ID записи</A></TD>
           <TD CLASS=\"HEAD\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=NAME\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Имя&nbsp;файла&nbsp;архивного&nbsp;журнала</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=FIRST_CHANGE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">FIRST_CHANGE\#</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=NEXT_CHANGE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">NEXT_CHANGE\#</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=BLOCKS\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Блоков</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=BLOCK_SIZE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Размер блока</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=STANDBY_DEST\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">STANDBY DEST</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=ARCHIVED\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">ARCHIVED</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=APPLIED\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">APPLIED</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=DELETED\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">DELETED</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=STATUS\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Статус</A></TD>
           </TR>" ;
      $count_rows = 0 ;
      while (my ($recid,$name,$first_change,$next_change,$blocks,$block_size,$standby_dest,$archived,$applied,$deleted,$status) = $sth->fetchrow_array() ) {
            $count_rows += 1 ;
            $name =~ s/\s/&nbsp;/g ; $resetlogs_time =~ s/\s/&nbsp;/g ; $first_time =~ s/\s/&nbsp;/g ; $next_time =~ s/\s/&nbsp;/g ; $completion_time =~ s/\s/&nbsp;/g ;
            printf("<TR><TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                    </TR>\n",$recid,$name,&show_razryads($first_change),&show_razryads($next_change),&show_razryads($blocks),$block_size,$standby_dest,$archived,$applied,$deleted,$status) ;
            }
        print "<TR><TD CLASS=\"SZDATA\">Итого</TD><TD CLASS=\"NUMDATA\" COLSPAN=\"10\">$count_rows</TD></TR>\n" ;
        print "</TABLE>" ;
        $sth->finish();
        $dbh->disconnect();
        }

# === ОТЧЕТ - выборка максимальных номеров последовательностей архивных журналов, группированных по различным статусам
   if ( $report_type eq "mxnrm" ) { if ( $order_field eq "" ) { $order_field = "DEST_ID" ; }

      $where_class = "" ; if ( $period eq "manual" ) { $where_class = ' WHERE FIRST_TIME >= ' . "TO_DATE('$period_from 00:00:00','YYYY-MM-DD HH24:MI:SS') AND " . 'FIRST_TIME < ' . "TO_DATE('$period_to 23:59:59','YYYY-MM-DD HH24:MI:SS') " ; }
      $request = 'select DEST_ID, max(SEQUENCE#) SEQUENCE, CREATOR, REGISTRAR, STANDBY_DEST, ARCHIVED, APPLIED, DELETED, decode(STATUS,\'A\',\'Avaliable\',\'D\',\'Deleted\',\'U\',\'Unavaliable\',STATUS) STATUS from v$archived_log ' . $where_class . ' GROUP BY DEST_ID, CREATOR, REGISTRAR, STANDBY_DEST, ARCHIVED, APPLIED, DELETED, STATUS ORDER BY ' . $order_field ;
      my $sth = $dbh->prepare($request) ;
      $sth->execute();
# вывести непосредственно контент
      print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
      print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=DEST_ID\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">DEST_ID</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=SEQUENCE\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">SEQUENCE\#</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=CREATOR\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">CREATOR</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=REGISTRAR\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">REGISTRAR</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=STANDBY_DEST\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">STANDBY DEST</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=ARCHIVED\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">ARCHIVED</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=APPLIED\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">APPLIED</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=DELETED\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">DELETED</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_archivelogs_list.cgi?order_field=STATUS\&report_type=$report_type\&period=$period\&period_from=$period_from\&period_to=$period_to\" TARGET=\"cont\">Статус</A></TD>
           </TR>" ;
      $count_rows = 0 ;
      while (my ($dest_id,$sequence,$creator,$registrar,$standby_dest,$archived,$applied,$deleted,$status) = $sth->fetchrow_array() ) {
            $count_rows += 1 ;
            $name =~ s/\s/&nbsp;/g ; $resetlogs_time =~ s/\s/&nbsp;/g ; $first_time =~ s/\s/&nbsp;/g ; $next_time =~ s/\s/&nbsp;/g ; $completion_time =~ s/\s/&nbsp;/g ;
            printf("<TR><TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"NUMDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"SZDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                        <TD CLASS=\"CENTERDATA\">%s</TD>
                    </TR>\n",$dest_id,&show_razryads($sequence),$creator,$registrar,$standby_dest,$archived,$applied,$deleted,$status) ;
            }
        print "<TR><TD CLASS=\"SZDATA\">Итого</TD><TD CLASS=\"NUMDATA\" COLSPAN=\"8\">$count_rows</TD></TR>\n" ;
        print "</TABLE>" ;
        $sth->finish();
        $dbh->disconnect();
        }
    }
# это конец контейнерной таблицы контента
print "</TD></TR></TABLE>" ;

# это конец общей контейнерной таблицы
print "</TD></TR></TABLE>" ;

if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n$request\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;

