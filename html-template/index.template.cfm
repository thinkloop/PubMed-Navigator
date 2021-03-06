<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">	
 
    <head>
        <title>${title}</title>   
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="keywords" content="Pubmed, Pubmed Article, Search Pubmed, Medical Journal, Google Scholar, Google Instant"/>
		<meta name="description" content="PubMed Navigator is the fastest way to search PubMed."/> 

        <style type="text/css" media="screen"> 
			html, body	{ height:100%; }
			body { margin:0; padding:0; overflow:auto; text-align:center; 
			       background-color: ${bgcolor}; }   
			object:focus { outline:none; }
			#flashContent { display:none; }
        </style>
		  
        <script type="text/javascript" src="swfobject.js"></script>
        <script type="text/javascript">
            <!-- For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection. --> 
            var swfVersionStr = "${version_major}.${version_minor}.${version_revision}";
            <!-- To use express install, set to playerProductInstall.swf, otherwise the empty string. -->
            var xiSwfUrlStr = "${expressInstallSwf}";
            var flashvars = {};
            var params = {};
            params.quality = "high";
            params.bgcolor = "${bgcolor}";
            params.allowscriptaccess = "sameDomain";
            params.allowfullscreen = "true";
            var attributes = {};
            attributes.id = "${application}";
            attributes.name = "${application}";
            attributes.align = "middle";
            swfobject.embedSWF(
                "${swf}.swf", "flashContent", 
                "${width}", "${height}", 
                swfVersionStr, xiSwfUrlStr, 
                flashvars, params, attributes);
			<!-- JavaScript enabled so display the flashContent div in case it is not replaced with a swf object. -->
			swfobject.createCSS("#flashContent", "display:block;text-align:left;");
        </script>
		
		<script type="text/javascript">
			var _gaq = _gaq || [];
			_gaq.push(['_setAccount', 'UA-9621976-3']);
			_gaq.push(['_trackPageview']);

			(function() {
			var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
			})();
		</script>		
    </head>
    <body>
        <div id="flashContent">
			<noscript> 

				<span fontSize="24">PubMed Navigator</span> is the <span fontSize="24">fastest</span> way to search PubMed. 

				

				Initial results appear <span fontSize="24">instantly</span>, then <span fontSize="24">richer</span> information <span fontSize="24">silently loads</span> in the background.

		

				To open the <span fontSize="24">full PubMed</span> article, click on an article title.

				

				To expand an abstract, click on the abstract text.

				

				<br /><br />

				

				<span fontWeight="bold" fontSize="20">Type your search terms in the search box above.</span>      

			</noscript>
			
        	<p>
	        	To view this page ensure that Adobe Flash Player version 
				${version_major}.${version_minor}.${version_revision} or greater is installed. 
			</p>
			<script type="text/javascript"> 
				var pageHost = ((document.location.protocol == "https:") ? "https://" :	"http://"); 
				document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='" 
								+ pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a>" ); 
			</script> 
        </div>
	   	
       	<noscript>
            <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="${width}" height="${height}" id="${application}">
                <param name="movie" value="${swf}.swf" />
                <param name="quality" value="high" />
                <param name="bgcolor" value="${bgcolor}" />
                <param name="allowScriptAccess" value="sameDomain" />
                <param name="allowFullScreen" value="true" />

                <object type="application/x-shockwave-flash" data="${swf}.swf" width="${width}" height="${height}">
                    <param name="quality" value="high" />
                    <param name="bgcolor" value="${bgcolor}" />
                    <param name="allowScriptAccess" value="sameDomain" />
                    <param name="allowFullScreen" value="true" />

                	<p> 
                		Either scripts and active content are not permitted to run or Adobe Flash Player version
                		${version_major}.${version_minor}.${version_revision} or greater is not installed.
                	</p>

                    <a href="http://www.adobe.com/go/getflashplayer">
                        <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash Player" />
                    </a>
                </object>
            </object>
	    </noscript>		
   </body>
</html>
