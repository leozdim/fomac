# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
option=$("#category option[value='']").clone()
set_up_select=()->
  if $(this).val()==''
    $('#art').addClass 'hide'
  else
    $('#art').removeClass 'hide'
    if $(this).find('option[value='+$(this).val()+']').data('single')==true
      $('#art select').append(option)
      $('#art select').removeAttr('multiple')
      $('#single').addClass('active-project').next().removeClass('active-project')
    else
      $('#art').find("option[value='']").remove()
      $('#art select').attr('multiple','multiple')
      $('#single').removeClass('active-project').next().addClass('active-project')
    $('#art select').material_select();
$(document).on('turbolinks:load', ->
  $('#category select').change set_up_select
  set_up_select.apply($('#category select'))


  $ ->
    $('#projects-table').dataTable
      processing: true
      serverSide: true
      ajax: $('#projects-table').data('source')
      pagingType: 'full_numbers'
      columns: [
        {data: 'id'}
        {data: 'folio'}
        {data: 'user'}
        {data: 'category'}
        {data: 'name'}
        {data: 'show'}
        {data: 'status'}
      ]
    validate=$('form:last').data('validate')
    if validate and  !validate.empty?  and validate.length>0
      $('form:last input[type=text],form:last input[type=file], form:last textarea, form:last select').attr('disabled',true)
      for v in validate 
        do -> 
          maybe=$("form:last [id*=#{v[2]}]")
          target=null
          maybe.each (y,x)-> 
            target=$(x) if $(x).prop('id').includes v[0]
          return if target==null
          target.attr('disabled',false)
          unless v[1]==null
            if target.prop('type')=='file'
              target.parents('div.file-field').after('<div class="chip" >Observaciòn: '+v[1]+'</div>')
            else
              target.after('<div class="chip" >Observaciòn: '+v[1]+'</div>')
      $("input,textarea").each ->
        if $(this).val()==""
          $(this).attr('disabled',false)
)

