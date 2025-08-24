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
#http://oracle.zerot.local/cgi/_get_graph_top_activity.cgi?order_field=idle_prcn&cpu=all&ag_type=day&period_from=2009-02-02&period_to=2009-03-02&isfirst=no " ;
###print $ENV{QUERY_STRING} ;
#%pv ;

# - вытащить из URL запроса значения уточняющих полей
&get_forms_param() ;

#@tmp1 = keys %pv ; for ($i=0;$i<=$#tmp1;$i++) { print "$tmp1[$i] = $pv{$tmp1[$i]} \n"; } print "$connector_definition{$pv{connector}} \n" ; print "$connector_credentials{$pv{connector}} \n" ; exit 0 ;

print "Content-Type: image/png\n\n";
#print "\n --- start db" ;
$CURR_YEAR = `date +%Y` ; $CURR_YEAR =~ s/[\r\n]+//g ;

####$where_class = " WHERE host_name = '$pv{host_name}' AND dt_record >= TO_DATE('$pv{period_from}','YYYY-MM-DD HH24:MI:SS') AND dt_record <= TO_DATE('$pv{period_to}','YYYY-MM-DD HH24:MI:SS') " ;
####if ( $pv{cpu} ne "" ) { $where_class .= " AND cpu = '$pv{cpu}' " ; }
#####$date_trunc = "TO_CHAR(dt_record,'YYYY-MM-DD HH24:MI:SS')" ;                                                                                                                  
####if ( $pv{ag_type} eq "hour" ) { $date_trunc = "TO_CHAR(dt_record,'YYYY-MM-DD HH24')" ; }                                                                                      
###if ( $pv{ag_type} eq "day" ) { $date_trunc = "TO_CHAR(dt_record,'YYYY-MM-DD')" ; }                                                                                            
####if ( $pv{ag_type} eq "month" ) { $date_trunc = "TO_CHAR(dt_record,'YYYY-MM')" ; }                                                                                             


# Шаг 01. Добавили WITH и нормализатор - работает только в 12 версии
#$request = "select TO_CHAR(d1.begin_time,'YYYY-MM-DD HH24:MI:SS') begin_time,sum(wc_ActiveSession) wc_ActiveSession, sum(wc_Concurrency) wc_Concurrency, sum(wc_UserIO) wc_UserIO,

my $source_table_name = "V\$ACTIVE_SESSION_HISTORY" ; if  ($pv{ds_type} eq "AWR") { $source_table_name = "DBA_HIST_ACTIVE_SESS_HISTORY" ; }
my $where_timepoint = "" ;
my $where_ext = "" ;
if ( $pv{period_from} eq "" ||  $pv{period_to} eq "" ) { die ; }
$where_timepoint .= " sample_time >= TO_DATE('$pv{period_from}','YYYY-MM-DD HH24:MI:SS') " ;
$where_timepoint .= " AND sample_time <= TO_DATE('$pv{period_to}','YYYY-MM-DD HH24:MI:SS')" ;
#                                   where ash.sample_time >= TO_DATE('$pv{period_from}','YYYY-MM-DD HH24:MI:SS') AND ash.sample_time <= TO_DATE('$pv{period_to}','YYYY-MM-DD HH24:MI:SS')
#$where_ext = " ash.sample_time >= TO_DATE('$pv{period_from}','YYYY-MM-DD HH24:MI:SS') AND ash.sample_time <= TO_DATE('$pv{period_to}','YYYY-MM-DD HH24:MI:SS')" ;

