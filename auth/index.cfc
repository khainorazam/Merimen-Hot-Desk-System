<cfcomponent displayname="authservices" hint="">
<!---     action for after login --->
    <cffunction name="act_login" hint="Action file for login security checking (by invoke act_login from services) and load user login session with user specified settings." returntype="any" output="true">
	<cfargument name="chkFirstTime" required="false" default="0" type="numeric"
		displayname="Check First Time Login"
		hint="Check if first time login. Invoke act_firsttimelogin from services for neccessary action and setup for first time login.">
    <CFINCLUDE template="act_login.cfm">
	<CFRETURN>
    </cffunction>
    <!---     action for after login --->
    <cffunction name="act_loginstaff" hint="Action file for login security checking (by invoke act_login from services) and load user login session with user specified settings." returntype="any" output="true">
	<cfargument name="chkFirstTime" required="false" default="0" type="numeric"
		displayname="Check First Time Login"
		hint="Check if first time login. Invoke act_firsttimelogin from services for neccessary action and setup for first time login.">
    <CFINCLUDE template="act_loginstaff.cfm">
	<CFRETURN>
    </cffunction>
<!---     logout --->
<cffunction name="act_logout" hint="Action file for logout." returntype="any" output="true">
	<cfargument name="chkFirstTime" required="false" default="0" type="numeric"
		displayname="Logout"
		hint="">
    <CFINCLUDE template="act_logout.cfm">
	<CFRETURN>
    </cffunction>
</cfcomponent>