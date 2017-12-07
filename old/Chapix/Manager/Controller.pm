package Chapix::Manager::Controller;

use lib('cpan/');
use warnings;
use strict;
use Carp;
use Digest::SHA qw(sha384_hex);
use List::Util qw(min max);

use Chapix::Conf;
use Chapix::Com;

use Chapix::Manager::Actions;
use Chapix::Manager::API;
use Chapix::Manager::View;

use Chapix::Mail::Controller;

# Language
#use Chapix::Manager::L10N;
#my $lh = Chapix::Accounts::L10N->get_handle($sess{user_language}) || die "Language?";
#sub loc (@) { return ( $lh->maketext(@_)) }

#
sub new {
    my $class = shift;
    my $self = {
        version  => '0.1',
    };

    if($sess{account_isadmin} ne "1"){
        msg_add('warning', 'Inicia sesión en tu cuenta de administrador para continuar.');
        http_redirect("/Accounts/Login");
    }

    bless $self, $class;

    # Init app ENV
    $self->_init();

    return $self;
}

# Initialize ENV
sub _init {
    my $self = shift;
}


# API
sub api {
    my $JSON = {
	error   => '',
	success => '',
	msg     => ''
    };
     
   
    print Chapix::Com::header_out('application/json');
    print JSON::XS->new->encode($JSON);
}


# Admin actions.
# Each action is detected by the "_submitted" param prefix
sub actions {
    my $self = shift;
    my $results = {};

    
}


sub process_results {
    my $results = shift;
    http_redirect($results->{redirect}) if($results->{redirect});
}

# Main display function, this function prints the required view.
sub view {
    my $self = shift;
    print Chapix::Com::header_out();

    print Chapix::Layout::print(Chapix::Manager::View::display_applicants_list());
    return;
} 

1;
