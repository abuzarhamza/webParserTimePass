use strict;
use warnings;
use diagnostics;

use lib "/home/abuzzar/Desktop/project/webParser/webParserTimePass";

#use Time::HiRes qw(clock_gettime clock_getres) ;
use Time::Piece;
use TopWeb::GetWebPage;
use Error;
#use TopWeb::ParseWebPage;


#need a high resolution time 2013_month_date_hh_mm_ss

my $DateTime = get_current_systime();

my $fileName = '/tmp/tdf'.'_'.$DateTime.'.html';

print "\$fileName : $fileName\n";

my $obj = TopWeb::GetWebPage->new();
$obj->SetWebLink('http://topdocumentaryfilms.com/invisible-nation/');

$obj->GetWebPage();
$obj->CheckOutput('_content');
$obj->SetFileName($fileName);
$obj->WriteToFile();


=head
get_current_systime : get local time yyyy_mm_dd_hh_mm_ss format
@in                 : 
=cut
sub get_current_systime {

	my $t        = localtime;
	my $Date     = $t->ymd("_");
	my $Time     = $t->hms("_"); 

	return $Date . "_" . $Time;	
}


