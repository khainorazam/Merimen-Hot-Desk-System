<!--- Create Staff Action --->
<cfif StructKeyExists(Form, "name")>
    <cfset name = Form.name>
    <cfset username = Form.username>
    <cfset password = Hash("password", "SHA-256")>
    <cfset role = Form.role>
    <cfset team = Form.team>
    <!--- if role = 1 (NORMAL STAFF), it will be assigned with 7 (NO TEAM) --->
    <cfif role eq 1>
        <cfset team = 7>
    </cfif>

    <!--- get all usernames and compare with username entered, username has to be unique --->
    <cfquery name="usernames" datasource="intro">
        SELECT vaUSERNAME
        FROM USR_DATA
        WHERE siSTATUS = 0
    </cfquery>

    <cfset isTeamleadUnique = true>

    <!---     If there is existing team lead, send error message --->
    <cfif role eq 2>
        <cfquery name="teamlead" datasource="intro">
            SELECT vaUSERNAME
            FROM USR_DATA
            WHERE iROLEID = 2 AND iTEAMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#team#">
        </cfquery>

        <cfif teamlead.RecordCount>
            <cfoutput>
                <script>
                    alert("Error: The team lead for the team already exist.");
                    // Redirect to the previous page 
                    window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_staff&#session.urltoken#"; 
                </script>
            </cfoutput>
            <cfset isTeamleadUnique = false>
        </cfif>
    </cfif>

    <cfset isUsernameUnique = true>

    <!--- Check if the entered username already exists in the database --->
    <cfloop query="usernames">
        <cfif username eq usernames.vaUSERNAME>
            <!--- Username already exists, set a flag to indicate it's not unique --->
            <cfset isUsernameUnique = false>
            <!--- Exit the loop since we found a match --->
            <cfbreak>
        </cfif>
    </cfloop>

    <!--- if username is unique, create the staff --->
    <cfif isUsernameUnique and isTeamleadUnique>
        <cftry>
            <!-- SSP: Insert user data into the database -->
            <cfstoredproc  PROCEDURE="sspManageStaff" DATASOURCE="intro" RETURNCODE="YES">
                <cfprocparam TYPE="IN" DBVARNAME="@asi_siMode" VALUE=1 cfsqltype="CF_SQL_SMALLINT">
                <cfprocparam TYPE="IN" DBVARNAME="@as_vaNAME" VALUE="#name#" cfsqltype="CF_SQL_VARCHAR">
                <cfprocparam TYPE="IN" DBVARNAME="@as_vaUSERNAME" VALUE="#username#" cfsqltype="CF_SQL_VARCHAR">
                <cfprocparam TYPE="IN" DBVARNAME="@as_vaPASSWORD" VALUE="#password#" cfsqltype="CF_SQL_VARCHAR">
                <cfprocparam TYPE="IN" DBVARNAME="@ai_iROLEID" VALUE="#role#" cfsqltype="CF_SQL_INTEGER">
                <cfprocparam TYPE="IN" DBVARNAME="@ai_iTEAMID" VALUE="#team#" cfsqltype="CF_SQL_INTEGER">
                <cfprocparam TYPE="IN" DBVARNAME="@ai_iUSID" NULL="YES" cfsqltype="CF_SQL_INTEGER">


                <cfif isDefined("cfstoredproc.StatusCode")>
                    <cfif cfstoredproc.StatusCode LT 0>
                        <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspManageStaff-INSERT(#cfstoredproc.StatusCode#)">
                    </cfif>
                </cfif>
            </cfstoredproc>

            <!--- after saving, redirect to admin home page with success message --->
            <cfoutput>
                <script>
                    alert("You have successfully created the staff!");
                    // Redirect to the login page
                    window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_staff&#session.urltoken#"; 
                </script>
            </cfoutput>
            <cfcatch type="Database">
                <!--- Database error occurred, handle it --->
                <cfoutput>
                    <script>
                        alert("Error: Failed to create staff! Please try filling the details again.");
                        // Redirect to the previous page 
                        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_staff&#session.urltoken#"; 
                    </script>
                </cfoutput>
            </cfcatch>
        </cftry>
    <!---     if not unique, send an error message    --->
    <cfelse>
        <cfoutput>
            <script>
                alert("Error: Username is already taken! Please enter another username.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_staff&#session.urltoken#"; 
            </script>
        </cfoutput>
    </cfif>
<cfelse>
    fail
</cfif>





