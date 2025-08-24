#!/usr/bin/perl

#require "/var/www/oracle/cgi/common_awr_function.pl" ;

sub print_db_status_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; 
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_db_status.cgi?period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=$sql_id&plan_hash=&sid=&serial=&ds_type=$pv{ds_type}&page_part=1\" TARGET=\"cont\">TOP активности БД</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_db_status.cgi?period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=$sql_id&plan_hash=&sid=&serial=&ds_type=$pv{ds_type}&page_part=2\" TARGET=\"cont\">Статусы бэкапов БД</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sessions_list_v11_grouped.cgi?order_field=s.SID\" TARGET=\"cont\">Текущие сессии</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_queued_locks_v11.cgi\" TARGET=\"cont\">Текущие блокировки</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_area_info.cgi?order_field=s.ADDRESS\" TARGET=\"cont\">Текущие SQL</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_awr_list.cgi?order_field=s.SID\" TARGET=\"cont\">AWR</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           </TR></TABLE>" ;
    }

sub print_get_session_info_internal_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ;
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_session_info.cgi?period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=&plan_hash=&sid=$pv{sid}&serial=$pv{serial}&ds_type=$pv{ds_type}&page_part=1\" TARGET=\"cont\">Общие</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_session_info.cgi?period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=&plan_hash=&sid=$pv{sid}&serial=$pv{serial}&ds_type=$pv{ds_type}&page_part=2\" TARGET=\"cont\">ТОП SQL</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_session_info.cgi?period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=&plan_hash=&sid=$pv{sid}&serial=$pv{serial}&ds_type=$pv{ds_type}&page_part=3\" TARGET=\"cont\">События ожидания</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_session_info.cgi?period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=&plan_hash=&sid=$pv{sid}&serial=$pv{serial}&ds_type=$pv{ds_type}&page_part=4\" TARGET=\"cont\">Статистики сессии</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           </TR></TABLE>" ;
    }

sub print_get_sql_info_by_id_internal_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ;
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_info_by_id.cgi?period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=$pv{sql_id}&plan_hash=$pv{plan_hash}&sid=&serial=&ds_type=$pv{ds_type}&page_part=1\" TARGET=\"cont\">Общие</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
               <A HREF=\"$base_url/cgi/get_sql_info_by_id.cgi?period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=$pv{sql_id}&plan_hash=$pv{plan_hash}&sid=&serial=&ds_type=$pv{ds_type}&page_part=2\" TARGET=\"cont\">Планы выполнения</A></TD>
           <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;&nbsp;&nbsp;&nbsp;</TD>
           </TR></TABLE>" ;
    }


