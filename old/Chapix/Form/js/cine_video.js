$(function(){
	$('#submit_evidence').on('click',function(){
		var invalid = false;
		var invalidField = false;	

		var video = $("#video").val();
		var demoReel = '';
		var sitioweb = '';

		if($('#categoria').val() !== 'Jóvenes creadores'){
				demoReel = $('#demo_reel').val();
				sitioweb = $('#sitioweb').val();
		}

		var kardex;
		var carta_aceptacion;
		if($('#categoria').val() === 'Desarrollo artístico individual'){
			
			kardex = document.getElementById('boleta_kardex_file').files[0];
			carta_aceptacion = document.getElementById('carta_aceptacion_file').files[0];

		}

		$('.section').addClass('loading');
	    
		var guion = document.getElementById('guion_file').files[0];
		var sinopsisCortometraje = document.getElementById('sinopsis_cortometraje_file').files[0];
        var guionCortometraje = document.getElementById('guion_cortometraje_file').files[0];
        var planCortometraje = document.getElementById('plan_cortometraje_file').files[0];
        var cartaAutorizacionCortometraje = document.getElementById('carta_autorizacion_cortometraje_file').files[0];

		var formData = new FormData();

		formData.append('_action','_cargar_evidencia');
		formData.append('_mode','cine_video');
		formData.append('_type','_guardar');
		formData.append('project_id',$('#project_id').val());
		formData.append('video_link',video);
		if(guion){
			formData.append('guion',guion);	
		}
		formData.append('categoria',$('#categoria').val());
		if(sinopsisCortometraje){
			formData.append('sinopsis_cortometraje',sinopsisCortometraje);
		}
		if(guionCortometraje){
			formData.append('guion_cortometraje',guionCortometraje);	
		}
		if(planCortometraje){
			formData.append('plan_rodaje_cortometraje',planCortometraje);
		}
		if(cartaAutorizacionCortometraje){
			formData.append('carta_autorizacion_cortometraje',cartaAutorizacionCortometraje);	
		}
		if($('#categoria').val() === 'Desarrollo artístico individual'){
			if(kardex){
				formData.append('boleta_kardex',kardex);	
			}
			if(carta_aceptacion){
				formData.append('carta_aceptacion',carta_aceptacion);
			}
		}
		if($('#categoria').val() !== 'Jóvenes creadores'){
			formData.append('demo_reel',demoReel);
			formData.append('sitioweb',sitioweb);
		}

		$.post({
			url:'/Form',
			method:'POST',
			data:formData,
			processData: false, 
            contentType: false,
		})
		.done(function(){
			window.location.replace('/FOMAC');
		});
	});

	function isOptional($element){
		var attr = $element.attr('optional');
		return typeof attr !== typeof undefined && attr !== false; 
	}

	function verificacionCortometraje(){
		return document.getElementById('sinopsis_cortometraje_file').files.length === 0 && document.getElementById('guion_cortometraje_file').files.length === 0 && document.getElementById('plan_cortometraje_file').files.length === 0 && document.getElementById('carta_autorizacion_cortometraje_file').files.length === 0;
	}
});
