Dropzone.autoDiscover = false;

var partiturasMusicaDropzone = (function(){
	var dropzone;
	var $selector = $('#musica_form #partituras');
	var dropzoneHasFiles = false;
	var maxReached = false;
	var module = {
		init:initialize,
		hasFiles:hasFiles,
		getDropzone:getDropzone,
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
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}

		dropzone = new Dropzone("#musica_form #partituras", 
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
		dropzone.on('removedFile',removedFile);
		dropzone.on('success',success);
		dropzone.on('maxfilesexceeded',maxfilesexceeded);
		dropzone.on('maxfilesreached',maxfilesreached);	
		dropzone.on('sending',sending);
	}

	function addedFile(){
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

	function sending(file,xhr,formData){
		formData.append('_action', '_cargar_evidencia');
		formData.append('_mode','musica');
		formData.append('_type','partituras');
		formData.append('project_id',$('#project_id').val());
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
})();

var documentosMusicaDropzone = (function(){
	var dropzone;
	var $selector = $('#musica_form #documentos');
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
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}

		dropzone = new Dropzone("#musica_form #documentos", 
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
		formData.append('_mode','musica');
		formData.append('_type','documentos');
		formData.append('project_id',$('#project_id').val());
	}
})();

var notasMusicaDropzone = (function(){
	var dropzone;
	var $selector = $('#musica_form #notas');
	var dropzoneHasFiles = false;
	var maxReached = false;
	var module = {
		init:initialize,
		hasFiles:hasFiles,
		getDropzone:getDropzone,
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

		dropzone = new Dropzone("#musica_form #notas", 
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

	function sending(file,xhr,formData){
		formData.append('_action', '_cargar_evidencia');
		formData.append('_mode','musica');
		formData.append('_type','notas');
		formData.append('project_id',$('#project_id').val());
	}

	function maxfilesreached(){
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

	function completed(){

	}

})();

$(function(){
	partiturasMusicaDropzone.init();
	documentosMusicaDropzone.init();
	notasMusicaDropzone.init();
	
	$('#musica_form #submit_evidence').on('click',function(){
		var invalid = false;
		var invalidField = false;	

		var video = $("#musica_form #video").val();
		var sitioweb = $("#musica_form #sitioweb").val();
		var audiomuestra = $('#musica_form #audiomuestra').val();

		$('.section').addClass('loading');

		var formData = new FormData();

		formData.append('_action','_cargar_evidencia');
		formData.append('_mode','musica');
		formData.append('_type','_guardar');
		formData.append('project_id',$('#project_id').val());
		formData.append('categoria',$('#categoria').val());
		formData.append('video_link',video);
		formData.append('sitioweb_link',sitioweb);
		formData.append('audiomuestra',audiomuestra);

		$.post({
			url:'/Form',
			method:'POST',
			data:formData,
			processData: false, 
            contentType: false,	
		})
		.done(function(){
			window.location.replace('/Form');
		});
	});

	function isOptional($element){
		var attr = $element.attr('optional');
		return typeof attr !== typeof undefined && attr !== false; 
	}
});
