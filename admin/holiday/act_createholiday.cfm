<!--- Create Holiday Action --->
<cfif StructKeyExists(Form, "name")>
    <cfset name = Form.name>
    <cfset date = Form.date> 
    <cfset date = DateFormat(ParseDateTime(Form.date, 'dd/mm/yyyy'), 'yyyy-mm-dd')>

    <!--- get all holiday dates and compare with date entered, date has to be unique --->
    <cfquery name="holidaydates" datasource="intro">
        SELECT dtDATE
        FROM HOLIDAY_DATA
    </cfquery>

    <cfset isDateUnique = true>

    <!--- Check if the entered date already exists in the database --->
    <cfloop query="holidaydates">
        <cfif date eq holidaydates.dtDATE>
            <!--- Date already exists, set a flag to indicate it's not unique --->
            <cfset isDateUnique = false>
            <!--- Exit the loop since we found a match --->
            <cfbreak>
        </cfif>
    </cfloop>

    <!--- if date is unique, create the holiday --->
    <cfif isDateUnique>
        <cftry>
            <!--- Query: Insert holiday data into the database --->
            <cfquery name="createHoliday" datasource="intro">
                INSERT INTO HOLIDAY_DATA (dtDATE, vaNAME)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_date" value="#date#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">
                )
            </cfquery>

            <!-- Query: Update the date in Hot Desk Table to include the holiday to the date -->
            <cfquery name="updateHotDeskDate" datasource="intro">
                UPDATE DATE_HDDATA
                SET iHOLIDAY = 1
                WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#date#">
            </cfquery>
            
            <!--- after saving, redirect to holiday page with success message --->
            <cfoutput>
                <script>
                    alert("You have successfully created the holiday!");
                    // Redirect to the login page
                    window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_holiday&#session.urltoken#"; 
                </script>
            </cfoutput>
            <cfcatch type="Database">
                <!--- Database error occurred, handle it --->
                <cfoutput>
                    <script>
                        alert("Error: Failed to create holiday! Please try filling the details again.");
                        // Redirect to the previous page 
                        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_holiday&#session.urltoken#"; 
                    </script>
                </cfoutput>
            </cfcatch>
        </cftry>
    <!---     if not unique, send an error message    --->
    <cfelse>
        <cfoutput>
            <script>
                alert("Error: Date already has a holiday assigned to it! Please enter another date.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_holiday&#session.urltoken#"; 
            </script>
        </cfoutput>
    </cfif>
<cfelse>
    fail
</cfif>





