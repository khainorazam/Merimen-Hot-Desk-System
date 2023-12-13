<!---Action for Approve Staff Date--->
<cfparam name="url.date" default="">
<cfparam name="url.id" default="">
<cfparam name="url.status" default="">

<cfquery name="getName" datasource="intro">
    SELECT vaNAME
    FROM USR_DATA
    WHERE iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfoutput>
<cfif structKeyExists(url, "date")>
<cftry>

    <!--- Approve --->
    <cfif url.status == 1>
    <!--- SSP: Update the approval to 0 --->
    <cfstoredproc  PROCEDURE="sspUpdateApprovalList" DATASOURCE="intro" RETURNCODE="YES">
        <cfprocparam TYPE="IN" DBVARNAME="@adt_dtDATE" VALUE="#url.date#" cfsqltype="CF_SQL_DATE">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_iUSID" VALUE="#url.id#" cfsqltype="CF_SQL_INTEGER">

        <cfif isDefined("cfstoredproc.StatusCode")>
            <cfif cfstoredproc.StatusCode == -1>
                <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspUpdateApprovalList-INSERT(#cfstoredproc.StatusCode#)">
            </cfif>
        </cfif>
    </cfstoredproc>


    <script>
        alert("You have approved hot seat for #getName.vaNAME# on #DateFormat(url.date, "dd/mm/yyyy")#!");
        // Redirect to the login page
        window.location.href = "index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#&week=#session.vars.week#"; 
    </script>

    <!--- Reject --->
    <cfelseif url.status == 2>
    <!--- SSP: Reject and Set the Approval to 2 --->
    <cfstoredproc  PROCEDURE="sspRejectStaffHotDesk" DATASOURCE="intro" RETURNCODE="YES">
        <cfprocparam TYPE="IN" DBVARNAME="@adt_dtDATE" VALUE="#url.date#" cfsqltype="CF_SQL_DATE">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_iUSID" VALUE="#url.id#" cfsqltype="CF_SQL_INTEGER">

        <cfif isDefined("cfstoredproc.StatusCode")>
            <cfif cfstoredproc.StatusCode == -1>
                <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspRejectStaffHotDesk-INSERT(#cfstoredproc.StatusCode#)">
            </cfif>
        </cfif>
    </cfstoredproc>

    <script>
        alert("You have rejected hot seat for #getName.vaNAME# on #DateFormat(url.date, "dd/mm/yyyy")#!");
        // Redirect to the login page
        window.location.href = "index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#&week=#session.vars.week#"; 
    </script>

    </cfif>
    
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to update hot seat approval status! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#&week=#session.vars.week#"; 
            </script>
    </cfcatch>
</cftry>
<cfelse>
    fail
</cfif>
</cfoutput>
