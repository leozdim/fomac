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
)
$ ->
  $('#projects-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#projects-table').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'folio'}
      {data: 'user'}
      {data: 'category'}
      {data: 'status'}
      {data: 'show'}
      {data: 'edit'}
      {data: 'delete'}
    ]
