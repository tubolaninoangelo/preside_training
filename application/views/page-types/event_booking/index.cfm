<cf_presideparam name="args.title"         field="page.title"        editable="true" />
<cf_presideparam name="args.main_content"  field="page.main_content" editable="true" />

<cfoutput>

	<div class="main-wrapper">

		<div class="row">

			<div class="main-content col-xs-8 col-sm-offset-2">

				<h1>#args.title#</h1>
				#args.main_content#
				<form id="eventBooking" method="post" action="#event.buildLink( linkTo = 'page-types.event_booking.saveEventBooking' )#">

					#renderForm(
						  formName            = "event-booking.register"
						, context             = "website"
						, fieldLayout         = "formcontrols.layout.formfield.website"
					    , savedData			  = rc.savedData  ?: {}
						, validationResult    = rc.validationResult ?: ""
					    , includeValidationJs = true
					)#

					<div class="form-group mod-submit-form mod-bordered u-aligned-center">
						<input type="submit" name="submit-update" class="btn btn-big" value="Continue">
					</div>


				</form>

				<script>
					document.getElementById("number_of_seat").onchange = function() { calculateAmount()};

					function calculateAmount() {
						var numSeat = document.getElementById("number_of_seat").value;
						var eventPrice  = document.getElementById("event-price").value;
						var total = parseInt(numSeat) * parseInt(eventPrice);
					    document.getElementById("total_amount").value = total;
					}
				</script>

			</div>

		</div>

	</div>

</cfoutput>