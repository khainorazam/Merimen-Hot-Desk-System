<cfset enteredUsername = Form.username>
<cfset enteredPassword = Hash(Form.password, "SHA-256")>

<cfquery name="getUser" datasource="intro">
    SELECT *
    FROM USR_DATA
    WHERE vaUSERNAME = '#enteredUsername#'
</cfquery>

<cfoutput>
<cfif #getUser.RecordCount# EQ 1 AND #getUser.vaPASSWORD# EQ #enteredPassword# AND !#getUser.siSTATUS#>


    <!-- Successful login; set session variable and redirect to home page -->
    <cfset session.vars.userLoggedIn = true>

    <cfquery name="getUserTeam" datasource="intro">
        SELECT vaNAME, iGROUPID
        FROM TEAM_DATA
        WHERE iTEAMID = '#getUser.iTEAMID#'
    </cfquery>

    
    <cfset session.vars.teamName = #getUserTeam.vaNAME#>
    <cfset session.vars.teamID = #getUser.iTEAMID#>
    <cfset session.vars.groupID = #getUserTeam.iGROUPID#>
    <cfset session.vars.usid = #getUser.iUSID#>
    <cfset session.vars.name = #getUser.vaNAME#>
    <cfset session.vars.roleID = #getUser.iROLEID#>

    <cfif #getUser.iUPDATEPWD#>
        <cflocation url="index.cfm?fusebox=hotdesk&fuseaction=dsp_home&#session.urltoken#">
    <cfelse>
        <cflocation url="index.cfm?fusebox=staff&fuseaction=dsp_profile&#session.urltoken#">
    </cfif>


<cfelse>
    <!-- Display an error message for failed login -->
    <script>
        alert("Login failed. Invalid username or password.");
        window.location.href = "index.cfm"; 
    </script>
    
</cfif>

</cfoutput>
