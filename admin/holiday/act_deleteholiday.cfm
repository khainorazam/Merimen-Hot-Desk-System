<!--- Check if the ID parameter exists and is numeric --->
<cfparam name="url.id" default="">

<cfoutput>
<cfif isNumeric(url.id)>

<cftry>
    <cfquery name="getHolidayInfo" datasource="intro">
        SELECT dtDATE
        FROM HOLIDAY_DATA
        WHERE iHOLIDAYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
    </cfquery>

    <!-- Update hot desk data iHOLIDAY to NULL for all rows with the same date -->
    <cfquery name="updateHotDeskInfo" datasource="intro">
        UPDATE DATE_HDDATA
        SET iHOLIDAY = NULL
        WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#getHolidayInfo.dtDATE#">
    </cfquery>

    <!-- Delete the holiday based on the ID -->
    <cfquery name="deleteHoliday" datasource="intro">
        DELETE FROM HOLIDAY_DATA
        WHERE iHOLIDAYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
    </cfquery>


<!--- Redirect back to the main page after the deletion --->
<!--- after deleting, redirect to holiday page with success message --->
    <script>
        alert("You have successfully deleted the holiday!");
        // Redirect to the holiday page
        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_holiday&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to delete holiday! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_holiday&#session.urltoken#"; 
            </script>
    </cfcatch>
</cftry>    
</cfif>
</cfoutput>
