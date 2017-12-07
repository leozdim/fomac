package Chapix::Form::View;

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

use Data::Dumper;

# Language
#use Chapix::Form::L10N;
#my $lh = Chapix::Form::L10N->get_handle($sess{user_language}) || die "Language?";
#sub loc (@) { return ( $lh->maketext(@_)) }

sub default {
    msg_add('warning','Not implemented');
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
	    
	    $id = $label;
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
    my $label   = shift || 'Agregar';
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
  my $label   = shift || 'Regresar';
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
    my $label   = shift || 'Search';
    my $class = 'waves-effect waves-dark ';
    my $icon  = 'keyboard_backspace';

    my $btn = ' <a href="javascript:xaaTooggleSearch();" class="'.$class.'" alt="'.$label.'" title="'.$label.'" >';
    $btn   .= '<i class="material-icons">search</i>';
    $btn   .= '</a>';
    $conf->{Page}->{Toolbar} .= $btn;

    $conf->{Page}->{Search} = {
        Field => (CGI::textfield({-name=>'q', -id=>'q'})),
        Show => ($_REQUEST->{'q'} || ''),
        Label => 'Search',
    };
}

sub initialize_view{
	my $current_view = shift || 'no-view';
	my $description = shift || 'no description';
	my $output  = {};

	if($current_view eq 'Evidencias'){
		$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/dropzone.js" type="text/javascript"></script>';
	    $conf->{Page}->{CSS} .= '<link href="Chapix/Form/css/dropzone.min.css" type="text/css" rel="stylesheet"/>';
	}
	$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/icm-form.js?0.02" type="text/javascript"></script>';
	$conf->{Page}->{CSS} .= '<link href="Chapix/Form/css/animate.css" type="text/css" rel="stylesheet" media="screen,projection"/>';
	$conf->{Page}->{CSS} .= '<link href="Chapix/Form/css/icm-form.css" type="text/css" rel="stylesheet" media="screen,projection"/>';
	$conf->{Page}->{Title} = $current_view;
	$conf->{Page}->{Description} = $description;

	#print Dumper($sess{on_step});

	$output->{account_data} =  $dbh->selectrow_hashref("SELECT account_id,name,step,email FROM accounts WHERE account_id = ?",{},$sess{account_id});
	$output->{project_id} = $dbh->selectrow_array("SELECT project_id FROM project_registry WHERE account_id = ?",{},$sess{account_id}) || 0;
    
	my $steps_data = $dbh->selectall_arrayref("SELECT s.*, sa.is_completed, sa.skipped FROM steps s INNER JOIN steps_account sa ON s.step_id = sa.step_id WHERE sa.account_id = ?",{Slice=>{}},$sess{account_id});
	my @steps = ();
	$output->{steps} = {};

	foreach my $step(@{$steps_data}){
		my $step_data = {
			step_data => { 
				step_circle => $step->{step_id}, 
				step_title => $step->{step_title}, 
				is_completed => $step->{is_completed},
				skipped => $step->{skipped} 
			}, 
			tooltip_data => { 
				step => $step->{tooltip_step}, 
				title => $step->{tooltip_title}, 
				description => $step->{tooltip_description}
			}
		};
		push(@steps,$step_data);
		$output->{steps}->{$step->{step_id}} = {is_completed => $step->{is_completed}, skipped => $step->{skipped}};
	}

	my $completed_steps = $dbh->selectrow_array("SELECT COUNT(*) FROM steps_account WHERE account_id = ? AND is_completed = 1",{},$sess{account_id});
	my $step_size = $dbh->selectrow_array("SELECT COUNT(*) FROM steps",{});

	$output->{breadcrumbs} = breadcrumbs_compose({current_view => $current_view, current_step => $output->{account_data}->{step}, steps => \@steps});
	#$output->{logout} = CGI::a({-href=>"/Accounts/Logout", class=>"btn-floating btn-large tooltipped blue darken-2", 'data-tooltip'=>"Cerrar Sesión", 'data-position'=>"left"},'<i class="large material-icons">close</i>');	
	$output->{logout} = '<a id="close_sess" href="/Accounts/Logout" class="btn waves-effect waves-light blue darken-2 right" type="button" value="Cerrar">Cerrar</a>';
		
	if($completed_steps eq $step_size){
		#$output->{finish} = CGI::a({-href=>"/Form/Finish?_action=done", class=>"btn-floating btn-large tooltipped blue darken-2", 'data-tooltip'=>"Finalizar", 'data-position'=>"left"},'<i class="large material-icons">check</i>');	
		$output->{finish} = '<a id="done" href="/Form/Finish?_action=done" class="btn waves-effect waves-light blue darken-2 right" type="button" value="Finalizar">Finalizar</a>';
	}
	
	return $output;
}

