#!/usr/bin/perl   

# этот код является частью программно технологического комплекса ОрСиМОН БЕССТ. автором которого является Белонин Сергей Станиславович
# полное название "Монитор СУБД Oracle и ОС UNIX/Linux Белонина Сергея Станиславовича"
# настоящий код является авторской интеллектуальной собственностью и защищён законами РФ и международными  соглашениями
# использование настоящего авторского кода без предварительного заключения письменного лицензионного
# договора с автором - правообладателем или его законным представителем запрещено
  
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
$current_connector = "none" ; if ( $ENV{HTTP_COOKIE} =~ /.*[;\s]*current_connector=([^;]+)[;\s]*.*/ ) { $current_connector = $1 ; }

# - вытащить из URL запроса значения уточняющих полей
$order_field = "USERNAME" ;
if ( $ENV{REQUEST_METHOD} eq "GET" && $ENV{QUERY_STRING} =~ /order_field=(.*)/) { $order_field = $1 ;
    $order_field =~ s/[\r\n]+//g ; $order_field =~ s/%(..)/pack("c",hex($1))/ge ; }
else { die "No valid request data $ENV{QUERY_STRING}" ; }

$ENV{ORACLE_SID} = $current_connector ;
my $dbh = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '');
$request = 'select USERNAME, USER_ID, ACCOUNT_STATUS, TO_CHAR(LOCK_DATE,\'YYYY-MM-DD HH24:MI:SS\') LOCK_DATE, 
                   TO_CHAR(EXPIRY_DATE,\'YYYY-MM-DD HH24:MI:SS\') EXPIRY_DATE, DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE,
                   TO_CHAR(CREATED,\'YYYY-MM-DD HH24:MI:SS\') CREATED, PROFILE, EXTERNAL_NAME 
                   from dba_users ' . "order by $order_field asc" ;
                                 
print "Content-Type: text/html\n\n"; 
&print_html_head("Информация о пользователях системы") ;

my $sth = $dbh->prepare($request) ;
$sth->execute();
print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">" ;
print "<TR><TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_users_list.cgi?order_field=ACCOUNT_STATUS\" TARGET=\"cont\">Статус</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_users_list.cgi?order_field=USERNAME\" TARGET=\"cont\">Пользователь</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_users_list.cgi?order_field=USER_ID\" TARGET=\"cont\">ID</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_users_list.cgi?order_field=EXTERNAL_NAME\" TARGET=\"cont\">Внешнее имя</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_users_list.cgi?order_field=PROFILE\" TARGET=\"cont\">Профиль</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_users_list.cgi?order_field=DEFAULT_TABLESPACE\" TARGET=\"cont\">ТС по умолчанию</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_users_list.cgi?order_field=TEMPORARY_TABLESPACE\" TARGET=\"cont\">ТС временное</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_users_list.cgi?order_field=CREATED\" TARGET=\"cont\">Дата создания</A></TD>           
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_users_list.cgi?order_field=LOCK_DATE\" TARGET=\"cont\">Дата блокировки</A></TD>
           <TD CLASS=\"HEAD\"><A HREF=\"$base_url/cgi/get_users_list.cgi?order_field=EXPIRY_DATE\" TARGET=\"cont\">Дата истечения</A></TD>
           </TR>" ;

$users_count_all = 0 ;
while (my ($username,$user_id,$account_status,$lock_date,$expiry_date,$default_tablespace,$temporary_tablespace,$created,$profile,$external_name) = $sth->fetchrow_array() ) {
      if ( $users_count_by_status{$account_status} eq "" || $users_count_by_status{$account_status} < 1 ) { $users_count_by_status{$account_status} = 0 ; } 
      $users_count_all += 1 ; $users_count_by_status{$account_status} += 1 ;

      if ( $username eq "" ) { $username = "&nbsp;" ; }
      if ( $user_id eq "" ) { $user_id = "&nbsp;" ; }
      if ( $account_status eq "" ) { $account_status = "&nbsp;" ; } $account_status =~ s/\s+/&nbsp;/g ;
      if ( $lock_date eq "" ) { $lock_date = "&nbsp;" ; } $lock_date =~ s/\s+/&nbsp;/g ;
      if ( $expiry_date eq "" ) { $expiry_date = "&nbsp;" ; } $expiry_date =~ s/\s+/&nbsp;/g ;
      if ( $default_tablespace eq "" ) { $default_tablespace = "&nbsp;" ; }
      if ( $temporary_tablespace eq "" ) { $temporary_tablespace = "&nbsp;" ; }
      if ( $created eq "" ) { $created = "&nbsp;" ; } $created =~ s/\s+/&nbsp;/g ;
      if ( $profile eq "" ) { $profile = "&nbsp;" ; }
      if ( $external_name eq "" ) { $external_name = "&nbsp;" ; }
      print "<TR><TD CLASS=\"SZDATA\">$account_status</TD>" ;
      printf ("<TD CLASS=\"SZDATA\"><A HREF=\"$base_url/cgi/get_user_info.cgi?username=%s&user_id=%d\" TARGET=\"cont\">%s</A></TD>",$username,$user_id,$username) ;
      printf ("<TD CLASS=\"NUMDATA\"><A HREF=\"$base_url/cgi/get_user_info.cgi?username=%s&user_id=%d\" TARGET=\"cont\">%d</A></TD>",$username,$user_id,$user_id) ;
      print "<TD CLASS=\"SZDATA\">$external_name</TD>" ;
      printf ("<TD CLASS=\"SZDATA\"><A HREF=\"$base_url/cgi/get_profile_info.cgi?profile=%s&order_field=RESOURCE_TYPE\">%s</A></TD>",$profile,$profile) ;
      printf ("<TD CLASS=\"SZDATA\"><A HREF=\"$base_url/cgi/get_tablespace_info.cgi?tablespace_name=%s\" TARGET=\"cont\">%s</A></TD>",$default_tablespace,$default_tablespace) ;
      printf ("<TD CLASS=\"SZDATA\"<A HREF=\"$base_url/cgi/get_tablespace_info.cgi?tablespace_name=%s\" TARGET=\"cont\">%s</A></TD>",$temporary_tablespace,$temporary_tablespace) ;
      printf ("<TD CLASS=\"NUMDATA\">%s</TD>
               <TD CLASS=\"NUMDATA\">%s</TD>
               <TD CLASS=\"NUMDATA\">%s</TD>
               </TR>\n",$created,$lock_date,$expiry_date) ;
      }
print "<TR><TD COLSPAN=\"10\">
           <TABLE BORDER=\"0\"><TR><TD>Пользователей всего:</TD><TD>$users_count_all, в т.ч.</TD></TR>" ;
@users_count_by_status_keys_nosort = keys %users_count_by_status ; @users_count_by_status_keys_sort = sort @users_count_by_status_keys_nosort ;
for ($i=0;$i<=$#users_count_by_status_keys_sort;$i++) {
    print "<TR><TD>&nbsp;&nbsp;&nbsp;$users_count_by_status_keys_sort[$i]:</TD><TD>$users_count_by_status{$users_count_by_status_keys_sort[$i]}</TD></TR>" ;
    }
print "</TABLE></TD></TR>" ;

print "</TABLE>" ;
$sth->finish();
$dbh->disconnect();                                        

if ( $is_view_request eq "yes" ) { print "<BR><HR COLOR=\"navy\"><P>Справочно - запрос к базе:</P>\n$request\n" ; }
print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;
