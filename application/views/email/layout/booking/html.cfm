<cfscript>
    param name="args.subject"          type="string" default="";
    param name="args.body"             type="string" default="";
    param name="args.footer"           type="string" default="";

	baseImageUrl = event.getSiteUrl( includePath=false ) & "/assets/img/email/";

    footer       = renderContent( "richeditor", args.footer );
</cfscript>

<cfoutput>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
        <head>
            <title>Email standard</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        </head>

        <body style="background:white;">
            <table>
                <tr>
                   <td><h1>Event booking</h1></td>
                </tr>
                <tr>
                    <td class="main-content" align="left" style="padding: 20px 50px 0" width="100%" >
                        #args.body#
                    </td>
                </tr>
                <tr>
                    <td>
                         #footer#
                    </td>
                </tr>
            </table>
        </body>
    </html>
</cfoutput>