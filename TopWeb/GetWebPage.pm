package TopWeb::GetWebPage;
use strict;
use warnings;
use Carp;
#use Exporter;


use LWP;


our $VERSION     = 1.0;
# our @ISA         = qw(Exporter);
# our @Export      = qw(GetWebPage SaveWebPage);
# our @EXPORT_OK   = qw();

sub new {

	my $class = shift;
    my $self = {
    	_weblink      => "",
    	_content      => "",
    	_file_name    => ""

    };

    bless $self, $class;
    return $self;
}


=head
SetWebLink : set the page link to obtain
@in        : 
@out       : 
=cut

sub SetWebLink {
	my ($self,$weblink) = @_;


	if (ref($weblink) ne  '') {
		die "the value passed is incorrect\n";
	}

	if ($weblink eq '') {
		die "the value passed is incorrect\n";
	}

	$self->{_weblink} = $weblink;
	return $self->{_weblink};
}

=head
GetWebPage : set the page link to obtain
@in        :
@out       : 
=cut
sub GetWebPage {

	my ($self) = (@_);

	if ($self->{_weblink} eq "") {
		die "the value of the weblink is empty";
	}

	my $browser  = LWP::UserAgent->new;
	my $response = $browser->get( $self->{_weblink} );


  	die "Can't get $self->{_weblink} -- ", $response->status_line
   	unless $response->is_success;

   	#$self->{_content} = $response->decode_content;
   	$self->{_content} = $response->content;

   	return $self->{_content};
}

=head
SetFileName : set file name
@in         : 
@out        : 
=cut
sub SetFileName {
	my ($self,$file_name) = @_;

	if (ref($file_name)  ne '') {
		die "incorrect value send";
	}

	if ($file_name eq '') {
		die "empty value";
	}

	$self->{_file_name} = $file_name;
	return $self->{_file_name};
}

=head
WriteToFile : write the obtain content to teh file
@in         : 
@out        : 
=cut
sub WriteToFile {

	my ($self) = @_;

	if ($self->{_file_name} eq "") {
		die "file name is not set\n";
	}

	open(FILE,">$self->{_file_name}") or die "cant open the file $self->{_file_name} : $!\n";
	print FILE "$self->{_content}";
	close FILE;


}

=head
CheckOutput : to check the output for the key
@in         : 
@out        : 
=cut
sub CheckOutput {

	my ($self,$key) = @_;

	if ($self->{$key} eq "") {
		die "file name is not set\n";
	}

	print "$self->{$key}\n";


}


1;