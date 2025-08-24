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
#$ENV{REQUEST_METHOD} = "GET" ;
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
$request = "
with d1 as (
select begin_time,end_time,
                     CASE WHEN wait_class = 'Average Active Sessions' THEN value ELSE 0 END wc_ActiveSession,
                     CASE WHEN wait_class = 'Concurrency' THEN value ELSE 0 END wc_Concurrency,
                     CASE WHEN wait_class = 'User I/O' THEN value ELSE 0 END wc_UserIO,
                     CASE WHEN wait_class = 'System I/O' THEN value ELSE 0 END wc_SystemIO,
                     CASE WHEN wait_class = 'Other' THEN value ELSE 0 END wc_Other,
                     CASE WHEN wait_class = 'Configuration' THEN value ELSE 0 END wc_Configuration,
                     CASE WHEN wait_class = 'Scheduler' THEN value ELSE 0 END wc_Scheduler,
                     CASE WHEN wait_class = 'CPU Usage Per Sec' THEN value ELSE 0 END wc_CPU,
                     CASE WHEN wait_class = 'Application' THEN value ELSE 0 END wc_Application,
                     CASE WHEN wait_class = 'Commit' THEN value ELSE 0 END wc_Commit,
                     CASE WHEN wait_class = 'Network' THEN value ELSE 0 END wc_Network,
                     CASE WHEN wait_class = 'Administrative' THEN value ELSE 0 END wc_Administrative,
                     CASE WHEN wait_class = 'Cluster' THEN value ELSE 0 END wc_Cluster
                     from ( SELECT h.begin_time,h.end_time,c.wait_class,
                                   h.time_waited / (h.intsize_csec / 100) value
                                   FROM v\$waitclassmetric_history h, v\$system_wait_class c
                                   WHERE h.wait_class# = c.wait_class# AND c.wait_class != 'Idle'
                            UNION ALL
                            SELECT begin_time,end_time,metric_name,
                                   CASE WHEN metric_name = 'CPU Usage Per Sec' THEN VALUE
                                        WHEN metric_name = 'Average Active Sessions' THEN VALUE END value
                                   FROM v\$sysmetric_history
                                   WHERE metric_name IN ('CPU Usage Per Sec', 'Average Active Sessions') AND GROUP_ID = 2)),
    normal_data as ( select
        ( select max(ds_sum_value.sum_value) max_actsess_smtmval from (
            select ds_row_sum_value.begin_time, ds_row_sum_value.end_time, sum(ds_row_sum_value.value) sum_value
                   from   ( SELECT h1.begin_time, h1.end_time, c1.wait_class, h1.time_waited / (h1.intsize_csec / 100) value
                                   FROM v\$waitclassmetric_history h1, v\$system_wait_class c1
                                   WHERE h1.wait_class# = c1.wait_class# AND c1.wait_class != 'Idle'
                            UNION ALL
                            SELECT h2.begin_time, h2.end_time, h2.metric_name, h2.value value
                                   FROM v\$sysmetric_history h2
                                   WHERE h2.metric_name IN ('CPU Usage Per Sec') AND h2.GROUP_ID = 2) ds_row_sum_value
                    group by ds_row_sum_value.begin_time, ds_row_sum_value.end_time) ds_sum_value ) /
        ( SELECT max(h3.value) max_active_session_count_value
                   FROM v\$sysmetric_history h3
                   WHERE h3.metric_name = 'Average Active Sessions' AND h3.GROUP_ID = 2
                   ) norm_index from dual),
normalizator as ( select CASE WHEN NOT (norm_index = 0 or norm_index is NULL) THEN norm_index ELSE 1 END norm_index from normal_data )
select TO_CHAR(d1.begin_time,'HH24:MI') begin_time, sum(wc_ActiveSession)/normalizator.norm_index wc_ActiveSession,
       sum(wc_Concurrency)/normalizator.norm_index wc_Concurrency, sum(wc_UserIO)/normalizator.norm_index wc_UserIO,
       sum(wc_SystemIO)/normalizator.norm_index wc_SystemIO, sum(wc_Other)/normalizator.norm_index wc_Other,
       sum(wc_Configuration)/normalizator.norm_index wc_Configuration, sum(wc_Scheduler)/normalizator.norm_index wc_Scheduler,
       sum(wc_CPU)/normalizator.norm_index wc_CPU, sum(wc_Application)/normalizator.norm_index wc_Application,
       sum(wc_Commit)/normalizator.norm_index wc_Commit, sum(wc_Network)/normalizator.norm_index wc_Network,
       sum(wc_Administrative)/normalizator.norm_index wc_Administrative, sum(wc_Cluster)/normalizator.norm_index wc_Cluster
       from d1, normalizator
    GROUP BY d1.begin_time, d1.end_time, normalizator.norm_index order by d1.begin_time, d1.end_time " ;

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
# SIGNATURE = '(C)2000 - $CURR_YEAR, Sergey S. Belonin' AND
$chart_select = "SELECT AREAGRAPH FROM mychart WHERE WIDTH=427 AND HEIGHT=310 AND X_AXIS='Time' and Y_AXIS='Utils' AND CUMULATIVE='1' AND
                        SIGNATURE = '(C)2016 - $CURR_YEAR, Sergey S. Belonin' AND
                        TITLE = 'Top activity on $connector_definition{$pv{connector}}' AND X_ORIENT='VERTICAL' AND
                        COLOR IN ('green','lgreen','dblue','lblue','dred','red','orange','dbrown','lgray','dgray','dpink','marine') AND TEXTCOLOR = 'blue' AND
 FORMAT='PNG'" ;

$sth = $dbh->prepare($chart_select) ;

$sth->execute or die 'Cannot execute: ' . $sth->errstr;
@row = $sth->fetchrow_array; print $row[0];
