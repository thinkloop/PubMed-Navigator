<cfsilent>
	<cfparam name="url.httpURL" default="" />
	<cfparam name="cfhttp" default="" />
	
	<cfif Len(url.httpURL)>
		<cfhttp url="#url.httpURL#" method="GET" throwOnError="no" />
	</cfif>
</cfsilent>
<cfoutput>#cfhttp.FileContent#</cfoutput>