sub welcome{
	$conf->{Page}->{CSS} .= '<link href="Chapix/Form/css/icm-form.css" type="text/css" rel="stylesheet" media="screen,projection"/>';
	$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/icm-form.js?0.02" type="text/javascript"></script>';
	
	my @submit = "Iniciar";  
    
    my $HTML = "";
    my $template = Template->new();
    
    my $vars = {
        conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        submit => @submit 
    };

    $template->process('Chapix/Form/tmpl/welcome.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;
}


sub register_project_form{
    my $view =  initialize_view('Registro','En este formulario elegirás la categoría y disciplina de tu proyecto');
    my @submit;
  
    if($view->{account_data}->{step} > 1){
        @submit = 'Actualizar';
    }else{
        @submit = 'Guardar';
    }

    my $project_collective = 0;
    
    my $project_registry = $dbh->selectrow_hashref("SELECT * FROM project_registry WHERE account_id = ?",{},$view->{account_data}->{account_id});
	if($project_registry->{tipo_proyecto} eq 'Colectivo'){
		$project_collective = $dbh->selectrow_hashref("SELECT * FROM project_collective_disciplines WHERE project_id = ?",{},$view->{project_id});	
	}
	
    my $HTML = "";
    my $template = Template->new();
    
    my $vars = {
        conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        view => $view,
        project => $project_registry,
        project_collective => $project_collective,
        submit => @submit 
    };

    $template->process('Chapix/Form/tmpl/project_registry.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;
}

sub project_participants_form{
	my $view = initialize_view('Participantes','Registra al participante o representante de equipo (Colectivo)');
	my $submit;

	if($view->{account_data}->{step} > 2){
		$submit = 'Actualizar';
	}else{
		$submit = 'Guardar';
	}

	my $project_participants = $dbh->selectrow_hashref("SELECT * FROM project_participants WHERE project_id = ?",{},$view->{project_id});
	#my $project_type = $dbh->selectrow_array("SELECT tipo_proyecto FROM project_registry WHERE project_id = ?",{},$view->{project_id});
	#my $colectivo;

	#if($project_type eq 'Colectivo'){
	#   $view->{agregar} = '<button class="btn waves-effect waves-light blue darken-2" type="button" name="agregar" value="Agregar" id="agregar">Agregar participante</button>';
	#   $submit = 'Finalizar Colectivo';
    #}
    
	my $HTML = "";
	my $template = Template->new();

	my $vars = {
		conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        view => $view,
       	participant => $project_participants,
       	#colectivo => $colectivo,
        submit => $submit 
	};

	$template->process('Chapix/Form/tmpl/participants_form.html',$vars,\$HTML) or $HTML = $template->error();
	return $HTML;
}

sub project_attachments{
	my $view = initialize_view('Anexos','Descarga los anexos necesarios según tu tipo de proyecto, serán requeridos en los siguientes pasos');
	my $submit;
	my $uploaded = 0;

	$submit = 'Finalizar';

	my $project_docs = $dbh->selectrow_hashref("SELECT * FROM project_participants_documents WHERE project_id = ?",{},$view->{project_id});
	
	if($project_docs->{carta_compromiso}){
		$uploaded = 1;
	}	

	my $HTML = "";
	my $template = Template->new();

	my $vars = {
		conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        view => $view,
        submit => $submit 
	};

	$template->process('Chapix/Form/tmpl/anexos.html',$vars,\$HTML) or $HTML = $template->error();
	return $HTML;
}

sub project_participants_docs_form{
	my $view = initialize_view('Documentos','Sube los documentos solicitados');
    my $submit;
    my $finish;

    my $participants = $dbh->selectall_arrayref("SELECT CONCAT(p.nombres,' ',p.apellido_paterno,' ',p.apellido_materno) AS nombre, pd.documents_id, pd.uploaded FROM project_participants_documents pd INNER JOIN project_participants p ON p.participant_id = pd.participant_id WHERE p.project_id = ?",{Slice => {}},$view->{project_id});
    my $uploaded = $dbh->selectrow_array("SELECT COUNT(*) FROM project_participants_documents WHERE uploaded = 1 AND project_id = ?",{},$view->{project_id});
    my $project_info = $dbh->selectrow_hashref("SELECT categoria,tipo_proyecto FROM project_registry WHERE project_id = ?",{},$view->{project_id});
    my $participant_docs = $dbh->selectrow_hashref("SELECT * FROM project_participants_documents WHERE project_id = ?",{},$view->{project_id});

    if($uploaded eq scalar @{$participants}){
        $finish = '<button id="terminar_carga" class="btn waves-effect waves-light blue darken-2 right" type="button" value="Finalizar">Finalizar Paso 3</button>';
    }

    my $HTML = "";
    my $template = Template->new();

    my $vars = {
        conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        view => $view,
        participants => $participants,
        project => $project_info,
        docs => $participant_docs,
        finalizar => $finish, 
    };

    $template->process('Chapix/Form/tmpl/participants_docs_form.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;   
}

sub project_general_information_form{
    my $view = initialize_view('Proyecto','Descripción general del proyecto, háblanos un poco de sus antecedentes, justificación, objetivos, metas y el contexto en el cual se ubicará tu proyecto');
    
    my @fields = qw/project_id nombre antecedentes justificacion objetivos_generales objetivos_especificos metas beneficiarios contexto/;
    my @submit;
    my $general_completed = 0;


	
	if($view->{steps}->{5}->{is_completed}){
        @submit = 'Actualizar';
        $general_completed = 1;
    }elsif($view->{steps}->{5}->{skipped} || !$view->{steps}->{5}->{is_completed}){
      	@submit = 'Guardar';
	    if($view->{steps}->{5}->{skipped}){
	      	$general_completed = 1;
	    }
    }

    my $project_general_info = $dbh->selectrow_hashref("SELECT * FROM project_information WHERE project_id = ?",{},$view->{project_id});

    my $form = CGI::FormBuilder->new(
        name => 'project_general_information',
        method => 'POST',
        fields => [qw/project_info_id project_id nombre descripcion antecedentes justificacion objetivo_general objetivos_especificos metas beneficiarios contexto bibliografia proyecto_documentos/],
        action => '/Form',
        values => $project_general_info,
        submit => \@submit,
    );

    my $formatos = 1;

    $form->field(name => 'project_info_id', type => 'hidden');
    $form->field(name => 'project_id', type => 'hidden', value => $view->{project_id});
    $form->field(name => 'nombre', label => 'Nombre del proyecto', type => 'textarea', class=>"materialize-textarea count-char", 'data-length' =>"100", comment => 'Identificar cómo se denominará el proyecto');
    $form->field(name => 'descripcion', label => 'Descripción del proyecto', type => 'textarea', class=>"materialize-textarea count-char", 'data-length' => "200", comment => 'Breve descripción de tu proyecto');
    $form->field(name => 'antecedentes', label => 'Antecedentes', type => 'textarea', class=>"materialize-textarea count-char", 'data-length' =>"500", comment => 'Referencia histórica breve y aspectos generales del caso. Recuento de teorías, autores, corrientes o puntos de vista que se hayan efectuado sobre el tema o similares.');
    $form->field(name => 'justificacion', label => 'Justificación', type => 'textarea', class=>"materialize-textarea count-char", 'data-length' =>"500", comment => 'Indicar la importancia del proyecto, el impacto social y cultural, sostenibilidad y sustentabilidad. Razones por las que debe llevarse a cabo el proyecto');
    $form->field(name => 'objetivo_general', label => 'Objetivo general', type => 'textarea', class=>"materialize-textarea count-char", 'data-length' =>"200", comment => 'Responde a las preguntas ¿Qué? ¿Para qué? utilizando verbos de acción, expresados en infinitivo');
    $form->field(name => 'objetivos_especificos', label => 'Objetivos específicos', type => 'textarea', class=>"materialize-textarea count-char", 'data-length' =>"300", comment => 'Explicar de manera detallada las acciones y beneficios que respaldan el objetivo general, se redacta en infinitivo');
    $form->field(name => 'metas', label => 'Metas o propósitos', type => 'textarea', class=>"materialize-textarea count-char", 'data-length' =>"300", comment => 'Describir los fines concretos, cuantificar las acciones y resultados a lograr con el desarrollo del proyecto');
    $form->field(name => 'beneficiarios', label => 'Titulares de derecho', type => 'textarea', class=>"materialize-textarea count-char", 'data-length' =>"300", comment => 'Señalar la cantidad de personas beneficiadas, ejemplo: 150 niñas de primaria. Especificar beneficiarios directos e indirectos del proyecto');
    $form->field(name => 'contexto', label => 'Ubicación y contexto', type => 'textarea', class=>"materialize-textarea count-char", 'data-length' =>"300", comment => 'Describir el lugar y ambiente en que se desarrollará su proyecto');
    $form->field(name => 'bibliografia', label => 'Bibliografía', type => 'textarea', class=>"materialize-textarea count-char", 'data-length' => '500', comment => 'Escribe aquí tus citas bibliográficas');
    $form->field(name => 'proyecto_documentos', label => 'Documentos', comment => 'Formato Excel de cronograma, fuentes de financiamiento y desglose de gastos', type=>'file');

    if($project_general_info->{proyecto_documentos}){
		$form->field(name => 'proyecto_documentos', label => 'Documentos <i class="material-icons white-text">check_circle</i>', comment => 'Formato excel de cronograma, fuentes de financiamiento y desglose de gastos', type=>'file');    	
    }

    my $HTML = $form->render(
        template => {
            template => 'Chapix/Form/tmpl/icm-form.html',
            type => 'TT2',
            variable => 'form',
            data => {
                conf  => $conf,
                sess => \%sess,
                loc => \&loc,
                msg   => msg_print(),
                view => $view,
                formatos => $formatos,
                completed => $general_completed
            },
        },
    );

    return $HTML;
}

sub social_retribution_form{
    my $view = initialize_view('Retribución','Aportación a la sociedad');
    my @submit;
    
    if($view->{steps}->{6}->{is_completed}){
        @submit = 'Actualizar';
    }elsif($view->{steps}->{6}->{skipped} || !$view->{steps}->{6}->{is_completed}){
      	@submit = 'Guardar';
	}

    my $retribution_info = $dbh->selectrow_hashref("SELECT * FROM project_retribution WHERE project_id = ?",{},$view->{project_id});

    my $HTML = "";
    my $template = Template->new();

    my $vars = {
        conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        view => $view,
        retribution => $retribution_info,
        submit => @submit
    };

    $template->process('Chapix/Form/tmpl/retribution_form.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;
}

sub evidence_form{
    my $view = initialize_view('Evidencias','Sube evidencias de trabajos de tu autoría');
    my @submit;
    my $template_path = 'Chapix/Form/tmpl/evidence_form.html';

    my $project_info = $dbh->selectrow_hashref('SELECT project_id,categoria,disciplina,tipo_proyecto FROM project_registry WHERE project_id = ?',{},$view->{project_id});
    
    my $subtitle = 'Categoría '.$project_info->{categoria}.' en la disciplina de '.$project_info->{disciplina}; 
    
	if($view->{account_data}->{step} > 7){
        @submit = 'Actualizar';
    }else{
        @submit = 'Guardar';
    }

    my $form = '';
    if($project_info->{tipo_proyecto} eq 'Colectivo'){
    	$form = generate_collective_form($project_info);
    	$template_path = 'Chapix/Form/tmpl/evidence_collective_form.html';
    }else{
    	$form = generate_evidence_form($project_info);
    }
    
    my $HTML = '';
    my $template = Template->new();

    my $vars = {
    	conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        view => $view,
        forms => $form,
        subtitle => $subtitle,
        submit => @submit
    };
    
    $template->process($template_path,$vars,\$HTML) or $HTML = $template->error();
    return $HTML;   
}

sub generate_evidence_form {
    my $params = shift || {categoria => 'no-categoria', disciplina => 'no-disciplina'};
    my $form;
    my $current_qty;
    
   	#$params = {
		# disciplina => 'Letras',
		# categoria => 'Jovenes creadores',
		# project_id => '7'
  	#};

  	#$params->{disciplina} = 'Musica';
  	
    #Categoria jovenes creadores es el formulario base
    if($params->{disciplina} eq 'Artes visuales'){
    	$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/artes_visuales.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_artes_visuales WHERE project_id = ?',{},$params->{project_id});
		$form = artes_visuales_form($current_qty,$params->{categoria});
    }elsif($params->{disciplina} eq 'Danza'){
    	$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/danza.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_danza WHERE project_id = ?',{},$params->{project_id});
		$form = danza_form($current_qty,$params->{categoria});
    }elsif($params->{disciplina} eq 'Música'){
    	$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/musica.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_musica WHERE project_id = ?',{},$params->{project_id});
		$form = musica_form($current_qty,$params->{categoria});
    }elsif($params->{disciplina} eq 'Teatro'){
    	$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/teatro.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_teatro WHERE project_id = ?',{},$params->{project_id});
		$form = teatro_form($current_qty,$params->{categoria});
    }elsif($params->{disciplina} eq 'Cine y video'){
    	$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/cine_video.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_cine_video WHERE project_id = ?',{},$params->{project_id});
		$form = cine_video_form($current_qty,$params->{categoria});
    }elsif($params->{disciplina} eq 'Letras'){
		$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/letras.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_letras WHERE project_id = ?',{},$params->{project_id});
		$form = letras_form($current_qty,$params->{categoria});
    }
    
    #if($params->{categoria} eq 'Creadores con trayectoria'){
	
    #}elsif($params->{categoria} eq 'Desarrollo artistico individual'){
	
    #}
    
    return $form;
}

sub generate_collective_form{
	my $params = shift;
	my $forms = [];
	my $current_qty;

	my $disciplinas = $dbh->selectrow_hashref("SELECT * FROM project_collective_disciplines WHERE project_id = ?",{},$params->{project_id});

	#$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/interdisciplinaria.js?0.03" type="text/javascript"></script>';
		
	if($disciplinas->{artes_visuales}){
		$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/multidisciplina_artes_visuales.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_artes_visuales WHERE project_id = ?',{},$params->{project_id});
		push($forms,{title=> "Artes Visuales", id=>"artes_visuales_form", form => artes_visuales_form($current_qty,$params->{categoria})});
	}
	if($disciplinas->{danza}){
		$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/multidisciplina_danza.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_danza WHERE project_id = ?',{},$params->{project_id});
		push($forms,{title=> "Danza",  id=>"danza_form", form => danza_form($current_qty,$params->{categoria})});
	}
	if($disciplinas->{musica}){
		$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/multidisciplina_musica.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_musica WHERE project_id = ?',{},$params->{project_id});
		push($forms,{title=> "Música",  id=>"musica_form", form => musica_form($current_qty,$params->{categoria})});
	}
	if($disciplinas->{teatro}){
		$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/multidisciplina_teatro.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_teatro WHERE project_id = ?',{},$params->{project_id});
		push($forms,{title=> "Teatro",  id=>"teatro_form", form => teatro_form($current_qty,$params->{categoria})});
	}
	if($disciplinas->{cine_video}){
		$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/multidisciplina_cine_video.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_cine_video WHERE project_id = ?',{},$params->{project_id});
		push($forms,{title=> "Cine y Video", id=>"cine_video_form", form => cine_video_form($current_qty,$params->{categoria})});
	}
	if($disciplinas->{letras}){
		$conf->{Page}->{JS} .= '<script src="Chapix/Form/js/multidisciplina_letras.js?0.04" type="text/javascript"></script>';
		$current_qty = $dbh->selectrow_hashref('SELECT * FROM evidencia_letras WHERE project_id = ?',{},$params->{project_id});
		push($forms,{title=> "Letras",  id=>"letras_form", form => letras_form($current_qty,$params->{categoria})});
	}

	return $forms;
}

sub artes_visuales_form {
	my $current_qty = shift || 0;
	my $categoria = shift || 'No categoria';
    my $HTML = '';
    my $template = Template->new();

    my $images = {};
    my $notes = {};
    my $catalog = {};
    my $documents = {};
 
    if($categoria eq 'Jóvenes creadores'){
        $images->{min} = 5;
        $images->{max} = 5;
        $images->{label} = 'Sube 5 imágenes de las obras que ha realizado';

        $notes->{min} = 1;
        $notes->{max} = 3;
        $notes->{label} = 'Sube de 1 a 3 notas de prensa sobre tu trabajo (Opcional)';
        $notes->{optional} = 1;

        $catalog->{min} = 1;
        $catalog->{max} = 1;
        $catalog->{label} = 'Sube un catálogo sobre tu trabajo (Opcional)';
        $catalog->{optional} = 1;

        $documents->{min} = 1;
        $documents->{max} = 3;
        $documents->{label} = 'Sube de 1 a 3 documentos de los tipos antes mencionados (Opcional)';
        $documents->{optional} = 1;
    }elsif($categoria eq 'Creadores con trayectoria'){
        $images->{min} = 10;
        $images->{max} = 10;
        $images->{label} = 'Sube 10 imágenes de las obras que ha realizado';

        $notes->{min} = 2;
        $notes->{max} = 2;
        $notes->{label} = 'Sube 2 notas de prensa sobre tu trabajo';
       
        $catalog->{min} = 2;
        $catalog->{max} = 2;
        $catalog->{label} = 'Sube 2 catálogos sobre tu trabajo';

        $documents->{min} = 2;
        $documents->{max} = 2;
        $documents->{label} = 'Sube 2 documentos de los tipos antes mencionados';
    }elsif($categoria eq 'Desarrollo artístico individual'){
        $images->{min} = 10;
        $images->{max} = 10;
        $images->{label} = 'Sube 10 imágenes de las obras que ha realizado';

        $notes->{min} = 3;
        $notes->{max} = 3;
        $notes->{label} = 'Sube 3 notas de prensa sobre tu trabajo';
       
        $catalog->{min} = 2;
        $catalog->{max} = 2;
        $catalog->{label} = 'Sube 2 catálogos sobre tu trabajo';

        $documents->{min} = 3;
        $documents->{max} = 3;
        $documents->{label} = 'Sube 3 documentos de los tipos antes mencionados';
   
    }elsif($categoria eq 'Producción artística colectiva'){
        $images->{min} = 10;
        $images->{max} = 10;
        $images->{label} = 'Sube 10 imágenes de las obras que ha realizado';

        $notes->{min} = 2;
        $notes->{max} = 2;
        $notes->{label} = 'Sube 2 notas de prensa sobre tu trabajo';
       
        $catalog->{min} = 2;
        $catalog->{max} = 2;
        $catalog->{label} = 'Sube 2 catálogos sobre tu trabajo';

        $documents->{min} = 2;
        $documents->{max} = 2;
        $documents->{label} = 'Sube 2 documentos de los tipos antes mencionados';
    }

    my $vars = {
    	conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        current_qty => $current_qty,
        categoria => $categoria,
        images => $images,
        notes => $notes,
        documents => $documents,
        catalog => $catalog
    };

    $template->process('Chapix/Form/tmpl/artes_visuales_form.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;       
}

sub danza_form {
	my $current_qty = shift || 0;
    my $categoria = shift || 'No categoria';
    my $HTML = '';
    my $template = Template->new();

    my $images = {};
    my $notes = {};
    my $documents = {};
    my $sitio = {}; 

    if($categoria eq 'Jóvenes creadores'){
        $images->{min} = 5;
        $images->{max} = 5;
        $images->{label} = '5 fotografías que den muestra del trabajo';

        $documents->{min} = 1;
        $documents->{max} = 3;
        $documents->{label} = '1 a 3 programas de mano, invitaciones, constancias y/o reconocimientos (Opcional)';
        $documents->{optional} = 1;

        $sitio->{label} = '1 liga a sitio de internet que incluya material u obra adicional del postulante (Opcional)';
        $sitio->{optional} = 1;
    }elsif($categoria eq 'Creadores con trayectoria'){
        $images->{min} = 8;
        $images->{max} = 8;
        $images->{label} = '8 fotografías que den muestra del trabajo';

        $notes->{min} = 2;
        $notes->{max} = 2;
        $notes->{label} = 'Sube 2 notas de prensa sobre tu trabajo';

        $documents->{min} = 2;
        $documents->{max} = 2;
        $documents->{label} = '2 programas de mano, invitaciones, constancias y/o reconocimientos ';
    
        $sitio->{label} = 'Agrega un link de un sitio web con contenido que incluya material u obras adicionales de tu autoría';
    }elsif($categoria eq 'Desarrollo artístico individual'){
        $images->{min} = 8;
        $images->{max} = 8;
        $images->{label} = '8 fotografías que den muestra del trabajo';

        $notes->{min} = 3;
        $notes->{max} = 3;
        $notes->{label} = 'Sube 3 notas de prensa sobre tu trabajo';

        $documents->{min} = 3;
        $documents->{max} = 3;
        $documents->{label} = '3 programas de mano, invitaciones, constancias y/o reconocimientos ';
    
        $sitio->{label} = 'Agrega un link de un sitio web con contenido que incluya material u obras adicionales de tu autoría';
    
    }elsif($categoria eq 'Producción artística colectiva'){
        $images->{min} = 8;
        $images->{max} = 8;
        $images->{label} = 'Sube 8 imágenes de las obras que ha realizado';

        $notes->{min} = 2;
        $notes->{max} = 2;
        $notes->{label} = 'Sube 2 notas de prensa sobre tu trabajo';
      
        $documents->{min} = 2;
        $documents->{max} = 2;
        $documents->{label} = '2 programas de mano, invitaciones, constancias y/o reconocimientos ';
    
        $sitio->{label} = 'Agrega un link de un sitio web con contenido que incluya material u obras adicionales de tu autoría';
  
    }

    my $vars = {
    	conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        current_qty => $current_qty,
        categoria => $categoria,
        images => $images,
        documents => $documents,
        notes => $notes,
        sitio => $sitio
    };

    $template->process('Chapix/Form/tmpl/danza_form.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;       	
}

sub musica_form {
    my $current_qty = shift || 0;
    my $categoria = shift || 'No categoria';
    my $HTML = '';
    my $template = Template->new();

    my $images = {};
    my $documents = {};
    my $partituras = {};
    my $grabaciones = {};
    my $notes = {};
    my $sitio = {};
    my $audio = {};

    if($categoria eq 'Jóvenes creadores'){
        $images->{min} = 5;
        $images->{max} = 5;
        $images->{label} = 'Sube 5 imágenes de las obras que ha realizado';

        $partituras->{min} = 1;
        $partituras->{max} = 2;
        $partituras->{label} = '1 a 2 partituras de su autoría para los postulantes en composición (Opcional)';
        $partituras->{optional} = 1;

        $grabaciones->{min} = 2;
        $grabaciones->{max} = 2;
        $grabaciones->{label} = 'Sube 2 grabaciones en formato digital (especifica en el nombre de la grabacion si es composición o interpretación)';

        $documents->{min} = 1;
        $documents->{max} = 3;
        $documents->{label} = '1 a 3 programas de mano, invitaciones, constancias y/o reconocimientos (Opcional)';
        $documents->{optional} = 1;

        $sitio->{label} = '1 liga a sitio de internet que incluya material u obra adicional del postulante (Opcional)';
        $sitio->{optional} = 1;
    	
		$audio->{label} = 'Link de 2 grabaciones en formato digital de 10-20 min que den muestra del trabajo del postulante';
    	#$audio->{optional} = 1;
    }elsif($categoria eq 'Creadores con trayectoria'){
        $images->{min} = 10;
        $images->{max} = 10;
        $images->{label} = 'Sube 10 imágenes de las obras que ha realizado';

        $partituras->{min} = 2;
        $partituras->{max} = 2;
        $partituras->{label} = '2 partituras de su autoría para los postulantes en composición (Opcional)';
        $partituras->{optional} = 1;

        $grabaciones->{min} = 3;
        $grabaciones->{max} = 3;
        $grabaciones->{label} = 'Sube 3 grabaciones en formato digital (especifica en el nombre de la grabacion si es composición o interpretación)';

        $documents->{min} = 2;
        $documents->{max} = 2;
        $documents->{label} = 'Sube 2 documentos de los tipos antes mencionados';
        
        $notes->{min} = 2;
        $notes->{max} = 2;
        $notes->{label} = 'Sube 2 notas de prensa sobre tu trabajo';


        $sitio->{label} = 'Agrega un link de un sitio web con contenido que incluya material u obras adicionales de tu autoría';
    	
    	$audio->{label} = 'Link de 2 grabaciones en formato digital de 10-20 min que den muestra del trabajo del postulante';
    	#$audio->{optional} = 1;
    

    }elsif($categoria eq 'Desarrollo artístico individual'){
        $images->{min} = 10;
        $images->{max} = 10;
        $images->{label} = 'Sube 10 imágenes de las obras que ha realizado';

        $partituras->{min} = 3;
        $partituras->{max} = 3;
        $partituras->{label} = 'Sube 3 partituras de tu autoría (Opcional)';
        $partituras->{optional} = 1;

        $grabaciones->{min} = 4;
        $grabaciones->{max} = 4;
        $grabaciones->{label} = 'Sube 4 grabaciones en formato digital (especifica en el nombre de la grabacion si es composición o interpretación)';

        $documents->{min} = 3;
        $documents->{max} = 3;
        $documents->{label} = 'Sube 3 documentos de los tipos antes mencionados';
        
        $notes->{min} = 3;
        $notes->{max} = 3;
        $notes->{label} = 'Sube 3 notas de prensa sobre tu trabajo';

        $audio->{label} = 'Link de 2 grabaciones en formato digital de 10-20 min que den muestra del trabajo del postulante';
    	
        $sitio->{label} = 'Agrega un link de un sitio web con contenido que incluya material u obras adicionales de tu autoría';
    

    }elsif($categoria eq 'Producción artística colectiva'){
        $images->{min} = 10;
        $images->{max} = 10;
        $images->{label} = 'Sube 10 imágenes de las obras que ha realizado';

        $partituras->{min} = 2;
        $partituras->{max} = 2;
        $partituras->{label} = 'Sube 2 partituras de tu autoría (Opcional)';
        $partituras->{optional} = 1;

        $grabaciones->{min} = 3;
        $grabaciones->{max} = 3;
        $grabaciones->{label} = 'Sube 3 grabaciones en formato digital (especifica en el nombre de la grabacion si es composición o interpretación)';

        $documents->{min} = 2;
        $documents->{max} = 2;
        $documents->{label} = 'Sube 2 documentos de los tipos antes mencionados';
        
        $notes->{min} = 2;
        $notes->{max} = 2;
        $notes->{label} = 'Sube 2 notas de prensa sobre tu trabajo';

        $audio->{label} = 'Link de 2 grabaciones en formato digital de 10-20 min que den muestra del trabajo del postulante';
    	
        $sitio->{label} = 'Agrega un link de un sitio web con contenido que incluya material u obras adicionales de tu autoría';
  
    }

    my $vars = {
    	conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        current_qty => $current_qty,
        categoria => $categoria,
        images => $images,
        documents => $documents,
        partituras => $partituras,
        grabaciones => $grabaciones,
        sitio => $sitio,
        notes => $notes,
        audio => $audio
    };

    $template->process('Chapix/Form/tmpl/music_form.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;       
}

sub teatro_form {
	my $current_qty = shift || 0;
	my $categoria = shift || 'No categoria';
    my $HTML = '';
    my $template = Template->new();

    my $images = {};
    my $documents = {};
    my $notes = {};
    my $sitio = {};
    my $guion = {};
    my $dramaturgia = {};

    if($categoria eq 'Jóvenes creadores'){
        $images->{min} = 5;
        $images->{max} = 5;
        $images->{label} = 'Sube 5 imágenes de las obras que ha realizado';

        $documents->{min} = 1;
        $documents->{max} = 3;
        $documents->{label} = 'Sube de 1 a 3 documentos de los tipos antes mencionados (Opcional)';
        $documents->{optional} = 1;

        $sitio->{label} = 'Agrega un link de un sitio web con contenido que incluya material u obras adicionales de tu autoría (Opcional)';
        $sitio->{optional} = 1;

        $guion->{label} = 'Sinopsis del guion (obligatorio) y los requisitos anteriores.';

        $dramaturgia->{label} = 'Texto que demuestre los más representativo de su obra mínimo de 20 cuartillas, máximo de 2 textos inéditos (Solo para dramaturgia)';
        $dramaturgia->{optional} = 1;
    }elsif($categoria eq 'Creadores con trayectoria'){
        $images->{min} = 8;
        $images->{max} = 8;
        $images->{label} = 'Sube 8 imágenes de las obras que ha realizado';

        $documents->{min} = 2;
        $documents->{max} = 2;
        $documents->{label} = 'Sube 2 documentos de los tipos antes mencionados';
    
        $notes->{min} = 2;
        $notes->{max} = 2;
        $notes->{label} = 'Sube 2 notas de prensa sobre tu trabajo';


        $sitio->{label} = 'Agrega un link de un sitio web con contenido que incluya material u obras adicionales de tu autoría';
        $guion->{label} = 'Sinopsis del guion (obligatorio) y 2 guiones de su autoría, y los requisitos anteriores.';
    
    	$dramaturgia->{label} = 'Texto que demuestre los más representativo de su obra mínimo de 20 cuartillas, máximo de 3 textos inéditos (Solo para dramaturgia)';
        $dramaturgia->{optional} = 1;
   

    }elsif($categoria eq 'Desarrollo artístico individual'){
        $images->{min} = 8;
        $images->{max} = 8;
        $images->{label} = 'Sube 8 imágenes de las obras que ha realizado';

        $documents->{min} = 3;
        $documents->{max} = 3;
        $documents->{label} = 'Sube 3 documentos de los tipos antes mencionados';
        
        $notes->{min} = 3;
        $notes->{max} = 3;
        $notes->{label} = 'Sube 3 notas de prensa sobre tu trabajo';

        $sitio->{label} = 'Agrega un link de un sitio web con contenido que incluya material u obras adicionales de tu autoría';
        $guion->{label} = 'Sinopsis del guion (obligatorio) y 2 guiones de su autoría, y los requisitos anteriores.';
    
    	$dramaturgia->{label} = 'Texto que demuestre los más representativo de su obra mínimo de 20 cuartillas, máximo de 3 textos inéditos (Solo para dramaturgia)';
        $dramaturgia->{optional} = 1;

    }elsif($categoria eq 'Producción artística colectiva'){
        $images->{min} = 8;
        $images->{max} = 8;
        $images->{label} = 'Sube 8 imágenes de las obras que ha realizado';

        $documents->{min} = 2;
        $documents->{max} = 2;
        $documents->{label} = 'Sube 2 documentos de los tipos antes mencionados';
    
        $notes->{min} = 2;
        $notes->{max} = 2;
        $notes->{label} = 'Sube 2 notas de prensa sobre tu trabajo';

        $sitio->{label} = 'Agrega un link de un sitio web con contenido que incluya material u obras adicionales de tu autoría';
        $guion->{label} = 'Sinopsis del guion (obligatorio) y 2 guiones de su autoría, y los requisitos anteriores.';
    	
    	$dramaturgia->{label} = 'Texto que demuestre los más representativo de su obra mínimo de 20 cuartillas, máximo de 3 textos inéditos (Solo para dramaturgia)';
        $dramaturgia->{optional} = 1;
    }

    my $vars = {
    	conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        current_qty => $current_qty,
        categoria => $categoria,
        images => $images,
        documents => $documents,
        sitio => $sitio,
        guion => $guion,
        notes => $notes,
        dramaturgia => $dramaturgia
    };

    $template->process('Chapix/Form/tmpl/teatro_form.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;           
}

sub cine_video_form {
	my $current_qty = shift || 0;
	my $categoria = shift || 'No categoria';
    my $HTML = '';
    my $template = Template->new();

    my $sitio = {};
    my $demo_reel = {};
    my $video = {};
    my $cortometraje = {};
    my $guion = {};

    if($categoria eq 'Jóvenes creadores'){
    	$video->{label} = '1 link de un video de su autoría que de muestra de su trabajo (Solo para subcategoria video)';
        $video->{optional} = 1;   	
    	
        $cortometraje->{label} = 'Cortometraje (Solo para subcategoria cortometraje)';
    	
    	$guion->{label} = 'Guion de tu autoría. (Solo para subcategoria guion)';
        $guion->{optional} = 1;
    }elsif($categoria eq 'Creadores con trayectoria'){
   		$video->{label} = '1 link de un video de su autoría que de muestra de su trabajo (Solo para subcategoria video)';
    	$video->{optional} = 1;    
        
    	$cortometraje->{label} = 'Cortometraje.  (Solo para subcategoria cortometraje)';
    	
    	$guion->{label} = 'Guion de tu autoría. (Solo para subcategoria guion)';
        $guion->{optional} = 1;
    	
    	$demo_reel->{label} = '1 demo reel de los trabajos realizados (resumen de 5 minutos ej. link de YouTube).';

    	$sitio->{label} = '1 liga a sitio de internet que incluya material u obra adicional del postulante.';

    }elsif($categoria eq 'Desarrollo artístico individual'){
    	$video->{label} = '2 links de videos de su autoría que demuestre su trabajo (Solo para subcategoria video)';
    	$video->{optional} = 1;    
        
    	$cortometraje->{label} = 'Cortometraje.  (Solo para subcategoria cortometraje)';
    	
    	$guion->{label} = 'Guion de tu autoría. (Solo para subcategoria guion)';
    	$guion->{optional} = 1;

    	$demo_reel->{label} = '1 demo reel de los trabajos realizados (resumen de 5 minutos ej. link de YouTube).';

    	$sitio->{label} = '1 liga a sitio de internet que incluya material u obra adicional del postulante.';

    }elsif($categoria eq 'Producción artística colectiva'){
    	$video->{label} = '1 link de un video de su autoría que de muestra de su trabajo (Solo para subcategoria video)';
    	$video->{optional} = 1;    
        
    	$cortometraje->{label} = 'Cortometraje. (Solo para subcategoria cortometraje)';
    	
    	$guion->{label} = 'Guion de tu autoría. (Solo para subcategoria guion)';
    	$guion->{optional} = 1;

    	$demo_reel->{label} = '1 demo reel de los trabajos realizados (resumen de 5 minutos ej. link de YouTube).';

    	$sitio->{label} = '1 liga a sitio de internet que incluya material u obra adicional del postulante.';
    }

    my $vars = {
    	conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        current_qty => $current_qty,
        categoria => $categoria,
        video => $video,
        demo_reel => $demo_reel,
        sitio => $sitio,
        cortometraje => $cortometraje,
        guion => $guion
    };

    $template->process('Chapix/Form/tmpl/cine_video_form.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;       
}

sub letras_form {
	my $current_qty = shift || 0;
	my $categoria = shift || 'No categoria';
    my $HTML = '';
    my $template = Template->new();

    my $portadas = {};
    my $sitio = {};
    my $texto = {};

    if($categoria eq 'Jóvenes creadores'){
        $portadas->{min} = 1;
        $portadas->{max} = 3;
        $portadas->{label} = '1 a 3 portadas de libros publicados (Opcional)';
        $portadas->{optional} = 1;

        $sitio->{label} = 'Agrega un link a un sitio web con contenido que incluya material u obras adicionales de tu autoría (Opcional)';
        $sitio->{optional} = 1;

        $texto->{label} = '1 texto inédito o publicado de su autoría';
    }elsif($categoria eq 'Creadores con trayectoria'){
        $portadas->{min} = 1;
        $portadas->{max} = 1;
        $portadas->{label} = '1 portada de libros publicados';
        
        $sitio->{label} = 'Agrega un link a un sitio web con contenido que incluya material u obras adicionales de tu autoría';
        
        $texto->{label} = '2 textos inéditos o publicado de su autoría';
    
    }elsif($categoria eq 'Desarrollo artístico individual'){
        $portadas->{min} = 2;
        $portadas->{max} = 2;
        $portadas->{label} = '2 portadas de libros publicados';
        
        $sitio->{label} = 'Agrega un link a un sitio web con contenido que incluya material u obras adicionales de tu autoría';

        $texto->{label} = '2 textos inéditos o publicado de su autoría';
    }elsif($categoria eq 'Producción artística colectiva'){
        $portadas->{min} = 1;
        $portadas->{max} = 1;
        $portadas->{label} = '1 portada de libros publicados';
        
        $sitio->{label} = 'Agrega un link a un sitio web con contenido que incluya material u obras adicionales de tu autoría';
        
        $texto->{label} = '2 textos inéditos o publicado de su autoría'; 
    }

    my $vars = {
    	conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
        current_qty => $current_qty,
        categoria => $categoria,
        portadas => $portadas,
        sitio => $sitio,
        texto => $texto
    };

    $template->process('Chapix/Form/tmpl/letras_form.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;       
}

sub close_screen{
    my $HTML = "";
    my $template = Template->new();
    my $logout = '<a id="close_sess" href="/Accounts/Logout" class="btn waves-effect waves-light blue darken-2 right" type="button" value="Cerrar">Cerrar</a>';
    
    my $folio = $dbh->selectrow_array("SELECT folio FROM project_registry WHERE account_id = ?",{},$sess{account_id});

    my $vars = {
        conf  => $conf,
        sess => \%sess,
        loc => \&loc,
        msg   => msg_print(),
    	logout => $logout,
    	folio => $folio
    };

    $template->process('Chapix/Form/tmpl/invoice-tmpl.html',$vars,\$HTML) or $HTML = $template->error();
    return $HTML;
}

sub bases_page {
    my $accept = CGI::a({-href=>"/Form/Invoice?accept=true", class=>"waves-effect waves-light btn blue darken-2"},'Aceptar Terminos');
    my @breadcrumbs = ('Registra tu proyecto','Evidencias de tu proyecto','Descripción de tu proyecto','Informacíon general de tu proyecto','Retribución social','Desglose de gastos','Aceptar Terminos');    
    my $logout = CGI::a({-href=>"/Accounts/Logout", class=>"btn-floating btn-large tooltipped blue darken-2", 'data-tooltip'=>"Cerrar Sesión", 'data-position'=>"left"},'<i class="large material-icons">close</i>');
    

    my $HTML = "";
    my $template = Template->new();
    my $vars = {
        REQUEST => $_REQUEST,
        conf => $conf,
        sess => \%sess,
        accept => $accept,
        msg => msg_print(),
        loc => \&loc,
        breadcrumbs => \@breadcrumbs,
        logout => $logout,
    };

    $template->process("Chapix/Form/tmpl/bases_tmpl.html", $vars, \$HTML) or $HTML = $template->error();
    return $HTML;
}




sub invoice_page { 
    my $logout = '<a id="close_sess" href="/Accounts/Logout" class="btn waves-effect waves-light blue darken-2 right" type="button" value="Cerrar">Cerrar</a>';
    my $information = {};
 
    $information->{account_info} = $dbh->selectrow_hashref("SELECT * FROM accounts WHERE account_id = ?",{},$sess{account_id});
    $information->{project_description} = $dbh->selectrow_hashref("SELECT * FROM projects_description WHERE account_id = ?",{},$sess{account_id});
    $information->{project_general_information} = $dbh->selectrow_hashref("SELECT * FROM projects_general_information WHERE account_id = ?",{},$sess{account_id});
    $information->{project_info} = $dbh->selectrow_hashref("SELECT * FROM projects_register WHERE account_id = ?",{},$sess{account_id});

    my $HTML = "";
    my $template = Template->new();
    my $vars = {
        REQUEST => $_REQUEST,
        conf => $conf,
        sess => \%sess,
        msg => msg_print(),
        logout => $logout,
        information => $information
    };

    $template->process("Chapix/Form/tmpl/invoice-tmpl.html", $vars, \$HTML) or $HTML = $template->error();
    return $HTML;
}


sub breadcrumbs_compose{
	my $params = shift;
	my $current_view = $params->{current_view} || 'no-view';
	my $current_step = $params->{current_step} || 'no-step';
	my $steps = $params->{steps} || [
		{ 
			step_data => { 
				step_circle => 1, 
				step_title => 'No Title', 
				is_completed => 1 
			}, 
			tooltip_data => { 
				step => 'Primer Paso', 
				title => 'No Title', 
				description => 'no description'
			}
		},
	];

	my $html = '<ul class="steps-box">';

    foreach my $step(@{$steps}){
    	my $step_class = '';
    	if($current_view eq $step->{step_data}->{step_title} or $_REQUEST->{go_to} eq $step->{step_data}->{step_circle}){
    		$step_class = 'is-current ';
    	}

		if($step->{step_data}->{is_completed}){
			$step_class .= 'is-completed';
			$html .= '<li class="steps '.$step_class.'" onclick="goToStep('.$step->{step_data}->{step_circle}.')">'; 	
		}elsif($step->{step_data}->{skipped}){
			$html .= '<li class="steps '.$step_class.'" onclick="goToStep('.$step->{step_data}->{step_circle}.')">';
		}else{
			$html .= '<li class="steps '.$step_class.'">';
		}

		my $current_step = $dbh->selectrow_array("SELECT step FROM accounts WHERE account_id = ?",{},$sess{account_id});
    	
		if($current_step eq $step->{step_data}->{step_circle}){
    		$html .= '<div class="steps-point" onclick="goToStep('.$step->{step_data}->{step_circle}.')">'; 	
    	}else{
    		$html .= '<div class="steps-point">';
    	}
    	
    	$html .=    '<div class="steps-circle">'.$step->{step_data}->{step_circle}.'</div>'.
					      	'<div class="steps-title">'.$step->{step_data}->{step_title}.'</div>'.
					      	'<div class="steps-tooltip">'.
					        	'<div class="tooltip-step">'.$step->{tooltip_data}->{step}.'</div>'.
					        	'<div class="tooltip-title">'.$step->{tooltip_data}->{title}.'</div>'.
					        	'<div class="tooltip-description">'.$step->{tooltip_data}->{description}.'</div>'.
					      	'</div>'.
					    '</div>'.
					'</li>';
    }

    $html .= '</ul>';
	
	return $html;
}
1;
