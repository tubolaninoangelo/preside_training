PIXL8.loadDisqusComment = function() {
	if ( typeof( cfrequest ) === "undefined" ) {
		return false;
	}

	var disqusShortname = ( typeof( cfrequest.disqusShortname ) === "undefined" ? "" : cfrequest.disqusShortname );
	var PAGE_IDENTIFIER = ( typeof( cfrequest.pageIdentifier )  === "undefined" ? "" : cfrequest.pageIdentifier );
	var PAGE_URL        = ( typeof( cfrequest.pageURL )         === "undefined" ? "" : cfrequest.pageURL );

	/**
	 *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
	 *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables
	 */

	var disqus_config = function () {
		this.page.url = PAGE_URL;  // Replace PAGE_URL with your page's canonical URL variable
		this.page.identifier = PAGE_IDENTIFIER; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
	};

	if( disqusShortname == "" ) {
		return false;
	}

	var d = document, s = d.createElement('script');

	s.src = '//'+disqusShortname+'.disqus.com/embed.js';  // IMPORTANT: Replace EXAMPLE with your forum shortname!

	s.setAttribute('data-timestamp', +new Date());
	(d.head || d.body).appendChild(s);

};

( function( $ ) {

	$( document ).ready( function() {

		PIXL8.loadDisqusComment();

	} );

} )( jQuery );