package TopWeb::ParseWebPage;
use TopWeb::WebName::TopDocumentary::SinglePageParse;


sub new {

}

sub SetWebName {

	my ($self,$webname) = @_;

	if ( ref($webname) ne 'STRING') {
		die "incorrect type";

	}
	$self->{_webname} = $webname;
	return $self->{_webname};

}

sub GetWebName {
	
	my ($self,$webname) = @_;

	if (! exists $self->{_webname}) {
		die "empty argument";
	}

	return $self->{_webname};
}

sub ParseHtmlPage {

	my $object = "";
	if ($self->{_webname} eq 'tdf') {
		
		$object = TopWeb::WebName::TopDocumentary::SinglePageParse->new();

	} 
	else {
		die "unkown entry\n";
	}

	
	$object->ParseSinglePage($self->{_content});

	$self->SetCharacterEncoding(
							$object->GetHtmlElement('_character_encoding')
		);

	$self->SetImageLink(
							$object->GetHtmlElement('_image_link')
		);

	$self->SetTittle(
							$object->GetHtmlElement('_title')
		);

	$self->SetDescription(
							$object->GetHtmlElement('_description')
		);

}




sub GetCharacterEncoding {

}


sub GetImageLink {

}

sub GetTittle {

}

sub GetDescription {

}

sub GetVedioLink {

}

1;