sub print_activity_graph($$$$$$$$) { my $filter_period_from = $_[0] ; my $filter_period_to = $_[1] ; my $filter_sql_id = $_[2] ; my $filter_sql_plan_hash_value = $_[3] ; my $filter_session_id = $_[4] ; my $filter_session_serial = $_[5] ; my $percent = $_[6] ; $source_table_name = $_[7] ;
    my $where_ext = "" ;
    if ( $filter_period_from eq "" || $filter_period_to eq "") { return  ; }
    $where_ext .= " ash.sample_time >= TO_DATE('$filter_period_from','YYYY-MM-DD HH24:MI:SS') " ;
    $where_ext .= " AND ash.sample_time <= TO_DATE('$filter_period_to','YYYY-MM-DD HH24:MI:SS')" ;
    if ( $filter_sql_id ne "" ) { $where_ext .= " AND SQL_ID = '$filter_sql_id'" ; }
    if ( $filter_sql_plan_hash_value ne "" ) { $where_ext .= " AND SQL_PLAN_HASH_VALUE = '$filter_sql_plan_hash_value'" ; }
    if ( $filter_session_id ne "" ) { $where_ext .= " AND SESSION_ID = '$filter_session_id'" ; }
    if ( $filter_session_serial ne "" ) { $where_ext .= " AND SESSION_SERIAL# = '$filter_session_serial'" ; }
    $request_chart_per_class = "
select sum(src3.wc_ActiveSession) c_ActiveSession,
       sum(src3.wc_Concurrency) wc_Concurrency, sum(src3.wc_UserIO) wc_UserIO,
       sum(src3.wc_SystemIO) wc_SystemIO, sum(src3.wc_Other) wc_Other,
       sum(src3.wc_Configuration) wc_Configuration, sum(src3.wc_Scheduler) wc_Scheduler,
       sum(src3.wc_CPU) wc_CPU, sum(src3.wc_Application) wc_Application,
       sum(src3.wc_Commit) wc_Commit, sum(src3.wc_Network) wc_Network,
       sum(src3.wc_Administrative) wc_Administrative, sum(src3.wc_Cluster) wc_Cluster
       from ( select src2.timepoint,
              CASE WHEN src2.wait_class = 'Average Active Sessions' THEN src2.value ELSE 0 END wc_ActiveSession,
              CASE WHEN src2.wait_class = 'Concurrency' THEN src2.value ELSE 0 END wc_Concurrency,
              CASE WHEN src2.wait_class = 'User I/O' THEN src2.value ELSE 0 END wc_UserIO,
              CASE WHEN src2.wait_class = 'System I/O' THEN src2.value ELSE 0 END wc_SystemIO,
              CASE WHEN src2.wait_class = 'Other' THEN src2.value ELSE 0 END wc_Other,
              CASE WHEN src2.wait_class = 'Configuration' THEN src2.value ELSE 0 END wc_Configuration,
              CASE WHEN src2.wait_class = 'Scheduler' THEN src2.value ELSE 0 END wc_Scheduler,
              CASE WHEN src2.wait_class = 'CPU Usage Per Sec' THEN src2.value ELSE 0 END wc_CPU,
              CASE WHEN src2.wait_class = 'Application' THEN src2.value ELSE 0 END wc_Application,
              CASE WHEN src2.wait_class = 'Commit' THEN src2.value ELSE 0 END wc_Commit,
              CASE WHEN src2.wait_class = 'Network' THEN src2.value ELSE 0 END wc_Network,
              CASE WHEN src2.wait_class = 'Administrative' THEN src2.value ELSE 0 END wc_Administrative,
              CASE WHEN src2.wait_class = 'Cluster' THEN src2.value ELSE 0 END wc_Cluster
              from ( select to_char(src1.sample_time, 'YYYY-MM-DD HH24:MI ') timepoint,
                            CASE WHEN src1.wait_class IS NULL THEN 'CPU Usage Per Sec' else src1.wait_class END wait_class, round(sum(src1.value)/60,4) value
                            from ( select ash.sample_time, ash.wait_class, count(*) value
                                   from $source_table_name ash
                                   where $where_ext
                                   group by ash.sample_time, ash.wait_class) src1
                            group by to_char(src1.sample_time, 'YYYY-MM-DD HH24:MI '), src1.wait_class) src2
                            ) src3" ;
#-debug-print "<BR>\n$request_chart_per_class" ;
    my $white_spaces = 100 - $percent ;
    my $count_class = 0 ;
    my $dbh_chart_per_class = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
    my $sth_chart_per_class = $dbh_chart_per_class->prepare($request_chart_per_class) ; $sth_chart_per_class->execute() ;

    while ( $count_class == 0 && (my ($wc_ActiveSession, $wc_Concurrency, $wc_UserIO, $wc_SystemIO, $wc_Other, $wc_Configuration, $wc_Scheduler, $wc_CPU, $wc_Application, $wc_Commit, $wc_Network, $wc_Administrative, $wc_Cluster) = $sth_chart_per_class->fetchrow_array() )) {
          $count_class++ ;
          my $tmp_sum = $wc_ActiveSession + $wc_Concurrency + $wc_UserIO + $wc_SystemIO + $wc_Other + $wc_Configuration + $wc_Scheduler + $wc_CPU + $wc_Application + $wc_Commit + $wc_Network + $wc_Administrative + $wc_Cluster ;
#-debug-print "<BR>--$white_spaces -- $tmp_sum --" ;
#-debug-print "<BR>\n - class - tmp_sum $tmp_sum, sql_id $sql_id, time $begin_time, actSess $wc_ActiveSession, concurr $wc_Concurrency, userIO $wc_UserIO, systemIO $wc_SystemIO, other $wc_Other, config $wc_Configuration, sched $wc_Scheduler, cpu $wc_CPU, app $wc_Application, commit $wc_Commit, net $wc_Network, admin $wc_Administrative, clust $wc_Cluster\n" ;
          $wc_ActiveSession = sprintf("%.1f", $wc_ActiveSession * $percent / $tmp_sum) ;
          $wc_Concurrency = sprintf("%.1f", $wc_Concurrency * $percent / $tmp_sum) ;
          $wc_UserIO = sprintf("%.1f", $wc_UserIO * $percent / $tmp_sum) ;
          $wc_SystemIO = sprintf("%.1f", $wc_SystemIO * $percent / $tmp_sum) ;
          $wc_Other = sprintf("%.1f", $wc_Other * $percent / $tmp_sum) ;
          $wc_Configuration = sprintf("%.1f", $wc_Configuration * $percent / $tmp_sum) ;
          $wc_Scheduler = sprintf("%.1f", $wc_Scheduler * $percent / $tmp_sum) ;
          $wc_CPU = sprintf("%.1f", $wc_CPU * $percent / $tmp_sum) ;
          $wc_Application = sprintf("%d", $wc_Application * $percent / $tmp_sum) ;
          $wc_Commit = sprintf("%d", $wc_Commit * $percent / $tmp_sum) ;
          $wc_Network = sprintf("%d", $wc_Network * $percent / $tmp_sum) ;
          $wc_Administrative = sprintf("%d", $wc_Administrative * $percent / $tmp_sum) ;
          $wc_Cluster = sprintf("%d", $wc_Cluster * $percent / $tmp_sum) ;
#-debug-print "<BR>\n - class - tmp_sum $tmp_sum, sql_id $sql_id, time $begin_time, actSess $wc_ActiveSession, concurr $wc_Concurrency, userIO $wc_UserIO, systemIO $wc_SystemIO, other $wc_Other, config $wc_Configuration, sched $wc_Scheduler, cpu $wc_CPU, app $wc_Application, commit $wc_Commit, net $wc_Network, admin $wc_Administrative, clust $wc_Cluster\n" ;
          print "<TABLE WIDTH=\"200pt;\" HEIGHT=\"15pt;\" CELLPADDING=\"0\" CELLSPACING=\"0\"><TR>" ;
          if ( $wc_CPU > 0 ) { print "<TD TITLE=\"CPU $wc_CPU\%\" STYLE=\"width: $wc_CPU\%; height: 15pt; background-color: green;\">&nbsp;</TD>" ; }
          if ( $wc_Scheduler > 0 ) { print "<TD TITLE=\"Scheduler $wc_Scheduler\%\" STYLE=\"width: $wc_Scheduler\%; height: 15pt; background-color: palegreen;\">&nbsp;</TD>" ; }
          if ( $wc_UserIO > 0 ) { print "<TD TITLE=\"User I/O $wc_UserIO\%\" STYLE=\"width: $wc_UserIO\%; height: 15pt; background-color: navy;\">&nbsp;</TD>" ; }
          if ( $wc_SystemIO > 0 ) { print "<TD TITLE=\"System I/O $wc_SystemIO\%\" STYLE=\"width: $wc_SystemIO\%; height: 15pt; background-color: deepskyblue;\">&nbsp;</TD>" ; }
          if ( $wc_Concurrency > 0 ) { print "<TD TITLE=\"Concurrency $wc_Concurrency\%\" STYLE=\"width: $wc_Concurrency\%; height: 15pt; background-color: darkred;\">&nbsp;</TD>" ; }
          if ( $wc_Application > 0 ) { print "<TD TITLE=\"Application $wc_Application\%\" STYLE=\"width: $wc_Application\%; height: 15pt; background-color: red;\">&nbsp;</TD>" ; }
          if ( $wc_Commit > 0 ) { print "<TD TITLE=\"Commit $wc_Commit\%\" STYLE=\"width: $wc_Commit\%; height: 15pt; background-color: brown;\">&nbsp;</TD>" ; }
          if ( $wc_Configuration > 0 ) { print "<TD TITLE=\"Configuration $wc_Configuration\%\" STYLE=\"width: $wc_Configuration\%; height: 15pt; background-color: lightgray;\">&nbsp;</TD>" ; }
          if ( $wc_Network > 0 ) { print "<TD TITLE=\"Network $wc_Network\%\" STYLE=\"width: $wc_Network\%; height: 15pt; background-color: gray;\">&nbsp;</TD>" ; }
          if ( $wc_Administrative > 0 ) { print "<TD TITLE=\"Administrative $wc_Administrative\%\" STYLE=\"width: $wc_Administrative\%; height: 15pt; background-color: pink;\">&nbsp;</TD>" ; }
          if ( $wc_Other > 0 ) { print "<TD TITLE=\"Other $wc_Other\%\" STYLE=\"width: $wc_Other\%; height: 15pt; background-color: aqua;\">&nbsp;</TD>" ; }
          if ( $wc_Cluster > 0 ) { print "<TD TITLE=\"Cluster $wc_Cluster\%\" STYLE=\"width: $wc_Cluster\%; height: 15pt; background-color: gainsboro;\">&nbsp;</TD>" ; }
          print "<TD STYLE=\"width: $white_spaces\%; height: 15pt; background-color: white;\">&nbsp;</TD>" ;
          print "</TR></TABLE>" ; }
    $sth_chart_per_class->finish() ; $dbh_chart_per_class->disconnect() ;
    }

