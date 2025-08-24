#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_dbgeneral_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_dbgeneral_db.cgi?order_field=BEGIN_TIME\" TARGET=\"cont\">База</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_dbgeneral_instance.cgi?order_field=BEGIN_TIME\" TARGET=\"cont\">Экземпляр</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_dbgeneral_controlfile.cgi?order_field=BEGIN_TIME\" TARGET=\"cont\">Controlfile</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_dbgeneral_cf_sections.cgi?order_field=TYPE\" TARGET=\"cont\">Секции controlfile</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{5}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_data_from_table_view.cgi?order_field=NAME&owner=SYS&name=V\$PARAMETER2&is_second=yes\" TARGET=\"cont\">INIT параметры</A></TD>
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
#$current_connector = "TITAN_RKB" ;

# - вытащить из URL запроса значения уточняющих полей
$order_field = "GROUPNUM" ;
##if ( $ENV{REQUEST_METHOD} eq "GET" && $ENV{QUERY_STRING} =~ /order_field=(.*)/) { $order_field = $1 ;
##    $order_field =~ s/[\r\n]+//g ; $order_field =~ s/%(..)/pack("c",hex($1))/ge ; }
##else { die "No valid request data $ENV{QUERY_STRING}" ; }

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
$request = 'select DBID, NAME, TO_CHAR(CREATED,\'YYYY-MM-DD HH24:MI:SS\') CREATED, RESETLOGS_CHANGE#, 
                   TO_CHAR(RESETLOGS_TIME,\'YYYY-MM-DD HH24:MI:SS\') RESETLOGS_TIME, 
                   PRIOR_RESETLOGS_CHANGE#, TO_CHAR(PRIOR_RESETLOGS_TIME,\'YYYY-MM-DD HH24:MI:SS\') PRIOR_RESETLOGS_TIME, LOG_MODE, CHECKPOINT_CHANGE#, 
                   ARCHIVE_CHANGE#, CONTROLFILE_TYPE, TO_CHAR(CONTROLFILE_CREATED,\'YYYY-MM-DD HH24:MI:SS\') CONTROLFILE_CREATED, CONTROLFILE_SEQUENCE#, 
                   CONTROLFILE_CHANGE#, TO_CHAR(CONTROLFILE_TIME,\'YYYY-MM-DD HH24:MI:SS\') CONTROLFILE_TIME,
                   OPEN_RESETLOGS, TO_CHAR(VERSION_TIME,\'YYYY-MM-DD HH24:MI:SS\'), OPEN_MODE, PROTECTION_MODE, PROTECTION_LEVEL, REMOTE_ARCHIVE, ACTIVATION#,
                   DATABASE_ROLE, ARCHIVELOG_CHANGE#, SWITCHOVER_STATUS, DATAGUARD_BROKER, GUARD_STATUS, SUPPLEMENTAL_LOG_DATA_MIN, 
                   SUPPLEMENTAL_LOG_DATA_PK, SUPPLEMENTAL_LOG_DATA_UI, FORCE_LOGGING from v$database' ;
                                 
my $sth = $dbh->prepare($request) ;
$sth->execute();
print "Content-Type: text/html\n\n"; 
&print_html_head("Информация о базе") ;

# добавить определение навигационно - оформительского механизма закладок
&print_dbgeneral_navigation(1) ;

print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">" ;
print "<TR><TD>" ;

# вывести непосредственно контент
print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
$count_rows = 0 ;
while (my ($dbid,$name,$created,$resetlogs_change_n,$resetlog_time,$prior_resetlogs_change_n,$prior_resetlogs_time,$log_mode,$checkpoint_change_n,
           $archive_change_n,$controlfile_type,$controlfile_created,$controlfile_sequence_n,$controlfile_change_n,$controlfile_time,$open_resetlogs,
           $version_time,$open_mode,$protection_mode,$protection_level,$remote_archive,$activation_n,$database_role,$archivelog_change_n,
           $switchhover_status,$dataguard_broker,$guard_status,$supplemental_log_data_min,$supplemental_log_data_pk,$supplemental_log_data_ui,
           $force_logging) = $sth->fetchrow_array() ) {
      if ( $status eq "" ) { $status = "&nbsp;" ; } if ( $type eq "" ) { $type = "&nbsp;" ; }

      printf("<TR><TD CLASS=\"CENTERDATA\" COLSPAN=\"3\">Общие сведения</TD></TR>\n") ;
      printf("<TR><TD CLASS=\"SZDATA\">Имя базы</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$name) ;
      printf("<TR><TD CLASS=\"SZDATA\">DB ID</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$dbid) ;
      printf("<TR><TD CLASS=\"SZDATA\">Режим открытия (open mode)</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$open_mode) ;
      printf("<TR><TD CLASS=\"SZDATA\">Дата создания</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$created) ;
      printf("<TR><TD CLASS=\"SZDATA\">Force loggin</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$force_logging) ;
      printf("<TR><TD CLASS=\"SZDATA\">Время версии</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$version_time) ;
      printf("<TR><TD CLASS=\"SZDATA\">Номер активации</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$activation_n) ;

      printf("<TR><TD CLASS=\"CENTERDATA\" COLSPAN=\"3\">Режим журналирования</TD></TR>\n") ;
      printf("<TR><TD CLASS=\"SZDATA\">Режим журналирования</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$log_mode) ;
      printf("<TR><TD CLASS=\"SZDATA\">Наивысший NEXT_CHANGE# в архивных журналах</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$archivelog_change_n) ;

      printf("<TR><TD CLASS=\"CENTERDATA\" COLSPAN=\"3\">Конфигурация горячего резерва</TD></TR>\n") ;
      printf("<TR><TD CLASS=\"SZDATA\">Роль базы</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$database_role) ;
      printf("<TR><TD CLASS=\"SZDATA\">Статус SWITCHHOVER</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$switchhover_status) ;
      printf("<TR><TD CLASS=\"SZDATA\">Dataguard broker</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$dataguard_broker) ;
      printf("<TR><TD CLASS=\"SZDATA\">Статус DataGuard</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$guard_status) ;
      printf("<TR><TD CLASS=\"SZDATA\">Режим защиты (data guard)</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$protection_mode) ;
      printf("<TR><TD CLASS=\"SZDATA\">Уровень защиты (data guard)</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$protection_level) ;

      printf("<TR><TD CLASS=\"CENTERDATA\" COLSPAN=\"3\">Контрольный файл</TD></TR>\n") ;
      printf("<TR><TD CLASS=\"SZDATA\">Тип контрольного файла</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$controlfile_type) ;
      printf("<TR><TD CLASS=\"SZDATA\">Дата создания контрольного файла</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$controlfile_created) ;
      printf("<TR><TD CLASS=\"SZDATA\">Текущее время контрольного файла</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$controlfile_time) ;
      printf("<TR><TD CLASS=\"SZDATA\">Номер последней транзакции контрольного файла</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$controlfile_sequence_n) ;
      printf("<TR><TD CLASS=\"SZDATA\">Последний SCN в бэкапном контрольном файле</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$controlfile_change_n) ;
      printf("<TR><TD CLASS=\"SZDATA\">Номер последнего SCN, прошедшего контрольную точку</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$checkpoint_change_n) ;
      printf("<TR><TD CLASS=\"SZDATA\">Номер последнего заархивированного SCN</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$archive_change_n) ;

      printf("<TR><TD CLASS=\"CENTERDATA\" COLSPAN=\"3\">Инкарнация</TD></TR>\n") ;
      printf("<TR><TD CLASS=\"SZDATA\">Open resetlogs</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$open_resetlogs) ;
      printf("<TR><TD CLASS=\"SZDATA\">Номер стартового изменения текущей инкарнации</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$resetlogs_change_n) ;
      printf("<TR><TD CLASS=\"SZDATA\">Дата старта текущей инкарнации</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$resetlog_time) ;
      printf("<TR><TD CLASS=\"SZDATA\">Номер стартового изменения предидущей инкарнации</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$prior_resetlogs_change_n) ;
      printf("<TR><TD CLASS=\"SZDATA\">Дата старта предидущей инкарнации</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$prior_resetlogs_time) ;

      printf("<TR><TD CLASS=\"CENTERDATA\" COLSPAN=\"3\">Прочее</TD></TR>\n") ;
      printf("<TR><TD CLASS=\"SZDATA\">supplemental_log_data_min</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$supplemental_log_data_min) ;
      printf("<TR><TD CLASS=\"SZDATA\">supplemental_log_data_pk</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$supplemental_log_data_pk) ;
      printf("<TR><TD CLASS=\"SZDATA\">supplemental_log_data_ui</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$supplemental_log_data_ui) ;
      printf("<TR><TD CLASS=\"SZDATA\">Удаленный архив</TD><TD CLASS=\"NUMDATA\">%s</TD></TR>\n",$remote_archive) ;
      }
print "</TABLE>" ;
print "</TD></TR></TABLE>" ;
$sth->finish();
$dbh->disconnect();                                        

if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n$request\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
