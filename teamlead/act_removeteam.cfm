<!--- Add To Team Action  --->
<cfparam name="url.id" default="">

<cfif isNumeric(url.id)>
<cfoutput>

<cftry>
    <!--- SSP: Update the user's team to no team --->
    <cfstoredproc  PROCEDURE="sspManageUserTeam" DATASOURCE="intro" RETURNCODE="YES">
        <cfprocparam TYPE="IN" DBVARNAME="@asi_siMode" VALUE=2 cfsqltype="CF_SQL_SMALLINT">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_iUSERID" VALUE="#url.id#" cfsqltype="CF_SQL_INTEGER">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_ITEAMID" NULL="YES" cfsqltype="CF_SQL_INTEGER">

        <cfif isDefined("cfstoredproc.StatusCode")>
            <cfif cfstoredproc.StatusCode lt 0>
                <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspManageUserTeam-UPDATE(#cfstoredproc.StatusCode#)">
            </cfif>
        </cfif>
    </cfstoredproc>

<!--- Redirect back to the main page after the updating --->
<!--- after updating, redirect to team lead home page with success message --->
    <script>
        alert("You have successfully remove the user from the team!");
        // Redirect to the login page
        window.location.href = "index.cfm?fusebox=teamlead&fuseaction=dsp_team&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to remove staff from team! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=teamlead&fuseaction=dsp_team&#session.urltoken#"; 
            </script>

    </cfcatch>

</cftry>    
</cfoutput>

</cfif>
