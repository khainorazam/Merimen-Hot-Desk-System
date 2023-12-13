<!--- Update Staff Action  --->
<cfparam name="form.update_id" default="">
<cfparam name="form.update_role" default="">

<cfoutput>
<cfif structKeyExists(form, "update_id")>
<cftry>
    <!--- SSP: Update the role --->
    <cfstoredproc procedure="sspUpdateStaffRole" datasource="intro">
        <cfprocparam type="in" cfsqltype="cf_sql_integer" value="#form.update_id#">
        <cfprocparam type="in" cfsqltype="cf_sql_integer" value="#form.update_role#">
    </cfstoredproc>

<!--- after updating, redirect to admin home page with success message --->
    <script>
        alert("You have successfully updated staff role!");
        // Redirect to the login page
        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_staff&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to update staff role! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_staff&#session.urltoken#"; 
            </script>
    </cfcatch>
</cftry>
<cfelse>
    fail
</cfif>
</cfoutput>
