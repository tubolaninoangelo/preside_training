<cf_presideparam name="args.title"         field="page.title"        editable="true" />
<cf_presideparam name="args.main_content"  field="page.main_content" editable="true" />

<cfoutput>
	<h1 class="text-center">#args.title#</h1>
	#args.main_content#

	<div class="main-wrapper">

		<div class="row">
			<div class="main-content col-xs-8 col-sm-offset-2">

				<form id="eventBooking" method="post" action="#event.buildLink( linkTo = 'page-types.member_registration_page.submitMemberRegistrationDetails' )#">

					#renderForm(
						  formName            = "membership.registration"
						, context             = "website"
						, fieldLayout         = "formcontrols.layout.formfield.website"
					    , savedData			  = rc.savedData  ?: {}
						, validationResult    = rc.validationResult ?: ""
					    , includeValidationJs = true
					    <!--- , additionalArgs      = {
					    	fields = {
					    		session     = {
						    		  values = ValueList(eventSessions.label)
						    		, labels = ValueList(eventSessions.label) }

					    	}
					    } --->
					)#

					<div class="form-group mod-submit-form mod-bordered u-aligned-center">
						<input type="submit" name="submit-update" class="btn btn-big" value="Submit">
					</div>

				</form>

			</div>

		</div>

	</div>

</cfoutput>