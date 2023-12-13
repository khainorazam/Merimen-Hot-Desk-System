<!--- Update Hot Desk Information (Day) Action  --->
<cfparam name="form.date" default="">
<cfparam name="form.totalseat" default="">
<cfparam name="form.emergencyseat" default="">

<cfoutput>
<cfif structKeyExists(form, "date")>
<cftry>
    <!--- SSP: Update the date hot desk info --->
    <cfstoredproc  PROCEDURE="sspUpdateHotDeskInformation" DATASOURCE="intro" RETURNCODE="YES">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_iSEAT_TOTAL" VALUE ="#form.totalseat#" cfsqltype="CF_SQL_INTEGER">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_iSEAT_EMERGENCY" VALUE="#form.emergencyseat#" cfsqltype="CF_SQL_INTEGER">
        <cfprocparam TYPE="IN" DBVARNAME="@adt_dtDATE" VALUE="#form.date#" cfsqltype="CF_SQL_DATE">

        <cfif isDefined("cfstoredproc.StatusCode")>
            <cfif cfstoredproc.StatusCode == -1>
                <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspUpdateHotDeskInformation-INSERT(#cfstoredproc.StatusCode#)">
            </cfif>
        </cfif>
    </cfstoredproc>

<!--- after updating, redirect to week page with success message --->
    <script>
        alert("You have successfully updated hot desk information for #DateFormat(form.date, "dd/mm/yyyy")#!");
        // Redirect to the login page
        window.location.href = "index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to update hot desk information! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#"; 
            </script>
    </cfcatch>
</cftry>
<cfelse>
    fail
</cfif>
</cfoutput>
