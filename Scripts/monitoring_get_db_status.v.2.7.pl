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

require '/var/www/oracle/cgi/omon.cfg' ;
use DBI ;
use threads ;
use threads::shared ;

my @connectors = keys %connector_definition ;
my %stat_db : shared ;

print "Content-Type: text/html\n\n";
print "<HTML><HEAD>
<meta http-equiv=\"refresh\" content=\"180;url=http://oracle.zerot.local/cgi/monitoring_get_db_status.cgi\">
<META HTTP-EQUIV=Content-Type content=\"text/html; charset=utf-8\">
<META HTTP-EQUIV=\"Cache-Control\" content=\"no-cache, no-store, max-age=0, must-revalidate\">
<META HTTP-EQUIV=\"Pragma\" content=\"no-cache\">
<META HTTP-EQUIV=\"Expires\" content=\"Fri, 01 Jan 1990 00:00:00 GMT\">
</HEAD><BODY>
<STYLE>
<!-- TR:nth-child(odd) { background: #fff; }
TR:nth-child(even) { background: #F7F7F7; } -->
A:link { text-decoration: none; color: navy; }
A:active { text-decoration: none; color: navy; }
A:visited { text-decoration: none; color: navy; }
A:hover { text-decoration: none; color: navy; }
</STYLE>
" ;

sub get_status2($$$) { my $cnctr = $_[0] ; $cnctr_def = $_[1] ; $cnctr_cred = $_[2] ;
    eval {
         my $dbh = DBI->connect($cnctr_def, $cnctr_cred);
         my $SQL="select i.INST_ID, i.INSTANCE_NUMBER, i.INSTANCE_NAME, i.HOST_NAME, i.VERSION, TO_CHAR(i.STARTUP_TIME,'YYYY-MM-DD HH24:MI:SS'), i.STATUS, i.PARALLEL, i.THREAD#, i.DATABASE_STATUS,
                         i.INSTANCE_ROLE, d.OPEN_MODE, d.LOG_MODE, d.DATABASE_ROLE, d.FORCE_LOGGING, d.CURRENT_SCN, d.FLASHBACK_ON, d.NAME, d.DB_UNIQUE_NAME, d.DBID, (select count(*) from v\$database_block_corruption) as BLCK_CORRUPT
                         from gv\$instance i, gv\$database d where i.inst_id = d.inst_id order by INSTANCE_NUMBER\n" ;
#print "$SQL\n" ;
         my $sth=$dbh->prepare($SQL) ; $sth->execute ;
         $stat_db{$cnctr} = "" ;
         while (my ($INST_ID, $INSTANCE_NUMBER, $INSTANCE_NAME, $HOST_NAME, $VERSION, $STARTUP_TIME, $STATUS, $PARALLEL, $THREAD_N, $DATABASE_STATUS, $INSTANCE_ROLE, $OPEN_MODE, $LOG_MODE, $DATABASE_ROLE, $FORCE_LOGGING, $CURRENT_SCN, $FLASHBACK_ON, $NAME, $DB_UNIQUE_NAME, $DBID, $BLCK_CORRUPT) = $sth->fetchrow()) {
            if ( $INST_ID eq "" ) { $INST_ID = "&nbsp;" ; } if ( $INSTANCE_NUMBER eq "" ) { $INSTANCE_NUMBER = "&nbsp;" ; } if ( $INSTANCE_NAME eq "" ) { $INSTANCE_NAME = "&nbsp;" ; }
            if ( $HOST_NAME eq "" ) { $HOST_NAME = "&nbsp;" ; } if ( $VERSION eq "" ) { $VERSION = "&nbsp;" ; }
            $STARTUP_TIME =~ s/\s/\&nbsp\;/g ; if ( $STARTUP_TIME eq "" ) { $STARTUP_TIME = "&nbsp;" ; }
            if ( $STATUS eq "" ) { $STATUS = "&nbsp;" ; } if ( $PARALLEL eq "" ) { $PARALLEL = "&nbsp;" ; } if ( $THREAD_N eq "" ) { $THREAD_N = "&nbsp;" ; }
            if ( $DATABASE_STATUS eq "" ) { $DATABASE_STATUS = "&nbsp;" ; } if ( $INSTANCE_ROLE eq "" ) { $INSTANCE_ROLE = "&nbsp;" ; } if ( $INSTANCE_MODE eq "" ) { $INSTANCE_MODE = "&nbsp;" ; }
            $OPEN_MODE =~ s/\s/\&nbsp\;/g ; if ( $OPEN_MODE eq "" ) { $OPEN_MODE = "&nbsp;" ; }
            if ( $STATUS eq "OPEN" ) { $dc = "green" ; } else { $dc = "red" ; }
            $DATABASE_ROLE =~ s/\s/\&nbsp\;/g ; if ( $DATABASE_ROLE eq "" ) { $DATABASE_ROLE = "&nbsp;" ; } 
            if ( $FORCE_LOGGING eq "" ) { $FORCE_LOGGING = "&nbsp;" ; } if ( $CURRENT_SCN eq "" ) { $CURRENT_SCN = "&nbsp;" ; }
            $FLASHBACK_ON =~ s/\s/\&nbsp\;/g ; if ( $FLASHBACK_ON eq "" ) { $FLASHBACK_ON = "&nbsp;" ; }
            if ( $NAME eq "" ) { $NAME = "&nbsp;" ; }
            if ( $BLCK_CORRUPT eq "0" ) { $blck_corr_dc = "right_green" ; } else { $blck_corr_dc = "right_red" ; }
            $stat_db{$cnctr} = "$stat_db{$cnctr}<TR><TD TITLE=\"Коннектор $cnctr, строка соединения $cnctr_def\"><A HREF=\"http://oracle.zerot.local/cgi/get_db_status.cgi?set_current_connector=$cnctr\">$NAME</A></TD>
                               <TD>$DB_UNIQUE_NAME</TD><TD>$DATABASE_ROLE</TD><TD>$OPEN_MODE</TD><TD CLASS=\"$dc\">$STATUS</TD>
                               <TD CLASS=\"$blck_corr_dc\">$BLCK_CORRUPT</TD><TD>$INSTANCE_NAME</TD><TD>$DBID</TD><TD>$STARTUP_TIME</TD><TD>$HOST_NAME</TD><TD>$VERSION</TD><TD>$INST_ID</TD><TD>$INSTANCE_NUMBER</TD>
                               <TD>$THREAD_N</TD><TD>$PARALLEL</TD><TD>$DATABASE_STATUS</TD><TD>$INSTANCE_ROLE</TD><TD>$LOG_MODE</TD><TD>$FORCE_LOGGING</TD><TD>$CURRENT_SCN</TD><TD>$FLASHBACK_ON</TD></TR>" ;
#print "$stat_db{$cnctr} \n" ;
            }
         $dbh->disconnect() ;
         }
    }

for ($i=0;$i<=$#connectors;$i++) {
    $stat_db{$connectors[$i]} = "<TR><TD TITLE=\"Коннектор $connectors[$i], строка соединения $connector_definition{$connectors[$i]}\" CLASS=\"nochecked\" COLSPAN=\"21\">&nbsp;NO CHECKED : $connector_comments{$connectors[$i]} : $connector_description{$connectors[$i]}</TD></TR>" ;
#print "$stat_db{$connectors[$i]} \n";
    threads->create(\&get_status2,$connectors[$i],$connector_definition{$connectors[$i]},$connector_credentials{$connectors[$i]})->detach;
    }


# ждём требуемое для опроса время
sleep 20 ;

print "<STYLE>
TD { font-size: 10pt; font-family: sans-serif; }
TD.green { color: green; }
TD.red { color: red; }
TD.right_green { color: green; text-align: right; }
TD.right_red { color: red; text-align: right;  }
TD.nochecked { color: brown; text-align: left ; }
TD.tdhead { text-align: center; }
</STYLE>
<TABLE BORDER=\"1\" STYLE=\"width: 100%;\">" ;
print "<TR><TD CLASS=\"tdhead\">DATABASE NAME</TD><TD CLASS=\"tdhead\">DB UNIQUE NAME</TD><TD CLASS=\"tdhead\">DATABASE DATABASE ROLE</TD>
 <TD CLASS=\"tdhead\">DATABASE OPEN MODE</TD><TD CLASS=\"tdhead\">INSTANCE STATUS</TD>
 <TD CLASS=\"tdhead\">BLOCK CRRPT</TD><TD CLASS=\"tdhead\">INSTANCE NAME</TD><TD CLASS=\"tdhead\">DBID</TD><TD CLASS=\"tdhead\">INSTANCE STARTUP TIME</TD><TD CLASS=\"tdhead\">INSTANCE HOST NAME</TD>
 <TD CLASS=\"tdhead\">INSTANCE VERSION</TD><TD CLASS=\"tdhead\">INST ID</TD><TD CLASS=\"tdhead\">INSTANCE NUMBER</TD><TD CLASS=\"tdhead\">INSTANCE THREAD_N</TD><TD CLASS=\"tdhead\">INSTANCE PARALLEL</TD>
 <TD CLASS=\"tdhead\">INSTANCE DATABASE STATUS</TD><TD CLASS=\"tdhead\">INSTANCE ROLE</TD><TD CLASS=\"tdhead\">DATABASE LOG MODE</TD><TD CLASS=\"tdhead\">DATABASE FORCE LOGGING</TD><TD CLASS=\"tdhead\">DATABASE CURRENT SCN</TD>
 <TD CLASS=\"tdhead\">DATABASE FLASHBACK ON</TD></TR>" ;
@aaa = sort(keys %stat_db) ; for ($i=0;$i<=$#aaa;$i++) { print "$stat_db{$aaa[$i]}\n" ; }
print "</TABLE>" ;

print "</BODY></HTML>" ;
