# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
  $ ->
  $('#users-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#users-table').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'first_name'}
      {data: 'last_name'}
      {data: 'second_last_name'}
      {data: 'role'}
      {data: 'show'}
      {data: 'edit'}

    ]
)
