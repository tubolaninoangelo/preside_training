<cfscript>

	disqusShortname = getSystemSetting( category = "disqus", setting="shortname" ) ?: "";

</cfscript>

<cfoutput>

	<cfif isEmpty( disqusShortname ) >
		<p><strong>Please set up the disqus shortname in system settings.</strong></p>
	<cfelse>
		<div id="disqus_thread"></div>
	</cfif>

</cfoutput>


<script>
    /**
     *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
     *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables
     */
    /*
    var disqus_config = function () {
        this.page.url = PAGE_URL;  // Replace PAGE_URL with your page's canonical URL variable
        this.page.identifier = PAGE_IDENTIFIER; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
    };
    */
    (function() {  // DON'T EDIT BELOW THIS LINE
        var d = document, s = d.createElement('script');

        <cfoutput>
        	s.src = 'https://#disqusShortname#.disqus.com/embed.js';
        </cfoutput>

        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
    })();
</script>

<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>