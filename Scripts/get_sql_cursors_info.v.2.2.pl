#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено


sub print_sqlarea_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ADDRESS\" TARGET=\"cont\">Срезы<BR>данных<BR>SQLAREA</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_area_from_collector.cgi?order_field=CR_SQL_ID\" TARGET=\"cont\">Коллектор<BR>SQLAREA</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ADDRESS\" TARGET=\"cont\">Аналитика<BR>ТОПов<BR>SQLAREA</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ADDRESS\" TARGET=\"cont\">Срезы<BR>планов&nbsp;SQL<BR>запросов</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{5}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_cursors_info.cgi?order_field=s.ADDRESS\" TARGET=\"cont\">Срезы<BR>курсоров</A></TD>
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
$order_field = "s.ADDRESS" ; $report_type = "" ;
if ( $ENV{REQUEST_METHOD} eq "GET" && $ENV{QUERY_STRING} =~ /^order_field=([^&]*)$/ ) { $order_field = $1 ;
     $order_field =~ s/[\r\n]+//g ; $order_field =~ s/%(..)/pack("c",hex($1))/ge ; }
else { die "No valid request data $ENV{QUERY_STRING}" ; }

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
                                 
print "Content-Type: text/html\n\n"; 
&print_html_head("Информация о курсорах SQL") ;

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_sqlarea_navigation(5) ;

print "</TD><TD STYLE=\" padding: 0pt; height: 100%;\">
       <TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; height: 100%;\">
              <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none; height: 100%;\">&nbsp;</TD></TR>
       </TABLE>
       </TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"padding: 0pt;\">" ;

# это начало контейнерной таблицы контента
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">" ;
print "<TR><TD>" ;
$request = 'select s.ADDRESS,s.HASH_VALUE,s.OBJECT_STATUS,s.REMOTE,s.PLAN_HASH_VALUE,s.CHILD_NUMBER,s.OUTLINE_CATEGORY,s.OUTLINE_SID,s.CHILD_ADDRESS,s.SQLTYPE,s.LITERAL_HASH_VALUE,
                   s.LOADED_VERSIONS,s.OPEN_VERSIONS,s.CPU_TIME,s.ELAPSED_TIME,s.SHARABLE_MEM,s.PERSISTENT_MEM,s.RUNTIME_MEM,s.SORTS,s.DISK_READS,s.BUFFER_GETS,s.ROWS_PROCESSED,
                   s.PARSE_CALLS,s.EXECUTIONS,s.FETCHES,lu.USERNAME PARSING_USER,lc.USERNAME PARSING_SCHEMA,s.KEPT_VERSIONS,s.USERS_OPENING,s.USERS_EXECUTING,
                   s.FIRST_LOAD_TIME,s.LOADS,s.INVALIDATIONS,s.LAST_LOAD_TIME,s.COMMAND_TYPE,s.OPTIMIZER_MODE,s.OPTIMIZER_COST,s.MODULE,s.ACTION,s.SERIALIZABLE_ABORTS,s.IS_OBSOLETE,s.CHILD_LATCH 
                   from v$sql s, dba_users lu, dba_users lc where s.PARSING_USER_ID = lu.USER_ID AND s.PARSING_SCHEMA_ID = lc.USER_ID ORDER BY ' . $order_field ;

my $sth = $dbh->prepare($request) ;
$sth->execute();
# вывести непосредственно контент

print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ADDRESS\" TARGET=\"cont\">Курсор SQL</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.OBJECT_STATUS\" TARGET=\"cont\">Статус объекта</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.REMOTE\" TARGET=\"cont\">Удаленное мапирование</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.PLAN_HASH_VALUE\" TARGET=\"cont\">PLAN_HASH_VALUE</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.CHILD_NUMBER\" TARGET=\"cont\">CHILD_NUMBER</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.OUTLINE_CATEGORY\" TARGET=\"cont\">OUTLINE_CATEGORY</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.OUTLINE_SID\" TARGET=\"cont\">OUTLINE_SID</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.CHILD_ADDRESS\" TARGET=\"cont\">CHILD_ADDRESS</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.SQLTYPE\" TARGET=\"cont\">Тип SQL</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.LITERAL_HASH_VALUE\" TARGET=\"cont\">LITERAL_HASH_VALUE</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.LOADED_VERSIONS\" TARGET=\"cont\">Загружено курсоров</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.OPEN_VERSIONS\" TARGET=\"cont\">Открыто сейчас</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.CPU_TIME\" TARGET=\"cont\">Время процессора</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ELAPSED_TIME\" TARGET=\"cont\">Время всего</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.SHARABLE_MEM\" TARGET=\"cont\">Памяти, всего</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.PERSISTENT_MEM\" TARGET=\"cont\">Памяти, постоянной</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.RUNTIME_MEM\" TARGET=\"cont\">Памяти, runtime</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.SORTS\" TARGET=\"cont\">Завершенных сортировок</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.DISK_READS\" TARGET=\"cont\">Физических чтений</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.BUFFER_GETS\" TARGET=\"cont\">Логических чтений</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ROWS_PROCESSED\" TARGET=\"cont\">Обработано строк</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.PARSE_CALLS\" TARGET=\"cont\">Количество разборов</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.EXECUTIONS\" TARGET=\"cont\">Количество выполнений</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.FETCHES\" TARGET=\"cont\">Возвратов данных</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=lu.ISER_ID\" TARGET=\"cont\">Первый пользователь</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=lc.ISER_ID\" TARGET=\"cont\">Первая схема</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.KEPT_VERSIONS\" TARGET=\"cont\">Маркированных курсоров</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.USERS_OPENING\" TARGET=\"cont\">Пользователей открывало</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.USERS_EXECUTING\" TARGET=\"cont\">Пользователей исполняло</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.FIRST_LOAD_TIME\" TARGET=\"cont\">Время первой загрузки</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.LOADS\" TARGET=\"cont\">Загрузок и перезагрузок</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.INVALIDATIONS\" TARGET=\"cont\">INVALIDATIONS</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.LAST_LOAD_TIME\" TARGET=\"cont\">Время последней загрузки</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.COMMAND_TYPE\" TARGET=\"cont\">Тип команды</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.OPTIMIZER_MODE\" TARGET=\"cont\">Режим оптимизатора</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.OPTIMIZER_COST\" TARGET=\"cont\">Стоимость запроса</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.MODULE\" TARGET=\"cont\">MODULE</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ACTION\" TARGET=\"cont\">ACTION</A></TD>

           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.SERIALIZABLE_ABORTS\" TARGET=\"cont\">SERIALIZABLE_ABORTS</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.IS_OBSOLETE\" TARGET=\"cont\">IS_OBSOLETE</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.CHILD_LATCH\" TARGET=\"cont\">CHILD_LATCH</A></TD>
       </TR>" ;

$count_rows = 0 ;
while (my ($address,$hash_value,$object_status,$remote,$plan_hash_value,$child_number,$outline_category,$outline_sid,$child_address,$sqltype,$literal_hash_value,$loaded_versions,$open_versions,$cpu_time,$eplased_time,$sharable_mem,$persistent_mem,$runtime_mem,$sorts,$disk_reads,$buffer_gets,$rows_processed,$parse_calls,$fetches,$executions,$parsibg_user_id,$parsing_chema_id,$kept_versions,$users_opening,$users_executing,$first_load_time,$loads,$invalidations,$last_load_time,$command_type,$optimizer_mode,$optimizer_cost,$module,$action,$serializable_aborts,$is_obsolete,$child_latch) = $sth->fetchrow_array() ) {
      $count_rows += 1 ; 
      if ( $module eq "" ) { $module = "&nbsp;" ; } $module =~ s/\s/&nbsp;/g ;
      if ( $action eq "" ) { $action = "&nbsp;" ; } $action =~ s/\s/&nbsp;/g ;
      if ( $optimizer_mode eq "" ) { $optimizer_mode = "&nbsp;" ; } $optimizer_mode =~ s/\s/&nbsp;/g ;
      if ( $object_status eq "" ) { $object_status = "&nbsp;" ; } $object_status =~ s/\s/&nbsp;/g ;
      if ( $optimizer_cost eq "" ) { $optimizer_cost = "&nbsp;" ; } $optimizer_cost =~ s/\s/&nbsp;/g ;
      if ( $outline_category eq "" ) { $outline_category = "&nbsp;" ; } $outline_category =~ s/\s/&nbsp;/g ;
      printf("<TR><TD CLASS=\"SZDATA\"><A HREF=\"$base_url/cgi/get_sql_info.cgi?address=%s&hash_value=%s\">%s,&nbsp;%s,&nbsp;%s</A></TD>
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
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
              </TR>\n",$address,$hash_value,$address,$hash_value,$child_address,$object_status,$remote,$plan_hash_value,$child_number,$outline_category,
                       $outline_sid,$child_address,$sqltype,$literal_hash_value,$loaded_versions,$open_versions,&show_razryads($cpu_time),&show_razryads($eplased_time),
                       &show_razryads($sharable_mem),&show_razryads($persistent_mem),&show_razryads($runtime_mem),&show_razryads($sorts),
                       &show_razryads($disk_reads),&show_razryads($buffer_gets),&show_razryads($rows_processed),&show_razryads($parse_calls),
                       &show_razryads($fetches),&show_razryads($executions),$parsibg_user_id,$parsing_chema_id,&show_razryads($kept_versions),
                       &show_razryads($users_opening),&show_razryads($users_executing),$first_load_time,&show_razryads($loads),
                       &show_razryads($invalidations),$last_load_time,$command_type,$optimizer_mode,$optimizer_cost,$module,$action,$serializable_aborts,$is_obsolete,$child_latch) ;
      }
print "<TR><TD CLASS=\"SZDATA\">Итого</TD><TD CLASS=\"NUMDATA\" COLSPAN=\"40\">$count_rows</TD></TR>\n" ;
print "</TABLE>" ;
$sth->finish();
$dbh->disconnect();
# это конец контейнерной таблицы контента
print "</TD></TR></TABLE>" ;

# это конец общей контейнерной таблицы
print "</TD></TR></TABLE>" ;
      
if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n$request\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
