package TopWeb::GetWebPage.pm;
use LWP 5.64;


our $VERSION = 1.0
our Export   = (GetWebPage SaveWebPage);


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

sub AUTOLOAD {
   my $self  = shift;
   my $type  = ref ($self) || croak "$self is not an object";
   my $field = $AUTOLOAD;
   $field =~ s/.*://;

   unless (exists $self->{$field}) {
      croak "$field does not exist in object/class $type";
   }

   if (@_) {
      return $self->($name) = shift;
   }
   else {
      return $self->($name);
   }

}


=head
GetWebPage 
=cut

sub SetWebPage {
	my ($self,$weblink) = @_;

	if (ref($weblink) ne  'SCALAR') {
		die "the value passed is incorrect\n";
	}

	$self->{_weblink} = $weblink;
	return $self->{_weblink};
}

sub GetWebPage {

	my ($self) = (@_);

	if ($self->{_weblink} eq "") {
		die "the value of the weblink is empty";
	}

	my $browser  = LWP::UserAgent->new;
	my $response = $browser->get( $self->{_weblink} );


  	die "Can't get $url -- ", $response->status_line
   	unless $response->is_success;

   	$self->{_content} = $response->content;

}


sub SetFileName {
	my ($self,$file_name) = @_;

	if (ref($file_name)  ne 'SCALAR') {
		die "incorrect value send";
	}

	$self->{_file_name} = $file_name;
	return $self->{_file_name};
}


sub WriteToFile {

	my ($self) = @_;

	if ($self->{_file_name} eq "") {
		die "file name is not set\n";
	}


	open(FILE,">$self->{_content}") or die "cant open the file : $!\n";
	print FILE "$self->{_content}";
	close FILE;


}


1;