<!--- Add To Team Action  --->
<cfparam name="url.id" default="">
<cfoutput>
<cfif isNumeric(url.id && #session.vars.teamid#)>

<cftry>
    <!--- SSP: Update the user's team based on team id and user id --->
    <cfstoredproc  PROCEDURE="sspManageUserTeam" DATASOURCE="intro" RETURNCODE="YES">
        <cfprocparam TYPE="IN" DBVARNAME="@asi_siMode" VALUE=1 cfsqltype="CF_SQL_SMALLINT">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_iUSERID" VALUE="#url.id#" cfsqltype="CF_SQL_INTEGER">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_ITEAMID" VALUE="#session.vars.teamid#" cfsqltype="CF_SQL_INTEGER">

        <cfif isDefined("cfstoredproc.StatusCode")>
            <cfif cfstoredproc.StatusCode lt 0>
                <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspManageUserTeam-UPDATE(#cfstoredproc.StatusCode#)">
            </cfif>
        </cfif>
    </cfstoredproc>

<!--- Redirect back to the main page after the updating --->
<!--- after updating, redirect to team lead home page with success message --->
    <script>
        alert("You have successfully added the user to team!");
        // Redirect to the login page
        window.location.href = "index.cfm?fusebox=teamlead&fuseaction=dsp_team&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
        <cfoutput>
            <script>
                alert("Error: Failed to add staff to team! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=teamlead&fuseaction=dsp_team&#session.urltoken#"; 
            </script>
        </cfoutput>
    </cfcatch>
</cftry>    
</cfif>
</cfoutput>
