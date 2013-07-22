package TopWeb::WebName::TopDocumentary::Crawler;


use TopWeb::GetWebPage;
use HTML::TreeBuilder;


sub new {
	my $class = shift;
    my $self = {
    	_web_link          => "",
    	_max_try           => 20,
    	_link              => {},
    	_doc_link          => {}
    };

    bless $self, $class;
    return $self;
}


sub SetWebLink {

	my ($self,$web_link) = @_;

	if (ref($web_link) ne '') {
		die "incorrect value set for _web_link\n";
	}

	if ($web_link eq '') {
		die "some value need to be set\n";
	}

	$self->{_web_link}= $web_link;
	$self->{_link}{$web_link} = "not visted";

	return $self;

}

sub BuildLinkHash {

	my ($self) = @_;
	
	my $obj = TopWeb::GetWebPage->new();
	
		
	my $MAXTRY = $self->{_max_try};
	my $TRYCOUNT = 1;
	
	my $oldLink = "";

	#new Link will be assign in the key _web_link
	while($self->{_web_link} ne '' ) {

		if ($oldLink eq '' ||  $oldLink ne $self->{_web_link} ) {

			$oldLink = $self->{_web_link};
			$TRYCOUNT = 1;
		}
		elsif ($oldLink eq $self->{_web_link} )  {
			$TRYCOUNT++;
		}
		

		$obj->SetWebLink( $self->{_web_link} ) ;
		$obj->GetWebPage();

		my $webLink = $self->{_web_link};
		$self->{_link}{$webLink} = 'visited';
		$self->_parsePageContent($obj->{_content});

		print "Test1\n";

		if ($TRYCOUNT >= $MAXTRY ) {
			die "issue in connection";
		}

	}

	return $self;
}


sub _parsePageContent {

	my ($self,$file_content) = @_;

	my $title         = "";
	my $charEncode    = "";
	my $imgLink       = "";
	my $vedioLink     = "";
	my $description   = "";
	my $category      = "";

	my $tree = HTML::TreeBuilder->new();
	$tree->parse($file_content);

	#print "$file_content\n";
	#to extract link of all documentary
	#<div class="wrapexcerpt">
	my (@post) = $tree->look_down(_tag,'div','class','wrapexcerpt');
	#<h2 class="postTitle">
	#<a title="To the Last Drop" href="http://topdocumentaryfilms.com/last-drop/">To the Last Drop</a>
	#</h2>
	foreach my $post (@post) {

		my $title    = "";
		my $docLink  = "";

		my $h1    = $post->look_down(_tag,'h2','class','postTitle');
		my $t     = $h1->look_down(_tag,'a');
		
		my $title   = $t->as_text;
		my $docLink = $t->attr('href'); 

		if ( $title ne ''  && $docLink  ne '' ) {
			if ( ! (exists $self->{_doc_link}{$docLink}{title} )) {
				$self->{_doc_link}{$docLink}{title} = $title;
			}
		}

	}



	# <div class="pagination text_center">
	# <span class="current">1</span>
	# <a class="inactive" href="http://topdocumentaryfilms.com/all/page/2/">2</a>

	my $link = "";
	my %link = ();
	my ($page) = $tree->look_down(_tag,'div','class','pagination text_center');
	
	if ($page) {

		my $linkFlag = 0;

		my (@nextPage) = $page->look_down(_tag,'a','class','inactive'); 		

		foreach my $nextPage (@nextPage) {
			if ($nextPage) {

				$link = $nextPage->attr('href');

				if ( ($link ne $self->{_web_link} )
					&& ( ! (exists ( $self->{_link}{$link} ) ) )
					&& ($self->{_link}{$link} ne 'visited')
				) {

					$self->{_web_link} = $link;
					print "T3  : $self->{_web_link}\n";
					$linkFlag = 1;
					last;
				}
			}
			else {
				warn "No link found\n";
			}
			
		}

		if ( $linkFlag == 0 ) {
			#to switch off the while loop
			$self->{_web_link} = "";
		}

	}
	else {
		warn "No link data found in page\n";
	}

	$tree->delete;	

	return $self;
}

1;