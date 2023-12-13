<cfparam NAME="attributes.FUSEBOX" DEFAULT="">
<cfparam NAME="attributes.FUSEACTION" DEFAULT="">

<cfset Cookie.cfid = session.cfid>
<cfset Cookie.cftoken = session.cftoken>
<cfset session.entered = now()>

<cfif isDefined('session.vars.usid')>
<cfinclude  template="header.cfm">
</cfif>

<cfif ((#attributes.fusebox# eq "") AND !isDefined('session.vars.usid')) OR (#attributes.fusebox# neq "" AND isDefined('session.vars.usid')) OR (#attributes.fusebox# eq "auth")>
    <!--- Switch case for fusebox (folder)--->
<cfswitch EXPRESSION=#attributes.fusebox#>	
	<cfcase VALUE="auth">
        <cfinclude TEMPLATE="auth/index.cfm">
    </cfcase>
    <cfcase value="hotdesk">
        <cfinclude TEMPLATE="hotdesk/index.cfm">
    </cfcase>
    <cfcase VALUE="admin">
        <cfinclude TEMPLATE="admin/index.cfm">
    </cfcase>
    <cfcase VALUE="staff">
        <cfinclude TEMPLATE="staff/index.cfm">
    </cfcase>
    <cfcase VALUE="teamlead">
        <cfinclude TEMPLATE="teamlead/index.cfm">
    </cfcase>
    <cfdefaultcase>
        <cfinclude template="dsp_login.cfm"> 
    </cfdefaultcase>
</cfswitch>
<cfelse>
    <script>
        alert("You have logged out. Please log in again to continue.");
        window.location.href = "index.cfm";
    </script>
</cfif>

