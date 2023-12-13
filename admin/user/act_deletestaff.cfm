<!--- Check if the ID parameter exists and is numeric --->
<cfparam name="url.id" default="">

<cfoutput>
<cfif isNumeric(url.id)>

<cftry>
    <!--- SSP : Delete the staff based on the ID by changing status to 1 --->
    <cfstoredproc  PROCEDURE="sspManageStaff" DATASOURCE="intro" RETURNCODE="YES">
        <cfprocparam TYPE="IN" DBVARNAME="@asi_siMode" VALUE=2 cfsqltype="CF_SQL_SMALLINT">
        <cfprocparam TYPE="IN" DBVARNAME="@as_vaNAME" NULL="YES" cfsqltype="CF_SQL_VARCHAR">
        <cfprocparam TYPE="IN" DBVARNAME="@as_vaUSERNAME" NULL="YES" cfsqltype="CF_SQL_VARCHAR">
        <cfprocparam TYPE="IN" DBVARNAME="@as_vaPASSWORD" NULL="YES" cfsqltype="CF_SQL_VARCHAR">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_iROLEID" NULL="YES" cfsqltype="CF_SQL_INTEGER">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_iTEAMID" NULL="YES" cfsqltype="CF_SQL_INTEGER">
        <cfprocparam TYPE="IN" DBVARNAME="@ai_iUSID" VALUE="#url.id#" cfsqltype="CF_SQL_INTEGER">


        <cfif isDefined("cfstoredproc.StatusCode")>
            <cfif cfstoredproc.StatusCode LT 0>
                <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspManageStaff-UPDATE(#cfstoredproc.StatusCode#)">
            </cfif>
        </cfif>
    </cfstoredproc>


<!--- Redirect back to the main page after the deletion --->
<!--- after deleting, redirect to admin home page with success message --->
    <script>
        alert("You have successfully deleted the staff!");
        // Redirect to the login page
        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_staff&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to delete staff! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_staff&#session.urltoken#"; 
            </script>
    </cfcatch>
</cftry>    
</cfif>
</cfoutput>
