( function( $ ) {

	$( document ).ready( function() {

		$("#number_of_seat").change(function(){
			var numSeat    = $(this).val();
			var eventPrice = $("#event_price").val();
			$("#total_amount").val( parseInt(numSeat) * parseInt(eventPrice) );
		});

	} );

} )( jQuery );