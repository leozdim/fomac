$(function(){
	$('#cine_video_form #submit_evidence').on('click',function(){
		var invalid = false;
		var invalidField = false;	

		var video = $("#cine_video_form #video").val();
		var demoReel = '';
		var sitioweb = '';

		demoReel = $('#cine_video_form #demo_reel').val();
		sitioweb = $('#cine_video_form #sitioweb').val();

		$('.section').addClass('loading');
	    
		var guion = $('#cine_video_form #guion_file')[0].files[0];
		var sinopsisCortometraje = $('#cine_video_form #sinopsis_cortometraje_file')[0].files[0];
		var guionCortometraje = $('#cine_video_form #guion_cortometraje_file')[0].files[0];
		var planCortometraje = $('#cine_video_form #plan_cortometraje_file')[0].files[0];
		var cartaAutorizacionCortometraje = $('#cine_video_form #carta_autorizacion_cortometraje_file')[0].files[0];

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
		formData.append('demo_reel',demoReel);
		formData.append('sitioweb',sitioweb);
		

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
		return $('#cine_video_form #sinopsis_cortometraje_file')[0].files.length === 0 && $('#cine_video_form #guion_cortometraje_file')[0].files.length === 0 && $('#cine_video_form #plan_cortometraje_file')[0].files.length === 0 && $('#cine_video_form #carta_autorizacion_cortometraje_file')[0].files.length === 0;
	}
});
