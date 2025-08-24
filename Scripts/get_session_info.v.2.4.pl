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
use POSIX;
use locale;
$loc = POSIX::setlocale( &POSIX::LC_ALL, "ru_RU.UTF8" );
require "/var/www/oracle/cgi/omon.cfg" ;
require "/var/www/oracle/cgi/common_func.body" ;
require "/var/www/oracle/cgi/common_awr_function.pl" ;

$current_connector = "none" ; if ( $ENV{HTTP_COOKIE} =~ /.*[;\s]*current_connector=([^;]+)[;\s]*.*/ ) { $current_connector = $1 ; }

$ENV{ORACLE_SID} = $current_connector ;

get_forms_param() ;
$sid = $pv{sid} ; $serial = $pv{serial} ;


print "Content-Type: text/html\n\n"; 
&print_html_head("Информация о сессии SID = $sid, SERIAL# = $serial") ;

print_head_ash_graph() ;
print_js_ash_block() ;
#-debug-print "<BR>\n--- page_part $pv{page_part} ---<BR>" ;
if ( $pv{page_part} eq "" ) { $pv{page_part} = 1 ; }
print "<BR>" ;
print_get_session_info_internal_navigation($pv{page_part}) ;
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">
       <TR><TD>" ;
# --- подготовить коннектор для выборки различных уточняющих даных
my $dbconn_ext = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '') ;

