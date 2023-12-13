<!--- Update Password Action --->
<cfif StructKeyExists(Form, "password1")>
    <cfset password = Hash(Form.password1, "SHA-256")>
<cftry>
    <cfif StructKeyExists(Form, "currentpassword")><!--- For change current password  --->
        <cfset currPassword = Hash(Form.currentpassword, "SHA-256")>

        <cfquery name="getUser" datasource="intro">
            SELECT vaPASSWORD
            FROM USR_DATA
            WHERE iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.update_id#">
        </cfquery>

        <cfif currPassword eq getUser.vaPASSWORD>
            <!--- Query: Update profile --->
            <cfquery name="changePassword" datasource="intro">
                UPDATE USR_DATA
                SET vaPASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#password#">
                WHERE iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.update_id#">
            </cfquery>

            <!--- after updating, redirect to profile page with success message --->
            <script>
                alert("You have successfully updated the password!");
                window.location.href = "index.cfm?fusebox=staff&fuseaction=dsp_profile&#session.urltoken#"; 
            </script>
        <cfelse>
            <!-- Redirect to catch block if passwords do not match -->
            <cfthrow TYPE="PasswordMismatch" MESSAGE="Passwords do not match">
        </cfif>
    <cfelse><!--- First-time change password  --->
        <!--- SSP : Update the password for first-time --->
        <cfstoredproc PROCEDURE="sspUpdatePWDFirstTime" DATASOURCE="intro" RETURNCODE="YES">
            <cfprocparam TYPE="IN" DBVARNAME="@as_vaPASSWORD" VALUE="#password#" cfsqltype="CF_SQL_VARCHAR">
            <cfprocparam TYPE="IN" DBVARNAME="@ai_iUPDATEPWD" VALUE=1 cfsqltype="CF_SQL_INTEGER">
            <cfprocparam TYPE="IN" DBVARNAME="@ai_iUSID" VALUE="#session.vars.usid#" cfsqltype="CF_SQL_INTEGER">

            <cfif isDefined("cfstoredproc.StatusCode")>
                <cfif cfstoredproc.StatusCode LT 0>
                    <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspUpdatePWDFirstTime-UPDATE(#cfstoredproc.StatusCode#)">
                </cfif>
            </cfif>
        </cfstoredproc>

        <!--- after updating, redirect to login page again to try new password --->
        <script>
            alert("You have successfully updated the password! Login using the new password.");
            // Logout the user 
            window.location.href = "index.cfm?fusebox=auth&fuseaction=act_logout"; 
        </script>
    </cfif>

    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to update password! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=staff&fuseaction=dsp_profile&#session.urltoken#"; 
            </script>
    </cfcatch>
    <cfcatch type="PasswordMismatch">
        <!-- Handle incorrect password -->
        <script>
            alert("Error: Incorrect current password. Please try again.");
            // Redirect to the previous page 
            window.location.href = "index.cfm?fusebox=staff&fuseaction=dsp_profile&#session.urltoken#"; 
        </script>
    </cfcatch>
</cftry>
<cfelse>
    fail
</cfif>





