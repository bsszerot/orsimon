#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено

sub print_locks_navigation($) { $active_tab{1} = "" ; $active_tab{2} = "" ; $active_tab{3} = "" ; $active_tab{4} = "" ; $active_tab{5} = "" ; $active_tab{6} = "" ;  $active_tab{7} = "" ;
    $num_active_tab = $_[0] ; $active_tab{$num_active_tab} = " solid none solid" ;
    print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 0pt none; width: 100%;\">
           <TR><TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;</TD>
               <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{1}; text-align: center;\">
                   <A HREF=\"$base_url/cgi/get_dml_locks.cgi?order_field=l.SID\" TARGET=\"cont\">DML все</A></TD>
               <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;</TD>

               <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{2}; text-align: center;\">
                   <A HREF=\"$base_url/cgi/get_dml_tm_locks.cgi?order_field=l.SID\" TARGET=\"cont\">TM DML locks</A></TD>
               <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;</TD>

               <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{3}; text-align: center;\">
                   <A HREF=\"$base_url/cgi/get_dml_tx_locks.cgi?order_field=l.SID\" TARGET=\"cont\">TX Row locks</A></TD>
               <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;</TD>

               <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{4}; text-align: center;\">
                   <A HREF=\"$base_url/cgi/get_dml_locks_with_waits.cgi?order_field=l.SID\" TARGET=\"cont\">DML с ожиданиями</A></TD>
               <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;</TD>

               <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{5}; text-align: center;\">
                   <A HREF=\"$base_url/cgi/get_waiters_session.cgi?order_field=WAITING_SESSION\" TARGET=\"cont\">Ждущие сессии</A></TD>
               <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;</TD>

               <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{6}; text-align: center;\">
                   <A HREF=\"$base_url/cgi/get_blockers_session.cgi?order_field=b.HOLDING_SESSION\" TARGET=\"cont\">Блокировщики</A></TD>
               <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;</TD>

               <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{7}; text-align: center;\">
                   <A HREF=\"$base_url/cgi/get_lock_procedures.cgi?order_field=KGLPNHDL,KGLPNREQ\" TARGET=\"cont\">DDL holders</A></TD>
               <TD STYLE=\"border: 2pt navy; border-style: none none solid none;\">&nbsp;</TD>

               <TD STYLE=\"border: 2pt navy; border-style: solid $active_tab{8}; text-align: center;\">
                   <A HREF=\"$base_url/cgi/get_ddl_locks.cgi?order_field=l.SESSION_ID\" TARGET=\"cont\">DDL все</A></TD>
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
&get_forms_param() ;
# принудительно переопределить порядок сортировки, критичный для данного запроса
$pv{order_field} = "sll.ID1 ASC, sll.LMODE DESC" ;

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
# сгруппировать всех ожидающих, и для каждого их них вытащить блокирующего и ожидающих (order id1, shift)
#, sll.ROW_WAIT_ROWID#, sll.ROW_WAIT_FILE#, sll.ROW_WAIT_BLOCK#
#$request = 'SELECT /*+ ORDERED */ lpad(\' \',DECODE(sll.lmode,0,1,0)) SHIFT, sll.sid SID, sll.serial#, sll.STATUS, sll.USERNAME, sll.OSUSER, sll.PROCESS, sll.LOCKWAIT, sll.id1, sll.id2, 
#                   sll.LMODE LMODE_RAW,decode(sll.LMODE,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',sll.LMODE) LMODE, 
#                   sll.REQUEST REQUEST_RAW,decode(sll.REQUEST,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',sll.REQUEST) REQUEST, 
#                   sll.TYPE,decode(sll.block,0,\'нет\',1,\'блокирует\',2,\'глобально\',to_char(sll.block)) BLOCKING_OTHERS, 
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN o.OWNER else \'\' END,
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN o.OBJECT_NAME else \'\' END,
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN o.OBJECT_TYPE else \'\' END,
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN sll.ROW_WAIT_ROW# else NULL END,
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN sll.ROW_WAIT_FILE# else NULL END,
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN sll.ROW_WAIT_BLOCK# else NULL END,sll.KADDR,sll.ADDR
#                   FROM (SELECT /*+ ORDERED */ l.sid SID, s.serial#, s.STATUS, s.USERNAME, s.OSUSER, s.PROCESS, s.LOCKWAIT, l.id1, l.id2, l.LMODE, l.REQUEST, 
#                                l.TYPE, l.block, s.ROW_WAIT_OBJ#, s.ROW_WAIT_ROW#, s.ROW_WAIT_FILE#, s.ROW_WAIT_BLOCK#,l.KADDR,l.ADDR
#                                FROM V$LOCK l, V$SESSION s 
#                                WHERE (l.id1,l.id2,l.type) IN (SELECT id1,id2,type FROM V$LOCK WHERE request > 0 GROUP BY id1,id2,type) 
#                                      AND l.sid = s.sid) sll 
#                   LEFT OUTER JOIN dba_objects o ON sll.ROW_WAIT_OBJ# = o.OBJECT_ID ORDER BY ' . $pv{order_field} ;

# /*+ ORDERED */

#            select \'s\',0,0,\'status\',\'us\',\'osus\',0,\'LW\',0,0, \'owntm\',\'obtm\',\'tyobtm\',0,\'modsz\',0,\'reqsz\',\'typeaa\',
#                          \'bloccc\', \'\',\'\',\'\',0,0,0 from dual' ;

#UNION 
#select \'shift\',0,0,\'status2\',\'us\',\'osus\',0,\'LW\',0,0, \'owntm\',\'obtm\',\'tyobtm\',0,\'modsz\',0,\'reqsz\',\'typeaa\',
#                          \'bloccc\', \'\',\'\',\'\',0,0,0 from dual ' ;
#                   SELECT /*+ ORDERED */ lpad(\' \',DECODE(sll.lmode,0,1,0)) SHIFT, sll.sid SID, sll.serial#, sll.STATUS, sll.USERNAME, sll.OSUSER, sll.PROCESS, sll.LOCKWAIT, sll.id1, sll.id2, \'\',\'\',\'\',
#                   sll.LMODE LMODE_RAW,decode(sll.LMODE,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',sll.LMODE) LMODE, 
#                   sll.REQUEST REQUEST_RAW,decode(sll.REQUEST,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',sll.REQUEST) REQUEST, 
#                   sll.TYPE,decode(sll.block,0,\'нет\',1,\'блокирует\',2,\'глобально\',to_char(sll.block)) BLOCKING_OTHERS, 
#                   CASE WHEN sll.request > 0 THEN o.OWNER else \'\' END,
#                   CASE WHEN sll.request > 0 THEN o.OBJECT_NAME else \'\' END,
#                   CASE WHEN sll.request > 0 THEN o.OBJECT_TYPE else \'\' END,
#                   CASE WHEN sll.request > 0 THEN sll.ROW_WAIT_ROW# else NULL END,
#                   CASE WHEN sll.request > 0 THEN sll.ROW_WAIT_FILE# else NULL END,
#                   CASE WHEN sll.request > 0 THEN sll.ROW_WAIT_BLOCK# else NULL END
#                   FROM (SELECT /*+ ORDERED */ l.sid SID, s.serial#, s.STATUS, s.USERNAME, s.OSUSER, s.PROCESS, s.LOCKWAIT, l.id1, l.id2, l.LMODE, l.REQUEST, 
#                                l.TYPE, l.block, s.ROW_WAIT_OBJ#, s.ROW_WAIT_ROW#, s.ROW_WAIT_FILE#, s.ROW_WAIT_BLOCK#,l.KADDR,l.ADDR
#                                FROM V$LOCK l, V$SESSION s 
#                                WHERE (l.id1,l.id2,l.type) IN (SELECT id1,id2,type FROM V$LOCK WHERE request > 0 GROUP BY id1,id2,type) 
#                                      AND l.sid = s.sid AND l.type = \'TX\') sll 
#                   LEFT OUTER JOIN dba_objects o ON sll.ROW_WAIT_OBJ# = o.OBJECT_ID ORDER BY sll.ID1 ASC, sll.LMODE DESC' ;


#while (my ($shift,$sid,$serial,$status,$user,$osuser,$os_cln_pid,$lockwaits,$id1,$id2,$tm_owner,$tm_object_name,$tm_object_type,$lmode_raw,$lmode,$request_raw,
#$request,$type,$block,$owner,$object_name,$object_type,$rowid,$fileid,$block_no,$kaddr,$addr) = $sth->fetchrow_array() ) {

#$request = 'SELECT /*+ ORDERED */ lpad(\' \',DECODE(sll.lmode,0,1,0)) SHIFT, sll.sid SID, sll.serial#, sll.STATUS, sll.USERNAME, sll.OSUSER, sll.PROCESS, sll.LOCKWAIT, sll.id1, sll.id2, 
#                   sll.LMODE LMODE_RAW,decode(sll.LMODE,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',sll.LMODE) LMODE, 
#                   sll.REQUEST REQUEST_RAW,decode(sll.REQUEST,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',sll.REQUEST) REQUEST, 
#                   sll.TYPE,decode(sll.block,0,\'нет\',1,\'блокирует\',2,\'глобально\',to_char(sll.block)) BLOCKING_OTHERS, 
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN o.OWNER else \'\' END,
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN o.OBJECT_NAME else \'\' END,
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN o.OBJECT_TYPE else \'\' END,
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN sll.ROW_WAIT_ROW# else NULL END,
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN sll.ROW_WAIT_FILE# else NULL END,
#                   CASE WHEN sll.TYPE = \'TX\' AND sll.request > 0 THEN sll.ROW_WAIT_BLOCK# else NULL END,sll.KADDR,sll.ADDR
#                   FROM (SELECT /*+ ORDERED */ l.sid SID, s.serial#, s.STATUS, s.USERNAME, s.OSUSER, s.PROCESS, s.LOCKWAIT, l.id1, l.id2, l.LMODE, l.REQUEST, 
#                                l.TYPE, l.block, s.ROW_WAIT_OBJ#, s.ROW_WAIT_ROW#, s.ROW_WAIT_FILE#, s.ROW_WAIT_BLOCK#,l.KADDR,l.ADDR
#                                FROM V$LOCK l, V$SESSION s 
#                                WHERE (l.id1,l.id2,l.type) IN (SELECT id1,id2,type FROM V$LOCK WHERE request > 0 GROUP BY id1,id2,type) 
#                                      AND l.sid = s.sid AND l.type = \'TM\') sll 
#                   LEFT OUTER JOIN dba_objects o ON sll.ROW_WAIT_OBJ# = o.OBJECT_ID ORDER BY ' . $pv{order_field} ;


print "Content-Type: text/html\n\n"; 
&print_html_head_refresh("Текущие DML блокировки с ожидающими сессиями",60,"get_dml_locks_with_waits.cgi?order_field=l.SID,l.REQUEST") ;
# добавить определение навигационно - оформительского механизма закладок
&print_locks_navigation(4) ;
print "<TABLE CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"border: 2pt navy; border-style: none solid solid solid; width: 100%;\">" ;
print "<TR><TD>" ;

# вывести непосредственно контент
print "<DIV>-- выборка удерживающих и ожидающих блокировку сессий для случаев, когда есть ожидающие возможности получить блокировку --</DIV>
       <TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"11\">&nbsp;</TD><TD COLSPAN=\"3\" STYLE=\"text-align: center;\">Объект DML (TM) блокировки</TD>
           <TD COLSPAN=\"6\" STYLE=\"text-align: center;\">Ожидание сессией COMMIT для ROWID</TD></TR>
       <TR><TD CLASS=\"HEAD\">Сессия</TD>
           <TD CLASS=\"HEAD\">Статус</TD>
           <TD CLASS=\"HEAD\">Oracle user</TD>
           <TD CLASS=\"HEAD\">ОС user</TD>
           <TD CLASS=\"HEAD\">PID клиентского процесса</TD>
           <TD CLASS=\"HEAD\">Блокирует ли других</TD> 
           <TD CLASS=\"HEAD\">Тип блокировки</TD>
           <TD CLASS=\"HEAD\">Режим блокировки</TD>
           <TD CLASS=\"HEAD\">Режим ожидания</TD>
           <TD CLASS=\"HEAD\">Адрес блокировки</TD>
           <TD CLASS=\"HEAD\">ID1,ID2</TD>
           <TD CLASS=\"HEAD\">Владелец</TD>
           <TD CLASS=\"HEAD\">Имя объекта</TD>
           <TD CLASS=\"HEAD\">Тип объекта</TD>
           <TD CLASS=\"HEAD\">Ожидаемая строка ROWID</TD>
           <TD CLASS=\"HEAD\">ID файла</TD>
           <TD CLASS=\"HEAD\">Номер блока</TD>
           <TD CLASS=\"HEAD\">Владелец</TD>
           <TD CLASS=\"HEAD\">Имя объекта с ожиданиями COMMIT (TX)</TD>
           <TD CLASS=\"HEAD\">Тип объекта</TD>
           </TR>" ;

# начальное условие - сессия ждёт блокировку (lmode = 0, а не request !=0), от него пляшем
# далее для того, чтобы выделить тех, кто не блокирует
$request_tm = 'SELECT /*+ ORDERED */ lpad(\' \',DECODE(sll.block,0,1,0)) SHIFT, sll.sid SID, sll.serial#, sll.STATUS, sll.USERNAME, sll.OSUSER, sll.PROCESS, sll.LOCKWAIT, sll.id1, sll.id2, sll.TM_OWNER, sll.TM_OBJECT_NAME, sll.TM_OBJECT_TYPE,
                   sll.LMODE LMODE_RAW,decode(sll.LMODE,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',sll.LMODE) LMODE, 
                   sll.REQUEST REQUEST_RAW,decode(sll.REQUEST,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',sll.REQUEST) REQUEST, 
                   sll.TYPE,decode(sll.block,0,\'нет\',1,\'блокирует\',2,\'глобально\',to_char(sll.block)) BLOCKING_OTHERS, 
                   CASE WHEN sll.request > 0 THEN o.OWNER else \'\' END,
                   CASE WHEN sll.request > 0 THEN o.OBJECT_NAME else \'\' END,
                   CASE WHEN sll.request > 0 THEN o.OBJECT_TYPE else \'\' END,
                   CASE WHEN sll.request > 0 THEN sll.ROW_WAIT_ROW# else NULL END,
                   CASE WHEN sll.request > 0 THEN sll.ROW_WAIT_FILE# else NULL END,
                   CASE WHEN sll.request > 0 THEN sll.ROW_WAIT_BLOCK# else NULL END
                   FROM (SELECT /*+ ORDERED */ l.sid SID, s.serial#, s.STATUS, s.USERNAME, s.OSUSER, s.PROCESS, s.LOCKWAIT, l.id1, l.id2, l.LMODE, l.REQUEST, 
                                l.TYPE, l.block, s.ROW_WAIT_OBJ#, s.ROW_WAIT_ROW#, s.ROW_WAIT_FILE#, s.ROW_WAIT_BLOCK#,l.KADDR,l.ADDR, o.OWNER TM_OWNER, o.OBJECT_NAME TM_OBJECT_NAME, o.OBJECT_TYPE TM_OBJECT_TYPE
                                FROM V$LOCK l, V$SESSION s, dba_objects o
                                WHERE (l.id1,l.id2,l.type) IN (SELECT id1,id2,type FROM V$LOCK WHERE lmode = 0 GROUP BY id1,id2,type) 
                                      AND l.sid = s.sid AND l.id1 = o.OBJECT_ID AND l.type = \'TM\') sll 
                   LEFT OUTER JOIN dba_objects o ON sll.ROW_WAIT_OBJ# = o.OBJECT_ID ORDER BY sll.ID1 ASC, sll.block DESC' ;


#$request = 'SELECT /*+ ORDERED */ lpad(\' \',DECODE(l.lmode,0,1,0)) SHIFT, l.sid SID, s.serial#, s.STATUS, s.USERNAME, s.OSUSER, s.PROCESS, s.LOCKWAIT,
#                   l.id1, l.id2, o.OWNER, o.OBJECT_NAME, o.OBJECT_TYPE,
#                   l.LMODE LMODE_RAW, decode(l.LMODE,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',l.LMODE) LMODE, 
#                   l.REQUEST REQUEST_RAW, decode(l.REQUEST,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',l.REQUEST) REQUEST, 
#                   l.TYPE, decode(l.block,0,\'нет\',1,\'блокирует\',2,\'глобально\',to_char(l.block)) BLOCKING_OTHERS,\'\',\'\',\'\',0,0,0
#                   FROM V$LOCK l, V$SESSION s, dba_objects o  
#                   WHERE (l.id1,l.id2,l.type) IN (SELECT id1,id2,type FROM V$LOCK WHERE lmode = > 0 GROUP BY id1,id2,type)
#                         AND l.sid = s.sid AND l.id1 = o.OBJECT_ID AND l.type = \'TM\' ORDER BY l.ID1 ASC, l.LMODE DESC' ;

my $sth = $dbh->prepare($request_tm) ;
$sth->execute();
$is_not_null_answer = "no" ;
while (my ($shift,$sid,$serial,$status,$user,$osuser,$os_cln_pid,$lockwaits,$id1,$id2,$tm_owner,$tm_object_name,$tm_object_type,$lmode_raw,$lmode,$request_raw,$request,$type,$block,$owner,$object_name,$object_type,$rowid,$fileid,$block_no) = $sth->fetchrow_array() ) {
      if ( $shift eq " " ) { $shift = "..." ; } if ( $user eq "" ) { $user = "&nbsp;" ; } if ( $osuser eq "" ) { $osuser = "&nbsp;" ; } 
      if ( $os_cln_pid eq "" ) { $os_cln_pid = "&nbsp;" ; } if ( $id1 eq "" ) { $id1 = "&nbsp;" ; } if ( $id2 eq "" ) { $id2 = "&nbsp;" ; }
      $lmode =~ s/\s/&nbsp;/g ; $request =~ s/\s/&nbsp;/g ; if ( $lockwaits eq "" ) { $lockwaits = "&nbsp;" ; } 
      if ( $owner eq " " || $owner eq "" ) { $owner = "&nbsp;" ; } if ( $object_name eq " " || $object_name eq "" ) { $object_name = "&nbsp;" ; } 
      if ( $object_type eq " " || $object_type eq "" ) { $object_type = "&nbsp;" ; }
      if ( $rowid eq "" ) { $rowid = "&nbsp;" ; } if ( $fileid eq "" ) { $fileid = "&nbsp;" ; } if ( $block_no eq "" ) { $block_no = "&nbsp;" ; }
      if ( $tm_owner eq "" ) { $tm_owner = "&nbsp;" ; } if ( $tm_object_name eq "" ) { $tm_object_name = "&nbsp;" ; } if ( $tm_object_type eq "" ) { $tm_object_type = "&nbsp;" ; }
      printf("<TR><TD CLASS=\"SZDATA\"><A HREF=\"$base_url/cgi/get_session_info.cgi?sid=%s&serial=%s\" TARGET=\"cont\">%s&nbsp;%s,%s</A></TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s&nbsp;(lmode&nbsp;%s)</TD>
                  <TD CLASS=\"CENTERDATA\">%s&nbsp;(req&nbsp;%s)</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s,%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
              </TR>\n",$sid,$serial,$shift,$sid,$serial,$status,$user,$osuser,$os_cln_pid,$block,$type,$lmode,$lmode_raw,$request,$request_raw,$lockwaits,$id1,$id2,$tm_owner,$tm_object_name,$tm_object_type,$rowid,$fileid,$block_no,$owner,$object_name,$object_type) ;
      $is_not_null_answer = "yes" ;
      }
if ( $is_not_null_answer eq "no" ) { print "<TR><TD COLSPAN=\"20\" CLASS=\"SZDATA\">Блокировки DML(TM) с ожиданиями отсутствуют</TD></TR>" ;}

$request_tx = 'SELECT /*+ ORDERED */ lpad(\' \',DECODE(sll.block,0,1,0)) SHIFT, sll.sid SID, sll.serial#, sll.STATUS, sll.USERNAME, sll.OSUSER, sll.PROCESS, sll.LOCKWAIT, sll.id1, sll.id2, \'\',\'\',\'\',
                   sll.LMODE LMODE_RAW,decode(sll.LMODE,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',sll.LMODE) LMODE, 
                   sll.REQUEST REQUEST_RAW,decode(sll.REQUEST,0,\'none\',1,\'null (NULL)\',2,\'row-S (SS)\',3,\'row-X (SX)\',4,\'share (X)\',5,\'S/Row-X (SSX)\',6,\'executive (X)\',sll.REQUEST) REQUEST, 
                   sll.TYPE,decode(sll.block,0,\'нет\',1,\'блокирует\',2,\'глобально\',to_char(sll.block)) BLOCKING_OTHERS, 
                   CASE WHEN sll.request > 0 THEN o.OWNER else \'\' END,
                   CASE WHEN sll.request > 0 THEN o.OBJECT_NAME else \'\' END,
                   CASE WHEN sll.request > 0 THEN o.OBJECT_TYPE else \'\' END,
                   CASE WHEN sll.request > 0 THEN sll.ROW_WAIT_ROW# else NULL END,
                   CASE WHEN sll.request > 0 THEN sll.ROW_WAIT_FILE# else NULL END,
                   CASE WHEN sll.request > 0 THEN sll.ROW_WAIT_BLOCK# else NULL END
                   FROM (SELECT /*+ ORDERED */ l.sid SID, s.serial#, s.STATUS, s.USERNAME, s.OSUSER, s.PROCESS, s.LOCKWAIT, l.id1, l.id2, l.LMODE, l.REQUEST, 
                                l.TYPE, l.block, s.ROW_WAIT_OBJ#, s.ROW_WAIT_ROW#, s.ROW_WAIT_FILE#, s.ROW_WAIT_BLOCK#,l.KADDR,l.ADDR
                                FROM V$LOCK l, V$SESSION s 
                                WHERE (l.id1,l.id2,l.type) IN (SELECT id1,id2,type FROM V$LOCK WHERE lmode = 0 GROUP BY id1,id2,type) 
                                      AND l.sid = s.sid AND l.type = \'TX\') sll 
                   LEFT OUTER JOIN dba_objects o ON sll.ROW_WAIT_OBJ# = o.OBJECT_ID ORDER BY sll.ID1 ASC, sll.block DESC' ;
my $sth = $dbh->prepare($request_tx) ;
$sth->execute();
$is_not_null_answer = "no" ;
while (my ($shift,$sid,$serial,$status,$user,$osuser,$os_cln_pid,$lockwaits,$id1,$id2,$tm_owner,$tm_object_name,$tm_object_type,$lmode_raw,$lmode,$request_raw,$request,$type,$block,$owner,$object_name,$object_type,$rowid,$fileid,$block_no) = $sth->fetchrow_array() ) {
      if ( $shift eq " " ) { $shift = "..." ; } if ( $user eq "" ) { $user = "&nbsp;" ; } if ( $osuser eq "" ) { $osuser = "&nbsp;" ; } 
      if ( $os_cln_pid eq "" ) { $os_cln_pid = "&nbsp;" ; } if ( $id1 eq "" ) { $id1 = "&nbsp;" ; } if ( $id2 eq "" ) { $id2 = "&nbsp;" ; }
      $lmode =~ s/\s/&nbsp;/g ; $request =~ s/\s/&nbsp;/g ; if ( $lockwaits eq "" ) { $lockwaits = "&nbsp;" ; } 
      if ( $owner eq " " || $owner eq "" ) { $owner = "&nbsp;" ; } if ( $object_name eq " " || $object_name eq "" ) { $object_name = "&nbsp;" ; } 
      if ( $object_type eq " " || $object_type eq "" ) { $object_type = "&nbsp;" ; }
      if ( $rowid eq "" ) { $rowid = "&nbsp;" ; } if ( $fileid eq "" ) { $fileid = "&nbsp;" ; } if ( $block_no eq "" ) { $block_no = "&nbsp;" ; }
      if ( $tm_owner eq "" ) { $tm_owner = "&nbsp;" ; } if ( $tm_object_name eq "" ) { $tm_object_name = "&nbsp;" ; } if ( $tm_object_type eq "" ) { $tm_object_type = "&nbsp;" ; }
      printf("<TR><TD CLASS=\"SZDATA\"><A HREF=\"$base_url/cgi/get_session_info.cgi?sid=%s&serial=%s\" TARGET=\"cont\">%s&nbsp;%s,%s</A></TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"CENTERDATA\">%s&nbsp;(lmode&nbsp;%s)</TD>
                  <TD CLASS=\"CENTERDATA\">%s&nbsp;(req&nbsp;%s)</TD>
                  <TD CLASS=\"CENTERDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s,%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"NUMDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
                  <TD CLASS=\"SZDATA\">%s</TD>
              </TR>\n",$sid,$serial,$shift,$sid,$serial,$status,$user,$osuser,$os_cln_pid,$block,$type,$lmode,$lmode_raw,$request,$request_raw,$lockwaits,$id1,$id2,$tm_owner,$tm_object_name,$tm_object_type,$rowid,$fileid,$block_no,$owner,$object_name,$object_type) ;
      $is_not_null_answer = "yes" ;
      }
if ( $is_not_null_answer eq "no" ) { print "<TR><TD COLSPAN=\"20\" CLASS=\"SZDATA\">Блокировки TX с ожиданиями отсутствуют</TD></TR>" ;}

print "</TABLE>" ;
print "</TD></TR></TABLE>" ;
$sth->finish();
$dbh->disconnect();                                        

if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запросы к базе:</P>\n<PRE>$request_tm \n\n $request_tx</PRE>\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
