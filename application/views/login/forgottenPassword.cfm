<cfparam name="args.title"                            field="page.title" editable="true" />
<cfparam name="args.loginId_not_found"                field="forgotten_password.loginId_not_found" default="Sorry, your email address is not found in the system." />
<cfparam name="args.invalid_reset_token"              field="forgotten_password.invalid_reset_token" default="Invalid reset token." />
<cfparam name="args.password_reset_instructions_sent" field="forgotten_password.password_reset_instructions_sent" default="Instructions for setting your password have been sent to your registered email account." />
<cfparam name="args.sidebar_content"                  field="forgotten_password.sidebar_content" default="" />

<cfscript>
    event.include( "/css/specific/update-details/" );
</cfscript>

<cfparam name="rc.loginId" default="" />
<cfparam name="rc.message" default="" />

<cfoutput>
    <div class="contents" >
        <div class="main-content">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12 col-md-8">
                        <h1>#args.title#</h1>

                        <cfswitch expression="#rc.message#">
                            <cfcase value="LOGINID_NOT_FOUND">
                                <div class="form-info"><p>#args.loginId_not_found#</p></div>
                            </cfcase>
                            <cfcase value="INVALID_RESET_TOKEN">
                                <div class="form-info"><p>#args.invalid_reset_token#</p></div>
                            </cfcase>
                            <cfcase value="PASSWORD_RESET_INSTRUCTIONS_SENT">
                                <div class="form-info form-success"><p>#args.password_reset_instructions_sent#</p></div>
                            </cfcase>
                        </cfswitch>

                        <form action="#event.buildLink( linkTo='login.sendResetInstructions' )#" method="post">
                            <div class="form-group">
                                <div class="form-field">
                                    <input type="email" class="form-control" name="loginId" id="loginIdField">
                                    <label class="label" for="loginIdField">Email address</label> 
                                </div>
                            </div>

                            <div class="form-group mod-submit-form mod-bordered u-aligned-right ">
                                <input type="submit" name="submit-update" class="btn btn-big" value="Reset Password">   
                            </div>
                        </form>
                    </div>
                    <cfif len( trim( args.sidebar_content ) )>
                        <aside class="col-xs-12 col-md-4 sidebar">
                            <div class="sidebar-wrapper">
                                <div class="widget widget-enquiry">
                                    #renderContent(
                                          renderer = "richeditor"
                                        , data     = args.sidebar_content
                                    )#
                                </div>
                            </div>
                        </aside>
                    </cfif>
                </div>
            </div>
        </div>
    </div>
</cfoutput>