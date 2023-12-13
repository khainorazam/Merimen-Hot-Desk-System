<!--- Update Holiday Action  --->
<cfparam name="form.update_id" default="">
<cfparam name="form.update_name" default="">

<cfoutput>
<cfif structKeyExists(form, "update_id")>
<cftry>
    <!--- Query: Update profile --->
    <cfquery name="updateProfile" datasource="intro">
        UPDATE USR_DATA
        SET vaNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.update_name#">
        WHERE iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.update_id#">
    </cfquery>

<!--- after updating, redirect to profile page with success message --->
    <script>
        alert("You have successfully updated your profile!");
        // Redirect to the holiday page
        window.location.href = "index.cfm?fusebox=staff&fuseaction=dsp_profile&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to update your profile! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=staff&fuseaction=dsp_profile&#session.urltoken#"; 
            </script>
    </cfcatch>
</cftry>
<cfelse>
    fail
</cfif>
</cfoutput>
