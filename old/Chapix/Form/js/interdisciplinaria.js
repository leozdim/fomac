Dropzone.autoDiscover = false;

/*var catalogoArtesVisualesDropzone = (function(){
	var dropzone;
	var $selector = $('#artes_visuales_form #catalogo');
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
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		if(maxQty === 0){
			//defaultMessage = "Evidencias cargadas";
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}

		dropzone = new Dropzone("#artes_visuales_form #catalogo", 
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
		//dropzone.on('queuecomplete',completed);
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
		formData.append('_mode','artes_visuales');
		formData.append('_type','catalogo');
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	/*function addedFile(file){

	}*/

	/*function completed(){

	}
})();

var notasArtesVisualesDropzone = (function(){
	var dropzone;
	var $selector = $('#artes_visuales_form #notas');
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
		var maxQty = $('#artes_visuales_form #notas').attr('max-qty') - $selector.attr('current-qty');
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		if(maxQty === 0){
			//defaultMessage = "Evidencias cargadas";
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}

		dropzone = new Dropzone("#notas", 
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
		//dropzone.on('queuecomplete',completed);
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
		formData.append('_mode','artes_visuales');
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	/*function completed(){

	}

})();

var documentosArtesVisualesDropzone = (function(){
	var dropzone;
	var $selector = $('#artes_visuales_form #documentos');
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
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		if(maxQty === 0){
			//defaultMessage = "Evidencias cargadas";
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}

		dropzone = new Dropzone("#artes_visuales_form #documentos", 
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
		//dropzone.on('queuecomplete',completed);
		
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	function sending(file,xhr,formData){
		formData.append('_action', '_cargar_evidencia');
		formData.append('_mode','artes_visuales');
		formData.append('_type','documentos');
		formData.append('project_id',$('#project_id').val());
	}

	/*function completed(){

	}

	
})();

var imagenesArtesVisualesDropzone = (function(){
	var dropzone;
	var $selector = $('#imagenes');
	var maxReached = false;
	var dropzoneHasFiles = false;
	var module = {
		init:initialize,
		getDropzone:getDropzone,
		hasFiles:hasFiles,
		optional:isOptional,
		validSize:valid,
		getSelector:selector
	};

	return module;

	function initialize(){
		var maxQty = $selector.attr('max-qty') - $selector.attr('current-qty');
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		if(maxQty === 0){
			//defaultMessage = "Evidencias cargadas";
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}
		dropzone = new Dropzone("#artes_visuales_form #imagenes", 
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
		dropzone.on('maxfilesexceeded',maxfilesexceeded);
		dropzone.on('maxfilesreached',maxfilesreached);
		dropzone.on('sending',sending);
		dropzone.on('addedfile',addedFile);
		dropzone.on('removedFile',removedFile);
		dropzone.on('success',success);
		//dropzone.on('sending',sending);
		//dropzone.on('queuecomplete',completed);
		
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

	function sending(file, xhr, formData){
		formData.append('_action','_cargar_evidencia');
		formData.append('_mode','artes_visuales');
		formData.append('_type','imagenes');
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	/*function addedFile(file){

	}*/

	/*function sending(file,xhr,formData){
		formData.append('_action', '_cargar_evidencia');
		formData.append('_mode','artes_visuales');
		formData.append('project_id', $("#project_id").val());
	}*/

	/*function completed(){

	}
})();*/

//END ARTES VISUALES

