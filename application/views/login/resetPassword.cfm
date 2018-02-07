<cfparam name="args.title"                  field="page.title" editable="true" />
<cfparam name="args.empty_password"         field="reset_password.empty_password"         default="You must supply a new password." />
<cfparam name="args.passwords_do_not_match" field="reset_password.passwords_do_not_match" default="The passwords you supplied do not match." />
<cfparam name="args.unknown_error"          field="reset_password.unknown_error"          default="An unknown error occurred while attempting to reset your password. Please try again." />

<cfparam name="rc.token"   default="" />
<cfparam name="rc.message" default="" />

<cfscript>
    event.include( "/css/specific/update-details/" )
         .include( "/js/specific/tooltipster/" );
</cfscript>

<cfoutput>
    <div class="contents" >
        <div class="main-content">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12 col-md-8">
                        <h1 class="title">#args.title#</h1>

                        <cfswitch expression="#rc.message#">
                            <cfcase value="EMPTY_PASSWORD">
                                <div class="form-info"><p>#args.empty_password#</p></div>
                            </cfcase>
                            <cfcase value="PASSWORDS_DO_NOT_MATCH">
                                <div class="form-info"><p>#args.passwords_do_not_match#</p></div>
                            </cfcase>
                            <cfcase value="UNKNOWN_ERROR">
                                <div class="form-info"><p>#args.unknown_error#</p></div>
                            </cfcase>
                        </cfswitch>

                        <form action="#event.buildLink( linkTo='login.resetPasswordAction' )#" method="post">
                            <input type="hidden" name="token" value="#rc.token#" />
                            <div class="form-group">
                                <div class="form-field">
                                    <input type="password" name="password" id="passwordField" class="form-control">
                                    <label class="label" for="passwordField">#translateResource( uri="page-types.reset_password:newPassword.label" )#</label>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="form-field">
                                    <input type="password" name="passwordConfirmation" id="passwordConfirmationField" class="form-control">
                                    <label class="label" for="passwordConfirmationField">#translateResource( uri="page-types.reset_password:confirmPassword.label" )#</label>
                                </div>
                            </div>

                            <div class="form-group mod-submit-form mod-bordered u-aligned-center">
                                <input type="submit" name="submit-update" class="btn btn-big sm" value="Update">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfoutput>