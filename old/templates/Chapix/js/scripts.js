$(function(){
	$(".button-collapse").sideNav();

	/*$("#main-carousel").owlCarousel({
        autoHeight:true,
    	loop : true,
        autoplay : true,
        autoplayHoverPause : true,
        nav:true,
        dots:true,
        navText:['',''],
        responsive:{
            0:{
                items:1
            }
        }
	});

	$("#second-carousel").owlCarousel({
		margin:15,
		loop:true,
		autoplay:true,
		autoplayHoverPause:true,
		nav:true,
		dots:false,
		navText:['',''],
		responsive:{
			0:{
				items:1
			},
			460:{
				items:2
			},
			991:{
				items:3
			}
		}
	});

	$("#big-carousel").owlCarousel({
		autoHeight:true,
    	loop : true,
        autoplay : true,
        autoplayHoverPause : true,
        nav:false,
        dots:false,
        navText:['',''],
        responsive:{
            0:{
                items:1
            }
        }
	});*/
	
    $('select').material_select();

    $('.dropdown-button').dropdown({ 
      hover: true, // Activate on hover
      belowOrigin: true, // Displays dropdown below the button
    });

    $('.datepicker').pickadate({
        selectMonths: true, // Creates a dropdown to control month
        selectYears: 80, // Creates a dropdown of 15 years to control year
        format:'yyyy-mm-dd'
    });
        

});