if ($pv{page_part} eq "1" ) {
# это начало внутренней контейнерной таблицы контента
print "<TABLE STYLE=\"width: 100%\">
       <TR><TD STYLE=\"width: 50%; vertical-align: top;\">" ;
# - запросить данные по указанным значениям фильтра и вывести их (по идее должна возвращаться только одна
# - сессия, но использована универсальная конструкция обработки многих строк
$request_main = 'select s.SID,s.SERIAL#,TO_CHAR(s.LOGON_TIME,\'YYYY-MM-DD HH24:MI:SS\'),s.USERNAME,s.MODULE,s.ACTION,s.CLIENT_INFO,s.STATUS,a.NAME COMMAND, 
                        s.LOCKWAIT,s.OSUSER,s.PROCESS,s.MACHINE,s.TERMINAL,s.PROGRAM,s.SQL_ADDRESS,s.SQL_HASH_VALUE,s.PREV_SQL_ADDR,s.PREV_HASH_VALUE, 
                        s.ROW_WAIT_OBJ#,s.ROW_WAIT_FILE#,s.ROW_WAIT_BLOCK#,s.ROW_WAIT_ROW#,p.SPID,p.USERNAME,p.TERMINAL,p.PROGRAM,p.TRACEID, 
                        CASE p.BACKGROUND WHEN \'1\' THEN \'BGR\' ELSE \'FRG\' END BACKGROUND, p.LATCHWAIT,p.LATCHSPIN,p.PGA_USED_MEM,p.PGA_ALLOC_MEM, 
                        p.PGA_FREEABLE_MEM,p.PGA_MAX_MEM 
                        from v$session s, v$process p, audit_actions a 
                        where s.paddr = p.addr and s.command = a.action' . " and s.sid = $sid and s.serial# = $serial" ;
my $dbconn_main = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
my $cursor_handler_main = $dbconn_main->prepare($request_main) ;
$cursor_handler_main->execute();
while (my ($s_sid,$s_serial,$s_logon_time,$s_username,$s_module,$s_action,$s_client_info,$s_status,$a_command,$s_lockwait,$s_osuser,$s_process,$s_machine,
           $s_terminal,$s_program,$s_sql_address,$s_sql_hash_value,$s_prev_sql_addr,$s_prev_hash_value,$s_row_wait_obj,$s_row_wait_file,$s_row_wait_block,
           $s_row_wait_row,$p_spid,$p_username,$p_terminal,$p_program,$p_traceid,$p_background,$p_latchwait,$p_latchspin,$p_pga_used_mem,$p_pga_alloc_mem,
           $p_pga_freeable_mem,$p_pga_max_mem) = $cursor_handler_main->fetchrow_array() ) {

# --- предусмотреть возврат запросом пустых значений
      $s_sidif =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_sid eq "" ) { $s_sid = "&nbsp;" ; }
      $s_serial =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_serial eq "" ) { $s_serial = "&nbsp;" ; }
      $s_logon_time =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_logon_time eq "" ) { $s_logon_time = "&nbsp;" ; }
      $s_username =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_username eq "" ) { $s_username = "&nbsp;" ; }
      $s_module =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_module eq "" ) { $s_module = "&nbsp;" ; }
      $s_action =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_action eq "" ) { $s_action = "&nbsp;" ; }
      $s_client_info =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_client_info eq "" ) { $s_client_info = "&nbsp;" ; }
      $s_status =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_status eq "" ) { $s_status = "&nbsp;" ; }
      $a_command =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $a_command eq "" ) { $a_command = "&nbsp;" ; }
      $s_lockwait =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_lockwait eq "" ) { $s_lockwait = "&nbsp;" ; }
      $s_osuser =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_osuser eq "" ) { $s_osuser = "&nbsp;" ; }
      $s_process =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_process eq "" ) { $s_process = "&nbsp;" ; }
      $s_machine =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_machine eq "" ) { $s_machine = "&nbsp;" ; }
      $s_terminal =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_terminal eq "" ) { $s_terminal = "&nbsp;" ; }
      $s_program =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_program eq "" ) { $s_program = "&nbsp;" ; }
      $s_sql_address =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_sql_address eq "" ) { $s_sql_address = "&nbsp;" ; }
      $s_sql_hash_value =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_sql_hash_value eq "" ) { $s_sql_hash_value = "&nbsp;" ; }
      $s_prev_sql_addr =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_prev_sql_addr eq "" ) { $s_prev_sql_addr = "&nbsp;" ; }
      $s_prev_hash_value =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_prev_hash_value eq "" ) { $s_prev_hash_value = "&nbsp;" ; }
      $s_row_wait_obj =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_row_wait_obj eq "" ) { $s_row_wait_obj = "&nbsp;" ; }
      $s_row_wait_file =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_row_wait_file eq "" ) { $s_row_wait_file = "&nbsp;" ; }
      $s_row_wait_block =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_row_wait_block eq "" ) { $s_row_wait_block = "&nbsp;" ; }
      $s_row_wait_row =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $s_row_wait_row eq "" ) { $s_row_wait_row = "&nbsp;" ; }
      $p_spid =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_spid eq "" ) { $p_spid = "&nbsp;" ; }
      $p_username =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_username eq "" ) { $p_username = "&nbsp;" ; }
      $p_terminal =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_terminal eq "" ) { $p_terminal = "&nbsp;" ; }
      $p_program =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_program eq "" ) { $p_program = "&nbsp;" ; }
      $p_traceid =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_traceid eq "" ) { $p_traceid = "&nbsp;" ; }
      $p_background =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_background eq "" ) { $p_background = "&nbsp;" ; }
      $p_latchwait =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_latchwait eq "" ) { $p_latchwait = "&nbsp;" ; }
      $p_latchspin =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_latchspin eq "" ) { $p_latchspin = "&nbsp;" ; }
      $p_pga_used_mem =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_pga_used_mem eq "" ) { $p_pga_used_mem = "&nbsp;" ; }
      $p_pga_alloc_mem =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_pga_alloc_mem eq "" ) { $p_pga_alloc_mem = "&nbsp;" ; }
      $p_pga_freeable_mem =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_pga_freeable_mem eq "" ) { $p_pga_freeable_mem = "&nbsp;" ; }
      $p_pga_max_mem =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ; if ( $p_pga_max_mem eq "" ) { $p_pga_max_mem = "&nbsp;" ; }

