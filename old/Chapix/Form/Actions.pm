package Chapix::Form::Actions;

use lib('../');
use lib('../cpan/');
use warnings;
use strict;
use Carp;
use CGI::Carp qw(fatalsToBrowser);
use CGI::FormBuilder;
use Digest::SHA qw(sha384_hex);
#use JSON::XS;
use List::Util qw(min max);

use Chapix::Conf;
use Chapix::Com;
use Data::Dumper;
use File::Path qw(make_path remove_tree);

# Language
#use Chapix::Form::L10N;
#my $lh = Chapix::Form::L10N->get_handle($sess{user_language}) || die "Language?";
#sub loc (@) { return ( $lh->maketext(@_)) }

sub close_step{ 
    my $current_step = shift || 0;
  
    if($current_step eq '7'){
    	$dbh->do("UPDATE steps_account SET is_completed = 1 WHERE step_id = ? AND account_id = ?",{},$current_step,$sess{account_id});
	}else{
		my $account_step = $dbh->selectrow_array("SELECT step FROM accounts WHERE account_id = ?",{},$sess{account_id});

		if($current_step eq $account_step){
			$dbh->do("UPDATE accounts SET step = ? WHERE account_id = ?",{},($current_step + 1),$sess{account_id});	
		}
		$dbh->do("UPDATE steps_account SET is_completed = 1, skipped = 0 WHERE step_id = ? AND account_id = ?",{},$current_step,$sess{account_id});
	}
    
    my $updated_step = $current_step + 1;
    $sess{on_step} = "$updated_step";
}

sub skip_step{
	my $current_step = shift || 0;
	my $account_step = $dbh->selectrow_array("SELECT step FROM accounts WHERE account_id = ?",{},$sess{account_id});

	if($current_step eq $account_step){
		$dbh->do("UPDATE accounts SET step = ? WHERE account_id = ?",{},($current_step + 1),$sess{account_id});	
	}
	$dbh->do("UPDATE steps_account SET skipped = 1 WHERE step_id = ? AND account_id = ?",{},$current_step,$sess{account_id});

}

sub start{
	my $results = {};
	eval{
		$dbh->do("UPDATE accounts SET step = 1 WHERE account_id = ?",{},$sess{account_id});
	};
	if($@){
		croak ''.$@;
	}else{
		$results->{success} = 1;
		$results->{msg} = "Exito";
	}
	return $results;
}

