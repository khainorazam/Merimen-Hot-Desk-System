<!--- Update monthlyschedule Action  --->
<cfparam name="form.update_id" default="">
<cfparam name="form.update_nickname" default="">
<cfparam name="form.update_group" default="">


<cfoutput>
<cfif structKeyExists(form, "update_id")>
<cftry>
    <!--- Query: Update the team info --->
    <cfquery name="updateTeamInfo" datasource="intro">
        UPDATE TEAM_DATA
        SET
            vaNICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.update_nickname#">
            , iGROUPID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.update_group#">
        WHERE
            iTEAMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.update_id#">
    </cfquery>


<!--- after updating, redirect to Monthly Schedule page with success message --->
    <script>
        alert("You have successfully updated team info!");
        // Redirect to the team page
        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_monthlyschedule&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to update team info! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_monthlyschedule&#session.urltoken#"; 
            </script>
    </cfcatch>
</cftry>
<cfelse>
    fail
</cfif>
</cfoutput>