/*var documentosDanzaDropzone = (function(){
	var dropzone;
	var $selector = $('#danza_form #documentos');
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
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		if(maxQty === 0){
			//defaultMessage = "Evidencias cargadas";
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}

		dropzone = new Dropzone("#danza_form #documentos", 
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
		//dropzone.on('queuecomplete',completed);
		
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	function sending(file,xhr,formData){
		formData.append('_action', '_cargar_evidencia');
		formData.append('_mode','danza');
		formData.append('_type','documentos');
		formData.append('project_id',$('#project_id').val());
	}

	/*function completed(){

	}

	
})();

var imagenesDanzaDropzone = (function(){
	var dropzone;
	var $selector = $('#danza_form #imagenes');
	var maxReached = false;
	var dropzoneHasFiles = false;
	var module = {
		init:initialize,
		getDropzone:getDropzone,
		hasFiles:hasFiles,
		optional:isOptional,
		validSize:valid,
		getSelector:selector
	};

	return module;

	function initialize(){
		var maxQty = $selector.attr('max-qty') - $selector.attr('current-qty');
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		if(maxQty === 0){
			//defaultMessage = "Evidencias cargadas";
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}
		dropzone = new Dropzone("#danza_form #imagenes", 
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
		dropzone.on('maxfilesexceeded',maxfilesexceeded);
		dropzone.on('maxfilesreached',maxfilesreached);
		dropzone.on('sending',sending);
		dropzone.on('addedfile',addedFile);
		dropzone.on('removedFile',removedFile);
		dropzone.on('success',success);
		//dropzone.on('sending',sending);
		//dropzone.on('queuecomplete',completed);
		
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

	function sending(file, xhr, formData){
		formData.append('_action','_cargar_evidencia');
		formData.append('_mode','danza');
		formData.append('_type','imagenes');
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	/*function addedFile(file){

	}*/

	/*function sending(file,xhr,formData){
		formData.append('_action', '_cargar_evidencia');
		formData.append('_mode','artes_visuales');
		formData.append('project_id', $("#project_id").val());
	}*/

	/*function completed(){

	}
})();

var notasDanzaDropzone = (function(){
	var dropzone;
	var $selector = $('#danza_form #notas');
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
		var maxQty = $('#notas').attr('max-qty') - $selector.attr('current-qty');
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		if(maxQty === 0){
			//defaultMessage = "Evidencias cargadas";
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}

		dropzone = new Dropzone("#danza_form #notas", 
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
		//dropzone.on('queuecomplete',completed);
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
		formData.append('_mode','danza');
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	function completed(){

	}

})();*/

//DANZA END

/*var partiturasMusicaDropzone = (function(){
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
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
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
		//dropzone.on('queuecomplete',completed);
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	/*function addedFile(file){

	}*/

	/*function completed(){

	}
})();

/*var grabacionesMusicaDropzone = (function(){
	var dropzone;
	var $selector = $('#musica_form #grabacion');
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
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		if(maxQty === 0){
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}

		dropzone = new Dropzone("#musica_form #grabacion", 
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
		//dropzone.on('queuecomplete',completed);
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
		formData.append('_type','grabacion');
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	/*function completed(){

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
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
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
		//dropzone.on('queuecomplete',completed);
		
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
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

	/*function completed(){

	}

	
})();

var imagenesMusicaDropzone = (function(){
	var dropzone;
	var $selector = $('#musica_form #imagenes');
	var maxReached = false;
	var dropzoneHasFiles = false;
	var module = {
		init:initialize,
		getDropzone:getDropzone,
		hasFiles:hasFiles,
		optional:isOptional,
		validSize:valid,
		getSelector:selector
	};

	return module;

	function initialize(){
		var maxQty = $selector.attr('max-qty') - $selector.attr('current-qty');
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		if(maxQty === 0){
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}
		dropzone = new Dropzone("#musica_form #imagenes", 
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
		dropzone.on('maxfilesexceeded',maxfilesexceeded);
		dropzone.on('maxfilesreached',maxfilesreached);
		dropzone.on('sending',sending);
		dropzone.on('addedfile',addedFile);
		dropzone.on('removedFile',removedFile);
		dropzone.on('success',success);
		//dropzone.on('sending',sending);
		//dropzone.on('queuecomplete',completed);
		
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

	function sending(file, xhr, formData){
		formData.append('_action','_cargar_evidencia');
		formData.append('_mode','musica');
		formData.append('_type','imagenes');
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	/*function addedFile(file){

	}*/

	/*function sending(file,xhr,formData){
		formData.append('_action', '_cargar_evidencia');
		formData.append('_mode','artes_visuales');
		formData.append('project_id', $("#project_id").val());
	}*/

	/*function completed(){

	}
})();*/

//END MUSICA