sub register_project{
    my $results = {};
    my $folio = '';
    eval{
    	if($_REQUEST->{categoria} eq 'Jóvenes creadores'){
        	$folio .= 'JC-';
		}elsif($_REQUEST->{categoria} eq 'Creadores con trayectoria'){
			$folio .= 'CCT-';
		}elsif($_REQUEST->{categoria} eq 'Desarrollo artístico individual'){
			$folio .= 'DAI-';
		}elsif($_REQUEST->{categoria} eq 'Producción artística colectiva'){
			$folio .= 'PAC-';
		}
        	
    	if($_REQUEST->{disciplina} eq 'Artes visuales'){
    		$folio .= 'artes-visuales-';
		}elsif($_REQUEST->{disciplina} eq 'Danza'){
			$folio .= 'danza-';
		}elsif($_REQUEST->{disciplina} eq 'Música'){
			$folio .= 'musica-';
		}elsif($_REQUEST->{disciplina} eq 'Teatro'){
			$folio .= 'teatro-';
		}elsif($_REQUEST->{disciplina} eq 'Cine y video'){
			$folio .= 'cine-y-video-';
		}elsif($_REQUEST->{disciplina} eq 'Letras'){
			$folio .= 'letras-';
		}

        if($_REQUEST->{_submit} eq 'Guardar'){
        	
        	$dbh->do("INSERT INTO project_registry (account_id,categoria,disciplina,tipo_proyecto) VALUES(?,?,?,?)",{},$_REQUEST->{account_id},$_REQUEST->{categoria},$_REQUEST->{disciplina},$_REQUEST->{tipo_proyecto});
            my $project_id = $dbh->last_insert_id('','','project_registry','');
            $folio .= $project_id;
            $dbh->do("UPDATE project_registry SET folio = ? WHERE project_id = ?",{},$folio,$project_id);
            
            if($_REQUEST->{disciplina} eq 'Artes visuales'){
            	$dbh->do("INSERT INTO evidencia_artes_visuales (project_id) VALUES (?)",{},$project_id);
            }elsif($_REQUEST->{disciplina} eq 'Danza'){
            	$dbh->do("INSERT INTO evidencia_danza (project_id) VALUES (?)",{},$project_id);
            }elsif($_REQUEST->{disciplina} eq 'Música'){
            	$dbh->do("INSERT INTO evidencia_musica (project_id) VALUES (?)",{},$project_id);
            }elsif($_REQUEST->{disciplina} eq 'Teatro'){
 				$dbh->do("INSERT INTO evidencia_teatro (project_id) VALUES (?)",{},$project_id);           	
            }elsif($_REQUEST->{disciplina} eq 'Cine y video'){
            	$dbh->do("INSERT INTO evidencia_cine_video (project_id) VALUES (?)",{},$project_id);
            }elsif($_REQUEST->{disciplina} eq 'Letras'){
   				$dbh->do("INSERT INTO evidencia_letras (project_id) VALUES (?)",{},$project_id);         	
            }

            if($_REQUEST->{tipo_proyecto} eq 'Colectivo'){
            	my $artes_visuales = 0;
            	my $danza = 0;
            	my $musica = 0;
            	my $teatro = 0;
            	my $cine_video = 0;
            	my $letras = 0;

            	$artes_visuales = 1 if($_REQUEST->{artes_visuales});
            	$danza = 1 if($_REQUEST->{danza});
            	$musica = 1 if($_REQUEST->{musica});
            	$teatro = 1 if($_REQUEST->{teatro});
            	$cine_video = 1 if($_REQUEST->{cine_video});
            	$letras = 1 if($_REQUEST->{letras});

            	$dbh->do("INSERT INTO project_collective_disciplines (project_id,artes_visuales,danza,musica,teatro,cine_video,letras) VALUES(?,?,?,?,?,?,?)",{},$project_id,$artes_visuales,$danza,$musica,$teatro,$cine_video,$letras);
            	my $collective_id = $dbh->last_insert_id('','','project_collective_disciplines',''); 

            	my $disciplinas_colectivas = $dbh->selectrow_hashref("SELECT * FROM project_collective_disciplines WHERE colectivo_id = ?",{},$collective_id);
            	
			    if($disciplinas_colectivas->{artes_visuales}){
				 	$dbh->do("INSERT INTO evidencia_artes_visuales (project_id) VALUES (?)",{},$project_id);
           		}

				if($disciplinas_colectivas->{danza}){
				 	$dbh->do("INSERT INTO evidencia_danza (project_id) VALUES (?)",{},$project_id);
           		}

				if($disciplinas_colectivas->{musica}){
				 	$dbh->do("INSERT INTO evidencia_musica (project_id) VALUES (?)",{},$project_id);
           		}

				if($disciplinas_colectivas->{teatro}){
					$dbh->do("INSERT INTO evidencia_teatro (project_id) VALUES (?)",{},$project_id);           	
            	}

				if($disciplinas_colectivas->{cine_video}){
					$dbh->do("INSERT INTO evidencia_cine_video (project_id) VALUES (?)",{},$project_id);
            	}

				if($disciplinas_colectivas->{letras}){
					$dbh->do("INSERT INTO evidencia_letras (project_id) VALUES (?)",{},$project_id);         	
            	}

            }
            close_step(1);
        
        }elsif($_REQUEST->{_submit} eq 'Actualizar'){
        	$folio .= $_REQUEST->{project_id};

        	my $current_discipline = $dbh->selectrow_array("SELECT disciplina FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});
        	my $current_category = $dbh->selectrow_array("SELECT categoria FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});

        	$dbh->do("UPDATE project_registry SET categoria = ?, disciplina = ?, tipo_proyecto = ?, folio = ? WHERE project_id = ?",{},$_REQUEST->{categoria},$_REQUEST->{disciplina},$_REQUEST->{tipo_proyecto},$folio,$_REQUEST->{project_id});
        	$dbh->do("UPDATE steps_account SET is_completed = 0 WHERE step_id = 7 AND account_id = ?",{},$sess{account_id});

        	if($current_discipline ne $_REQUEST->{disciplina} || $current_category ne $_REQUEST->{categoria}){
	        	if($current_discipline eq 'Artes visuales'){
	            	$dbh->do("DELETE FROM evidencia_artes_visuales WHERE project_id = ?",{},$_REQUEST->{project_id});
           		}
	            if($current_discipline eq 'Danza'){
	           		$dbh->do("DELETE FROM evidencia_danza WHERE project_id = ?",{},$_REQUEST->{project_id});
           		}
	            if($current_discipline eq 'Música'){
	            	$dbh->do("DELETE FROM evidencia_musica WHERE project_id = ?",{},$_REQUEST->{project_id});
           		}
	            if($current_discipline eq 'Teatro'){
	 				$dbh->do("DELETE FROM evidencia_teatro WHERE project_id = ?",{},$_REQUEST->{project_id});
            	}
	            if($current_discipline eq 'Cine y video'){
	            	$dbh->do("DELETE FROM evidencia_cine_video WHERE project_id = ?",{},$_REQUEST->{project_id});
            	}
	            if($current_discipline eq 'Letras'){
	   				$dbh->do("DELETE FROM evidencia_letras WHERE project_id = ?",{},$_REQUEST->{project_id});
            	}

	            if($_REQUEST->{disciplina} eq 'Artes visuales'){
	            	$dbh->do("INSERT INTO evidencia_artes_visuales (project_id) VALUES (?)",{},$_REQUEST->{project_id});
	            }
	            if($_REQUEST->{disciplina} eq 'Danza'){
	            	$dbh->do("INSERT INTO evidencia_danza (project_id) VALUES (?)",{},$_REQUEST->{project_id});
	            }
	            if($_REQUEST->{disciplina} eq 'Música'){
	            	$dbh->do("INSERT INTO evidencia_musica (project_id) VALUES (?)",{},$_REQUEST->{project_id});
	            }
	            if($_REQUEST->{disciplina} eq 'Teatro'){
	 				$dbh->do("INSERT INTO evidencia_teatro (project_id) VALUES (?)",{},$_REQUEST->{project_id});           	
	            }
	            if($_REQUEST->{disciplina} eq 'Cine y video'){
	            	$dbh->do("INSERT INTO evidencia_cine_video (project_id) VALUES (?)",{},$_REQUEST->{project_id});
	            }
	            if($_REQUEST->{disciplina} eq 'Letras'){
	   				$dbh->do("INSERT INTO evidencia_letras (project_id) VALUES (?)",{},$_REQUEST->{project_id});         	
	            }
        	}

        	if($_REQUEST->{tipo_proyecto} eq 'Colectivo'){
        		my $record = $dbh->selectrow_array("SELECT COUNT(*) FROM project_collective_disciplines WHERE project_id = ?",{},$_REQUEST->{project_id});
        		if(!$record){
        			$dbh->do("INSERT INTO project_collective_disciplines (project_id) VALUES (?)",{},$_REQUEST->{project_id});
        		}

            	my $artes_visuales = 0;
            	my $danza = 0;
            	my $musica = 0;
            	my $teatro = 0;
            	my $cine_video = 0;
            	my $letras = 0;

            	$artes_visuales = 1 if($_REQUEST->{artes_visuales});
            	$danza = 1 if($_REQUEST->{danza});
            	$musica = 1 if($_REQUEST->{musica});
            	$teatro = 1 if($_REQUEST->{teatro});
            	$cine_video = 1 if($_REQUEST->{cine_video});
            	$letras = 1 if($_REQUEST->{letras});

            	$dbh->do("UPDATE project_collective_disciplines SET artes_visuales = ?,danza = ?,musica = ?,teatro = ?,cine_video = ?,letras = ? WHERE project_id = ?",{},$artes_visuales,$danza,$musica,$teatro,$cine_video,$letras,$_REQUEST->{project_id});
           
            	my $disciplinas_colectivas = $dbh->selectrow_hashref("SELECT * FROM project_collective_disciplines WHERE project_id = ?",{},$_REQUEST->{project_id});
            	
			    if($disciplinas_colectivas->{artes_visuales}){
			    	my $exists = $dbh->selectrow_array("SELECT COUNT(*) FROM evidencia_artes_visuales WHERE project_id = ?",{},$_REQUEST->{project_id});
				 	if(!$exists){
						$dbh->do("INSERT INTO evidencia_artes_visuales (project_id) VALUES (?)",{},$_REQUEST->{project_id});
				 	}
				}else{
           			$dbh->do("DELETE FROM evidencia_artes_visuales WHERE project_id = ?",{},$_REQUEST->{project_id});
           		}

				if($disciplinas_colectivas->{danza}){
			    	my $exists = $dbh->selectrow_array("SELECT COUNT(*) FROM evidencia_danza WHERE project_id = ?",{},$_REQUEST->{project_id});
				 	if(!$exists){
				 		$dbh->do("INSERT INTO evidencia_danza (project_id) VALUES (?)",{},$_REQUEST->{project_id});
				 	}
           		}else{
           			$dbh->do("DELETE FROM evidencia_danza WHERE project_id = ?",{},$_REQUEST->{project_id});
           		}

				if($disciplinas_colectivas->{musica}){
			    	my $exists = $dbh->selectrow_array("SELECT COUNT(*) FROM evidencia_musica WHERE project_id = ?",{},$_REQUEST->{project_id});
				 	if(!$exists){
						$dbh->do("INSERT INTO evidencia_musica (project_id) VALUES (?)",{},$_REQUEST->{project_id});
           			}
           		}else{
           			$dbh->do("DELETE FROM evidencia_musica WHERE project_id = ?",{},$_REQUEST->{project_id});
           		}

				if($disciplinas_colectivas->{teatro}){
			    	my $exists = $dbh->selectrow_array("SELECT COUNT(*) FROM evidencia_teatro WHERE project_id = ?",{},$_REQUEST->{project_id});
				 	if(!$exists){
						$dbh->do("INSERT INTO evidencia_teatro (project_id) VALUES (?)",{},$_REQUEST->{project_id});           	
					}
            	}else{
            		$dbh->do("DELETE FROM evidencia_teatro WHERE project_id = ?",{},$_REQUEST->{project_id});
            	}

				if($disciplinas_colectivas->{cine_video}){
					my $exists = $dbh->selectrow_array("SELECT COUNT(*) FROM evidencia_cine_video WHERE project_id = ?",{},$_REQUEST->{project_id});
				 	if(!$exists){
						$dbh->do("INSERT INTO evidencia_cine_video (project_id) VALUES (?)",{},$_REQUEST->{project_id});
            		}
            	}else{
            		$dbh->do("DELETE FROM evidencia_cine_video WHERE project_id = ?",{},$_REQUEST->{project_id});
            	}

				if($disciplinas_colectivas->{letras}){
			    	my $exists = $dbh->selectrow_array("SELECT COUNT(*) FROM evidencia_letras WHERE project_id = ?",{},$_REQUEST->{project_id});
				 	if(!$exists){
						$dbh->do("INSERT INTO evidencia_letras (project_id) VALUES (?)",{},$_REQUEST->{project_id});         	
					}
            	}else{
					$dbh->do("DELETE FROM evidencia_letras WHERE project_id = ?",{},$_REQUEST->{project_id});
            	}
           }
        }
    };
    if($@){
        msg_add('danger',$@);
        croak ''.$@
    }else{
        msg_add('success','Proyecto registrado con exito');
        $results->{redirect} = "/Form";
    }

    return $results;
}

sub project_participants{
	my $results = {};
	eval{
		if($_REQUEST->{_submit} eq 'Guardar'){
	       $dbh->do("INSERT INTO project_participants (project_id,nombres,apellido_paterno,apellido_materno,email,telefono,celular,calle,numero,numero_interior,colonia,codigo_postal,CURP,fecha_de_nacimiento,ciudad,estado,nacionalidad,grado_de_estudios,representante_de_equipo) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,0)",{},
	       $_REQUEST->{project_id},$_REQUEST->{nombres},$_REQUEST->{apellido_paterno},$_REQUEST->{apellido_materno},$_REQUEST->{email},$_REQUEST->{telefono},$_REQUEST->{celular},$_REQUEST->{calle},$_REQUEST->{numero},$_REQUEST->{numero_interior},$_REQUEST->{colonia},$_REQUEST->{codigo_postal},$_REQUEST->{curp},$_REQUEST->{fecha_de_nacimiento},$_REQUEST->{ciudad},$_REQUEST->{estado},$_REQUEST->{nacionalidad},$_REQUEST->{grado_de_estudios});		
	       my $participant_id = $dbh->last_insert_id('','','project_participants','');
           $dbh->do("INSERT INTO project_participants_documents (participant_id,project_id) VALUES (?,?)",{},$participant_id,$_REQUEST->{project_id});
           close_step(2);
        }elsif($_REQUEST->{_submit} eq 'Agregar'){
            $dbh->do("INSERT INTO project_participants (project_id,nombres,apellido_paterno,apellido_materno,email,telefono,celular,direccion_actual,CURP,fecha_de_nacimiento,lugar_de_nacimiento,nacionalidad,grado_de_estudios,representante_de_equipo) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,0)",{},
            $_REQUEST->{project_id},$_REQUEST->{nombres},$_REQUEST->{apellido_paterno},$_REQUEST->{apellido_materno},$_REQUEST->{email},$_REQUEST->{telefono},$_REQUEST->{celular},$_REQUEST->{direccion_actual},$_REQUEST->{curp},$_REQUEST->{fecha_de_nacimiento},$_REQUEST->{lugar_de_nacimiento},$_REQUEST->{nacionalidad},$_REQUEST->{grado_de_estudios});     
            my $participant_id = $dbh->last_insert_id('','','project_participants','');
            $dbh->do("INSERT INTO project_participants_documents (participant_id,project_id) VALUES (?,?)",{},$participant_id,$_REQUEST->{project_id});
        }elsif($_REQUEST->{_submit} eq 'Finalizar' || $_REQUEST->{_submit} eq 'Finalizar Colectivo'){
            close_step(2);
        }elsif($_REQUEST->{_submit} eq 'Actualizar'){
        	$dbh->do("UPDATE project_participants SET nombres = ?, apellido_paterno = ?, apellido_materno = ?, email = ?, telefono = ?, celular = ?, calle = ?, numero = ?, numero_interior = ?, colonia = ?, codigo_postal = ?, CURP = ?, fecha_de_nacimiento = ?, ciudad = ?, estado = ?, nacionalidad = ?, grado_de_estudios = ?, representante_de_equipo = 0 WHERE participant_id = ?",{},$_REQUEST->{nombres},$_REQUEST->{apellido_paterno},$_REQUEST->{apellido_materno},$_REQUEST->{email},$_REQUEST->{telefono},$_REQUEST->{celular},$_REQUEST->{calle},$_REQUEST->{numero},$_REQUEST->{numero_interior},$_REQUEST->{colonia},$_REQUEST->{codigo_postal},$_REQUEST->{curp},$_REQUEST->{fecha_de_nacimiento},$_REQUEST->{ciudad},$_REQUEST->{estado},$_REQUEST->{nacionalidad},$_REQUEST->{grado_de_estudios},$_REQUEST->{participant_id});
		}
	};
	if($@){
        msg_add('danger',$@);
        croak ''.$@
    }else{
        msg_add('success','Participantes registrados con exito');
        $results->{redirect} = "/Form";
    }
    return $results;
}

#NUEVO MODULO
sub project_attachments_continue{
	my $results = {};
	eval{
		close_step(3);
	};
	if($@){
		msg_add('danger',$@);
	}else{
		msg_add('success','Documentacion agregada con exito');
        $results->{redirect} = "/Form";
	}
}
#EN ESTA POSICION

sub project_participants_docs{
    my $results = {};
    eval{
    	if($_REQUEST->{_submit} eq 'Cargar'){
    		my $route = 'participantes/'.$_REQUEST->{project_id}.'_'.$_REQUEST->{documents_id};
	    	if(!(-e $route)){
	    		mkdir($route);
	    	}

	    	my $carta_solicitud = Chapix::Com::upload_file('carta_solicitud',$route);
	    	my $acta_de_nacimiento = Chapix::Com::upload_file('acta_de_nacimiento',$route);
	    	my $comprobante_de_domicilio = Chapix::Com::upload_file('comprobante_de_domicilio',$route);
	    	my $identificacion_oficial = Chapix::Com::upload_file('identificacion_oficial',$route);
	    	my $curp = Chapix::Com::upload_file('curp',$route);
	    	my $curriculum = Chapix::Com::upload_file('curriculum',$route);
	    	my $carta_compromiso = Chapix::Com::upload_file('carta_compromiso',$route);
	    	my $boleta_kardex = Chapix::Com::upload_file('boleta_kardex',$route);
	    	my $carta_asignacion = Chapix::Com::upload_file('carta_asignacion',$route);

	    	$dbh->do("UPDATE project_participants_documents SET carta_solicitud = ? WHERE documents_id = ?",{},$carta_solicitud,$_REQUEST->{documents_id}) if($carta_solicitud);
	    	$dbh->do("UPDATE project_participants_documents SET acta_de_nacimiento = ? WHERE documents_id = ?",{},$acta_de_nacimiento,$_REQUEST->{documents_id}) if($acta_de_nacimiento);
	    	$dbh->do("UPDATE project_participants_documents SET comprobante_de_domicilio = ? WHERE documents_id = ?",{},$comprobante_de_domicilio,$_REQUEST->{documents_id}) if($comprobante_de_domicilio);
	    	$dbh->do("UPDATE project_participants_documents SET identificacion_oficial = ? WHERE documents_id = ?",{},$identificacion_oficial,$_REQUEST->{documents_id}) if($identificacion_oficial);
	    	$dbh->do("UPDATE project_participants_documents SET curp = ? WHERE documents_id = ?",{},$curp,$_REQUEST->{documents_id}) if($curp);
	    	$dbh->do("UPDATE project_participants_documents SET curriculum = ? WHERE documents_id = ?",{},$curriculum,$_REQUEST->{documents_id}) if($curriculum);
	    	$dbh->do("UPDATE project_participants_documents SET carta_compromiso = ? WHERE documents_id = ?",{},$carta_compromiso,$_REQUEST->{documents_id}) if($carta_compromiso);
	    	$dbh->do("UPDATE project_participants_documents SET boleta_kardex = ? WHERE documents_id = ?",{},$boleta_kardex,$_REQUEST->{documents_id}) if($boleta_kardex);
	    	$dbh->do("UPDATE project_participants_documents SET carta_asignacion = ? WHERE documents_id = ?",{},$carta_asignacion,$_REQUEST->{documents_id}) if($carta_asignacion);

	    	my $docs = $dbh->selectrow_hashref("SELECT * FROM project_participants_documents WHERE documents_id = ?",{},$_REQUEST->{documents_id});
			my $project_info = $dbh->selectrow_hashref("SELECT categoria,tipo_proyecto FROM project_registry WHERE project_id = ?",{},$docs->{project_id});
	    	my $uploaded_qty = 0;
	    	my $marked_as_done = 0;

	    	if($docs->{carta_solicitud}){
	    		$uploaded_qty++;
	    	}

	    	if($docs->{acta_de_nacimiento}){
	    		$uploaded_qty++;
	    	}

	    	if($docs->{comprobante_de_domicilio}){
	    		$uploaded_qty++;
	    	}

	    	if($docs->{identificacion_oficial}){
	    		$uploaded_qty++;
	    	}

	    	if($docs->{CURP}){
	    		$uploaded_qty++;
	    	}

	    	if($docs->{curriculum}){
	    		$uploaded_qty++;
	    	}

	    	if($docs->{carta_compromiso}){
				$uploaded_qty++;
	    	}


	    	if($project_info->{tipo_proyecto} eq 'Colectivo'){	
	    		if($docs->{carta_asignacion}){
					$uploaded_qty++;
	    		}
	    		if($uploaded_qty eq 8){
					$marked_as_done = 1;
				}
	    	}
	    	#elsif($project_info->{categoria} eq 'Desarrollo artístico individual'){
	    	#	if($docs->{boleta_kardex}){
			#		$uploaded_qty++;
	    	#	}
	    	#	if($uploaded_qty eq 8){
			#		$marked_as_done = 1;
			#	}
    		#}
    		else{
    			if($uploaded_qty eq 7){
					$marked_as_done = 1;
				}
    		}

    		if($marked_as_done){
    			$dbh->do("UPDATE project_participants_documents SET uploaded = 1 WHERE documents_id = ?",{},$_REQUEST->{documents_id});	
    			close_step(4);
    		}

    	}elsif($_REQUEST->{_submit} eq 'Finalizar'){
    		close_step(4);
    	}elsif($_REQUEST->{_submit} eq 'Continuar'){
    		skip_step(4);
    	}
    	
    };
    if($@){
        msg_add('danger',$@);
    }else{
        msg_add('success','Documentacion agregada con exito');
        $results->{redirect} = "/Form";
    }
    return $results;
}

sub project_general_information{
    my $results = {};
    my $route = 'financiamiento_cronograma/'.$_REQUEST->{project_id};
	    	
    eval{
        if($_REQUEST->{_submit} eq 'Guardar'){
        	my $proyecto_documentos = Chapix::Com::upload_file('proyecto_documentos',$route);

        	my $exists = $dbh->selectrow_array("SELECT COUNT(*) FROM project_information WHERE project_id = ?",{},$_REQUEST->{project_id});
        	if(!$exists){
        		$dbh->do("INSERT INTO project_information (project_id) VALUES (?)",{},$_REQUEST->{project_id});
        	}

        	$dbh->do("UPDATE project_information SET nombre = ? WHERE project_id = ?",{},$_REQUEST->{nombre},$_REQUEST->{project_id}) if($_REQUEST->{nombre});
        	$dbh->do("UPDATE project_information SET descripcion = ? WHERE project_id = ?",{},$_REQUEST->{descripcion},$_REQUEST->{project_id}) if($_REQUEST->{descripcion});
			$dbh->do("UPDATE project_information SET antecedentes = ? WHERE project_id = ?",{},$_REQUEST->{antecedentes},$_REQUEST->{project_id}) if($_REQUEST->{antecedentes});
			$dbh->do("UPDATE project_information SET justificacion = ? WHERE project_id = ?",{},$_REQUEST->{justificacion},$_REQUEST->{project_id}) if($_REQUEST->{justificacion});
			$dbh->do("UPDATE project_information SET objetivo_general = ? WHERE project_id = ?",{},$_REQUEST->{objetivo_general},$_REQUEST->{project_id}) if($_REQUEST->{objetivo_general});
			$dbh->do("UPDATE project_information SET objetivos_especificos = ? WHERE project_id = ?",{},$_REQUEST->{objetivos_especificos},$_REQUEST->{project_id}) if($_REQUEST->{objetivos_especificos});
			$dbh->do("UPDATE project_information SET metas = ? WHERE project_id = ?",{},$_REQUEST->{metas},$_REQUEST->{project_id}) if($_REQUEST->{metas});
			$dbh->do("UPDATE project_information SET beneficiarios = ? WHERE project_id = ?",{},$_REQUEST->{beneficiarios},$_REQUEST->{project_id}) if($_REQUEST->{beneficiarios});
			$dbh->do("UPDATE project_information SET contexto = ? WHERE project_id = ?",{},$_REQUEST->{contexto},$_REQUEST->{project_id}) if($_REQUEST->{contexto});
			$dbh->do("UPDATE project_information SET bibliografia = ? WHERE project_id = ?",{},$_REQUEST->{bibliografia},$_REQUEST->{project_id}) if($_REQUEST->{bibliografia});
			$dbh->do("UPDATE project_information SET proyecto_documentos = ? WHERE project_id = ?",{},$proyecto_documentos,$_REQUEST->{project_id}) if($proyecto_documentos);

        	#$dbh->do("INSERT INTO project_information (project_id,nombre,descripcion,antecedentes,justificacion,objetivo_general,objetivos_especificos,metas,beneficiarios,contexto,bibliografia) VALUES(?,?,?,?,?,?,?,?,?,?,?)",{},
        	#	$_REQUEST->{project_id},$_REQUEST->{nombre},$_REQUEST->{descripcion},$_REQUEST->{antecedentes},$_REQUEST->{justificacion},$_REQUEST->{objetivo_general},$_REQUEST->{objetivos_especificos},$_REQUEST->{metas},$_REQUEST->{beneficiarios},$_REQUEST->{contexto},$_REQUEST->{bibliografia});
        	#my $last_key = $dbh->last_insert_id('','','project_information','');

        	if(is_project_information_complete()){
        		close_step(5);	
        	}else{
        		skip_step(5);
        	}
        	
        }elsif($_REQUEST->{_submit} eq 'Actualizar'){
        	my $proyecto_documentos = Chapix::Com::upload_file('proyecto_documentos',$route);

        	$dbh->do("UPDATE project_information SET nombre = ? WHERE project_id = ?",{},$_REQUEST->{nombre},$_REQUEST->{project_id}) if($_REQUEST->{nombre});
        	$dbh->do("UPDATE project_information SET descripcion = ? WHERE project_id = ?",{},$_REQUEST->{descripcion},$_REQUEST->{project_id}) if($_REQUEST->{descripcion});
			$dbh->do("UPDATE project_information SET antecedentes = ? WHERE project_id = ?",{},$_REQUEST->{antecedentes},$_REQUEST->{project_id}) if($_REQUEST->{antecedentes});
			$dbh->do("UPDATE project_information SET justificacion = ? WHERE project_id = ?",{},$_REQUEST->{justificacion},$_REQUEST->{project_id}) if($_REQUEST->{justificacion});
			$dbh->do("UPDATE project_information SET objetivo_general = ? WHERE project_id = ?",{},$_REQUEST->{objetivo_general},$_REQUEST->{project_id}) if($_REQUEST->{objetivo_general});
			$dbh->do("UPDATE project_information SET objetivos_especificos = ? WHERE project_id = ?",{},$_REQUEST->{objetivos_especificos},$_REQUEST->{project_id}) if($_REQUEST->{objetivos_especificos});
			$dbh->do("UPDATE project_information SET metas = ? WHERE project_id = ?",{},$_REQUEST->{metas},$_REQUEST->{project_id}) if($_REQUEST->{metas});
			$dbh->do("UPDATE project_information SET beneficiarios = ? WHERE project_id = ?",{},$_REQUEST->{beneficiarios},$_REQUEST->{project_id}) if($_REQUEST->{beneficiarios});
			$dbh->do("UPDATE project_information SET contexto = ? WHERE project_id = ?",{},$_REQUEST->{contexto},$_REQUEST->{project_id}) if($_REQUEST->{contexto});
			$dbh->do("UPDATE project_information SET bibliografia = ? WHERE project_id = ?",{},$_REQUEST->{bibliografia},$_REQUEST->{project_id}) if($_REQUEST->{bibliografia});
			$dbh->do("UPDATE project_information SET proyecto_documentos = ? WHERE project_id = ?",{},$proyecto_documentos,$_REQUEST->{project_id}) if($proyecto_documentos);

        }elsif($_REQUEST->{_submit} eq 'Continuar'){
        	skip_step(5);
        }
    };

    if($@){
        msg_add('danger',$@);
        croak ''.$@;
    }else{
        msg_add('success',"La información general del proyecto se guardo con exito");
        $results->{redirect} = "/Form";
    }

    return $results;
}

sub is_project_information_complete{
	my $project_information = $dbh->selectrow_hashref("SELECT * FROM project_information WHERE project_id = ?",{},$_REQUEST->{project_id});
	my $is_complete = 1;

	if(!$project_information->{nombre}){
		$is_complete = 0;
	}

	if(!$project_information->{descripcion}){
		$is_complete = 0;
	}

	if(!$project_information->{antecedentes}){
		$is_complete = 0;
	}

	if(!$project_information->{justificacion}){
		$is_complete = 0;
	}

	if(!$project_information->{objetivo_general}){
		$is_complete = 0;
	}

	if(!$project_information->{objetivos_especificos}){
		$is_complete = 0;
	}

	if(!$project_information->{metas}){
		$is_complete = 0;
	}

	if(!$project_information->{beneficiarios}){
		$is_complete = 0;
	}

	if(!$project_information->{contexto}){
		$is_complete = 0;
	}

	if(!$project_information->{proyecto_documentos}){
		$is_complete = 0;
	}

	return $is_complete;
}

sub project_retribution{
    my $results = {};
    my $route = 'retribucion/'.$_REQUEST->{project_id};
    eval{
        if($_REQUEST->{_submit} eq 'Guardar'){
        	#my $disciplina = $dbh->selectrow_array('SELECT disciplina FROM project_registry WHERE project_id = ?',{},$_REQUEST->{project_id});
            my $exists = $dbh->selectrow_array("SELECT COUNT(*) FROM project_retribution WHERE project_id = ?",{},$_REQUEST->{project_id});
            if(!$exists){
            	$dbh->do("INSERT INTO project_retribution (project_id) VALUES (?)",{},$_REQUEST->{project_id});
            }

            $dbh->do("UPDATE project_retribution SET modalidad = ? WHERE project_id = ?",{},$_REQUEST->{modalidad},$_REQUEST->{project_id}) if($_REQUEST->{modalidad});
			$dbh->do("UPDATE project_retribution SET actividad_a_realizar = ? WHERE project_id = ?",{},$_REQUEST->{actividad_a_realizar},$_REQUEST->{project_id}) if($_REQUEST->{actividad_a_realizar});
            $dbh->do("UPDATE project_retribution SET descripcion_actividad = ? WHERE project_id = ?",{},$_REQUEST->{descripcion_actividad},$_REQUEST->{project_id}) if($_REQUEST->{descripcion_actividad});
            $dbh->do("UPDATE project_retribution SET numero_contribuciones = ? WHERE project_id = ?",{},$_REQUEST->{numero_contribuciones},$_REQUEST->{project_id}) if($_REQUEST->{numero_contribuciones});


            #$dbh->do("INSERT INTO project_retribution (project_id,modalidad,actividad_a_realizar,descripcion_actividad,numero_contribuciones) VALUES (?,?,?,?,?)",{},
            #	$_REQUEST->{project_id},$_REQUEST->{modalidad},$_REQUEST->{actividad_a_realizar},$_REQUEST->{descripcion_actividad},$_REQUEST->{numero_contribuciones});
            
   			if(is_project_retribution_complete()){
   				close_step(6);
   			}else{
   				skip_step(6);
   			}
        }elsif($_REQUEST->{_submit} eq 'Actualizar'){
                $dbh->do("UPDATE project_retribution SET modalidad = ? WHERE project_id = ?",{},$_REQUEST->{modalidad},$_REQUEST->{project_id}) if($_REQUEST->{modalidad});
				$dbh->do("UPDATE project_retribution SET actividad_a_realizar = ? WHERE project_id = ?",{},$_REQUEST->{actividad_a_realizar},$_REQUEST->{project_id}) if($_REQUEST->{actividad_a_realizar});
            	$dbh->do("UPDATE project_retribution SET descripcion_actividad = ? WHERE project_id = ?",{},$_REQUEST->{descripcion_actividad},$_REQUEST->{project_id}) if($_REQUEST->{descripcion_actividad});
            	$dbh->do("UPDATE project_retribution SET numero_contribuciones = ? WHERE project_id = ?",{},$_REQUEST->{numero_contribuciones},$_REQUEST->{project_id}) if($_REQUEST->{numero_contribuciones});
		}elsif($_REQUEST->{_submit} eq 'Continuar'){
    		skip_step(6);
    	}

    };

    if($@){
        msg_add('danger', $@);
        #croak ''.$@;
    }else{
        msg_add('success',"Propuestas guardadas");
        $results->{redirect} = "/Form";
        #croak 'success';
    }
    return $results;
}

sub is_project_retribution_complete{
	my $project_retribution = $dbh->selectrow_hashref("SELECT * FROM project_retribution WHERE project_id = ?",{},$_REQUEST->{project_id});
	my $is_complete = 1;

	if(!$project_retribution->{modalidad}){
		$is_complete = 0;
	}

	if(!$project_retribution->{actividad_a_realizar}){
		$is_complete = 0;	
	}

	if(!$project_retribution->{descripcion_actividad}){
		$is_complete = 0;
	}

	if(!$project_retribution->{numero_contribuciones}){
		$is_complete = 0;
	}

	return $is_complete;
}

sub check_collective_evidences_upload{
	my $disciplines = $dbh->selectrow_hashref("SELECT * FROM project_collective_disciplines WHERE project_id = ?",{},$_REQUEST->{project_id});
	my $marked_as_done = 0;
	my $active_disciplines_qty = 0;
	my $uploaded_evidence_qty = 0;
	my $uploaded;

	if($disciplines->{artes_visuales}){
		$active_disciplines_qty++;
	}

	if($disciplines->{danza}){
		$active_disciplines_qty++;
	}

	if($disciplines->{musica}){
		$active_disciplines_qty++;
	}

	if($disciplines->{teatro}){
		$active_disciplines_qty++;
	}

	if($disciplines->{cine_video}){
		$active_disciplines_qty++;
	}

	if($disciplines->{letras}){
		$active_disciplines_qty++;
	}

	$uploaded = $dbh->selectrow_array("SELECT uploaded FROM evidencia_artes_visuales WHERE project_id = ?",{},$_REQUEST->{project_id});
	if($uploaded){
		$uploaded_evidence_qty++;
	}

	$uploaded = $dbh->selectrow_array("SELECT uploaded FROM evidencia_danza WHERE project_id = ?",{},$_REQUEST->{project_id});
	if($uploaded){
		$uploaded_evidence_qty++;
	}

	$uploaded = $dbh->selectrow_array("SELECT uploaded FROM evidencia_musica WHERE project_id = ?",{},$_REQUEST->{project_id});
	if($uploaded){
		$uploaded_evidence_qty++;
	}

	$uploaded = $dbh->selectrow_array("SELECT uploaded FROM evidencia_teatro WHERE project_id = ?",{},$_REQUEST->{project_id});
	if($uploaded){
		$uploaded_evidence_qty++;
	}

	$uploaded = $dbh->selectrow_array("SELECT uploaded FROM evidencia_cine_video WHERE project_id = ?",{},$_REQUEST->{project_id});
	if($uploaded){
		$uploaded_evidence_qty++;
	}

	$uploaded = $dbh->selectrow_array("SELECT uploaded FROM evidencia_letras WHERE project_id = ?",{},$_REQUEST->{project_id});
	if($uploaded){
		$uploaded_evidence_qty++;
	}


	if($active_disciplines_qty eq $uploaded_evidence_qty){
		$marked_as_done = 1;
	}

	return $marked_as_done;
}

sub evidencias_artes_visuales{
	my $results = {};
	eval{
		my $route = 'test/artes_visuales_'.$_REQUEST->{project_id};
		if(!(-d 'data/'.$route)){
	    	make_path('data/'.$route);
	    }
		my $tipo_proyecto = $dbh->selectrow_array("SELECT tipo_proyecto FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});
		my $kardex;
		my $carta_aceptacion;
		if($_REQUEST->{_type} eq 'imagenes'){
			$route .= '/img';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}
	    	
			my $current_count = $dbh->selectrow_array('SELECT imagenes FROM evidencia_artes_visuales WHERE project_id = ?',{},$_REQUEST->{project_id});
			#subir_imagenes
			my $image = Chapix::Com::upload_file('file', $route);
			$dbh->do('UPDATE evidencia_artes_visuales SET imagenes = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($image);
		}elsif($_REQUEST->{_type} eq 'documentos'){
			$route .= '/docs';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}
	    	
			my $current_count = $dbh->selectrow_array('SELECT documentos FROM evidencia_artes_visuales WHERE project_id = ?',{},$_REQUEST->{project_id});
			#subir documentos
			my $doc = Chapix::Com::upload_file('file', $route);
			$dbh->do('UPDATE evidencia_artes_visuales SET documentos = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($doc);
		}elsif($_REQUEST->{_type} eq 'notas'){
			$route .= '/notes';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}
	    	
			my $current_count = $dbh->selectrow_array('SELECT notas FROM evidencia_artes_visuales WHERE project_id = ?',{},$_REQUEST->{project_id});
			#subir documentos
			my $note = Chapix::Com::upload_file('file', $route);
			$dbh->do('UPDATE evidencia_artes_visuales SET notas = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($note);
		}elsif($_REQUEST->{_type} eq 'catalogo'){
			$route .= '/catalogo';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}
			my $current_count = $dbh->selectrow_array('SELECT catalogo FROM evidencia_artes_visuales WHERE project_id = ?',{},$_REQUEST->{project_id});
			#subir documentos
			my $catalog = Chapix::Com::upload_file('file', $route);
			$dbh->do('UPDATE evidencia_artes_visuales SET catalogo = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($catalog);
		}elsif($_REQUEST->{_type} eq '_guardar'){
			#fin del proceso

			if($_REQUEST->{categoria} eq 'Desarrollo artístico individual'){
				$kardex = Chapix::Com::upload_file('boleta_kardex',$route);
				$carta_aceptacion = Chapix::Com::upload_file('carta_aceptacion',$route);
				
				$dbh->do('UPDATE evidencia_artes_visuales SET boleta_kardex = ?  WHERE project_id = ?',{},$kardex,$_REQUEST->{project_id}) if($kardex);
				$dbh->do('UPDATE evidencia_artes_visuales SET carta_aceptacion = ? WHERE project_id = ?',{},$carta_aceptacion,$_REQUEST->{project_id}) if($carta_aceptacion);
			}

			if(check_artes_visuales()){
				$dbh->do('UPDATE evidencia_artes_visuales SET uploaded = 1 WHERE project_id = ?',{},$_REQUEST->{project_id});	
			}
			
			if($tipo_proyecto eq 'Colectivo' and check_collective_evidences_upload()){
				close_step(7);	
			}elsif($tipo_proyecto ne 'Colectivo' and check_artes_visuales()){
				close_step(7);
			}
		}
	};
	if($@){
		croak ''.$@;
	}else{
		$results->{success} = 1;
		$results->{msg} = 'Proceso exitoso';
	}

	return $results;
}

sub check_artes_visuales{
	my $categoria = $dbh->selectrow_array("SELECT categoria FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});

	my $images = {};
	my $notes = {};
	my $catalog = {};
	my $documents = {};

	my $completed = 1;

	my $artes_visuales_evidencias = $dbh->selectrow_hashref("SELECT * FROM evidencia_artes_visuales WHERE project_id = ?",{},$_REQUEST->{project_id});

	if($categoria eq 'Jóvenes creadores'){
        $images->{min} = 5; $images->{max} = 5;
        $notes->{min} = 0; $notes->{max} = 3;
        $catalog->{min} = 0; $catalog->{max} = 1;
        $documents->{min} = 0; $documents->{max} = 3;
    }elsif($categoria eq 'Creadores con trayectoria'){
        $images->{min} = 10; $images->{max} = 10;
        $notes->{min} = 2; $notes->{max} = 2;
        $catalog->{min} = 2; $catalog->{max} = 2;
        $documents->{min} = 2; $documents->{max} = 2;
    }elsif($categoria eq 'Desarrollo artístico individual'){
        $images->{min} = 10; $images->{max} = 10;
        $notes->{min} = 3; $notes->{max} = 3;
        $catalog->{min} = 2; $catalog->{max} = 2;
        $documents->{min} = 3; $documents->{max} = 3;
       
    }elsif($categoria eq 'Producción artística colectiva'){
        $images->{min} = 10; $images->{max} = 10;
        $notes->{min} = 2; $notes->{max} = 2;
        $catalog->{min} = 2; $catalog->{max} = 2;
        $documents->{min} = 2; $documents->{max} = 2;
    }


    if(!($artes_visuales_evidencias->{imagenes} >= $images->{min} && $artes_visuales_evidencias->{imagenes} <= $images->{max})){
    	$completed = 0;
    }

    if(!($artes_visuales_evidencias->{notas} >= $notes->{min} && $artes_visuales_evidencias->{notas} <= $notes->{max})){
    	$completed = 0;
    }

	if(!($artes_visuales_evidencias->{catalogo} >= $catalog->{min} && $artes_visuales_evidencias->{catalogo} <= $catalog->{max})){
    	$completed = 0;
    }

	if(!($artes_visuales_evidencias->{documentos} >= $documents->{min} && $artes_visuales_evidencias->{catalogo} <= $documents->{max})){
    	$completed = 0;
    }

    if($categoria eq 'Desarrollo artístico individual'){
    	if(!$artes_visuales_evidencias->{boleta_kardex}){
    		$completed = 0;
    	}

    	if(!$artes_visuales_evidencias->{carta_aceptacion}){
    		$completed = 0;
    	}
    }

    return $completed;        
}

sub evidencias_danza{
	my $results = {};
	eval{
		my $route = 'test/danza_'.$_REQUEST->{project_id};
		if(!(-d 'data/'.$route)){
	    	make_path('data/'.$route);
	    }

		my $tipo_proyecto = $dbh->selectrow_array("SELECT tipo_proyecto FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});
		my $kardex;
		my $carta_aceptacion;
		
		if($_REQUEST->{_type} eq 'imagenes'){
			$route .= '/img';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}

			my $current_count = $dbh->selectrow_array('SELECT imagenes FROM evidencia_danza WHERE project_id = ?',{},$_REQUEST->{project_id});
			#subir_imagenes
			my $image = Chapix::Com::upload_file('file', $route);
			$dbh->do('UPDATE evidencia_danza SET imagenes = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($image);
		}elsif($_REQUEST->{_type} eq 'documentos'){
			$route .= '/docs';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}
	    	
			my $current_count = $dbh->selectrow_array('SELECT documentos FROM evidencia_danza WHERE project_id = ?',{},$_REQUEST->{project_id});
			#subir documentos
			my $doc = Chapix::Com::upload_file('file', $route);
			$dbh->do('UPDATE evidencia_danza SET documentos = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($doc);
		}elsif($_REQUEST->{_type} eq 'notas'){
            $route .= '/notes';
            
            if(!(-d 'data/'.$route)){
                make_path('data/'.$route);
            }
            
            my $current_count = $dbh->selectrow_array('SELECT notas FROM evidencia_danza WHERE project_id = ?',{},$_REQUEST->{project_id});
            #subir documentos
            my $note = Chapix::Com::upload_file('file', $route);
            $dbh->do('UPDATE evidencia_danza SET notas = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($note);
        }elsif($_REQUEST->{_type} eq '_guardar'){
			$dbh->do('UPDATE evidencia_danza SET videomuestra = ?, sitioweb = ? WHERE project_id = ?',{},$_REQUEST->{video_link},$_REQUEST->{sitioweb_link},$_REQUEST->{project_id});
			
			if($_REQUEST->{categoria} eq 'Desarrollo artístico individual'){
				$kardex = Chapix::Com::upload_file('boleta_kardex',$route);
				$carta_aceptacion = Chapix::Com::upload_file('carta_aceptacion',$route);
				
				$dbh->do('UPDATE evidencia_danza SET boleta_kardex = ?  WHERE project_id = ?',{},$kardex,$_REQUEST->{project_id}) if($kardex);
				$dbh->do('UPDATE evidencia_danza SET carta_aceptacion = ? WHERE project_id = ?',{},$carta_aceptacion,$_REQUEST->{project_id}) if($carta_aceptacion);
			}

			if(check_danza()){
				$dbh->do('UPDATE evidencia_danza SET uploaded = 1 WHERE project_id = ?',{},$_REQUEST->{project_id});
			}

			if($tipo_proyecto eq 'Colectivo' and check_collective_evidences_upload()){
				close_step(7);	
			}elsif($tipo_proyecto ne 'Colectivo' and check_danza()){
				close_step(7);
			}
		}
	};
	if($@){
		croak ''.$@;
	}else{
		$results->{success} = 1;
		$results->{msg} = 'Proceso exitoso';
	}

	return $results;
}

sub check_danza{
	my $categoria = $dbh->selectrow_array("SELECT categoria FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});

 	my $images = {};
    my $notes = {};
    my $documents = {};
    my $sitio = {};
    
    my $completed = 1;

	my $danza_evidencias = $dbh->selectrow_hashref("SELECT * FROM evidencia_danza WHERE project_id = ?",{},$_REQUEST->{project_id});

    if($categoria eq 'Jóvenes creadores'){
        $images->{min} = 5; $images->{max} = 5;
    	$documents->{min} = 0; $documents->{max} = 3;
    	
    	$sitio->{optional} = 1;
    }elsif($categoria eq 'Creadores con trayectoria'){
        $images->{min} = 8; $images->{max} = 8;
    	$notes->{min} = 2; $notes->{max} = 2;
 		$documents->{min} = 2; $documents->{max} = 2;

    }elsif($categoria eq 'Desarrollo artístico individual'){
        $images->{min} = 8; $images->{max} = 8;
    	$notes->{min} = 3; $notes->{max} = 3;
        $documents->{min} = 3; $documents->{max} = 3;
    
    }elsif($categoria eq 'Producción artística colectiva'){
        $images->{min} = 8; $images->{max} = 8;
    	$notes->{min} = 2; $notes->{max} = 2;
        $documents->{min} = 2; $documents->{max} = 2;
    
    }

    if(!$sitio->{optional} and !$danza_evidencias->{sitioweb}){
    	$completed = 0;
    }

    if(!$danza_evidencias->{videomuestra}){
    	$completed = 0;
    }

    if(!($danza_evidencias->{imagenes} >= $images->{min} && $danza_evidencias->{imagenes} <= $images->{max})){
    	$completed = 0;
    }

    if(!($danza_evidencias->{notas} >= $notes->{min} && $danza_evidencias->{notas} <= $notes->{max})){
    	$completed = 0;
    }

	if(!($danza_evidencias->{documentos} >= $documents->{min} && $danza_evidencias->{catalogo} <= $documents->{max})){
    	$completed = 0;
    }

    if($categoria eq 'Desarrollo artístico individual'){
    	if(!$danza_evidencias->{boleta_kardex}){
    		$completed = 0;
    	}

    	if(!$danza_evidencias->{carta_aceptacion}){
    		$completed = 0;
    	}
    }

    return $completed;
}

sub evidencias_musica{
	my $results = {};
	eval{
		my $route = 'test/musica_'.$_REQUEST->{project_id};
		if(!(-d 'data/'.$route)){
	    	make_path('data/'.$route);
	    }

		my $tipo_proyecto = $dbh->selectrow_array("SELECT tipo_proyecto FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});
		my $kardex;
		my $carta_aceptacion;

		if($_REQUEST->{_type} eq 'imagenes'){
			$route .= '/img';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}

			my $current_count = $dbh->selectrow_array('SELECT imagenes FROM evidencia_musica WHERE project_id = ?',{},$_REQUEST->{project_id});
			#subir_imagenes
			my $image = Chapix::Com::upload_file('file', $route);
			$dbh->do('UPDATE evidencia_musica SET imagenes = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($image);
		}elsif($_REQUEST->{_type} eq 'documentos'){
			$route .= '/docs';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}

			my $current_count = $dbh->selectrow_array('SELECT documentos FROM evidencia_musica WHERE project_id = ?',{},$_REQUEST->{project_id});
			#subir documentos
			my $doc = Chapix::Com::upload_file('file', $route);
			$dbh->do('UPDATE evidencia_musica SET documentos = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($doc);
		}elsif($_REQUEST->{_type} eq 'partituras'){
			$route .= '/partituras';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}

	    	my $partitura = Chapix::Com::upload_file('file',$route);
			my $current_count = $dbh->selectrow_array('SELECT partituras FROM evidencia_musica WHERE project_id = ?',{},$_REQUEST->{project_id}) if($partitura);
			#subir documentos
			$dbh->do('UPDATE evidencia_musica SET partituras = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id});
		}elsif($_REQUEST->{_type} eq 'grabacion'){
			$route .= '/grabaciones';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}

	    	my $grabacion = Chapix::Com::upload_file('file',$route);
			my $current_count = $dbh->selectrow_array('SELECT grabacion FROM evidencia_musica WHERE project_id = ?',{},$_REQUEST->{project_id}) if($grabacion);
			#subir documentos
			$dbh->do('UPDATE evidencia_musica SET grabacion = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id});
		}elsif($_REQUEST->{_type} eq 'notas'){
            $route .= '/notes';
            
            if(!(-d 'data/'.$route)){
                make_path('data/'.$route);
            }
            
            my $current_count = $dbh->selectrow_array('SELECT notas FROM evidencia_musica WHERE project_id = ?',{},$_REQUEST->{project_id});
            #subir documentos
            my $note = Chapix::Com::upload_file('file', $route);
            $dbh->do('UPDATE evidencia_musica SET notas = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($note);
        }elsif($_REQUEST->{_type} eq '_guardar'){
			$dbh->do('UPDATE evidencia_musica SET videomuestra = ?, sitioweb = ?, audiomuestra = ? WHERE project_id = ?',{},$_REQUEST->{video_link},$_REQUEST->{sitioweb_link},$_REQUEST->{audiomuestra},$_REQUEST->{project_id});
			
			if($_REQUEST->{categoria} eq 'Desarrollo artístico individual'){
				$kardex = Chapix::Com::upload_file('boleta_kardex',$route);
				$carta_aceptacion = Chapix::Com::upload_file('carta_aceptacion',$route);
				
				$dbh->do('UPDATE evidencia_musica SET boleta_kardex = ?  WHERE project_id = ?',{},$kardex,$_REQUEST->{project_id}) if($kardex);
				$dbh->do('UPDATE evidencia_musica SET carta_aceptacion = ? WHERE project_id = ?',{},$carta_aceptacion,$_REQUEST->{project_id}) if($carta_aceptacion);
			}

			if(check_musica()){
				$dbh->do('UPDATE evidencia_musica SET uploaded = 1 WHERE project_id = ?',{},$_REQUEST->{project_id});
			}

			if($tipo_proyecto eq 'Colectivo' and check_collective_evidences_upload()){
				close_step(7);	
			}elsif($tipo_proyecto ne 'Colectivo' and check_musica()){
				close_step(7);
			}
		}
	};
	if($@){
		croak ''.$@;
	}else{
		$results->{success} = 1;
		$results->{msg} = 'Proceso exitoso';
	}

	return $results;
}

sub check_musica{
	my $categoria = $dbh->selectrow_array("SELECT categoria FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});

	my $images = {};
    my $documents = {};
    my $partituras = {};
    my $notes = {};
    my $sitio = {};
    my $audio = {};
    my $video = {};

    my $completed = 1;

    my $evidencia_musica = $dbh->selectrow_hashref("SELECT * FROM evidencia_musica WHERE project_id = ?",{},$_REQUEST->{project_id});

    if($categoria eq 'Jóvenes creadores'){
        $partituras->{min} = 0; $partituras->{max} = 2;
        $documents->{min} = 0; $documents->{max} = 3;
      
        $sitio->{optional} = 1;
        $video->{optional} = 1;
    	
	}elsif($categoria eq 'Creadores con trayectoria'){
        $partituras->{min} = 0; $partituras->{max} = 2;
        $documents->{min} = 2; $documents->{max} = 2;
        $notes->{min} = 2; $notes->{max} = 2;

        $video->{optional} = 1;
        
    }elsif($categoria eq 'Desarrollo artístico individual'){
        $partituras->{min} = 0; $partituras->{max} = 3;
        $documents->{min} = 3; $documents->{max} = 3;
        $notes->{min} = 3; $notes->{max} = 3;

        $video->{optional} = 1;
        
    }elsif($categoria eq 'Producción artística colectiva'){
        $partituras->{min} = 0; $partituras->{max} = 2;
        $documents->{min} = 2; $documents->{max} = 2;
        $notes->{min} = 2; $notes->{max} = 2;

        $video->{optional} = 1;
    }

    if(!$sitio->{optional} and !$evidencia_musica->{sitioweb}){
    	$completed = 0;
    }

    if(!$evidencia_musica->{audiomuestra}){
    	$completed = 0;
    }

    if(!$video->{optional} and !$evidencia_musica->{videomuestra}){
    	$completed = 0;
    }

    if($categoria eq 'Desarrollo artístico individual'){
    	if(!$evidencia_musica->{boleta_kardex}){
    		$completed = 0;
    	}

    	if(!$evidencia_musica->{carta_aceptacion}){
    		$completed = 0;
    	}
    }

     if(!($evidencia_musica->{imagenes} >= $images->{min} && $evidencia_musica->{imagenes} <= $images->{max})){
    	$completed = 0;
    }

    if(!($evidencia_musica->{partituras} >= $partituras->{min} && $evidencia_musica->{partituras} <= $partituras->{max})){
    	$completed = 0;
    }


	if(!($evidencia_musica->{documentos} >= $documents->{min} && $evidencia_musica->{catalogo} <= $documents->{max})){
    	$completed = 0;
    }

     if(!($evidencia_musica->{notas} >= $notes->{min} && $evidencia_musica->{notas} <= $notes->{max})){
    	$completed = 0;
    }

    return $completed;
}

sub evidencias_teatro{
	my $results = {};
	eval{
		my $route = 'test/teatro_'.$_REQUEST->{project_id};
		if(!(-d 'data/'.$route)){
	    	make_path('data/'.$route);
	    }

		my $tipo_proyecto = $dbh->selectrow_array("SELECT tipo_proyecto FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});
		my $kardex;
		my $carta_aceptacion;

		if($_REQUEST->{_type} eq 'imagenes'){
			$route .= '/img';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}

			my $image = Chapix::Com::upload_file('file',$route);
			my $current_count = $dbh->selectrow_array('SELECT imagenes FROM evidencia_teatro WHERE project_id = ?',{},$_REQUEST->{project_id});
			#subir_imagenes
			$dbh->do('UPDATE evidencia_teatro SET imagenes = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($image);
		}elsif($_REQUEST->{_type} eq 'documentos'){
			$route .= '/docs';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}

	    	my $doc = Chapix::Com::upload_file('file',$route);
			my $current_count = $dbh->selectrow_array('SELECT documentos FROM evidencia_teatro WHERE project_id = ?',{},$_REQUEST->{project_id}) if($doc);
			#subir documentos
			$dbh->do('UPDATE evidencia_teatro SET documentos = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id});
		}elsif($_REQUEST->{_type} eq 'notas'){
            $route .= '/notes';
            
            if(!(-d 'data/'.$route)){
                make_path('data/'.$route);
            }
            
            my $current_count = $dbh->selectrow_array('SELECT notas FROM evidencia_teatro WHERE project_id = ?',{},$_REQUEST->{project_id});
            #subir documentos
            my $note = Chapix::Com::upload_file('file', $route);
            $dbh->do('UPDATE evidencia_teatro SET notas = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($note);
        }elsif($_REQUEST->{_type} eq '_guardar'){
			my $texto = Chapix::Com::upload_file('texto',$route);
			my $carta = Chapix::Com::upload_file('carta_de_autorizacion',$route);
			#$guion .= '_guion';
			#$carta .= '_carta';
			$dbh->do('UPDATE evidencia_teatro SET texto = ? WHERE project_id = ?',{},$texto,$_REQUEST->{project_id}) if($texto);
			$dbh->do('UPDATE evidencia_teatro SET carta_de_autorizacion = ? WHERE project_id = ?',{},$carta,$_REQUEST->{project_id}) if($carta);
			$dbh->do('UPDATE evidencia_teatro SET videomuestra = ?, sitioweb = ? WHERE project_id = ?',{},$_REQUEST->{video_link},$_REQUEST->{sitioweb_link},$_REQUEST->{project_id});
			
			if($_REQUEST->{categoria} eq 'Desarrollo artístico individual'){
				$kardex = Chapix::Com::upload_file('boleta_kardex',$route);
				$carta_aceptacion = Chapix::Com::upload_file('carta_aceptacion',$route);
				
				$dbh->do('UPDATE evidencia_teatro SET boleta_kardex = ?  WHERE project_id = ?',{},$kardex,$_REQUEST->{project_id}) if($kardex);
				$dbh->do('UPDATE evidencia_teatro SET carta_aceptacion = ? WHERE project_id = ?',{},$carta_aceptacion,$_REQUEST->{project_id}) if($carta_aceptacion);
			}

			if(check_teatro()){
				$dbh->do('UPDATE evidencia_teatro SET uploaded = 1 WHERE project_id = ?',{},$_REQUEST->{project_id});
			}

			if($tipo_proyecto eq 'Colectivo' and check_collective_evidences_upload()){
				close_step(7);	
			}elsif($tipo_proyecto ne 'Colectivo' and check_teatro()){
				close_step(7);
			}
		}
	};
	if($@){
		croak ''.$@;
	}else{
		$results->{success} = 1;
		$results->{msg} = 'Proceso exitoso';
	}

	return $results;	
}

sub check_teatro{
	my $categoria = $dbh->selectrow_array("SELECT categoria FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});

 	my $images = {};
    my $notes = {};
    my $documents = {};
    my $sitio = {};
    my $video = {};
    my $texto = {};
    my $carta = {};
    
    my $completed = 1;

	my $evidencia_teatro = $dbh->selectrow_hashref("SELECT * FROM evidencia_teatro WHERE project_id = ?",{},$_REQUEST->{project_id});

    if($categoria eq 'Jóvenes creadores'){
        $images->{min} = 5; $images->{max} = 5;
    	$documents->{min} = 0; $documents->{max} = 3;
    	
    	$sitio->{optional} = 1;
    	$texto->{optional} = 1;
    }elsif($categoria eq 'Creadores con trayectoria'){
        $images->{min} = 8; $images->{max} = 8;
    	$notes->{min} = 2; $notes->{max} = 2;
 		$documents->{min} = 2; $documents->{max} = 2;

 		$texto->{optional} = 1;
    }elsif($categoria eq 'Desarrollo artístico individual'){
        $images->{min} = 8; $images->{max} = 8;
    	$notes->{min} = 3; $notes->{max} = 3;
        $documents->{min} = 3; $documents->{max} = 3;

        $texto->{optional} = 1;
    
    }elsif($categoria eq 'Producción artística colectiva'){
        $images->{min} = 8; $images->{max} = 8;
    	$notes->{min} = 2; $notes->{max} = 2;
        $documents->{min} = 2; $documents->{max} = 2;
    	
    	$texto->{optional} = 1;
    
    }

    if(!$sitio->{optional} and !$evidencia_teatro->{sitioweb}){
    	$completed = 0;
    }

    if(!$evidencia_teatro->{videomuestra}){
    	$completed = 0;
    }

    if(!$texto->{optional} and !$evidencia_teatro->{texto}){
    	$completed = 0;
    }

    if(!$carta->{optional} and !$evidencia_teatro->{carta_de_autorizacion}){
    	$completed = 0;
    }

    if(!($evidencia_teatro->{imagenes} >= $images->{min} && $evidencia_teatro->{imagenes} <= $images->{max})){
    	$completed = 0;
    }

    if(!($evidencia_teatro->{notas} >= $notes->{min} && $evidencia_teatro->{notas} <= $notes->{max})){
    	$completed = 0;
    }

	if(!($evidencia_teatro->{documentos} >= $documents->{min} && $evidencia_teatro->{catalogo} <= $documents->{max})){
    	$completed = 0;
    }

    if($categoria eq 'Desarrollo artístico individual'){
    	if(!$evidencia_teatro->{boleta_kardex}){
    		$completed = 0;
    	}

    	if(!$evidencia_teatro->{carta_aceptacion}){
    		$completed = 0;
    	}
    }

    return $completed;

}

sub evidencias_cine_video{
	my $results = {};
	eval{
		my $route = 'test/cine_video_'.$_REQUEST->{project_id};
		if(!(-d 'data/'.$route)){
	    	make_path('data/'.$route);
	    }

		my $kardex;
		my $carta_aceptacion;
		my $tipo_proyecto = $dbh->selectrow_array("SELECT tipo_proyecto FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});
		
		if($_REQUEST->{_type} eq '_guardar'){
			my $guion = Chapix::Com::upload_file('guion',$route);

			
			if($_REQUEST->{categoria} ne 'Jóvenes creadores'){
                $dbh->do('UPDATE evidencia_cine_video SET demo_reel = ?, sitioweb = ? WHERE project_id = ?',{},$_REQUEST->{demo_reel},$_REQUEST->{sitioweb},$_REQUEST->{project_id});
            }

            $dbh->do('UPDATE evidencia_cine_video SET videomuestra = ?, uploaded = 1 WHERE project_id = ?',{},$_REQUEST->{video_link},$_REQUEST->{project_id});
            $dbh->do('UPDATE evidencia_cine_video SET guion = ? WHERE project_id = ?',{},$guion,$_REQUEST->{project_id}) if($guion);
            
            if($_REQUEST->{categoria} eq 'Desarrollo artístico individual'){
				$kardex = Chapix::Com::upload_file('boleta_kardex',$route);
				$carta_aceptacion = Chapix::Com::upload_file('carta_aceptacion',$route);
				
				$dbh->do('UPDATE evidencia_cine_video SET boleta_kardex = ?  WHERE project_id = ?',{},$kardex,$_REQUEST->{project_id}) if($kardex);
				$dbh->do('UPDATE evidencia_cine_video SET carta_aceptacion = ? WHERE project_id = ?',{},$carta_aceptacion,$_REQUEST->{project_id}) if($carta_aceptacion);
			}

			$route .= '/cortometraje';
			if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}

			my $guion_cortometraje = Chapix::Com::upload_file('guion_cortometraje',$route);
			my $sinopsis_cortometraje = Chapix::Com::upload_file('sinopsis_cortometraje',$route);
			my $plan_rodaje_cortometraje = Chapix::Com::upload_file('plan_rodaje_cortometraje',$route);
			my $carta_autorizacion_cortometraje = Chapix::Com::upload_file('carta_autorizacion_cortometraje',$route);

			$dbh->do('UPDATE evidencia_cine_video SET guion_cortometraje = ? WHERE project_id = ?',{},$guion_cortometraje,$_REQUEST->{project_id}) if($guion_cortometraje);
			$dbh->do('UPDATE evidencia_cine_video SET sinopsis_cortometraje = ? WHERE project_id = ?',{},$sinopsis_cortometraje,$_REQUEST->{project_id}) if($sinopsis_cortometraje);
			$dbh->do('UPDATE evidencia_cine_video SET plan_rodaje_cortometraje = ? WHERE project_id = ?',{},$plan_rodaje_cortometraje,$_REQUEST->{project_id}) if($plan_rodaje_cortometraje);
			$dbh->do('UPDATE evidencia_cine_video SET carta_autorizacion_cortometraje = ? WHERE project_id = ?',{},$carta_autorizacion_cortometraje,$_REQUEST->{project_id}) if($carta_autorizacion_cortometraje);
			
			if(check_cine_video()){
				 $dbh->do('UPDATE evidencia_cine_video SET uploaded = 1 WHERE project_id = ?',{},$_REQUEST->{project_id});
			}

			#fin del proceso
			if($tipo_proyecto eq 'Colectivo' and check_collective_evidences_upload()){
				close_step(7);	
			}elsif($tipo_proyecto ne 'Colectivo' and check_cine_video()){
				if(check_cine_video()){
					close_step(7);	
				}
			}
		}
	};
	if($@){
		croak ''.$@;
	}else{
		$results->{success} = 1;
		$results->{msg} = 'Proceso exitoso';
	}

	return $results;
}

sub check_cine_video{
	my $categoria = $dbh->selectrow_array("SELECT categoria FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});

	my $evidencia_cine_video = $dbh->selectrow_hashref("SELECT * FROM evidencia_cine_video WHERE project_id = ?",{},$_REQUEST->{project_id});
	my $completed = 1;
	my $counter = 0;

    if($evidencia_cine_video->{videomuestra}){
    	$counter++;
    }

    if($evidencia_cine_video->{guion}){
    	$counter++;
    }

    if($evidencia_cine_video->{guion_cortometraje}){
    	$counter++;
    }

    if($evidencia_cine_video->{sinopsis_cortometraje}){
    	$counter++;
    }

    if($evidencia_cine_video->{plan_rodaje_cortometraje}){
    	$counter++;
    }

    if($evidencia_cine_video->{carta_autorizacion_cortometraje}){
    	$counter++;
    }

    if($counter < 1){
    	$completed = 0;
    }

    if($categoria eq 'Desarrollo artístico individual'){
    	if(!$evidencia_cine_video->{boleta_kardex}){
    		$completed = 0;
    	}

    	if(!$evidencia_cine_video->{carta_aceptacion}){
    		$completed = 0;
    	}
    }

    if($categoria ne 'Jóvenes creadores'){
    	if(!$evidencia_cine_video->{sitioweb}){
    		$completed = 0;
    	}

    	if(!$evidencia_cine_video->{demo_reel}){
    		$completed = 0;
    	}
    }

	return $completed;
}

sub evidencias_letras{
	my $results = {};
	
	eval{
		my $route = 'test/letras_'.$_REQUEST->{project_id};
		if(!(-d 'data/'.$route)){
	    	make_path('data/'.$route);
	    }

		my $tipo_proyecto = $dbh->selectrow_array("SELECT tipo_proyecto FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});
		my $kardex;
		my $carta_aceptacion;

		if($_REQUEST->{_type} eq 'portadas'){
			$route .= '/portadas';
			
	    	if(!(-d 'data/'.$route)){
	    		make_path('data/'.$route);
	    	}

	    	my $portada = Chapix::Com::upload_file('file',$route);
			my $current_count = $dbh->selectrow_array('SELECT portadas FROM evidencia_letras WHERE project_id = ?',{},$_REQUEST->{project_id});
			#subir documentos
			$dbh->do('UPDATE evidencia_letras SET portadas = ? WHERE project_id = ?',{},$current_count + 1,$_REQUEST->{project_id}) if($portada);
		}elsif($_REQUEST->{_type} eq '_guardar'){
			my $texto = Chapix::Com::upload_file('texto_inedito',$route);
			$dbh->do('UPDATE evidencia_letras SET sitioweb = ? WHERE project_id = ?',{},$_REQUEST->{sitioweb_link},$_REQUEST->{project_id});
			$dbh->do('UPDATE evidencia_letras SET texto_inedito = ? WHERE project_id = ?',{},$texto,$_REQUEST->{project_id}) if($texto);
			
			if($_REQUEST->{categoria} eq 'Desarrollo artístico individual'){
				$kardex = Chapix::Com::upload_file('boleta_kardex',$route);
				$carta_aceptacion = Chapix::Com::upload_file('carta_aceptacion',$route);
				
				$dbh->do('UPDATE evidencia_letras SET boleta_kardex = ?  WHERE project_id = ?',{},$kardex,$_REQUEST->{project_id}) if($kardex);
				$dbh->do('UPDATE evidencia_letras SET carta_aceptacion = ? WHERE project_id = ?',{},$carta_aceptacion,$_REQUEST->{project_id}) if($carta_aceptacion);
			}

			if(check_letras()){
				$dbh->do('UPDATE evidencia_letras SET uploaded = 1 WHERE project_id = ?',{},$_REQUEST->{project_id});
			}

			#fin del proceso
			if($tipo_proyecto eq 'Colectivo' and check_collective_evidences_upload()){
				close_step(7);	
			}elsif($tipo_proyecto ne 'Colectivo' and check_letras()){
				close_step(7);
			}
		}
	};
	if($@){
		croak ''.$@;
	}else{
		$results->{success} = 1;
		$results->{msg} = 'Proceso exitoso';
	}

	return $results;
}

sub check_letras{
	my $categoria = $dbh->selectrow_array("SELECT categoria FROM project_registry WHERE project_id = ?",{},$_REQUEST->{project_id});

	my $portadas = {};
    my $sitio = {};
    my $texto = {};

    my $completed = 1;
    my $evidencia_letras =  $dbh->selectrow_hashref("SELECT * FROM evidencia_letras WHERE project_id = ?",{},$_REQUEST->{project_id});


    if($categoria eq 'Jóvenes creadores'){
        $portadas->{min} = 0; $portadas->{max} = 3;
        $sitio->{optional} = 1;

    }elsif($categoria eq 'Creadores con trayectoria'){
        $portadas->{min} = 1; $portadas->{max} = 1;
        
    }elsif($categoria eq 'Desarrollo artístico individual'){
        $portadas->{min} = 2; $portadas->{max} = 2;
    
    }elsif($categoria eq 'Producción artística colectiva'){
        $portadas->{min} = 1; $portadas->{max} = 1;
    }

    if(!$sitio->{optional} and !$evidencia_letras->{sitioweb}){
    	$completed = 0;
    }

    if(!$texto->{optional} and !$evidencia_letras->{texto_inedito}){
    	$completed = 0;
    }

    if(!($evidencia_letras->{portadas} >= $portadas->{min} && $evidencia_letras->{portadas} <= $portadas->{max})){
    	$completed = 0;
    }

    if($categoria eq 'Desarrollo artístico individual'){
    	if(!$evidencia_letras->{boleta_kardex}){
    		$completed = 0;
    	}

    	if(!$evidencia_letras->{carta_aceptacion}){
    		$completed = 0;
    	}
    }

    return $completed;
}

sub finish{
	my $results = {};
	eval{
		$dbh->do("UPDATE accounts SET step = 8 WHERE account_id = ?",{},$sess{account_id});
		
		my $account = $dbh->selectrow_hashref("SELECT * FROM accounts WHERE account_id = ?",{},$sess{account_id});
    	my $folio = $dbh->selectrow_array("SELECT folio FROM project_registry WHERE account_id = ?",{},$account->{account_id});

    	my $Mail = Chapix::Mail::Controller->new();
        my $enviado = $Mail->html_template({
            to       => $account->{'email'},
            bcc      => 'danielsoto@xaandia.com', 
            subject  => 'fin de registro FOMAC',
            template => {
                file => 'Chapix/Form/tmpl/end-email.html',
                vars => {
                    name  => $account->{name},
                    email => $account->{email},
                    folio => $folio
                }
            }
        });

	};
	if($@){
		croak ''.$@;
	}else{
		$results->{redirect} = '/FOMAC';
	}
	return $results;
}

sub expenses_report{
    my $results = {};
    my $applicant_name = clear_string($sess{account_name});
    my $route = "reporte_gastos/".$applicant_name;
    eval{
        if($_REQUEST->{_submit} eq 'Guardar'){
            my $report = Chapix::Com::upload_file('report',$route);
            $dbh->do("INSERT INTO expenses_report (account_id,report) VALUES(?,?)",{},$sess{account_id},$report);
            my $new_step = int($sess{account_step}) + 1;
            $dbh->do("UPDATE accounts SET step = ? WHERE account_id = ?",{},$new_step,$sess{account_id});
            $sess{account_step} = "$new_step";
    
        }elsif($_REQUEST->{_submit} eq 'Actualizar'){
            my $actual_report = $dbh->selectrow_hashref("SELECT report FROM expenses_report WHERE account_id = ?",{},$sess{account_id});
            my $new_report = Chapix::Com::upload_file('report',$route);
            $dbh->do("UPDATE expenses_report SET report = ? WHERE account_id = ?",{},$new_report,$sess{account_id}); 
            unlink('data/'.$route.'/'.$actual_report->{report});
        }
    };

    if($@){
        msg_add('danger',$@);
    }else{
        msg_add('success',"Tu reporte fue guardado");
        $results->{redirect} = "/Form";
    }
    return $results;
}


sub clear_string{
    my $name = shift;

    $name =~ s/ñ/n/g;
    $name =~ s/á/a/g;
    $name =~ s/é/e/g;
    $name =~ s/í/i/g;
    $name =~ s/ó/o/g;
    $name =~ s/ú/u/g;
    $name =~ s/([\w']+)/\u\L$1/g;
    $name =~ s/\W//g;

    return $name;
}



1;