sub print_head_ash_graph() {
    $sz_current_date_short = `date "+%Y-%m-%d 09:00:00"` ;
    $sz_current_date = `date "+%Y-%m-%d 18:30:00"` ;
    $pv{period_from} = ( $pv{period_from} eq "" ) ? $sz_current_date_short : $pv{period_from} ;
    $pv{period_to} = ( $pv{period_to} eq "" ) ? $sz_current_date : $pv{period_to} ;
    if ($pv{ds_type} eq "") { $pv{ds_type} = "MEM" ; }
    my $is_ds_type_awr = "" ; my $is_ds_type_mem = " CHECKED" ; if ($pv{ds_type} eq "AWR") { $is_ds_type_awr = " CHECKED" ; $is_ds_type_mem = "" ; }
    print "<TABLE STYLE=\"width: 100%\">
    <TR><TD STYLE=\"text-align: left;\">График&nbsp;с&nbsp;<INPUT VALUE=\"$pv{period_from}\" ID=\"id_period_date_start\" STYLE=\"width: 101pt;\"></TD>
        <TD STYLE=\"text-align: center;\">
            SID&nbsp;<INPUT VALUE=\"$pv{sid}\" ID=\"id_sid\" STYLE=\"width: 49pt;\" DISABLED>&nbsp;
            SER#&nbsp;<INPUT VALUE=\"$pv{serial}\" ID=\"id_serial\" STYLE=\"width: 49pt;\" DISABLED>&nbsp;&nbsp;
            SQL_ID&nbsp;<INPUT VALUE=\"$pv{sql_id}\" ID=\"id_sql_id\" STYLE=\"width: 101pt;\" DISABLED>&nbsp;
            PLAN&nbsp;<INPUT VALUE=\"$pv{plan_hash}\" ID=\"id_plan_hash\" STYLE=\"width: 79pt;\" DISABLED>&nbsp;
        </TD>
        <TD STYLE=\"text-align: right;\">График&nbsp;по&nbsp;<INPUT VALUE=\"$pv{period_to}\" ID=\"id_period_date_stop\" STYLE=\"width: 101pt;\">
           &nbsp;<INPUT TITLE=\"Смотреть данные в таблице агрегации\" TYPE=\"radio\" NAME=\"ds_type\" ID=\"id_ds_type\" VALUE=\"AWR\" $is_ds_type_awr>AWR</INPUT>
           &nbsp;<INPUT TITLE=\"Смотреть данные в структурах памяти\" TYPE=\"radio\" NAME=\"ds_type\" ID=\"id_ds_type\" VALUE=\"MEM\" $is_ds_type_mem>Mem</INPUT>
           &nbsp; <SPAN STYLE=\"font-size: 11pt; color: navy; pointer: arrow;\"
                  onclick=\"renew_db_status_page(id_period_date_start.value,id_period_date_stop.value,id_sql_id.value,id_plan_hash.value,id_sid.value,id_serial.value,$pv{page_part})\">&nbsp;&nbsp;обновить</SPAN>
        </TD></TR>
    <TR><TD COLSPAN=\"3\">
    <A TARGET=\"_blank\" HREF=\"$base_url/cgi/_get_graph_ash_top_activity.cgi?connector=$current_connector&period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=$pv{sql_id}&plan_hash=$pv{plan_hash}&sid=$pv{sid}&serial=$pv{serial}&ds_type=$pv{ds_type}&width=1450&height=500\">
           <IMG style=\"width:100%; height: 240pt;\" SRC=\"$base_url/cgi/_get_graph_ash_top_activity.cgi?connector=$current_connector&period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=$pv{sql_id}&plan_hash=$pv{plan_hash}&sid=$pv{sid}&serial=$pv{serial}&ds_type=$pv{ds_type}&width=2800&height=600\"></A>
    </TD></TR>
    </TABLE>" ;
    }

