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

use DBI;
#u#se POSIX;
#u#se locale;
#$#loc = POSIX::setlocale( &POSIX::LC_ALL, "ru_RU.UTF8" );

require "/var/www/oracle/cgi/omon.cfg" ;
require "/var/www/oracle/cgi/common_func.body" ;
require "/var/www/oracle/cgi/common_awr_function.pl" ;
$current_connector = "none" ; if ( $ENV{HTTP_COOKIE} =~ /.*[;\s]*current_connector=([^;]+)[;\s]*.*/ ) { $current_connector = $1 ; }

$ENV{ORACLE_SID} = $current_connector ;

# - вытащить из URL запроса значения уточняющих полей
get_forms_param() ;

# логика работы модуля
# отразить полный текст запроса для данного среза данных
# отразить список планов исполнения за все периоды (возможно несколько планов, так что отразить также общее количество за период)
# сами планы не отражать - для этого предусмотреть отдельный модуль

# для текущего среза взять из библиотечного кеша, для прошлых данных выбрать первый подходящий источник, что допустимо в силу природы хэша
if ( "$pv{srcptr}" eq "" or "$pv{srcptr}" eq "0" ) { $request_sql_text = "select SQL_TEXT from v\$sqltext_with_newlines where SQL_ID = '$pv{sql_id}' ORDER BY PIECE" ; }
else { $request_sql_text = "select SQL_TEXT from BESTAT_V\$SQLTEXT_WITH_NEWLINES where SQL_ID = '$pv{sql_id}' AND POINT_ID = $pv{srcptr} ORDER BY PIECE" ; }
#$request_plan_prefix = "SELECT cardinality, lpad(' ',level-1)||operation,options,object_name, search_columns,cost,cpu_cost,io_cost,temp_space
#                               FROM v\$sql_plan
#                               CONNECT BY prior id = parent_id AND prior ADDRESS = ADDRESS AND prior HASH_VALUE = HASH_VALUE AND prior CHILD_NUMBER = CHILD_NUMBER
#                               START WITH id = 0 AND " ;
#AND ADDRESS = '740B4A90' AND HASH_VALUE = '178867674' AND CHILD_NUMBER = 1
#                               ORDER BY id" ;

#$request_plan_sql_text = "select * from table (dbms_xplan.display_cursor('$pv{sql_id}',0,'ADVANCED'))" ;
#$request_plan_sql_text = "select * from table (dbms_xplan.display_cursor('$pv{sql_id}',0,'ALLSTATS LAST'))" ;
###$request_plan_sql_text = "select * from table (dbms_xplan.display_cursor('$pv{sql_id}',null,'ADVANCED ALLSTATS'))" ;
#$request_plan_sql_text = "select * from table (dbms_xplan.display_cursor('$pv{sql_id}',0,'ALLSTATS LAST'))" ;
#$request_plan_sql_text = "select * from table (dbms_xplan.display_cursor('$pv{sql_id}',null,'ADAPTIVE ALLSTATS'))" ;

#$request_plan_sql_text = "select * from table (dbms_xplan.display_cursor('$pv{sql_id}',null,'ALL ADAPTIVE ALLSTATS ADVANCED LAST'))" ;
#для 11 версии
$request_plan_sql_text = "select * from table (dbms_xplan.display_cursor('$pv{sql_id}',null,'ALL'))" ;

print "Content-Type: text/html\n\n";
&print_html_head("Информация о SQL запросе SQL_ID = $pv{sql_id}, срез данных = $pv{ds_type}") ;

print_head_ash_graph() ;
print_js_ash_block() ;
print "<BR>" ;
if ( $pv{page_part} eq "" ) { $pv{page_part} = 2 ; }
print_get_sql_info_by_id_internal_navigation($pv{page_part}) ;
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">
    <TR><TD>" ;
# это начало внутренней контейнерной таблицы контента

if ($pv{page_part} eq "1") {
   print "<TABLE STYLE=\"width: 100%\">
          <TR><TD STYLE=\"width: 50%; vertical-align: top;\">" ;
   print_session_table_activity($pv{period_from},$pv{period_to},$pv{sql_id},'','','',$pv{ds_type}) ;
   print "</TD><TD STYLE=\"width: 50%; vertical-align: top;\">" ;
print "&nbsp;" ;
   print "</TD></TR></TABLE>" ;
   }

if ($pv{page_part} eq "2") {
# - запросить данные по указанным значениям фильтра и вывести их (по идее должна возвращаться только одна
# - сессия, но испогльзована универсальная конструкция обработки многих строк
   my $dbconn_main = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');

# получить и вывести текст SQL запроса
   my $cursor_handler_main = $dbconn_main->prepare($request_sql_text) ; $cursor_handler_main->execute();
   $sql_text_result = "" ;

   print "<P><FONT COLOR=\"navy\"><B>Текст SQL запроса:</B></FONT></P>" ;
   print "<PRE>" ;
   while ( my ($sql_text_result) = $cursor_handler_main->fetchrow_array() ) {
         $sql_text_result =~ s/[\r\n]+/<BR>/g ;
         print "$sql_text_result\n" ; }
   print "</PRE>" ;

   $cursor_handler_main = $dbconn_main->prepare($request_plan_sql_text) ; $cursor_handler_main->execute();
# вывести содержимое
   print "<P><FONT COLOR=\"navy\"><B>План дочернего курсора с параметрами: $filter_for_plan[$i1]</B></FONT></P>" ;
   print "<PRE>" ; 
   while ( @plan_result = $cursor_handler_main->fetchrow_array() ) {
         for ($i=0;$i<=$#plan_result;$i++) { my $column_value = $plan_result[$i];
             $column_value =~ s/\s/&nbsp;/g ; if ( $column_value eq "" ) { $column_value = "&nbsp;" ; }
             print "$column_value\n" ; } }
   print "</PRE>" ;
   }

$cursor_handler_main->finish();
$dbconn_main->disconnect();


print "</TD></TR></TABLE> " ; 

print "<BR>" ;
if ( $is_view_request eq "yes" ) {
   print "<BR><HR COLOR=\"navy\">
              <P><FONT COLOR=\"navy\"><B>Справочно: запрос о тексте SQL</B></FONT> <BR>$request_sql_text <BR><BR><B>Справочно: запрос плана SQL</B></FONT> <BR>$request_plan_sql_text</P>\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
