<!--- Update Holiday Action  --->
<cfparam name="form.update_id" default="">
<cfparam name="form.update_name" default="">

<cfoutput>
<cfif structKeyExists(form, "update_id")>
<cftry>
    <!--- Query: Update the holiday name --->
    <cfquery name="updateHolidayName" datasource="intro">
        UPDATE HOLIDAY_DATA
        SET vaNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.update_name#">
        WHERE iHOLIDAYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.update_id#">
    </cfquery>

<!--- after updating, redirect to holiday page with success message --->
    <script>
        alert("You have successfully updated holiday name!");
        // Redirect to the holiday page
        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_holiday&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to update holiday name! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_holiday&#session.urltoken#"; 
            </script>
    </cfcatch>
</cftry>
<cfelse>
    fail
</cfif>
</cfoutput>
