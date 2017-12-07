$(function(){    
    var formValidator = (function(){
	var module = {
	    validate:validateForm,
	    validateLength:validateCharLimit
	}
	return module;
	
	
	function validateForm(id){
	    var form = document.getElementById(id);
	    var emptyFields = '';
	    var curpNoValida = ''
	    for(var i=0; i < form.elements.length; i++){
			if(form.elements[i].value === '' && form.elements[i].hasAttribute('required')){
			    emptyFields += '-'+$("label[for='"+form.elements[i].id+"']").text();
			    emptyFields += '\n';
			    form.elements[i].className += 'invalid';
			}else{
				form.elements[i].classList.remove('invalid');
				if(form.elements[i].type !== 'checkbox'){
					form.elements[i].className += 'valid';
				}
			}
			if(form.elements[i].id === 'curp'){
				var regex = /^[A-Z]{1}[AEIOU]{1}[A-Z]{2}[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[HM]{1}(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)[B-DF-HJ-NP-TV-Z]{3}[0-9A-Z]{1}[0-9]{1}$/i;
				if(!regex.test(form.elements[i].value)){
					curpNoValida = 'El campo curp no cuenta con el formato requerido';
					form.elements[i].className += 'invalid';
				}
			}else{
				form.elements[i].classList.remove('invalid');
				if(form.elements[i].type !== 'checkbox'){
					form.elements[i].className += 'valid';
				}
			}
	    }
	    if(emptyFields || curpNoValida){
			alert(curpNoValida+'\n\n'+'Existen campos requieridos\n'+emptyFields);
			return false
	    } 
	    return true;
	}
	
	function validateCharLimit(form){
	    var invalidLength = '';
	    $(form).each(function(){
		  	if($(this).find(':input').hasClass('invalid')){
		  	    invalidLength = 'Invalido';
		  	}
	    });
	    if(invalidLength){
	  		alert('Campos exceden el numbero de caracteres minimos');
	  		return false;
	    }
	    return true;
	}
    })();

    var animation = (function(){

	var module = {
	    entrance:entranceAnimation,
	    exit:exitAnimation
	};
	return module;
	///////////////////////////////////////////////////////////
	function entranceAnimation(){
	    if($('.animated').hasClass('hidden')){
		$('.animated').removeClass('hidden');
	    }
	    $('.animated').addClass('bounceInRight');
	}

	function exitAnimation(){
	    $('.animated').removeClass('bounceInRight');
	    $('.animated').addClass('bounceOutLeft');
	    $('.animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(e){
		e.stopPropagation();
		$('.animated').addClass('hidden');
	    });
	}

    })();


    var stepsModule = (function(){
	var steps = $('.steps');
	// Timer for delay, must same as CSS!
	var stepsTimer = 200;
	var stepsTimerL = 400;

	var module = {
	    update:updateSteps
	};

	return module;
	/////////////////////////////////////
	function updateSteps(){
	    // remove mini between current
	    steps.addClass('is-mini');
	    
	    update();
	    
	    // Bounce Animation
	    steps.addClass('is-circle-entering');
	    
	    // Delay for BounceIn
	    setTimeout(bounceInDelay,stepsTimer);
	}

	function bounceInDelay(){
	    steps.each(function(i) {
		var self = $(this),
	        timer = (stepsTimer * 2) * i;
		setTimeout(function() {
		    // Line Flow
		    self.addClass('is-line-entering');
		    if(self.hasClass('is-current')) {
			// Title FadeIn
			steps.addClass('is-title-entering');
		    }
		}, timer);
	    });
	}

	function update(){
	    steps.each(function(i){
		var self = $(this);
		if (self.hasClass('is-current')) {
		    self.removeClass('is-mini');
		    self.prev().removeClass('is-mini');
		    self.next().removeClass('is-mini');
		}	
	    });
	}
    })();
    
    animation.entrance();
    stepsModule.update();
    $('form').removeAttr('onsubmit');

	//$('textarea').prop('required',true);
	$('#bibliografia').removeAttr('required');

    $('form').on('submit',function(e){
		e.preventDefault();
		if(this.id === 'participant_form'){
			if($('#submit_participants').val() === 'Finalizar Colectivo'){
				if($('#participant-size').val() <= 1){
					Materialize.toast('En modo colectivo debe de tener más de 1 participante',3000);
					return false;
				}
			}
			$('.section').addClass('loading');
		    var payload = {};
		    if(!$('#agregar').length){
				var participantData = $(this).serializeArray();
				for(var i = 0; i < participantData.length; i++){
				    payload[participantData[i].name] = participantData[i].value;
				}
		    }
		    payload._submit = $('#submit_participants').val();
		    payload._submitted_participants = 1;
		    animation.exit();
		    $.post(this.action,payload)
			.done(function(){
			    window.location.replace('/FOMAC');
			});
		}else if(this.id === 'project_registry_form'){
			$('.section').addClass('loading');
		    var payload = {};
		    var registryData = $(this).serializeArray();
		    for(var i = 0; i < registryData.length; i++){
				payload[registryData[i].name] = registryData[i].value;
		    }
		    payload._submit = $('#submit_project_registry').val();
		    payload._submitted_register_project = 1;
		    if($('#tipo-proyecto-colectivo').hasClass('active-project')){
				payload.disciplina = 'Interdisciplinara';
				payload.tipo_proyecto = 'Colectivo';
	 	    }else{
	 			payload.tipo_proyecto = 'Individual';
	 	    }
	 	    animation.exit();
	 	    $.post(this.action,payload)
			.done(function(){
			    window.location.replace('/FOMAC');
			});
		}else if(this.name === 'retribution_form'){
			$('.section').addClass('loading');
		    if(!formValidator.validateLength(this)){
				return false;
		    }

			var $form = $('#retribution_form').get(0);
		    var formData = new FormData($form);

		    formData.append('_submitted_retribution',1);
		    formData.append('_submit',$('#submit_retribution').val());
		    formData.append('numero_contribuciones',$('#contribucion-value').html());

		    $.post({
				url:'/Form',
				action:'POST',
				data:formData,
				contentType:false,
				processData:false
		    })
			.done(function(){
			    animation.exit();
			    window.location.replace('/FOMAC');
			});

		}else{
		    var validation = 'validate_'+this.name;
		    if(this.name === 'project_general_information' || this.name === 'retribution_form'){
				if(!formValidator.validateLength(this)){
				    return false;
				}
		    }
		    if(formValidator.validate(this.id)){
		    	$('.section').addClass('loading');
				var data = $(this).serializeArray();
				var payload = {};
				if(this.name === 'project_general_information'){
 					var $form = $('#project_general_information').get(0);
					var formData = new FormData($form);
					
					formData.append('_submit',$('input[name=_submit]').val());
				
			      	$.post({
						url:'/Form',
						action:'POST',
						data:formData,
						contentType:false,
						processData:false
				    })
					.done(function(){
					    animation.exit();
					    window.location.replace('/FOMAC');
					});
	      		}else{
					for(i = 0; i < data.length; i++){
				    payload[data[i].name] = data[i].value;
					}
					payload._submit = $('input[name=_submit]').val();
					animation.exit();
					$.post(this.action,payload)
					.done(function(){
						window.location.replace('/FOMAC');
					});	
				}
		    }
		}
    });

	$('#continuar-anexos').on('click',function(){
		$('.section').addClass('loading');
		animation.exit();
		var payload = {};
		payload._submitted_continue = 1;
		$.post('/Form',payload)
		.done(function(){
			window.location.replace('/FOMAC');
		});
	});


    $('#submit_project_registry').on('click',function(){
		if(formValidator.validate('project_registry_form')){
			if($('#categoria').val() === 'Producción artística colectiva'){
				if(!multipleDisciplinesChecked()){
					alert('En interdisciplinara debe elegir mas de una disciplina');
					return false;
				}
			}
		    $('#project_registry_form').submit();	
		}

		function multipleDisciplinesChecked(){
			var checked = 0;
			
			if($('#artes_visuales').prop("checked")){
				checked++;
			}
			if($('#danza').prop("checked")){
				checked++;
			}
			if($('#musica').prop("checked")){
				checked++;
			}
			if($('#teatro').prop("checked")){
				checked++;
			}
			if($('#cine_video').prop("checked")){
				checked++;
			}
			if($('#letras').prop("checked")){
				checked++;
			}

			return checked > 1;
		}
    });

    $('#submit_participants').on('click',function(){
		if($('#agregar').length){
		    $('#participant_form').submit();
		}else if(formValidator.validate('participant_form')){
		    $('#participant_form').submit();	
		}
    });

    $('#submit_retribution').on('click',function(){
		if(formValidator.validate('retribution_form')){
		    $('#retribution_form').submit();
		}
    });

    var categoriaChangeHandler = function(){
		var that = this;
		var disciplinaHolder = $('#disciplina-holder');
		if(disciplinaHolder.hasClass('hidden')){	
		    populateDisciplina();
		    disciplinaHolder.removeClass('hidden');
		    disciplinaHolder.addClass('animated bounceInRight');
		    disciplinaHolder.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',function(e){
			e.stopPropagation();
				$('#disciplina-holder').removeClass('animated bounceInRight');
		    });
		}else{
		    disciplinaHolder.addClass('animated bounceOutLeft');
		    disciplinaHolder.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',function(e){
			e.stopPropagation();
			disciplinaHolder.addClass('hidden');
			$('#disciplina-holder').removeClass('animated bounceOutLeft');
			$(that).trigger('change');
		    });
		}
		
		function populateDisciplina(){
		    var categoria = $(that).find(":selected").val();
		    if(categoria){
		    	switch(categoria){
				case 'Jóvenes creadores':
				case 'Creadores con trayectoria':
				case 'Desarrollo artístico individual':
				    disciplinaHolder.html(
					'<div class="col s12">'+
					    '<label for="disciplina">Disciplina</label>'+
					    '<select id="disciplina" name="disciplina" required>'+
					    '<option value="" disabled selected>Selecciona la disciplina</option>'+
					    '<option value="Artes visuales">Artes visuales</option>'+
					    '<option value="Danza">Danza</option>'+
					    '<option value="Música">Música</option>'+
					    '<option value="Teatro">Teatro</option>'+
					    '<option value="Cine y video">Cine y video</option>'+
					    '<option value="Letras">Letras</option>'+
					    '</select>'+
					    '</div>');
				    if($('#disciplina-value').length){
				    	$('#disciplina').val($('#disciplina-value').val());	
				    }
				    $('#disciplina').material_select();
				    $('#tipo-proyecto-colectivo').removeClass('active-project');
				    $('#tipo-proyecto-individual').addClass('active-project');
				    break;
				case 'Producción artística colectiva':
				    disciplinaHolder.html(
						'<div class="col s12">'+
					    '	<label for="disciplina">Disciplina (Selecciona 2 o mas disciplinas)</label>'+
					    '	<div class="row">'+
					    '		<div class="col s12">'+
					    '			<span id="disciplina" class="bold">Interdisciplinara</span>'+
					    '		</div>'+
					    '	</div>'+
					    '	<div class="row">'+
					    '		<div class="col s12">'+
					    '		<span class="margin-right">'+
    					'		 	<input type="checkbox" class="filled-in" id="artes_visuales" name="artes_visuales"/>'+
      					'			<label for="artes_visuales">Artes Visuales</label>'+
    					'		</span>'+
    					'		<span class="margin-right">'+
    					'		 	<input type="checkbox" class="filled-in" id="danza" name="danza"/>'+
      					'			<label for="danza">Danza</label>'+
    					'		</span>'+
    					'		<span class="margin-right">'+
    					'		 	<input type="checkbox" class="filled-in" id="musica" name="musica"/>'+
      					'			<label for="musica">Música</label>'+
    					'		</span>'+
    					'		<span class="margin-right">'+
    					'		 	<input type="checkbox" class="filled-in" id="teatro" name="teatro"/>'+
      					'			<label for="teatro">Teatro</label>'+
    					'		</span>'+
    					'		<span class="margin-right">'+
    					'		 	<input type="checkbox" class="filled-in" id="cine_video" name="cine_video"/>'+
      					'			<label for="cine_video">Cine y Video</label>'+
    					'		</span>'+
    					'		<span class="margin-right">'+
    					'		 	<input type="checkbox" class="filled-in" id="letras" name="letras"/>'+
      					'			<label for="letras">Letras</label>'+
    					'		</span>'+
					    '		</div>'+
					    '	</div>'+
					    '</div>');
				    $('#tipo-proyecto-individual').removeClass('active-project');
				    $('#tipo-proyecto-colectivo').addClass('active-project');
				    if($('#tipo_proyecto_value').length){
		
					if($('#tipo_proyecto_value').val() === 'Colectivo'){
							if($('#artes_visuales_value').val() === '1'){
								$('#artes_visuales').prop("checked",true);
							}
							if($('#danza_value').val() === '1'){
								$('#danza').prop("checked",true);
							}
							if($('#musica_value').val() === '1'){
								$('#musica').prop("checked",true);
							}
							if($('#teatro_value').val() === '1'){
								$('#teatro').prop("checked",true);
							}
							if($('#cine_video_value').val() === '1'){
								$('#cine_video').prop("checked",true);
							}
							if($('#letras_value').val() === '1'){
								$('#letras').prop("checked",true);
							}
						}
					}
				    break;
				}
		    }
		}
    };

    $('#categoria').change(categoriaChangeHandler);

    if($('#disciplina-value').length){
    	$('#categoria').trigger('change');
    }

    $('#agregar').on('click',function(){
	if(formValidator.validate('participant_form')){
		$('.section').addClass('loading');
	    var $participantsForm = $('#participant_form') 
	    var participantData = $participantsForm.serializeArray();
	    var payload = {};

	    if(participantData.length){
			for(var i = 0; i < participantData.length; i++){
			    payload[participantData[i].name] = participantData[i].value;
			}	
	    }

	    payload._submit = $('#agregar').val();
	    payload._submitted_participants = 1;
	    $.post(this.action,payload)
		.done(function(){
		   window.location.replace('/FOMAC');
		});
	}
    });

    $('.cargar_documentos').on('click',function(){
		var id = $(this).attr('id');
		
		//if(formValidator.validate('documents_'+id)){
		var $form = $('#documents_'+id).get(0);
	    var formData = new FormData($form);

		$('.section').addClass('loading');
	    formData.append('_submitted_participant_documents',1);
	    formData.append('_submit',$(this).val());

	    $.post({
		url:'/Form',
		action:'POST',
		data:formData,
		contentType:false,
		processData:false
	    })
		.done(function(){
		    animation.exit();
		   window.location.replace('/FOMAC');
		});
		//}
    });

    $('#terminar_carga').on('click',function(){
	var payload = {
	    _submit:$(this).val(),
	    _submitted_participant_documents:1
	};

	$.post({
	    url:'/Form',
	    action:'POST',
	    data:payload
	})
	    .done(function(){
		window.location.replace('/FOMAC');
	    })
    });

    $('#continuar-docs').on('click',function(){
	    $('.section').addClass('loading');
		var payload = {
		    _submit:$(this).val(),
		    _submitted_participant_documents:1
		};

		$.post({
		    url:'/Form',
		    action:'POST',
		    data:payload
		})
	    .done(function(){
		window.location.replace('/FOMAC');
	    })
    });

    $('#continuar-general').on('click',function(){
	    $('.section').addClass('loading');
		var payload = {
		    _submit:$(this).val(),
		    _submitted_project_general_information:1
		};

		$.post({
		    url:'/Form',
		    action:'POST',
		    data:payload
		})
	    .done(function(){
			window.location.replace('/FOMAC');
	    })
    });

    $('#continuar-retribucion').on('click',function(){
    	$('.section').addClass('loading');
    	var payload = {
    		_submit:$(this).val(),
    		_submitted_retribution:1
    	};

    	$.post({
    		url:'/Form',
    		action:'POST',
    		data:payload
    	})
    	.done(function(){
    		window.location.replace('/FOMAC');
    	});
    });

    var modalidadHandler = function(){
		var that = this;
		var actividadHolder = $('#actividad-holder');
		
		if(actividadHolder.hasClass('hidden')){
		    populateActividad();
		    actividadHolder.removeClass('hidden');
		    actividadHolder.addClass('animated bounceInRight');
		    actividadHolder.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',function(e){
			e.stopPropagation();
				$('#actividad-holder').removeClass('animated bounceInRight');
		    });
		}else{
		    actividadHolder.addClass('animated bounceOutLeft');
		    actividadHolder.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',function(e){
			e.stopPropagation();
			actividadHolder.addClass('hidden');
			$('#actividad-holder').removeClass('animated bounceOutLeft');
				$(that).trigger('change');
				$('#actividad_a_realizar').trigger('change');
		    });
		}

		function populateActividad(){
		    var modalidad = $(that).find(":selected").val();
		    if(modalidad){
			switch(modalidad){
			case 'Artistica':
			    actividad = '<label for="actividad_a_realizar">Actividad artística</label>'+
				'<select id="actividad_a_realizar" name="actividad_a_realizar"  required>'+
				'<option value="" disabled selected>Selecciona la actividad</option>'+
				'<option value="Presentaciones escénicas">Presentaciones escénicas</option>'+
				'<option value="Conciertos">Conciertos</option>'+
				'<option value="Recitales individuales o grupales">Recitales individuales o grupales</option>'+
				'</select>';
			    break;
			case 'Formativa':
			    actividad = '<label for="actividad_a_realizar">Actividad formativa</label>'+
				'<select id="actividad_a_realizar" name="actividad_a_realizar"  required>'+
				'<option value="" disabled selected>Selecciona la actividad</option>'+
				'<option value="Talleres">Talleres</option>'+
				'<option value="Cursos">Cursos</option>'+
				'</select>';
			    break;
			case 'Difusion':
			    actividad = '<label for="actividad_a_realizar">Actividad de difusión</label>'+
				'<select id="actividad_a_realizar" name="actividad_a_realizar"  required>'+
				'<option value="" disabled selected>Selecciona la actividad</option>'+
				'<option value="Conferencias">Conferencias</option>'+
				'<option value="Mesas redondas">Mesas redondas</option>'+
				'<option value="Lecturas publicas">Lecturas públicas</option>'+
				'</select>';
			    break;	
			}
			actividadHolder.html(actividad);
			if($('#actividad-value').length){
				$('#actividad_a_realizar').val($('#actividad-value').val());	
			}
			$('#actividad_a_realizar').material_select();
			$('#actividad_a_realizar').change(actividadHandler);
		    }else{
				actividadHolder.addClass('hidden');
				actividadHolder.html('');
		    }	
		}

		function actividadHandler(){
			var that_actividad = this;
			var contribucionHolder = $('#contribucion-holder');
			if(contribucionHolder.hasClass('hidden')){
			    populateContribucion();
			    contribucionHolder.removeClass('hidden');
			    contribucionHolder.addClass('animated bounceInRight');
			    contribucionHolder.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',function(e){
					e.stopPropagation();
					$('#contribucion-holder').removeClass('animated bounceInRight');
			    });

			}else{
			    contribucionHolder.addClass('animated bounceOutLeft');
			    contribucionHolder.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',function(e){
				e.stopPropagation();
				contribucionHolder.addClass('hidden');

				$('#contribucion-holder').removeClass('animated bounceOutLeft');

					$(that_actividad).trigger('change');
			    });
			}

			function populateContribucion(){
		    	var actividad = $(that_actividad).find(":selected").val();
			    
			    if(actividad){

					switch(actividad){
						case 'Presentaciones escénicas':
						case 'Conciertos':
						case 'Recitales individuales o grupales':
							contribucion = '3 presentaciones';
						break;
						case 'Talleres':
							contribucion = '20 horas';
						break;
						case 'Cursos':
							contribucion = '5 conferencias';
						break;	
						case 'Conferencias':
						case 'Mesas redondas':
						case 'Lecturas publicas':
							contribucion = '5 presentaciones';
						break;
					}
					var fixture = '<div class="row no-margin-bottom">'+
							    		'<div class="col s12">'+
							    		 	'<label class="special-label" for="numero_contribuciones">Número de contribuciones</label>'+
							    		 '</div>'+
							    		'<div class="col s12">'+
							    			'<span class="field-description">Contribuciones necesarias según actividad a realizar</span>'+
							    		'</div>'+
								    '</div>'+
								    '<div id="contribucion-value" class="col s12">'+contribucion+'</div>';
						    
					contribucionHolder.html(fixture);
			    }else{
					contribucionHolder.addClass('hidden');
					contribucionHolder.html('');
			    }	
			}
		}


    };

    $('#modalidad').change(modalidadHandler);

    if($('#actividad-value').length){
    	$('#modalidad').trigger('change');
    	$('#actividad_a_realizar').trigger('change');
    }



	$('#iniciar').on('click',function(){
		$.post({
			url:'/Form',
			data:{_action:'start'}
		}).
		done(function(){
			window.location.replace('/FOMAC');
		})
	});
});

function goToStep(id){
	window.location.search = '?go_to='+id;
}	