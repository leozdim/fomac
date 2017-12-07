package Chapix::Manager::View;

use lib('../');
use lib('../cpan/');
use warnings;
use strict;
use Carp;
use CGI::FormBuilder;

use Chapix::Conf;
use Chapix::List;
use Chapix::Com;
use Chapix::Layout;

# Language
#use Chapix::Manager::L10N;
#my $lh = Chapix::Manager::L10N->get_handle($sess{user_language}) || die "Language?";
#sub loc (@) { return ( $lh->maketext(@_)) }

sub default {
    msg_add('warning',loc('Not implemented'));
    return Chapix::Layout::print(msg_print());
}

sub set_path_route {
    my @items = @_;
    my $route = '';
    foreach my $item(@items){
	my $name = $item->[0];
	$name = CGI::a({-href=>$item->[1]},$name) if($item->[1]);
	$route .= ' <li>&raquo; '.$name.'</li> ';
    }
    $conf->{Page}->{Path} = '<ul class="path"><li><a href="/">Home</a><span class="divider"><i class="glyphicon glyphicon-menu-right"></i></span></li>' .
	$route.'</ul>';
}

sub display_home {
    my $HTML = "";
    my $template = Template->new();
    $conf->{Page}->{ShowSettings} = '1';

    set_toolbar(
        #['Accounts/Subscription','Contratar Marketero','grey-text','favorite'],
	);
    
    my $vars = {
        REQUEST => $_REQUEST,
        conf => $conf,
        sess => \%sess,
	    msg  => msg_print(),
        loc => \&loc,
    };
    $template->process("Chapix/Accounts/tmpl/home.html", $vars,\$HTML) or $HTML = $template->error();
    return $HTML;
}

sub set_toolbar {
    my @actions = @_;
    my $HTML = '';
    
    foreach my $action (@actions){
	my $btn = '<li>';
	my ($script, $label, $class, $icon) = @$action;
	
	if($script !~ /^\//){
	    $script = '/' . $script;
	}
	
	$class = 'waves-effect waves-light ' if(!$class);
	my $id = '';

	if ($label) {
	    $class .= ' tooltipped ';
	    
	    $id = loc($label);
	    $id =~ s/\s/_/g;
	    $id = lc($id).'_action';
	}
	
	$btn .= ' <a id="'.$id.'" href="'.$script.'" class="'.$class.'" data-position="bottom" data-delay="50" data-tooltip="'.$label.'">';
	
	if($icon){
	    $btn .= '<i class="material-icons">'.$icon.'</i> ';
	}
	
	# $btn .= $label;
	$btn .= '</a>';
	$btn .= '</li>';
	$HTML .= $btn;
    }
    if($HTML){
	$HTML = '<ul>' . $HTML . '</ul>';
    }
    $conf->{Page}->{Toolbar} .= $HTML;
}

sub set_add_btn {
    my $script  = shift;
    my $label   = shift || loc('Agregar');
    my @actions = @_;
    my $HTML = '';

    if($script !~ /^\//){
        $script = '/' . $script;
    }
    my $class = 'waves-effect waves-light ';
    my $icon  = 'keyboard_backspace';

    my $btn = '<div class="fixed-action-btn" style="bottom: 45px; right: 24px;">' .
        '<a href="'.$script.'" alt="'.$label.'" title="'.$label.'"  class="btn-floating btn-large waves-effect waves-light red"><i class="material-icons">add</i></a></div>';
    $conf->{Page}->{AddBtn} = $btn;
}


sub set_back_btn {
  my $script  = shift;
  my $label   = shift || loc('Go back');
  my @actions = @_;
  my $HTML = '';

  # if ($ENV{HTTP_REFERER} =~ /^http(?:s)?:\/\/[$conf->{App}->{URL}][^\/]+(\/.*)$/gm) {
  #     $script = $1;
  # }

  if($script !~ /^\//){
    $script = '/' . $script;
  }

  my $class = 'waves-effect waves-light ';
  my $icon  = 'keyboard_backspace';

  if ($label){
    $class .= ' tooltipped ';
  }

  my $btn = ' <a href="'.$script.'" class="'.$class.'"  data-position="bottom" data-delay="50" data-tooltip="'.$label.'">';
  $btn   .= '<i class="material-icons">'.$icon.'</i>';
  $btn   .= '</a>';
  $conf->{Page}->{BackBtn} = $btn;
}

sub set_search_action {
    my $label   = shift || loc('Search');
    my $class = 'waves-effect waves-dark ';
    my $icon  = 'keyboard_backspace';

    my $btn = ' <a href="javascript:xaaTooggleSearch();" class="'.$class.'" alt="'.$label.'" title="'.$label.'" >';
    $btn   .= '<i class="material-icons">search</i>';
    $btn   .= '</a>';
    $conf->{Page}->{Toolbar} .= $btn;

    $conf->{Page}->{Search} = {
        Field => (CGI::textfield({-name=>'q', -id=>'q'})),
        Show => ($_REQUEST->{'q'} || ''),
        Label => loc('Search'),
    };
}

sub display_applicants_list{
    my @params;
    my $WHERE = "";


    if($_REQUEST->{search}){
        $WHERE = (" name LIKE ? and is_admin = 0 ");
        push(@params,'%'.$_REQUEST->{search}.'%');
    }

    my $list = Chapix::List->new(
        dbh => $dbh,
        pagination => 1,
            auto_order => 1,
            sql =>{
                select => "account_id, name AS Nombre, CURP, nationality AS Nacionalidad, birthplace AS 'Lugar de Nacimiento', IF(active=1, 'Si', 'No') AS activo,'' AS details",
                from => "accounts",
                limit => 50,
                where => "is_admin = 0",
                params => \@params, 
            },
            link => {
                 key => "account_id",
                 hidde_key_col => 1,
                 transit_params => {'search' => $_REQUEST->{search}},    
            },
    );

    $list->get_data();
    $list->set_label('details', 'Detalles');
    foreach my $rec(@{$list->{rs}}){
        $rec->{details} = CGI::a({-href=>"/Manager/Details?account_id=$rec->{account_id}", class=>"waves-effect waves-light btn green accent-4"},'<i class="material-icons tiny">more</i>');
    }

    my $HTML = "";
    my $template = Template->new();
    my $vars = {
        REQUEST     => $_REQUEST,
        conf        => $conf,
        sess        => \%sess,
        msg         => msg_print(),
        list        => $list->print(),
    };
    $template->process("Chapix/Manager/tmpl/list.html", $vars,\$HTML) or $HTML = $template->error();
    return $HTML;
}
1;
