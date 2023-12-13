<!--- Create Staff Action --->
<cfif StructKeyExists(Form, "name")>
    <cfset name = Form.name>
    <cfset nickname = Form.nickname>

    <!--- get all names and compare with username entered, username has to be unique --->
    <cfquery name="names" datasource="intro">
        SELECT vaNAME
        FROM TEAM_DATA
    </cfquery>

    <cfset isUsernameUnique = true>

    <!--- Check if the entered username already exists in the database --->
    <cfloop query="names">
        <cfif name eq names.vaNAME>
            <!--- Username already exists, set a flag to indicate it's not unique --->
            <cfset isUsernameUnique = false>
            <!--- Exit the loop since we found a match --->
            <cfbreak>
        </cfif>
    </cfloop>

    <!--- if username is unique, create the staff --->
    <cfif isUsernameUnique>
        <cftry>
            <!-- Query: Check which group has the least amount of teams -->
            <cfquery name="getSmallestGroup" datasource="intro" maxrows="1">
                SELECT iGROUPID
                FROM TEAM_DATA
                WHERE iGROUPID IS NOT NULL
                GROUP BY iGROUPID
                ORDER BY COUNT(*) ASC;
            </cfquery>

            <!--- Query: create team and add to least group --->
            <cfquery name="createTeam" datasource="intro">
                INSERT INTO TEAM_DATA (vaNAME, vaNICKNAME, iGROUPID)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(name)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(nickname)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#getSmallestGroup.iGROUPID#">
                )
            </cfquery>

            <!--- after saving, redirect to team page with success message --->
            <cfoutput>
                <script>
                    alert("You have successfully created the team!");
                    // Redirect to the login page
                    window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_monthlyschedule&#session.urltoken#"; 
                </script>
            </cfoutput>
            <cfcatch type="Database">
                <!--- Database error occurred, handle it --->
                <cfoutput>
                    <script>
                        alert("Error: Failed to create team! Please try filling the details again.");
                        // Redirect to the previous page 
                        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_monthlyschedule&#session.urltoken#"; 
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
                window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_monthlyschedule&#session.urltoken#"; 
            </script>
        </cfoutput>
    </cfif>
<cfelse>
    fail
</cfif>





