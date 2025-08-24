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
require "/var/www/oracle/cgi/omon.cfg" ;
require "/var/www/oracle/cgi/common_func.body" ;
require "/var/www/oracle/cgi/common_awr_function.pl" ;

# - ДЛЯ ВСЕХ МОДУЛЕЙ - инициализировать значения сессии из cookie, если есть, или же использовать значения по умолчанию
$current_connector = "none" ; if ( $ENV{HTTP_COOKIE} =~ /.*[;\s]*current_connector=([^;]+)[;\s]*.*/ ) { $current_connector = $1 ; }
# - вытащить из URL запроса значения уточняющих полей
$pv{order_field} = "FREE_EXT_PERCENT" ;
&get_forms_param() ;

#$ENV{ORACLE_SID} = $current_connector ;
#my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');

if ($pv{set_current_connector} ne "" ) {
   print "Content-Type: text/html\n";
   print "Set-cookie: current_connector=$pv{set_current_connector}; path=/; domain=$ENV{HTTP_HOST}\n\n" ;
   print "<HTML><HEAD><META http-equiv=\"refresh\" content=\"0, url=http:////oracle.zerot.local/cgi/get_db_status.cgi\"></HEAD><BODY></BODY></HTML>" ;
   die 0 ; }
print "Content-Type: text/html\n\n";
&print_html_head("Статусы БД") ;

# - ДЛЯ ВСЕХ МОДУЛЕЙ - инициализировать значения сессии из cookie, если есть, или же использовать значения по умолчанию
$current_connector = "none" ; if ( $ENV{HTTP_COOKIE} =~ /.*[;\s]*current_connector=([^;]+)[;\s]*.*/ ) { $current_connector = $1 ; }

# это начало общей контейнерной таблицы
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; padding: 0pt;\">" ;
print "<TR><TD STYLE=\" padding: 0pt; width: 80%;\">" ;

# добавить определение навигационно - оформительского механизма закладок
&print_db_status_navigation(1) ;

print "</TD><TD STYLE=\" padding: 0pt; height: 100%;\">
       <TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: none; width: 100%; height: 100%;\">
              <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none; height: 100%;\">&nbsp;</TD></TR>
       </TABLE>
       </TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"padding: 0pt;\">" ;

# это начало контейнерной таблицы контента
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">" ;
print "<TR><TD>" ;

print_head_ash_graph() ;
print_js_ash_block() ;

print "</TD></TR>
<TR><TD>
<TABLE STYLE=\"width: 100%\">
<TR><TD STYLE=\"width: 50%; vertical-align: top;\">" ;
print_sql_table_activity($pv{period_from},$pv{period_to},'','','','',$pv{ds_type}) ;
print "</TD><TD STYLE=\"width: 50%; vertical-align: top;\">" ;
print_session_table_activity($pv{period_from},$pv{period_to},'','','','',$pv{ds_type}) ;
# это конец контейнерной таблицы контента
   print "</TD></TR></TABLE>" ;
# это конец общей контейнерной таблицы
   print "</TD></TR></TABLE>" ;
  if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n$request_top_sql\n<BR><BR>$request_top_sess\n" ; }
#   }
#else {
# это конец общей контейнерной таблицы
     print "</TD></TR></TABLE>" ;
#      }

print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