# --- отразить общие данные по запрошенной сессии
      print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
             <TR><TD CLASS=\"HEAD_1\" COLSPAN=\"4\">Общие данные о сессии</TD></TR>" ;
      print "<TR><TD CLASS=\"SZDATA\">Статус сессии</TD><TD CLASS=\"SZDATA\">$s_status</TD>
                 <TD CLASS=\"SZDATA\">Пользовательский модуль</TD><TD CLASS=\"SZDATA\">" ; print $s_module ; print "</TD></TR>" ;
      print "<TR><TD CLASS=\"SZDATA\">Текущее действие</TD><TD CLASS=\"SZDATA\">$a_command</TD>
                 <TD CLASS=\"SZDATA\">Пользовательское действие</TD><TD CLASS=\"SZDATA\">" ; print $s_action ; print "</TD></TR>" ;
      print "<TR><TD CLASS=\"SZDATA\">Ожидание блокировки</TD><TD CLASS=\"SZDATA\">$s_lockwait</TD>
                 <TD CLASS=\"SZDATA\">Пользовательская информация</TD><TD CLASS=\"SZDATA\">" ; print $s_client_info ; print "</TD></TR>" ;
      print "<TR><TD COLSPAN=\"4\">&nbsp;</TD></TR>
             <TR><TD CLASS=\"SZDATA\" COLSPAN=\"2\">sid и serial#</TD><TD CLASS=\"SZDATA\" COLSPAN=\"2\">$s_sid, $s_serial</TD></TR>
             <TR><TD CLASS=\"SZDATA\" COLSPAN=\"2\">Начало сессии</TD><TD CLASS=\"SZDATA\" COLSPAN=\"2\">$s_logon_time</TD></TR>
             <TR><TD CLASS=\"SZDATA\" COLSPAN=\"2\">Имя пользователя oracle</TD><TD CLASS=\"SZDATA\" COLSPAN=\"2\">$s_username</TD></TR>
             <TR><TD CLASS=\"SZDATA\" COLSPAN=\"2\">Имя пользователя ОС</TD><TD CLASS=\"SZDATA\" COLSPAN=\"2\">$s_osuser</TD></TR>
             </TABLE>" ;
      print "<BR>" ;
      print "<TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\"><TR><TD STYLE=\"widht: 60%; vertical-align: top;\">" ;

# --- отразить данные о пользовательском и серверном процессе
      print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
             <TR><TD CLASS=\"HEAD_1\" COLSPAN=\"2\">Пользовательский процесс</TD></TR>" ;
      print "<TR><TD CLASS=\"SZDATA\">ОС имя пользователя</TD><TD CLASS=\"SZDATA\">$s_osuser</TD></TR>
             <TR><TD CLASS=\"SZDATA\">ОС ID процесса</TD><TD CLASS=\"SZDATA\">$s_process</TD></TR>
             <TR><TD CLASS=\"SZDATA\">Машина</TD><TD CLASS=\"SZDATA\">$s_machine</TD></TR>
             <TR><TD CLASS=\"SZDATA\">Терминал</TD><TD CLASS=\"SZDATA\">$s_terminal</TD></TR>
             <TR><TD CLASS=\"SZDATA\">Программа</TD><TD CLASS=\"SZDATA\">$s_program</TD></TR>" ;
      print "</TABLE>" ;

      print "<BR><TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
             <TR><TD CLASS=\"HEAD_1\" COLSPAN=\"2\">Серверный процесс</TD></TR>" ;
      printf("<TR><TD CLASS=\"SZDATA\">Тип процесса</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD CLASS=\"SZDATA\">ОС имя пользователя</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD CLASS=\"SZDATA\">ОС ID процесса</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD CLASS=\"SZDATA\">Терминал</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD CLASS=\"SZDATA\">Программа</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD CLASS=\"SZDATA\">Идентификатор трассировки</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD COLSPAN=\"2\">&nbsp;</TD></TR>
             <TR><TD CLASS=\"SZDATA\">Ожидание защелки</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD CLASS=\"SZDATA\">Использование защелки</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD COLSPAN=\"2\">&nbsp;</TD></TR>
             <TR><TD CLASS=\"SZDATA\">PGA - используется сейчас</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD CLASS=\"SZDATA\">PGA - выделено всего</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD CLASS=\"SZDATA\">PGA - нужно освободить</TD><TD CLASS=\"SZDATA\">%s</TD></TR>
             <TR><TD CLASS=\"SZDATA\">PGA - выделялось максимально</TD><TD CLASS=\"SZDATA\">%s</TD></TR>",
             $p_background,$p_username,$p_spid,$p_terminal,$p_program,$p_traceid,$p_latchwait,$p_latchspin,&show_razryads($p_pga_used_mem),
             &show_razryads($p_pga_alloc_mem),&show_razryads($p_pga_freeable_mem),&show_razryads($p_pga_max_mem)) ;
      print "</TABLE>" ;

      print "</TD><TD>&nbsp;</TD><TD>" ;

      print "<BR><TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\"><TR><TD COLSPAN=\"2\">Основные статистики сессии</TD></TR>" ;