/*var documentosTeatroDropzone = (function(){
	var dropzone;
	var $selector = $('#teatro_form #documentos');
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
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		//var defaultMessage ='<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		if(maxQty === 0){
			//defaultMessage = "Evidencias cargadas";
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}

		dropzone = new Dropzone("#teatro_form #documentos", 
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
		//dropzone.on('queuecomplete',completed);
		
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}

	function sending(file,xhr,formData){
		formData.append('_action', '_cargar_evidencia');
		formData.append('_mode','teatro');
		formData.append('_type','documentos');
		formData.append('project_id',$('#project_id').val());
	}

	/*function completed(){

	}

	
})();

var imagenesTeatroDropzone = (function(){
	var dropzone;
	var $selector = $('#teatro_form #imagenes');
	var maxReached = false;
	var dropzoneHasFiles = false;
	var module = {
		init:initialize,
		getDropzone:getDropzone,
		hasFiles:hasFiles,
		optional:isOptional,
		validSize:valid,
		getSelector:selector
	};

	return module;

	function initialize(){
		var maxQty = $selector.attr('max-qty') - $selector.attr('current-qty');
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
		if(maxQty === 0){
			//defaultMessage = "Evidencias cargadas";
			defaultMessage = '<i class="medium material-icons blue-text text-darken-3">check_circle</i>';
		}
		dropzone = new Dropzone("#teatro_form #imagenes", 
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
		dropzone.on('maxfilesexceeded',maxfilesexceeded);
		dropzone.on('maxfilesreached',maxfilesreached);
		dropzone.on('sending',sending);
		dropzone.on('addedfile',addedFile);
		dropzone.on('removedFile',removedFile);
		dropzone.on('success',success);
		//dropzone.on('sending',sending);
		//dropzone.on('queuecomplete',completed);
		
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

	function sending(file, xhr, formData){
		formData.append('_action','_cargar_evidencia');
		formData.append('_mode','teatro');
		formData.append('_type','imagenes');
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
	}

	function selector(){
		return $selector;
	}
})();*/

//End Teatro

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
		var defaultMessage = "Arrastra tus archivos o da clic en este recuadro";
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
		return dropzone.getQueuedFiles().length >= ($selector.attr('min-qty') - 1) && dropzone.getQueuedFiles().length <= ($selector.attr('max-qty') - 1);
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

	/*function completed(){

	}*/

	
})();

