package TopWeb::WebName::TopDocumentary::SinglePageParse;

use HTML::TreeBuilder;

sub new {
	my $class = shift;
    my $self = {
    	_title             => "",
    	_character_encoding => "",
    	_image_link         => "",
    	_vedio_link         => "",
    	_description        => "",
    	_category           => ""
    };

    bless $self, $class;
    return $self;
}



sub parseSinglePage {

	my ($self,$file_content) = @_;


	my $title         = "";
	my $charEncode    = "";
	my $imgLink       = "";
	my $vedioLink     = "";
	my $description   = "";
	my $category      = "";

	#<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">

	foreach @fileContent {
		#encoding
		if ($_=~ qq{<meta content=\"text/html; charset=(.+)\" http-equiv=\"Content-Type\">}) {
			$charEncode = $1;
			last;
		}
	}

	my $p = "";

	my $tree = HTML::TreeBuilder->new();
	$tree->parse($file_content);

	#<h1 class="postTitle">Time Machine</h1>
	my $h1 = $tree->look_down('_tag', 'h1', 'class', 'postTitle');
	if ($h1) {
	  $title = $h1->as_text;
	} else {
	  warn "No heading in $_[0]?";
	}


	my $cat = $tree->look_down('_tag', 'a', 'rel', 'category tag');
	if ($cat) {
		$category = $cat->as_text;
	} else {
	  warn "No heading in $_[0]?";
	}


	my $content = $tree->look_down('_tag', 'div', 'class', 'postContent text_justify');
	if ($content) {
		
		my $des = $content->content_list ;
		if ($des) {
			
			my $img = $des->look_down(_tag,'img');
			
			if ($img) {
				$imgLink = $img->attr('src');
			} 
			else {
				warn "No content list in $_[0]?";
			}
			
			my @p = $des->look_down(_tag,'p');
			foreach (@p) {
				if ($_) {
					
					if ($description ne '' ) {
						$description = $_->as_text;
					} 
					else {
						$description .= $_->as_text;
					}
				}
				else {
					warn "No description list in $_[0]?";
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
	
	
}



sub  start_handler{


	if () {

	}
}







1;