sub print_sql_table_activity($$$$$$$) { my $filter_period_from = $_[0] ; my $filter_period_to = $_[1] ; my $filter_sql_id = $_[2] ; my $filter_sql_plan_hash_value = $_[3] ; my $filter_session_id = $_[4] ; my $filter_session_serial = $_[5] ; $source_table_name = $_[6] ;
    my $source_table_name = "V\$ACTIVE_SESSION_HISTORY" ; if  ($pv{ds_type} eq "AWR") { $source_table_name = "DBA_HIST_ACTIVE_SESS_HISTORY" ; }
    my $where_timepoint = "" ;
    my $where_ext = "" ;
    if ( $filter_period_from eq "" ||  $filter_period_to eq "" ) { die ; }
    $where_timepoint .= " sample_time >= TO_DATE('$filter_period_from','YYYY-MM-DD HH24:MI:SS') " ;
    $where_timepoint .= " AND sample_time <= TO_DATE('$filter_period_to','YYYY-MM-DD HH24:MI:SS')" ;
    if ( $filter_sql_id ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SQL_ID = '$filter_sql_id'" ; }
    if ( $filter_sql_plan_hash_value ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SQL_PLAN_HASH_VALUE = '$filter_sql_plan_hash_value'" ; }
    if ( $filter_session_id ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SESSION_ID = '$filter_session_id'" ; }
    if ( $filter_session_serial ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SESSION_SERIAL# = '$filter_session_serial'" ; }
    if ( $where_ext ne "" ) { $where_ext = " AND $where_ext" ; }
    print "<TABLE BORDER=\"1\" STYLE=\"width: 100%; border: 1pt navy; border-style: solid;\">
        <TR><TD>Activity</TD><TD>%</TD><TD>SQL ID [plan count]</TD><TD>Exec count</TD><TD>Elapsed time per exec</TD></TR>" ;
    my $source_table_name = "V\$ACTIVE_SESSION_HISTORY" ; if ($pv{ds_type} eq "AWR") { $source_table_name = "DBA_HIST_ACTIVE_SESS_HISTORY" ; }
    $request_top_sql = "select * from ( select round(a1.count_point * 100 / a2.sum_count_point, 2) percent, a1.sql_id
           from (select 'ok' ok1, count(*) count_point, sql_id
                        from $source_table_name
                        where $where_timepoint $where_ext
                              AND sql_id IS NOT NULL
                        group by sql_id) a1,
                (select 'ok' ok1, count(*) sum_count_point
                        from $source_table_name
                        where $where_timepoint $where_ext ) a2
            where a1.ok1 = a2.ok1
            order by 1 desc) where rownum < 30" ;
open(DEBG,">/tmp/print_sql_table_activity.out") ; print DEBG $request_top_sql ;
    my $dbh_top_sql = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
    my $sth_top_sql  = $dbh_top_sql->prepare($request_top_sql ) ; $sth_top_sql->execute() ;
    while (my ( $percent, $sql_id, $count_point ) = $sth_top_sql->fetchrow_array() ) {
          print "<TR><TD>" ;
          print_activity_graph($pv{period_from}, $pv{period_to}, $sql_id, '', '', '', $percent, $source_table_name) ;
          print "</TD><TD>$percent</TD>
                 <TD><A HREF=\"http://oracle.zerot.local/cgi/get_sql_info_by_id.cgi?period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=$sql_id&plan_hash=&sid=&serial=&ds_type=$pv{ds_type}&page_part=1&srcptr=&child_number=\">$sql_id</A></TD><TD></TD><TD>&nbsp;</TD></TR>" ;
          }
    $sth_top_sql->finish() ;
    $dbh_top_sql->disconnect() ;
    print "</TABLE>" ;
    }

sub print_session_table_activity($$$$$$$) { my $filter_period_from = $_[0] ; my $filter_period_to = $_[1] ; my $filter_sql_id = $_[2] ; my $filter_sql_plan_hash_value = $_[3] ; my $filter_session_id = $_[4] ; my $filter_session_serial = $_[5] ; $source_table_name = $_[6] ;
    my $source_table_name = "V\$ACTIVE_SESSION_HISTORY" ; if  ($pv{ds_type} eq "AWR") { $source_table_name = "DBA_HIST_ACTIVE_SESS_HISTORY" ; }
    my $where_timepoint = "" ;
    my $where_ext = "" ;
    if ( $filter_period_from eq "" ||  $filter_period_to eq "" ) { die ; }
    $where_timepoint .= " sample_time >= TO_DATE('$filter_period_from','YYYY-MM-DD HH24:MI:SS') " ;
    $where_timepoint .= " AND sample_time <= TO_DATE('$filter_period_to','YYYY-MM-DD HH24:MI:SS')" ;
    if ( $filter_sql_id ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SQL_ID = '$filter_sql_id'" ; }
    if ( $filter_sql_plan_hash_value ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SQL_PLAN_HASH_VALUE = '$filter_sql_plan_hash_value'" ; }
    if ( $filter_session_id ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SESSION_ID = '$filter_session_id'" ; }
    if ( $filter_session_serial ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SESSION_SERIAL# = '$filter_session_serial'" ; }
    if ( $where_ext ne "" ) { $where_ext = " AND $where_ext" ; }
    print "<TABLE BORDER=\"1\" STYLE=\"width: 100%; border: 1pt navy; border-style: solid;\">
            <TR><TD>Activity</TD><TD>%</TD><TD>SID, Serial#</TD><TD>Oracle User</TD><TD>OS User</TD></TR>";
    my $source_table_name = "V\$ACTIVE_SESSION_HISTORY" ;
    if  ($pv{ds_type} eq "AWR") { $source_table_name = "DBA_HIST_ACTIVE_SESS_HISTORY" ; }
    $request_top_sess = "select * from ( select round(a1.count_point * 100 / a2.sum_count_point, 2) percent, a1.sid, a1.serial#, a1.user_id, du.username
           from (select 'ok' ok1, count(*) count_point, session_id sid, session_serial# serial#, user_id
                        from $source_table_name
                        where $where_timepoint $where_ext
                        group by session_id, session_id, session_serial#, user_id) a1,
                (select 'ok' ok1, count(*) sum_count_point
                        from $source_table_name
                        where $where_timepoint $where_ext) a2,
                dba_users du
            where a1.ok1 = a2.ok1 AND a1.user_id = du.user_id
            order by 1 desc) where rownum < 30" ;
    my $dbh_top_sess = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
    my $sth_top_sess  = $dbh_top_sess ->prepare($request_top_sess ) ; $sth_top_sess ->execute() ;
    while (my ( $percent, $sid, $serial, $user_id, $user_name ) = $sth_top_sess->fetchrow_array() ) {
          print "<TR><TD>" ;
          print_activity_graph($pv{period_from}, $pv{period_to}, '', '', $sid, $serial, $percent, $source_table_name) ;
          print "</TD><TD>$percent</TD>
                     <TD><A HREF=\"http://oracle.zerot.local/cgi/get_session_info.cgi?period_from=$pv{period_from}&period_to=$pv{period_to}&sql_id=&plan_hash=&sid=$sid&serial=$serial&ds_type=$pv{ds_type}&page_part=1\">$sid, $serial</A></TD>
                     <TD TITLE=\"User ID: $user_id\">$user_name</TD><TD>&nbsp;</TD></TR>" ;
          }
    $sth_top_sess->finish() ;
    $dbh_top_sess->disconnect() ;
    print "</TABLE>" ;
    }

sub print_js_ash_block() {
    print "<SCRIPT LANGUAGE=\"JavaScript\">
function renew_db_status_page(v_period_from,v_period_to,v_sql_id,v_plan_hash,v_sid,v_serial,v_page_part) {
         var v_ds_type_value ;
         var v_url ;
         var id_radio_type = document.getElementsByName('ds_type') ;
         for (i=0; i < id_radio_type.length; i++) { if (id_radio_type[i].checked) { v_ds_type_value = id_radio_type[i].value ; } }
//         alert(v_ds_type_value) ;
//         window.location.href = \"http://oracle.zerot.local/cgi/get_db_status.cgi?period_from=\"+v_period_from+\"&period_to=\"+v_period_to+\"&ds_type=\"+v_ds_type_value ;
//alert(window.location.href) ;
         v_url = \"http://oracle.zerot.local\"+window.location.pathname+\"?period_from=\"+v_period_from+\"&period_to=\"+v_period_to+\"&sql_id=\"+v_sql_id+\"&plan_hash=\"+v_plan_hash+\"&sid=\"+v_sid+\"&serial=\"+v_serial+\"&ds_type=\"+v_ds_type_value+\"&page_part=\"+v_page_part ;
//         alert(v_url) ;
         window.location.href = v_url ;
         }
</SCRIPT>" ;
    }

1
