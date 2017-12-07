
package Chapix::Form::Controller;

use lib('cpan/');
use warnings;
use strict;
use Carp;
use Digest::SHA qw(sha384_hex);
use List::Util qw(min max);

use Chapix::Conf;
use Chapix::Com;
#use JSON::XS;

use Chapix::Form::Actions;
use Chapix::Form::API;
use Chapix::Form::View;

use Chapix::Mail::Controller;
use Data::Dumper;

# Language
#use Chapix::Form::L10N;
#my $lh = Chapix::Form::L10N->get_handle($sess{user_language}) || die "Language?";
#sub loc (@) { return ( $lh->maketext(@_)) }

#
sub new {
    my $class = shift;
    my $self = {
        version  => '0.1',
    };

    if(!$sess{account_id}){
         msg_add('warning', 'Inicia sesión en tu cuenta para continuar.');
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
     
    if($_REQUEST->{_action} eq 'get_all_data'){
    	$JSON = Chapix::Form::API::get_user_data($JSON);
    }
   	
    print Chapix::Com::header_out('application/json');
    print JSON::XS->new->encode($JSON);
}


# Admin actions.
# Each action is detected by the "_submitted" param prefix
sub actions {
    my $self = shift;
    my $results = {};

    if($_REQUEST->{_submitted_register_project}){
        $results = Chapix::Form::Actions::register_project();
        #process_results($results);
        return;
    }elsif($_REQUEST->{_submitted_participants}){
    	$results = Chapix::Form::Actions::project_participants();
    	#process_results($results);
    	return;
    }elsif($_REQUEST->{_submitted_participant_documents}){
        $results = Chapix::Form::Actions::project_participants_docs();
        #process_results($results);
        return;
    }elsif($_REQUEST->{_submitted_continue}){
    	$results = Chapix::Form::Actions::project_attachments_continue();
    	return;
    }elsif($_REQUEST->{_submitted_project_general_information}){
        $results = Chapix::Form::Actions::project_general_information();
        #process_results($results);
        return;
    }elsif($_REQUEST->{_submitted_retribution}){
        $results = Chapix::Form::Actions::project_retribution();
        #process_results($results);
        return;
    }elsif($_REQUEST->{_action} eq '_cargar_evidencia'){
    	if($_REQUEST->{_mode} eq 'artes_visuales'){
    		$results = Chapix::Form::Actions::evidencias_artes_visuales();
    	}elsif($_REQUEST->{_mode} eq 'danza'){
    		$results = Chapix::Form::Actions::evidencias_danza();
    	}elsif($_REQUEST->{_mode} eq 'musica'){
    		$results = Chapix::Form::Actions::evidencias_musica();
    	}elsif($_REQUEST->{_mode} eq 'teatro'){
    		$results = Chapix::Form::Actions::evidencias_teatro();
    	}elsif($_REQUEST->{_mode} eq 'cine_video'){
    		$results = Chapix::Form::Actions::evidencias_cine_video();
    	}elsif($_REQUEST->{_mode} eq 'letras'){
    		$results = Chapix::Form::Actions::evidencias_letras();
    	}
    }elsif($_REQUEST->{_action} eq 'start'){
    	$results = Chapix::Form::Actions::start();
    	return;
    }elsif($_REQUEST->{View} eq 'Finish' and $_REQUEST->{_action} eq 'done' and $sess{account_id}){
    	$results = Chapix::Form::Actions::finish();
    	process_results($results);
    }
}


sub process_results {
    my $results = shift;
    http_redirect($results->{redirect}) if($results->{redirect});
}

# Main display function, this function prints the required view.
sub view {
    my $self = shift;
    print Chapix::Com::header_out();

    my $current_step;
    if($sess{on_step} < "0"){
    	$current_step = $sess{on_step};
    }else{
    	$current_step = $dbh->selectrow_array("SELECT step FROM accounts WHERE account_id = ?",{},$sess{account_id});	
    }

    if($current_step eq "0"){
    	print Chapix::Layout::print(Chapix::Form::View::welcome());
    	return;
    }elsif($current_step eq "1" || $_REQUEST->{go_to} eq 1){
        $sess{on_step} = "1";
        print Chapix::Layout::print(Chapix::Form::View::register_project_form());
        return; 
    }elsif($current_step eq "2" || $_REQUEST->{go_to} eq 2){
         $sess{on_step} = "2";
         print Chapix::Layout::print(Chapix::Form::View::project_participants_form());
         return;
    }elsif($current_step eq "3" || $_REQUEST->{go_to} eq 3){
         $sess{on_step} = "3";
         print Chapix::Layout::print(Chapix::Form::View::project_attachments());
         return;
    }elsif($current_step eq "4" || $_REQUEST->{go_to} eq 4){
         $sess{on_step} = "4";
         print Chapix::Layout::print(Chapix::Form::View::project_participants_docs_form());
         return;
    }elsif($current_step eq "5" || $_REQUEST->{go_to} eq 5){
         $sess{on_step} = "5";
         print Chapix::Layout::print(Chapix::Form::View::project_general_information_form());
         return;
    }elsif($current_step eq "6" || $_REQUEST->{go_to} eq 6){
         $sess{on_step} = "6";
         print Chapix::Layout::print(Chapix::Form::View::social_retribution_form());
         return;
    }elsif($current_step eq "7" || $_REQUEST->{go_to} eq 7){
         $sess{on_step} = "7";
         print Chapix::Layout::print(Chapix::Form::View::evidence_form());
         return;
    }elsif($current_step eq "8"){
    	print Chapix::Layout::print(Chapix::Form::View::close_screen());
    	return;
    }
}

1;