# --- {
# --- отразить основные статистики сессии
      my $dbconn_mnstat = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '') ;
      $request_mnstat = 'select n.name, s.value from v$sesstat s, v$statname n where s.statistic# = n.statistic# and s.sid = ' . "$sid AND n.name in ('CPU used by this session','bytes received via SQL*Net from client','bytes received via SQL*Net from dblink','bytes sent via SQL*Net to client','bytes sent via SQL*Net to dblink','consistent changes','consistent gets','db block gets','db block changes','physical reads direct','physical writes','session pga memory','session uga memory','sorts (memory)','sorts (disk)','user calls')  ORDER BY n.name" ;
      my $cursor_handler_mnstat = $dbconn_main->prepare($request_mnstat) ; $cursor_handler_mnstat->execute() ;
      while (my ($n_name,$s_value) = $cursor_handler_mnstat->fetchrow_array() ) { print "<TR><TD>$n_name</TD><TD STYLE=\"text-align: right;\">$s_value</TD></TR>\n" ; }
      $cursor_handler_mnstat->finish() ; $dbconn_mnstat->disconnect() ;
# --- }      
      print "</TABLE>" ;
      print "</TD></TR></TABLE>" ;

print "</TD><TD STYLE=\"width: 50%; vertical-align: top;\">" ;

# --- запросить и отразить дополнительные данные - текущие ожидания сессии
      $request_waits = 'select SEQ#,EVENT,P1TEXT,P1,P1RAW,P2TEXT,P2,P2RAW,P3TEXT,P3,P3RAW,WAIT_TIME,SECONDS_IN_WAIT,STATE from v$session_wait where sid = ' . "$sid" ;
      my $cursor_handler_ext = $dbconn_ext->prepare($request_waits) ;
      $cursor_handler_ext->execute();
      print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
             <TR><TD CLASS=\"HEAD_1\" COLSPAN=\"7\">Текущие ожидания сессии</TD></TR>" ;
      print "<TR><TD CLASS=\"HEAD\">Событие / Seq </TD>
                 <TD CLASS=\"HEAD\">P1_TEXT / P2_TEXT / P3_TEXT</TD>
                 <TD CLASS=\"HEAD\">P1 / P2 / P3</TD>
                 <TD CLASS=\"HEAD\">P1_RAW / P2_RAW / P3_RAW</TD>
                 <TD CLASS=\"HEAD\">Wait_time</TD>
                 <TD CLASS=\"HEAD\">Second_in_wait</TD>
                 <TD CLASS=\"HEAD\">State</TD>
             </TR>" ;
      $is_not_null_answer = "no" ;
      while ( my ($seq,$event,$p1text,$p1,$p1raw,$p2text,$p2,$p2raw,$p3text,$p3,$p3raw,$wait_time,$seconds_in_wait,$state) = $cursor_handler_ext->fetchrow_array() ) {
            if ( $seq eq "" ) { $seq = "&nbsp;" ; } if ( $event eq "" ) { $event = "&nbsp;" ; }
            if ( $p1text eq "" ) { $p1text = "&nbsp;" ; } if ( $p1 eq "" ) { $p1 = "&nbsp;" ; } if ( $p1raw eq "" ) { $p1raw = "&nbsp;" ; }
            if ( $p2text eq "" ) { $p2text = "&nbsp;" ; } if ( $p2 eq "" ) { $p2 = "&nbsp;" ; } if ( $p2raw eq "" ) { $p2raw = "&nbsp;" ; }
            if ( $p3text eq "" ) { $p3text = "&nbsp;" ; } if ( $p3 eq "" ) { $p3 = "&nbsp;" ; } if ( $p3raw eq "" ) { $p3raw = "&nbsp;" ; }
            if ( $wait_time eq "" ) { $wait_time = "&nbsp;" ; }
            if ( $seconds_in_wait eq "" ) { $seconds_in_wait = "&nbsp;" ; }
            if ( $state eq "" ) { $state = "&nbsp;" ; }
            print "<TR><TD CLASS=\"SZDATA\">$event<BR>$seq</TD>
                       <TD CLASS=\"SZDATA\">$p1text<BR>$p2text<BR>$p3text</TD>
                       <TD CLASS=\"SZDATA\">$p1<BR>$p2<BR>$p3</TD>
                       <TD CLASS=\"SZDATA\">$p1row<BR>$p2row<BR>$p3raw</TD>
                       <TD CLASS=\"SZDATA\">$wait_time</TD>
                       <TD CLASS=\"SZDATA\">$seconds_in_wait</TD>
                       <TD CLASS=\"SZDATA\">$state</TD>
                   </TR>" ;
            $is_not_null_answer = "yes" ;
            }
      if ( $is_not_null_answer eq "no" ) { print "<TR><TD CLASS=\"SZDATA\" COLSPAN=\"7\">Нет ожиданий в настоящий момент</TD></TR>" ;}
      print "</TABLE>" ;
      $cursor_handler_ext->finish();
