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

sub print_head_ancor($$) { $a_order_field = $_[0] ; $a_title_field = $_[1] ; $order_symbol = "&nbsp;" ;
    if ( $pv{order_field} !~ /^$a_order_field/ ) { $a_order_field .= " DESC" ; }
    if ( $pv{order_field} =~ /^$a_order_field\sASC/ || $pv{order_field} eq "$a_order_field" ) { $a_order_field .= " DESC" ; $order_symbol = "&#9650;" ; }
    if ( $pv{order_field} =~ /^$a_order_field\sDESC/ ) { $a_order_field .= " ASC" ; $order_symbol = "&#9660;" ; }
    print "<TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" ALIGN=\"center\"><TR><TD>&nbsp;</TD>
           <TD STYLE=\"text-align: center;\"><A HREF=\"$base_url/cgi/get_data_from_table_view.cgi?order_field=$a_order_field&owner=$pv{owner}&name=$pv{name}&sz_num=$pv{sz_num}&ext_filter=$pv{ext_filter}&is_second=yes\" TARGET=\"cont\">$a_title_field</A></TD>
           <TD STYLE=\"color: navy;\">&nbsp;$order_symbol</TD></TR></TABLE>" ;
    }

use DBI;
#u#se POSIX;
#u#se locale;
#$#loc = POSIX::setlocale( &POSIX::LC_ALL, "ru_RU.UTF8" );

require "/var/www/oracle/cgi/omon.cfg" ;
$current_connector = "none" ; if ( $ENV{HTTP_COOKIE} =~ /.*[;\s]*current_connector=([^;]+)[;\s]*.*/ ) { $current_connector = $1 ; }

$ENV{ORACLE_SID} = $current_connector ;
$ENV{NLS_DATE_FORMAT} = "YYYY-MM-DD HH24:MI:SS" ;

# - вытащить из URL запроса значения уточняющих полей
get_forms_param() ;

# логика работы модуля отображения данных таблицы или представления
# по полученным значениям владельца и имени таблицы сформировать список полей для последующего вывода заголовков
# ... в перспективе для идентификатора владелец объект отработать правила переименования, хранимые отдельно
# получить сами данные с учётом ограничения выборки и порядка соритровки (и, в перспективе, фильтрующих полей)

print "Content-Type: text/html\n\n"; 
&print_html_head("Данные таблицы или представления $pv{name}, схема $pv{owner}") ;
                                                                                                                                                            
print "<FORM ACTION=\"$base_url/cgi/get_data_from_table_view.cgi\" METHOD=\"GET\">
       <TABLE BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\">
       <TR><TD COLSPAN=\"2\"><DIV STYLE=\"text-align: left;\"> -- отображение выборки ТРЕБУЕТ обязательного указания дополнительных условий --
           <BR> -- поле доп. фильтра в текущей версии не обрабатывается --</DIV></TD></TR> " ;
print "<TR><TD>&nbsp;Владелец/схема: </TD><TD STYLE=\"width: 75%\"><INPUT TYPE=\"input\" NAME=\"owner\" VALUE=\"$pv{owner}\"></TD></TR>
       <TR><TD>&nbsp;Объект: </TD><TD STYLE=\"width: 75%\"><INPUT TYPE=\"input\" NAME=\"name\" VALUE=\"$pv{name}\"></TD></TR>
       <TR><TD>&nbsp;Строк не более: </TD><TD STYLE=\"width: 75%\"><INPUT TYPE=\"input\" NAME=\"sz_num\" VALUE=\"$pv{sz_num}\"></TD></TR>
       <TR><TD>&nbsp;Доп. условие: </TD><TD STYLE=\"width: 75%\"><INPUT TYPE=\"input\" NAME=\"ext_filter\" VALUE=\"$pv{ext_filter}\"></TD></TR>
       <INPUT TYPE=\"hidden\" NAME=\"order_field\" VALUE=\"$pv{order_field}\"><INPUT TYPE=\"hidden\" NAME=\"is_second\" VALUE=\"yes\"></TD></TR>
       <TR><TD COLSPAN=\"2\" STYLE=\"text-align: left;\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=\"submit\" VALUE=\"Сформировать по указанным значениям\"></TD></TR>
       </TABLE></FORM>" ;

