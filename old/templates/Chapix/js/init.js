$(function(){
	$('.button-collapse').sideNav({
      edge: 'left', // Choose the horizontal origin
      closeOnClick: true, // Closes side-nav on <a> clicks, useful for Angular/Meteor
      draggable: true // Choose whether you can drag to open on touch screens
    });      
	$('select').material_select();
    
    $('.msg').each(function() {
        $(this).hide();
        if($(this).hasClass('msg-success')){
            Materialize.toast($(this).html(), 3000, 'msg-success');
        } else if ($(this).hasClass('msg-danger')){
            Materialize.toast($(this).html(), 180000, 'msg-danger');
            var snd = new Audio("/media/beep.wav");
            snd.play();
        } else if ($(this).hasClass('msg-warning')){
            Materialize.toast($(this).html(), 180000, 'msg-warning');
            var snd = new Audio("/media/beep.wav");
            snd.play();
        } else {
            Materialize.toast($(this).html(), 3000);
        }        
    });

     $('.datepicker').pickadate({
        selectMonths: true, // Creates a dropdown to control month
        selectYears: 150, // Creates a dropdown of 15 years to control year
        format: 'yyyy-mm-dd',
        closeOnSelect: false,
        onStart : function() {
            $('.picker').appendTo('body');
        },
        onSet: function (ele) {
            if (ele.select){
                //this.close();
            }
        },
        // The title label to use for the month nav buttons
        labelMonthNext: 'Mes siguiente',
        labelMonthPrev: 'Mes anterior',

		// The title label to use for the dropdown selectors
        labelMonthSelect: 'Selecciona un mes',
        labelYearSelect: 'Selecciona un año',

		// Months and weekdays
        monthsFull: [ 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre' ],
        monthsShort: [ 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic' ],
        weekdaysFull: [ 'Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado' ],
        weekdaysShort: [ 'Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab' ],

		// Materialize modified
        weekdaysLetter: [ 'D', 'L', 'M', 'X', 'J', 'V', 'S' ],

		// Today and clear
        today: 'Hoy',
        clear: 'Limpiar',
        close: 'Cerrar',
    });

      $('.dropdown-button').dropdown();

      $('.modal').modal();

      $('.count-char').characterCounter();
});