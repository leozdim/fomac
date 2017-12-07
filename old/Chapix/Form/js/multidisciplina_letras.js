var documentosLetrasDropzone = (function(){
	var dropzone;
	var $selector = $('#letras_form #portadas');
	var dropzoneHasFiles = false;
	var maxReached = false;
	var module = {
		init:initialize,
		hasFiles:hasFiles(),
		getDropzone:getDropzone,
		hasFiles:hasFiles,
		optional:isOptional,
		validSize:valid,
		getSelector:selector
	};

	return module;

	function initialize(){
		var maxQty = $selector.attr('max-qty') - $selector.attr('current-qty');
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro (Espera a que se carguen las imágenes antes de presionar guardar)";
		if($selector.attr('current-qty') > 0){
			defaultMessage = "Elementos cargados ("+$selector.attr('current-qty')+"/"+$selector.attr('max-qty')+")";
		}
		
		if(maxQty === 0){
			//defaultMessage = "Evidencias cargadas";
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}

		dropzone = new Dropzone("#letras_form #portadas", 
			{
				url : "/Form", 
				dictDefaultMessage: defaultMessage,
				maxFiles:maxQty,
				autoProcessQueue:false
			} 
		);
		if(maxQty === 0){
			$selector.addClass('valid done');	
		}
		setUpEvents();
	}

	function setUpEvents(){
		dropzone.on('addedfile',addedFile);
		dropzone.on('maxfilesexceeded',maxfilesexceeded);
		dropzone.on('maxfilesreached',maxfilesreached);
		dropzone.on('removedFile',removedFile);
		dropzone.on('success',success);	
		dropzone.on('sending',sending);
	}

	function addedFile(file){
		if(dropzone.getQueuedFiles().length > 0){
			dropzoneHasFiles = true;
		}

		if(valid()){
			console.log('is valid');
			if($selector.hasClass('waiting') || $selector.hasClass('invalid')){
				$selector.removeClass('waiting');
				$selector.removeClass('invalid');
			}
			$selector.addClass('valid');
			dropzone.options.autoProcessQueue = true;
			dropzone.processQueue();
		}else{
			if($selector.hasClass('invalid')){
				$selector.removeClass('invalid');
			}
			$selector.addClass('waiting');
		}
	}

	function removedFile(file){
		if(dropzone.getQueuedFiles().length === 0){
			dropzoneHasFiles = false;
		}
	}

	function maxfilesreached(file){
		maxReached = true;
	}

	function maxfilesexceeded(file){
		dropzone.removeFile(file);
	}

	function success(file,response){
		dropzone.options.autoProcessQueue = true;
		if(maxReached){
			$selector.addClass('done');
			$selector.removeClass('invalid');
		}
	}

	function getDropzone(){
		return dropzone;
	}

	function hasFiles(){
		return dropzoneHasFiles;
	}

	function isOptional(){
		var attr = $selector.attr('optional');
		return typeof attr !== typeof undefined && attr !== false; 
	}

	function valid(){
		//return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
		return dropzone.getQueuedFiles().length >= 0 && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	function sending(file,xhr,formData){
		formData.append('_action', '_cargar_evidencia');
		formData.append('_mode','letras');
		formData.append('_type','portadas');
		formData.append('project_id',$('#project_id').val());
	}
})();

$(function(){
	documentosLetrasDropzone.init();
	
	$('#letras_form #submit_evidence').on('click',function(){
		var invalid = false;
		var invalidField = false;	

		var sitioweb = $("#letras_form #sitioweb").val();

		$('.section').addClass('loading');
	    
		var texto = document.getElementById('texto_inedito_file').files[0];

		var formData = new FormData();

		formData.append('_action','_cargar_evidencia');
		formData.append('_mode','letras');
		formData.append('_type','_guardar');
		formData.append('project_id',$('#project_id').val());
		formData.append('sitioweb_link',sitioweb);
		if(texto){
			formData.append('texto_inedito',texto);	
		}
		formData.append('categoria',$('#categoria').val());
		
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
});