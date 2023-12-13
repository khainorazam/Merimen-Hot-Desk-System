<!--- sets the login session --->
<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCDISABLEDIRECT.cfm" Path="#GetCurrentTemplatePath()#">
<!---OUTPUT:TRUE--->
<cfparam name="attributes.chkFirstTime" default=0>
<cfparam name="attributes.ssologin" default=0><!---#18800 B2C existing user login--->
<cfparam name="form.sleUserName" default="">
<cfparam name="form.slePassword" default="">
<cfparam name="form.nonce" default="">
<cfparam name="FORM.hpwd" default="">
<cfparam name="Attributes.UID" default="">
<cfparam name="Attributes.SESSIONSTORE" default="0">
<cfparam name="Attributes.REDIRFUSEBOX" default="">
<cfparam name="Attributes.REDIRFUSEACTION" default="">
<cfparam name="attributes.resplogin" default=0>
<cfparam name="attributes.LF" default="">



<cfset attributes.USERID=form.sleUserName>
<cfset attributes.PMD5=form.slePassword>
<cfset attributes.nonce=form.nonce>
<cfset attributes.hpwd=form.hpwd>


<cfif attributes.chkFirstTime eq 1>
	<cfmodule TEMPLATE="#request.apppath#services/index.cfm" fusebox=SVCsec fuseaction=act_firsttimelogin ATTRIBUTECOLLECTION=#ATTRIBUTES#>
</cfif>

<cfmodule TEMPLATE="#request.apppath#services/index.cfm" FUSEBOX=SVCsec FUSEACTION=act_login ATTRIBUTECOLLECTION=#ATTRIBUTES#>

<!--- if session is set, redirects to home page --->
    <cfif isDefined("SESSION.VARS") == true>
        <cfset session.vars.roleid=3>
    <cflocation url="index.cfm?fusebox=hotdesk&fuseaction=dsp_home&#session.urltoken#">
    <cfelseif isDefined("SESSION.VARS") == false>
        <cfoutput>
            fail
        </cfoutput>
    </cfif>