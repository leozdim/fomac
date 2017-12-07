package Chapix::Form::API;

use lib('../');
use lib('../cpan/');
use warnings;
use strict;
use Carp;
use Digest::SHA qw(sha384_hex sha1_hex);

use Chapix::Conf;
use Chapix::Com;

# Language
#use Chapix::Form::L10N;
#my $lh = Chapix::Form::L10N->get_handle($sess{user_language}) || die "Language?";
#sub loc (@) { return ( $lh->maketext(@_)) }


sub get_user_data{
	my $JSON = shift;
	my $project_registry;
	my $project_participants;
	eval{
		my $current_step = $dbh->selectrow_array("SELECT step FROM accounts WHERE account_id = ?",{},$_REQUEST->{id});
		if($current_step >= 1){
			$JSON->{account_data} = $dbh->selectrow_hashref("SELECT name, email FROM accounts WHERE account_id = ?",{},$_REQUEST->{id});
			my $register_record = $dbh->selectrow_array("SELECT COUNT(*) FROM project_registry WHERE account_id = ?",{},$_REQUEST->{id});
			
			if($register_record){
				$project_registry = $dbh->selectrow_hashref("SELECT project_id, categoria,disciplina,tipo_proyecto WHERE account_id = ?",{},$_REQUEST->{id});
			}else{
				$project_registry = 'no_data';
			}

			if($project_registry->{project_id}){
				$project_participants = $dbh->selectall_arrayref("SELECT * FROM project_participants WHERE project_id = ?",{Slice => {}},$project_registry->{project_id}); 
			}else{
				$project_participants = 'no_data';
			}
		}

		$JSON->{account_data}->{current_step} = $current_step;
		$JSON->{project_registry} = $project_registry;
		$JSON->{project_participants} = $project_participants;
	};
	if($@){
		$JSON->{error} = 1;
		$JSON->{msg} = '$@';
	}else{
		$JSON->{success} = 1;
		$JSON->{msg} = 'La tarea a finalizado con exito';
	}

	return $JSON;
}


1;