$cursor_handler_main->finish();
$dbconn_main->disconnect();


# --- запросить и отразить текущий исполняемый SQL запрос и план исполнения к нему
      $request_current_sql = "select st.sql_text from v\$session s, v\$sqltext_with_newlines st where s.SQL_ADDRESS = st.address and s.SQL_HASH_VALUE = st.hash_value AND s.sid = $s_sid AND s.serial# = $s_serial order by piece asc" ;
      my $cursor_handler_ext = $dbconn_ext->prepare($request_current_sql) ;
      $cursor_handler_ext->execute();
      print "<BR><TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
             <TR><TD CLASS=\"HEAD_1\">Текущий SQL запрос <A HREF=\"$base_url/cgi/get_sql_info.cgi?address=$s_sql_address&hash_value=$s_sql_hash_value\">показать статистику и план исполнения</A></TD></TR><TR><TD CLASS=\"SZDATA\"><BR>" ;
      $is_not_null_answer = "no" ;
      while ( my ($curr_sql_text_piece) = $cursor_handler_ext->fetchrow_array() ) { 
            $curr_sql_text_piece =~ s/[\r\n]+/<BR>/g ; $curr_sql_text_piece =~ s/\t/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/g ;
            $curr_sql_text_piece =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ;
            print "$curr_sql_text_piece" ; $is_not_null_answer = "yes" ;
            }
      if ( $is_not_null_answer eq "no" ) { print "Нет данных о текущем SQL запросе сессии" ;}

      print "<BR>&nbsp;</TD></TR>\n</TABLE>" ;
      $cursor_handler_ext->finish();

# --- запросить и отразить предидущий исполняемый SQL запрос и план исполнения к нему
      $request_prev_sql = "select st.sql_text from v\$session s, v\$sqltext_with_newlines st where s.PREV_SQL_ADDR = st.address and s.PREV_HASH_VALUE = st.hash_value AND s.sid = $s_sid AND s.serial# = $s_serial order by piece asc" ;
      my $cursor_handler_ext = $dbconn_ext->prepare($request_prev_sql) ;
      $cursor_handler_ext->execute();
      print "<BR><TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
             <TR><TD CLASS=\"HEAD_1\">Предидущий SQL запрос <A HREF=\"$base_url/cgi/get_sql_info.cgi?address=$s_prev_sql_addr&hash_value=$s_prev_hash_value\">показать статистику и план исполнения</A></TD></TR><TR><TD CLASS=\"SZDATA\"><BR>" ;
      $is_not_null_answer = "no" ;
      while ( my ($prev_sql_text_piece) = $cursor_handler_ext->fetchrow_array() ) { 
            $prev_sql_text_piece =~ s/[\r\n]+/<BR>/g ; $prev_sql_text_piece =~ s/[\t]+/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/g ;
            $prev_sql_text_piece =~ s/[^\w\d\s<>:()\+=\/\\\-_\.,\'\"#\*%!]+//g ;
            print "$prev_sql_text_piece" ;
            $is_not_null_answer = "yes" ;
            }
      if ( $is_not_null_answer eq "no" ) { print "Нет данных о предидущем SQL запросе сессии" ;}
      print "<BR>&nbsp;</TD></TR>\n</TABLE>" ;
      $cursor_handler_ext->finish();
      }
# это конец внутренней контейнерной таблицы контента
   print "</TD></TR></TABLE>" ;
   }

if ("_$pv{page_part}" eq "_2") {
   print_sql_table_activity($pv{period_from},$pv{period_to},'','',$pv{sid},$pv{serial},$pv{ds_type}) ;
   }

