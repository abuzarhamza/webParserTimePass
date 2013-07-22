package TopWeb::WebName::TopDocumentary::SinglePageParse;

use HTML::TreeBuilder;

sub new {
	my $class = shift;
    my $self = {
    	_title              => "",
    	_character_encoding => "",
    	_image_link         => "",
    	_vedio_link         => "",
    	_description        => "",
    	_category           => ""
    };

    bless $self, $class;
    return $self;
}



sub ParseSinglePage {

	my ($self,$file_content) = @_;


	my $title         = "";
	my $charEncode    = "";
	my $imgLink       = "";
	my $vedioLink     = "";
	my $description   = "";
	my $category      = "";

	#<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">

	# foreach @fileContent {
	# 	#encoding
	# 	if ($_=~ qq{<meta content=\"text/html; charset=(.+)\" http-equiv=\"Content-Type\">}) {
	# 		$charEncode = $1;
	# 		last;
	# 	}
	# }



	my $tree = HTML::TreeBuilder->new();
	$tree->parse($file_content);

	#<h1 class="postTitle">Time Machine</h1>
	my $h1 = $tree->look_down('_tag', 'h1', 'class', 'postTitle');
	if ($h1) {
	  $title = $h1->as_text;
	} else {
	  warn "No title in $_[0]?";
	}


	my $cat = $tree->look_down('_tag', 'a', 'rel', 'category tag');
	if ($cat) {
		$category = $cat->as_text;
	} else {
	  warn "No category in $_[0]?";
	}



	my $content = $tree->look_down('_tag', 'div', 'class', 'postContent text_justify');
	if ($content) {
		
		my ($des) = $content->content_list ;

		if ($des) {
			
			my $img = $des->look_down(_tag,'img');
			
			if ($img) {
				$imgLink = $img->attr('src');
			} 
			else {
				warn "No imgLink in $_[0]?";
			}
			
			my (@p) = $des->look_down(_tag,'p');
			foreach (@p) {
				if ($_) {
					
					if ($description eq '' ) {
						$description = $_->as_text;
					} 
					else {
						$description .= $_->as_text;
					}
				}
				else {
					warn "No para list in $_[0]?";
				}
			}
		}
		else {
			warn "No content list in $_[0]?";
		}
	} 
	else {
		warn "No heading in $_[0]?";
	}

	#<iframe width="100%" height="325" frameborder="0" allowfullscreen="" src="http://www.youtube.com/embed/4xCdehrV96U?rel=0&iv_load_policy=3">
	my $vid = $tree->look_down('_tag', 'iframe', 'width', '100%' , 'height' , '325');
	if ($vid) {
		$vedioLink = $vid->attr('src');
	}
	else {
		warn "No vedio link in $_[0]?";	
	}


	$tree->delete;

	$self->{_title}       = $title;
	$self->{_category}    = $category;
	$self->{_image_link}  = $imgLink;
	$self->{_description} = $description;
	$self->{_vedio_link}  = $vedioLink;

	return $self;
	
}



sub  GetHtmlElement {

	my ($self,$html_elment)  = @_;

	if (ref($html_elment) ne '' ) {
		die "value passed is incorrect\n";
	}

	if ($html_elment eq '') {
		die "empty value passed is incorrect\n"
	}

	if (exists $self->{$html_elment} ) {
		return $self->{$html_elment};
	}
	else {
		return "";
	}

}



1;
