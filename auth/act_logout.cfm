<cfparam name=attributes.root default="">
<cfparam name=attributes.retryid default="">
<cfparam name=attributes.LOCKTIME default="">
<cfparam name="attributes.resplogin" default=0>
<!--- destroy existing session --->
<CFSET SKIP_LOGOUT=0><CFSET SESSION_EXISTS=0>
<CFIF IsDefined("SESSION.VARS") AND IsDefined("SESSION.VARS.USID")>
	<CFIF IsDefined("SESSION.VARS.MMUSERID") AND SESSION.VARS.MMUSERID IS NOT "">
		<CFSET SKIP_LOGOUT=1>
	<CFELSE>
		<CFSET SESSION_EXISTS=1>
	</CFIF>
	<CFIF SKIP_LOGOUT IS 0>
		<CFSTOREDPROC PROCEDURE="sspFSECUserLogout" DATASOURCE="#Request.SVCDSN#" RETURNCODE="YES">
		<CFPROCPARAM TYPE="IN" DBVARNAME="@iUSID" VALUE="#SESSION.VARS.USID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFIF StructKeyExists(URL,"IGNORELAST") and URL.IGNORELAST eq 1>
			<CFPROCPARAM TYPE="IN" DBVARNAME="@vaSESSCODE" VALUE="" CFSQLTYPE="CF_SQL_VARCHAR">
			<CFPROCPARAM TYPE="IN" DBVARNAME="@asi_ignorelast" VALUE="1" CFSQLTYPE="CF_SQL_INTEGER">
		<CFELSE>
			<CFPROCPARAM TYPE="IN" DBVARNAME="@vaSESSCODE" VALUE="#SESSION.URLToken#" CFSQLTYPE="CF_SQL_VARCHAR">
			<CFPROCPARAM TYPE="IN" DBVARNAME="@asi_ignorelast" VALUE="0" CFSQLTYPE="CF_SQL_INTEGER">
		</CFIF>
		</CFSTOREDPROC>
	</CFIF>
	<!---CFIF IsDefined("SESSION.VARS.MACID")>
		<CFIF Not IsDefined("COOKIE.MACID") OR (SESSION.VARS.MACID IS NOT COOKIE.MACID)>
			<CFTHROW TYPE="EX_SECFAILED" ErrorCode="BADCLI">
		</cfif>
	</CFIF--->
	<cfif isdefined("SESSION.SSO_UID")>
		<cfmodule template="#request.ssopath#index.cfm" FUSEBOX="MRMRoot" FUSEACTION="session_management" sessionid="#SESSION.SESSIONID#" sessiontoken="#SESSION.CFTOKEN#" cfid="#SESSION.CFID#" MODRESULT=SSO_SESSION mode=4 environment=100>
	<cfelse>
		<CFLOCK SCOPE="Session" Type="Exclusive" TimeOut=60>
		<CFSCRIPT>StructClear(session.vars);</CFSCRIPT>
		</CFLOCK>
	</cfif>
	<CFSET Request.inSession=0>
	<CFSET Request.DS.FN.SVCsessionStop()>
<cfelseif SESSION_EXISTS IS 0 AND (
		StructKeyExists(URL,"IGNORELAST") and URL.IGNORELAST eq 1 AND
		StructKeyExists(URL,"logoutusid") and URL.logoutusid gt 0
	)>
	<!--- Forcing logout even when session does not exist --->
	<cfif isdefined("SESSION.SSO_UID")>
		<cfmodule template="#request.ssopath#index.cfm" FUSEBOX="MRMRoot" FUSEACTION="session_management" sessionid="#SESSION.SESSIONID#" sessiontoken="#SESSION.CFTOKEN#" cfid="#SESSION.CFID#" MODRESULT=SSO_SESSION mode=4 environment=100>
	</cfif>
	<CFSTOREDPROC PROCEDURE="sspFSECUserLogout" DATASOURCE="#Request.SVCDSN#" RETURNCODE="YES">
	<CFPROCPARAM TYPE="IN" DBVARNAME="@iUSID" VALUE="#URL.logoutusid#" CFSQLTYPE="CF_SQL_INTEGER">
	<CFPROCPARAM TYPE="IN" DBVARNAME="@vaSESSCODE" VALUE="" CFSQLTYPE="CF_SQL_VARCHAR">
	<CFPROCPARAM TYPE="IN" DBVARNAME="@asi_ignorelast" VALUE="1" CFSQLTYPE="CF_SQL_INTEGER">
	</CFSTOREDPROC>
</cfif>

<CFLOCATION URL="#Request.Webroot#index.cfm" ADDTOKEN="no">