if ( $pv{sql_id} ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SQL_ID = '$pv{sql_id}'" ; }
if ( $pv{plan_hash_value} ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SQL_PLAN_HASH_VALUE = '$pv{plan_hash_value}'" ; }
if ( $pv{sid} ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SESSION_ID = '$pv{sid}'" ; }
if ( $pv{serial} ne "" ) { if ( $where_ext ne "" ) { $where_ext .= " AND " ; } $where_ext .= " SESSION_SERIAL# = '$pv{serial}'" ; }



if ( $pv{sql_id} ne "" || $pv{plan_hash_value} ne "" || $pv{sid} ne "" || $pv{serial} ne "") {
   $request = "
select src3.timepoint timepoint, sum(src3.wc_ActiveSession) c_ActiveSession,
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
                            from ( select ash_all.sample_time, ash.wait_class, ash.value
                                          from (select distinct sample_time from $source_table_name where $where_timepoint) ash_all
                                               LEFT OUTER JOIN
                                               (select sample_time, wait_class, count(*) value
                                                      from $source_table_name
                                                      where $where_timepoint AND $where_ext
                                                      group by sample_time, wait_class) ash
                                               ON ash_all.sample_time = ash.sample_time
                                               ORDER BY ash_all.sample_time asc) src1
                            group by to_char(src1.sample_time, 'YYYY-MM-DD HH24:MI '), src1.wait_class) src2
                            ) src3
       group by src3.timepoint order by src3.timepoint asc " ;
   }
else {
   $request = "
select src3.timepoint timepoint, sum(src3.wc_ActiveSession) c_ActiveSession,
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
                                   where $where_timepoint
                                   group by ash.sample_time, ash.wait_class) src1
                            group by to_char(src1.sample_time, 'YYYY-MM-DD HH24:MI '), src1.wait_class) src2
                            ) src3
       group by src3.timepoint order by src3.timepoint asc " ;
   }

#-debug-open(AA, ">/tmp/aaaaaaaa") ; printf AA $request ;

#ash.sample_time >= TO_DATE('$pv{period_from}','YYYY-MM-DD HH24:MI:SS') AND ash.sample_time <= TO_DATE('$pv{period_to}','YYYY-MM-DD HH24:MI:SS')
#
#    normalizator as ( select  max_actsess_smtmval / max_active_session_count_value  norm_index from normal_data )
#    normalizator as ( select CASE WHEN NOT (norm_index = 0 or norm_index is NULL) THEN norm_index ELSE 1 END norm_index from normal_data )
#print "$request" ;
#exit ;

#$begin_time, $end_time, $wc_ActiveSession, $wc_Concurrency, $wc_UserIO, $wc_SystemIO, $wc_Other, $wc_Configuration, $wc_Scheduler, $wc_CPU, $wc_Application, $wc_Commit, $wc_Network
#$begin_time, $end_time, $wc_ActiveSession, $wc_Concurrency, $wc_UserIO, $wc_SystemIO, $wc_Other, $wc_Configuration, $wc_Scheduler, $wc_CPU, $wc_Application, $wc_Commit, $wc_Network

# --------- собрать данные для построения графика
my $dbh_h = DBI->connect($connector_definition{$pv{connector}},$connector_credentials{$pv{connector}},''); my $sth_h = $dbh_h->prepare($request) ; $sth_h->execute(); $count_rows = 0 ;
while (my ($begin_time, $wc_ActiveSession, $wc_Concurrency, $wc_UserIO, $wc_SystemIO, $wc_Other, $wc_Configuration, $wc_Scheduler, $wc_CPU, $wc_Application, $wc_Commit, $wc_Network, $wc_Administrative, $wc_Cluster) = $sth_h->fetchrow_array() ) {
      if ( $wc_ActiveSession =~/^\..*/) { $wc_ActiveSession = "0" . $wc_ActiveSession ; }
      if ( $wc_Concurrency =~/^\..*/) { $wc_Concurrency = "0" . $wc_Concurrency ; }
      if ( $wc_UserIO =~/^\..*/) { $wc_UserIO = "0" . $wc_UserIO ; }
      if ( $wc_SystemIO =~/^\..*/) { $wc_SystemIO = "0" . $wc_SystemIO ; }
      if ( $wc_Other =~/^\..*/) { $wc_Other = "0" . $wc_Other ; }
      if ( $wc_Configuration =~/^\..*/) { $wc_Configuration = "0" . $wc_Configuration ; }
      if ( $wc_Scheduler =~/^\..*/) { $wc_Scheduler = "0" . $wc_Scheduler ; }
      if ( $wc_CPU =~/^\..*/) { $wc_CPU = "0" . $wc_CPU ; }
      if ( $wc_Application =~/^\..*/) { $wc_Application = "0" . $wc_Application ; }
      if ( $wc_Commit =~/^\..*/) { $wc_Commit = "0" . $wc_Commit ; }
      if ( $wc_Network =~/^\..*/) { $wc_Network = "0" . $wc_Network ; }
      if ( $wc_Administrative =~/^\..*/) { $wc_Administrative = "0" . $wc_Administrative ; }
      if ( $wc_Cluster =~/^\..*/) { $wc_Cluster = "0" . $wc_Cluster ; }
# - меняем очерёдность на аналогичную вкладке CloudControl
      $avg_data_source[0][$count_rows] = $begin_time ;
      $avg_data_source[1][$count_rows] = $wc_CPU ;
      $avg_data_source[2][$count_rows] = $wc_Scheduler ;
      $avg_data_source[3][$count_rows] = $wc_UserIO ;
      $avg_data_source[4][$count_rows] = $wc_SystemIO ;
      $avg_data_source[5][$count_rows] = $wc_Concurrency ;
      $avg_data_source[6][$count_rows] = $wc_Application ;
      $avg_data_source[7][$count_rows] = $wc_Commit ;
      $avg_data_source[8][$count_rows] = $wc_Configuration ;
      $avg_data_source[9][$count_rows] = $wc_Network ;
      $avg_data_source[10][$count_rows] = $wc_Administrative ;
      $avg_data_source[11][$count_rows] = $wc_Other ;
      $avg_data_source[12][$count_rows] = $wc_Cluster ;
      $avg_data_source[13][$count_rows] = $wc_ActiveSession ;
      $count_rows += 1 ; }
