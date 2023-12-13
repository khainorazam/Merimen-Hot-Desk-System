<!--- Update Monthly Schedule Action  --->
<cfparam name="form.update_month" default="">
<cfparam name="form.update_group" default="">

<cfoutput>
<cfif structKeyExists(form, "update_month")>
<cftry>

    <cfset updateMonth = form.update_month>
    <cfset updateGroup = form.update_group>

    <cfif isNumeric(updateMonth) and listLen(updateGroup)>
        <!---  query: update the weekdays of the month with the sequence of the group, 
           in a week cannot have the same group twice, 
           for example, if the week has january and february, maintain with the 
           january arrangement.
           logic:
           if the monday of the week is january, maintain arrangement of the week as usual
           if the first day of the month is not monday, execute the next week 
        --->

        <cfset updateGroupList = listToArray(updateGroup)>
        <cfset firstDayOfMonth = DateFormat(createDate(year(now()), updateMonth, 1))>
        <cfif updateMonth eq 12>
            <!-- If the month is December, set lastDayOfMonth to January of the next year minus one day -->
            <cfset lastDayOfMonth = DateFormat(createDate(year(now()) + 1, 1, 1) - createTimespan(0, 0, 1, 0))>
        <cfelse>
            <!-- For other months, use the existing calculation -->
            <cfset lastDayOfMonth = DateFormat(createDate(year(now()), updateMonth + 1, 1) - createTimespan(0, 0, 1, 0))>
        </cfif>

        
        <cfset startDay = firstDayOfMonth>
        <cfset endDay = lastDayOfMonth>

        <cfif dayOfWeek(firstDayOfMonth) neq 2>
            <!-- If the first day of the month is not Monday, set startDay to the next Monday -->
            <cfset startDay = DateFormat(dateAdd("d", 9 - dayOfWeek(firstDayOfMonth), firstDayOfMonth), "YYYY-MM-DD")>
        </cfif>

        <cfif dayOfWeek(lastDayofMonth) neq 1>
            <!-- If lastDayofMonth is not a Sunday, set endDay to the Sunday of the same week -->
            <cfset endDay = DateFormat(dateAdd("d", 6 - dayOfWeek(lastDayofMonth), lastDayofMonth), "YYYY-MM-DD")>
        </cfif>

        <cfquery name="getDatesQuery" datasource="intro">
            SELECT dtDATE, iGROUPID
            FROM DATE_HDDATA
            WHERE dtDATE >= <cfqueryparam value="#startDay#" cfsqltype="cf_sql_date">
            AND dtDATE < <cfqueryparam value="#endDay#" cfsqltype="cf_sql_date">
        </cfquery>

        <cfloop query="getDatesQuery">
            <cfset currentDayOfWeek = dayOfWeek(getDatesQuery.dtDATE)>

            <!-- Check if the current day is not Saturday or Sunday -->
            <cfif currentDayOfWeek neq 1 AND currentDayOfWeek neq 7>
                <cfset updateIndex = currentDayOfWeek - 1>

                <!-- Update the group based on the day -->
                <cfquery name="updateGroup" datasource="intro">
                    UPDATE DATE_HDDATA
                    SET iGROUPID = <cfqueryparam cfsqltype="cf_sql_integer" value="#updateGroupList[updateIndex]#">
                    WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#getDatesQuery.dtDATE#">
                </cfquery>
            </cfif>
        </cfloop>

    </cfif>

<!--- after updating, redirect to monthly schedule page with success message --->
    <script>
        alert("You have successfully updated monthly schedule!");
        // Redirect to the update monthly schedule page
        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_updatemonthlyschedule&#session.urltoken#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to update monthly schedule! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_updatemonthlyschedule&#session.urltoken#"; 
            </script>
    </cfcatch>
</cftry>
<cfelse>
    fail
</cfif>
</cfoutput>
