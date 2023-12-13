<!--- Update Hot Desk Default Day Action  --->
<cfparam name="form.id" default="">
<cfparam name="form.days" default="">
<cfoutput>
<cfif structKeyExists(form, "id")>
<cftry>
    <!--- SSP: Update the default days for user --->
    <cfstoredproc PROCEDURE="sspUpdateDefaultDays" DATASOURCE="intro" RETURNCODE="YES">
        <cfprocparam TYPE="IN" DBVARNAME="@as_vaDEFAULTDAYS" VALUE="#form.days#" cfsqltype="CF_SQL_VARCHAR">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_iUSID" VALUE="#form.id#" cfsqltype="CF_SQL_INTEGER">

        <cfif isDefined("cfstoredproc.StatusCode")>
            <cfif cfstoredproc.StatusCode LT 0>
                <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspUpdateDefaultDays-UPDATE(#cfstoredproc.StatusCode#)">
            </cfif>
        </cfif>
    </cfstoredproc>

<!--- after updating, redirect to admin home page with success message --->
    <script>
        alert("You have successfully updated your personal default days!");
        // Redirect to the profile page
        window.location.href = "index.cfm?fusebox=staff&fuseaction=dsp_profile&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to update personal default days! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=staff&fuseaction=dsp_profile&#session.urltoken#"; 
            </script>
    </cfcatch>
</cftry>
<cfelse>
    fail
</cfif>
</cfoutput>
