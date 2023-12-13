<!--- Check if the ID parameter exists and is numeric --->
<cfparam name="url.id" default="">

<cfoutput>
<cfif isNumeric(url.id)>

<cftry>

    <!--- query: Set the people who are in the team to 7 (no team) --->
    <cfquery name="removeTeamMembers" datasource="intro">
        UPDATE USR_DATA
        SET iTEAMID = <cfqueryparam cfsqltype="cf_sql_integer" value=7>
        WHERE iTEAMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
    </cfquery>

    <!-- Delete the team based on the ID -->
    <cfquery name="deleteTeam" datasource="intro">
        DELETE FROM TEAM_DATA
        WHERE iTEAMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
    </cfquery>

<!--- Redirect back to the main page after the deletion --->
<!--- after deleting, redirect to monthly schedule page with success message --->
    <script>
        alert("You have successfully deleted the team!");
        // Redirect to the monthlyschedule page
        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_monthlyschedule&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to delete team! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_monthlyschedule&#session.urltoken#"; 
            </script>
    </cfcatch>
</cftry>    
</cfif>
</cfoutput>
