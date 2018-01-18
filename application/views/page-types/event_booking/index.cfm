<cf_presideparam name="args.title"         field="page.title"        editable="true" />
<cf_presideparam name="args.main_content"  field="page.main_content" editable="true" />
<cf_presideparam name="args.bookable" editable="true" />


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
				)#

				<div class="form-group mod-submit-form mod-bordered u-aligned-center">
					<input type="submit" name="submit-update" class="btn btn-big" value="Continue">
				</div>
			</form>
	<!--- <form>
		<div class="form-group">
			<div class="form-field">
				<label>First Name</label>
				<input type="text" name="fname">
			</div>
		</div>
		<div class="form-group">
			<div class="form-field">
				<label>Last Name</label>
				<input type="text" name="lname">
			</div>
		</div>
		<div class="form-group">
			<div class="form-field">
				<label>Email</label>
				<input type="email" name="fname">
			</div>
		</div>
		<div class="form-group">
			<div class="form-field">
				<label>Email</label>
				<select name="email">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
				</select>
			</div>
		</div>
		<div class="form-group">
			<div class="form-field">
				<label>Total amount</label>
				<input type="text" name="lname" readonly>
			</div>
		</div>
		<div class="form-group">
			<div class="form-field ">
				<div class="checkbox">
					<input type="checkbox" id="chk-3" name="chk-3" checked="">
					<label for="chk-3">Option 1</label>
				</div>
				<div class="checkbox">
					<input type="checkbox" id="chk-4" name="chk-4">
					<label for="chk-4">Option 2</label>
				</div>
				<div class="checkbox">
					<input type="checkbox" id="chk-5" name="chk-5">
					<label for="chk-5">Option 3</label>
				</div>
			</div>
		</div>

		<div class="form-group">
			<div class="form-field">
				<label>Special request</label>
				<textarea name="special-request"></textarea>
			</div>
		</div>

	</form> --->

			</div>

		</div>

	</div>

</cfoutput>