if ($pv{page_part} eq "3" ) {
# --- запросить и отразить дополнительные данные - события текущей сессии
   $request_events = 'select EVENT,TOTAL_WAITS,TOTAL_TIMEOUTS,TIME_WAITED,AVERAGE_WAIT,MAX_WAIT,TIME_WAITED_MICRO from v$session_event where sid = ' . "$sid" ;
   my $cursor_handler_ext = $dbconn_ext->prepare($request_events) ;
   $cursor_handler_ext->execute();
   print "<BR><TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
          <TR><TD CLASS=\"HEAD_1\" COLSPAN=\"7\">События сессии</TD></TR>" ;
   print "<TR><TD CLASS=\"HEAD\">Событие</TD>
              <TD CLASS=\"HEAD\">Всего ожиданий</TD>
              <TD CLASS=\"HEAD\">Превышено таймаутов</TD>
              <TD CLASS=\"HEAD\">Общее время ожидания</TD>
              <TD CLASS=\"HEAD\">Среднее время ожидания</TD>
              <TD CLASS=\"HEAD\">Максимальное время ожидания</TD>
              <TD CLASS=\"HEAD\">Ожиданий, микросекунд</TD>
          </TR>" ;
   $is_not_null_answer = "no" ;
   while ( my ($event,$total_waits,$total_timeouts,$time_waited,$average_wait,$max_wait,$time_waited_micro) = $cursor_handler_ext->fetchrow_array() ) {
         print "<TR><TD CLASS=\"SZDATA\">$event</TD>
                    <TD CLASS=\"SZDATA\">$total_waits</TD>
                    <TD CLASS=\"SZDATA\">$total_timeouts</TD>
                    <TD CLASS=\"SZDATA\">$time_waited</TD>
                    <TD CLASS=\"SZDATA\">$average_wait</TD>
                    <TD CLASS=\"SZDATA\">$max_wait</TD>
                    <TD CLASS=\"SZDATA\">$time_waited_micro</TD>
               </TR>" ;
         $is_not_null_answer = "yes" ;
         }
   if ( $is_not_null_answer eq "no" ) { print "<TR><TD CLASS=\"SZDATA\" COLSPAN=\"7\">Нет зафиксированных событий для текущей сессии</TD></TR>" ;}
   print "</TABLE>" ;
   $cursor_handler_ext->finish();
   }

if ($pv{page_part} eq "4" ) {
# --- запросить и отразить дополнительные данные - статистики текущей сессии
   $request_stats = 'select n.name, s.value, n.class from v$sesstat s, v$statname n where s.statistic# = n.statistic# and s.sid = ' . "$sid ORDER BY n.name" ;
   my $cursor_handler_ext = $dbconn_ext->prepare($request_stats) ;
   $cursor_handler_ext->execute();
   print "<BR><TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
          <TR><TD CLASS=\"HEAD_1\" COLSPAN=\"7\">Статистики текущей сессии</TD></TR>" ;
   $is_not_null_answer = "no" ;
   while ( my ($name,$value,$class) = $cursor_handler_ext->fetchrow_array() ) {
         print "<TR><TD CLASS=\"SZDATA\">$name</TD><TD CLASS=\"NUMDATA\">$value</TD><TD CLASS=\"NUMDATA\">$class</TD></TR>" ;
         $is_not_null_answer = "yes" ;
         }
   if ( $is_not_null_answer eq "no" ) { print "<TR><TD CLASS=\"SZDATA\">Нет зафиксированных событий для текущей сессии</TD></TR>" ;}
   print "</TABLE>" ;
   $cursor_handler_ext->finish();
   }

# --- закрыть коннектор дополнительных данных
$dbconn_ext->disconnect(); 
print "</TABLE>" ;

print "</TD></TR></TABLE>" ;

print "<BR>" ;
if ( $is_view_request eq "yes" ) { 
   print "<BR><HR COLOR=\"navy\"><P>Справочно: </P>
              <P>- запрос о текущей сессии: $request_main</P>\n
              <P>- запрос об ожиданиях сессии: $request_waits</P>\n
              <P>- запрос о событиях сессии: $request_events</P>\n
              <P>- запрос о статистике сессии: $request_stats</P>\n
              <P>- запрос о текущем SQL запросе: $request_current_sql</P>\n
              <P>- запрос о предидущем SQL запросе: $request_prev_sql</P>\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
