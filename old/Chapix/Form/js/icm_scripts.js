$(function(){
	$('#category_selector').change(function(){
		var value = $(this).val();
		var resume_selector = $('#resume_doc');
		console.log(value);
		if(value === "Con trayectoria" && resume_selector.hasClass('hidden')){
			resume_selector.removeClass('hidden');
		}else if(value === "Sin trayectoria" && !(resume_selector.hasClass('hidden'))){
			resume_selector.addClass('hidden');
		}
	});

	$('#project_selector').change(function(){
		var value = $(this).val();
		var representative_selector = $('#team_representative');
		console.log(value);
		if(value === "Colectivo" && representative_selector.hasClass('hidden')){
			representative_selector.removeClass('hidden');
			//$('input[name=team_representative]').addAttr('required','required');
		}else if(value === "Individual" && !(representative_selector.hasClass('hidden'))){
			representative_selector.addClass('hidden');
			//$('input[name=team_representative]').removeAttr('required');
		}
	});
});