if ( $pv{is_second} eq "yes" ) { if ( $pv{name} =~ /^V\$.+$/ ) { $pv{name} =~ s/V\$/V_\$/g ; }
   $request_get_field_desc = "SELECT COLUMN_NAME,DATA_TYPE FROM dba_tab_columns WHERE OWNER = '$pv{owner}' and TABLE_NAME = '$pv{name}' order by COLUMN_ID" ;
# - запросить данные по указанным значениям фильтра и вывести их (по идее должна возвращаться только одна
# - сессия, но испогльзована универсальная конструкция обработки многих строк
   my $dbconn = DBI->connect( $connector_definition{$current_connector}, $connector_credentials{$current_connector}, '') ;
# получить заголовки таблицы или представления
   my $cursor_handler = $dbconn->prepare($request_get_field_desc) ; $cursor_handler->execute();
   $field_count = 0 ; while ( ($field_name[$field_count],$field_type[$field_count]) = $cursor_handler->fetchrow_array() ) { $field_count += 1 ; }
# вывести заголовки таблицы
   print "<TABLE BORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"0\" STYLE=\"width: 100%;\"><TR>" ;
   for ($i=0;$i<$field_count;$i++) { print "<TD CLASS=\"HEAD\">" ; &print_head_ancor("$field_name[$i]","$field_name[$i]") ; print "</TD>"; }
    print "</TR>\n" ;
# получить и вывести данные о полях таблицы или представления, заполнить нумерованные массивы данных
   $what_data = "" ; 
   for ($i=0;$i<$field_count;$i++) { if ( $what_data ne "" ) { $what_data .= "," ; } 
       if ( $field_type[$i] =~ /.*NUMBER.*/ || $field_type[$i] =~ /.*VARCHAR.*/ || $field_type[$i] =~ /.*DATE.*/ ) {
          $what_data .= "data.".$field_name[$i] ;
          }
       else
          { $what_data .= "'FIELD&nbsp;TYPE&nbsp;&nbsp;is&nbsp;$field_type[$i]'" ; }
       }
   $where_data = "" ; if ( $pv{ext_filter} ne "" ) { $where_data = "WHERE $pv{ext_filter}" ; }
   $order_data = "" ; if ( $pv{order_field} ne "" ) { $order_data = "ORDER BY $pv{order_field}" ; }
   $max_strings = "" ; if ( $pv{sz_num} ne "" && $pv{sz_num} > 0 ) { $max_strings = " WHERE ROWNUM < $pv{sz_num}" ; }
   $request_get_data = "SELECT $what_data FROM ( SELECT * FROM $pv{owner}.$pv{name} $where_data $order_data ) data $max_strings" ;
# получить и вывести данные
   my $cursor_handler = $dbconn->prepare($request_get_data) ; $cursor_handler->execute();
   while ( @object_data = $cursor_handler->fetchrow_array() ) { 
         print "<TR>" ; 
         for ($i=0;$i<$field_count;$i++) { 
             $align_type = "left" ; if ( $field_type[$i] =~ /.*NUMBER.*/ ) { $align_type = "right" ; } 
             $object_data[$i] =~ s/\s/&nbsp;/g ;
             if ( $object_data[$i] eq "" ) { $object_data[$i] = "&nbsp;" ; }
             print "<TD STYLE=\"text-align: $align_type;\">$object_data[$i]</TD>" ; } 
         print "</TR>\n" ; }
# вывести заголовки таблицы
   print "</TABLE>" ;
   print "<BR>" ;
   
   if ( $is_view_request eq "yes" ) { 
      print "<BR><HR COLOR=\"navy\">
                 <P><FONT COLOR=\"navy\"><B>Справочно: запрос заголовков</B></FONT> <BR><BR>$request_get_field_desc</P>
                 <P><FONT COLOR=\"navy\"><B>Справочно: запрос данных</B></FONT> <BR><BR>$request_get_data</P>\n" ; }
   }

print "<BR>&nbsp;<HR COLOR=\"navy\"><P STYLE=\"font-size 8pt; text-align: center;\">(C) 2000-2010 Sergey S. Belonin. All rights reserved</P>" ;
print "</BODY></HTML>" ;

$cursor_handler_main->finish();
$dbconn_main->disconnect();                                        