//Submit Function
$(function(){
	/*if($('#artes_visuales_form').length){
		//console.log('Artes visuales detectado '+$('#project_id').val());
		catalogoArtesVisualesDropzone.init();
		notasArtesVisualesDropzone.init();
		documentosArtesVisualesDropzone.init();
		imagenesArtesVisualesDropzone.init();

		$('#artes_visuales_form #submit_evidence').on('click',function(){
			var invalid = false;	

			if(!catalogoArtesVisualesDropzone.optional() && !catalogoArtesVisualesDropzone.getSelector().hasClass('done')){
				catalogoArtesVisualesDropzone.getSelector().addClass('invalid');
				invalid = true;
			}
			if(!notasArtesVisualesDropzone.optional() && !notasArtesVisualesDropzone.getSelector().hasClass('done')){
				notasArtesVisualesDropzone.getSelector().addClass('invalid');
				invalid = true;
			}
			if(!documentosArtesVisualesDropzone.optional() && !documentosArtesVisualesDropzone.getSelector().hasClass('done')){
				documentosArtesVisualesDropzone.getSelector().addClass('invalid');
				invalid = true;
			}
			if(!imagenesArtesVisualesDropzone.optional() && !imagenesArtesVisualesDropzone.getSelector().hasClass('done')){
				imagenesArtesVisualesDropzone.getSelector().addClass('invalid');
				invalid = true;
			}

			if(invalid){
				alert('Hay evidencias que no cumplen con las especificaciones');
				return false;
			}
			$('.section').addClass('loading');
		    

			$.post({
				url:'/Form',
				method:'POST',
				data:{_action:'_cargar_evidencia',_mode:'artes_visuales',_type:'_guardar',project_id:$('#project_id').val()}
			})
			.done(function(){
				window.location.replace('/FOMAC');
			});
		});
	}*/

	/*if($('#danza_form').length){
		//console.log('danza detectado '+$('#project_id').val());
		documentosDanzaDropzone.init();
		imagenesDanzaDropzone.init();
		notasDanzaDropzone.init();

		$('#danza_form #submit_evidence').on('click',function(){
			var invalid = false;
			var invalidField = false;	

			if(!documentosDanzaDropzone.optional() && !documentosDanzaDropzone.getSelector().hasClass('done')){
				documentosDanzaDropzone.getSelector().addClass('invalid');
				invalid = true;
			}
			if(!imagenesDanzaDropzone.optional() && !imagenesDanzaDropzone.getSelector().hasClass('done')){
				imagenesDanzaDropzone.getSelector().addClass('invalid');
				invalid = true;
			}

			if($('#danza_form #notas').length){
				if(!notasDropzone.optional() && !notasDropzone.getSelector.hasClass('valid done')){
					notasDropzone.getSelector().addClass('invalid');
					invalid = true;
				}
			}

			if(invalid){
				alert('Hay evidencias que no cumplen con las especificaciones');
				return false;
			}

			var video = $("#danza_form #video").val();
			var sitioweb = $("#danza_form #sitioweb").val();

			if(!video && !isOptional($('#danza_form #video'))){
				$('#danza_form #video').addClass('invalid')
				invalidField = true;
			}

			if(!sitioweb && !isOptional($('#danza_form #sitioweb'))){
				$('#danza_form #sitioweb').addClass('invalid')
				invalidField = true;
			}

			if(invalidField){
				alert("Existen campos obligatorios que estan vacios");
				return false;
			}
			$('.section').addClass('loading');
		    
			$.post({
				url:'/Form',
				method:'POST',
				data:{
					_action:'_cargar_evidencia',
					_mode:'danza',
					_type:'_guardar',
					project_id:$('#project_id').val(),
					video_link:video,
					sitioweb_link:sitioweb}
			})
			.done(function(){
				window.location.replace('/FOMAC');
			});
		});
	}*/

	/*if($('#musica_form').length){
		//console.log('Musica detectado');
		partiturasMusicaDropzone.init();
		//grabacionesMusicaDropzone.init();
		documentosMusicaDropzone.init();
		imagenesMusicaDropzone.init();

		$('#musica_form #submit_evidence').on('click',function(){
			var invalid = false;
			var invalidField = false;	

			if(!partiturasMusicaDropzone.optional() && !partiturasMusicaDropzone.getSelector().hasClass('done')){
				partiturasMusicaDropzone.getSelector().addClass('invalid');
				invalid = true;
			}
			/*if(!grabacionesMusicaDropzone.optional() && !grabacionesMusicaDropzone.getSelector().hasClass('done')){
				grabacionesMusicaDropzone.getSelector().addClass('invalid');
				invalid = true;
			}
			if(!documentosMusicaDropzone.optional() && !documentosMusicaDropzone.getSelector().hasClass('done')){
				documentosMusicaDropzone.getSelector().addClass('invalid');
				invalid = true;
			}
			if(!imagenesMusicaDropzone.optional() && !imagenesMusicaDropzone.getSelector().hasClass('done')){
				imagenesMusicaDropzone.getSelector().addClass('invalid');
				invalid = true;
			}

			if(invalid){
				alert('Hay evidencias que no cumplen con las especificaciones');
				return false;
			}

			var video = $("#musica_form #video").val();
			var sitioweb = $("#musica_form #sitioweb").val();

			if(!video && !isOptional($('#musica_form #video'))){
				$('#musica_form #video').addClass('invalid')
				invalidField = true;
			}

			if(!sitioweb && !isOptional($('#musica_form #sitioweb'))){
				$('#musica_form #sitioweb').addClass('invalid')
				invalidField = true;
			}

			if(invalidField){
				alert("Existen campos obligatorios que estan vacios");
				return false;
			}

			$('.section').addClass('loading');

			$.post({
				url:'/Form',
				method:'POST',
				data:{
					_action:'_cargar_evidencia',
					_mode:'musica',
					_type:'_guardar',
					project_id:$('#project_id').val(),
					video_link:video,
					sitioweb_link:sitioweb
				}
			})
			.done(function(){
				window.location.replace('/Form');
			});
		});
	}*/

	/*if($('#teatro_form').length){
		//console.log('Teatro detectado '+$('#project_id').val());
		documentosTeatroDropzone.init();
		imagenesTeatroDropzone.init();

		$('#teatro_form #submit_evidence').on('click',function(){
			var invalid = false;
			var invalidField = false;	

			if(!documentosTeatroDropzone.optional() && !documentosTeatroDropzone.getSelector().hasClass('done')){
				documentosTeatroDropzone.getSelector().addClass('invalid');
				invalid = true;
			}
			if(!imagenesTeatroDropzone.optional() && !imagenesTeatroDropzone.getSelector().hasClass('done')){
				imagenesTeatroDropzone.getSelector().addClass('invalid');
				invalid = true;
			}

			if(invalid){
				alert('Hay evidencias que no cumplen con las especificaciones');
				return false;
			}

			var video = $("#teatro_form #video").val();
			var sitioweb = $("#sitioweb").val();
			
			if(!video && !isOptional($('#teatro_form #video'))){
				$('#teatro_form #video').addClass('invalid')
				invalidField = true;
			}

			if(!sitioweb && !isOptional($('#teatro_form #sitioweb'))){
				$('#teatro_form #sitioweb').addClass('invalid')
				invalidField = true;
			}


			if($('#teatro_form #carta_de_autorizacion_file')[0].files.length === 0 && !isOptional($('#teatro_form #carta_de_autorizacion_file'))){
				$('#teatro_form #carta_de_autorizacion').addClass('invalid');
				invalidField = true;
			}

			if($('#teatro_form #guion_file')[0].files.length === 0 && !isOptional($('#teatro_form #guion_file'))){
				$('#teatro_form #guion').addClass('invalid');
				invalidField = true;
			}

			if(invalidField){
				alert("Existen campos obligatorios que estan vacios");
				return false;
			}
			$('.section').addClass('loading');
		    
			var guion = $('#teatro_form #guion_file')[0].files[0];
			var carta = $('#teatro_form #carta_de_autorizacion_file')[0].files[0];

			var formData = new FormData();

			formData.append('_action','_cargar_evidencia');
			formData.append('_mode','teatro');
			formData.append('_type','_guardar');
			formData.append('project_id',$('#project_id').val());
			formData.append('video_link',video);
			formData.append('sitioweb_link',sitioweb);
			formData.append('guion',guion);
			formData.append('carta_de_autorizacion',carta);

			/*for (var pair of formData.entries()) {
    	      console.log(pair[0]+ ', ' + pair[1]); 
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
	}*/

	/*if($('#cine_video_form').length){
		//console.log('Cine y video detectado '+$('#project_id').val());
		$('#cine_video_form #submit_evidence').on('click',function(){
			var invalid = false;
			var invalidField = false;	

			var video = $("#cine_video_form #video").val();
			
			if(!video && !isOptional($('#cine_video_form #video'))){
				$('#cine_video_form #video').addClass('invalid')
				invalidField = true;
			}

			if($('#cine_video_form #cortometraje_file')[0].files.length === 0 && !isOptional($('#cine_video_form #cortometraje_file'))){
				$('#cine_video_form #cortometraje').addClass('invalid');
				invalidField = true;
			}

			if($('#cine_video_form #guion_file')[0].files.length === 0 && !isOptional($('#cine_video_form #guion_file'))){
				$('#cine_video_form #guion').addClass('invalid');
				invalidField = true;
			}

			if(invalidField){
				alert("Existen campos obligatorios que estan vacios");
				return false;
			}
			$('.section').addClass('loading');
		    

			var guion = $('#cine_video_form #guion_file')[0].files[0];
			var cortometraje = $('#cine_video_form #cortometraje_file')[0].files[0];


			var formData = new FormData();

			formData.append('_action','_cargar_evidencia');
			formData.append('_mode','cine_video');
			formData.append('_type','_guardar');
			formData.append('project_id',$('#project_id').val());
			formData.append('video_link',video);
			formData.append('guion',guion);
			formData.append('cortometraje',cortometraje);

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
	}*/
	
	if($('#letras_form').length){
		//console.log('Letras detectado '+$('#project_id').val());
		documentosLetrasDropzone.init();

		$('#letras_form #submit_evidence').on('click',function(){
			var invalid = false;
			var invalidField = false;	

			if(!documentosLetrasDropzone.optional() && !documentosLetrasDropzone.getSelector().hasClass('done')){
				documentosLetrasDropzone.getSelector().addClass('invalid');
				invalid = true;
			}
	
			if(invalid){
				alert('Hay evidencias que no cumplen con las especificaciones');
				return false;
			}

			var sitioweb = $("#letras_form #sitioweb").val();

			if(!sitioweb && !isOptional($('#letras_form #sitioweb'))){
				$('#letras_form #sitioweb').addClass('invalid')
				invalidField = true;
			}

			if($('#letras_form #texto_inedito_file')[0].files.length === 0 && !isOptional($('#letras_form #texto_inedito_file'))){
				$('#letras_form #texto_inedito').addClass('invalid');
				invalidField = true;
			}

			if(invalidField){
				alert("Existen campos obligatorios que estan vacios");
				return false;
			}

			$('.section').addClass('loading');
		    

			var texto = $('#letras_form #texto_inedito_file')[0].files[0];

			var formData = new FormData();

			formData.append('_action','_cargar_evidencia');
			formData.append('_mode','letras');
			formData.append('_type','_guardar');
			formData.append('project_id',$('#project_id').val());
			formData.append('sitioweb_link',sitioweb);
			formData.append('texto_inedito',texto);
			
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
	}

	function isOptional($element){
		var attr = $element.attr('optional');
		return typeof attr !== typeof undefined && attr !== false; 
	}
	
});
