<cfscript>
	param name="args.title"           default="" field="page.title";
	param name="args.login_required"  default="" field="login.login_required";
	param name="args.login_failed"    default="" field="login.login_failed";
	param name="args.sidebar_content" default="" field="login.sidebar_content";
	event.include( "/css/specific/update-details/" );
	var postLoginUrl = rc.postLoginUrl ?: "";
</cfscript>
<cfoutput>
	<div class="contents" >
		<div class="main-content">
			<div class="container">
				<div class="row">
					<div class="col-xs-12 col-md-8">
						<h1 class="title">#args.title#</h1>	

						<cfswitch expression="#args.message#">
					        <cfcase value="LOGIN_REQUIRED">
					            <div class="form-info"><p>#args.login_required#</p></div>
					        </cfcase>
					        <cfcase value="LOGIN_FAILED">
					        	<div class="form-info"><p>#args.login_failed#</p></div>
					        </cfcase>
					    </cfswitch>

						<form method="post" action="#event.buildLink( linkTo="login.attemptLogin", queryString="postLoginUrl=#postLoginUrl#" )#">
							<div class="form-group">
								<div class="form-field">
									<input type="email" name="loginId" id="member-email-login" class="form-control">
									<label class="label" for="member-email-login">Email address</label> 
								</div>
							</div>
							<div class="form-group">
								<div class="form-field">
									<input type="password" name="password" id="member-password" class="form-control">
									<label class="label" for="member-password">Password</label> 
								</div>
								<p><a href="#event.buildLink( page="forgotten_password" )#" class="u-font-bold">Forgotten your password?</a></p>
							</div>
							<div class="form-group mod-submit-form mod-bordered mod-checkbox">
								<div class="form-group">
									<div class="form-field">
										<div class="checkbox">
											<input type="checkbox" id="remember-me-member" name="rememberMe">
											<label for="remember-me-member">REMEMBER ME</label>
										</div>
									</div>
								</div>
								<div class="form-group u-aligned-right">
									<input type="submit" name="submit-update" class="btn btn-big sm" value="Login"> 	
								</div>
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