$sth_h->finish() ;
$dbh_h->disconnect() ;

# --------- заполнить данные для построения графика
$dbh = DBI->connect('dbi:Chart:') or die "Cannot connect: " . $DBI::errstr ;
$dbh->do('CREATE TABLE mychart (begin_time VARCHAR(30), CPU FLOAT, Scheduler FLOAT, UserIO FLOAT, SystemIO FLOAT, Concurrency FLOAT, Application FLOAT, Commit FLOAT,
                 Configuration FLOAT, Network FLOAT, Administrative FLOAT, Other FLOAT, Cluster FLOAT)') or die $dbh->errstr;
for ($i=0;$i<$count_rows;$i++) {
    $sth = $dbh->prepare('INSERT INTO mychart VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
    $sth->bind_param(1, "$avg_data_source[0][$i]");
    $sth->bind_param(2, $avg_data_source[1][$i]);
    $sth->bind_param(3, $avg_data_source[2][$i]);
    $sth->bind_param(4, $avg_data_source[3][$i]);
    $sth->bind_param(5, $avg_data_source[4][$i]);
    $sth->bind_param(6, $avg_data_source[5][$i]);
    $sth->bind_param(7, $avg_data_source[6][$i]);
    $sth->bind_param(8, $avg_data_source[7][$i]);
    $sth->bind_param(9, $avg_data_source[8][$i]);
    $sth->bind_param(10, $avg_data_source[9][$i]);
    $sth->bind_param(11, $avg_data_source[10][$i]);
    $sth->bind_param(12, $avg_data_source[11][$i]);
    $sth->bind_param(13, $avg_data_source[12][$i]);
    $sth->execute or die 'Cannot execute: ' . $sth->errstr;
    }

#$chart_select = "SELECT AREAGRAPH FROM mychart WHERE WIDTH=427 AND HEIGHT=310 AND X_AXIS='Time' and Y_AXIS='Utils' AND CUMULATIVE='1' AND
# SIGNATURE = '(C)2008 - $CURR_YEAR, Sergey S. Belonin' AND
$chart_select = "SELECT AREAGRAPH FROM mychart WHERE WIDTH=$pv{width} AND HEIGHT=$pv{height} AND X_AXIS='Time' and Y_AXIS='Utils' AND CUMULATIVE='1' AND
                        SIGNATURE = '(C)2016 - $CURR_YEAR, Sergey S. Belonin' AND
                        TITLE = 'Top activity on $connector_definition{$pv{connector}}' AND X_ORIENT='VERTICAL' AND
                        COLOR IN ('green','lgreen','dblue','lblue','dred','red','orange','dbrown','lgray','dgray','dpink','marine') AND TEXTCOLOR = 'blue' AND FORMAT='PNG'" ;

$sth = $dbh->prepare($chart_select) ;

$sth->execute or die 'Cannot execute: ' . $sth->errstr;
@row = $sth->fetchrow_array; print $row[0];
