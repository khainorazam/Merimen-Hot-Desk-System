<!--- Pop Up for Update Monthly Schedule --->

<!-- Hidden pop-up container for Update Button -->
<cfset startDay = "">
<cfif url.month eq "">
    <cfloop from="1" to="12" index="month">
        <cfset firstDayOfMonth = DateFormat(createDate(year(now()), month, 1))>

        <cfif dayOfWeek(firstDayOfMonth) neq 2>
            <!-- If the first day of the month is not Monday, set startDay to the next Monday -->
            <cfset startDay = DateFormat(dateAdd("d", 9 - dayOfWeek(firstDayOfMonth), firstDayOfMonth), "YYYY-MM-DD")>
        </cfif>
        <cfoutput query="groupAll">
            <div id="popup-#month#" class="popup-container">
                <h1>Update #monthAsString(month)#'s Schedule</h1>
                <form action="index.cfm?fusebox=admin&fuseaction=act_updatemonthlyschedule&#session.urltoken#" method="POST" name="updatemonthlyscheduleform">
                    <table  border=3 cellpadding=3 width=100%>
                        <col width=25% style=font-weight:bold;background-color:lightyellow>
                        <col width=75% style=background-color:gainsboro>
                        <cfloop from="1" to="5" index="dayIndex">
                            <!--- query: get the groupid for the days --->
                            <cfquery name="groupSpecific" datasource="intro">
                                SELECT TOP 1 a.iGROUPID
                                FROM TEAM_DATA a
                                INNER JOIN DATE_HDDATA b ON a.iGROUPID = b.iGROUPID
                                WHERE DATEPART(WEEKDAY, b.dtDATE) = #dayIndex + 1#
                                    AND MONTH(b.dtDATE) = #month#
                                    <cfif dayOfWeek(firstDayOfMonth) neq 2>
                                    AND b.dtDATE >= <cfqueryparam value="#startDay#" cfsqltype="cf_sql_date">
                                    </cfif>
                            </cfquery>

                            <cfset groupIDDay = groupSpecific.iGROUPID>
                            <cfset teamNames = []>

                            <!--- Query: gets the teams based on the groupID to display in the table --->
                            <cfquery name="getTeamsinGroup" datasource="intro">
                                SELECT vaNICKNAME
                                FROM TEAM_DATA
                                WHERE iGROUPID = <cfqueryparam cfsqltype="cf_sql_integer" value="#groupIDDay#">
                            </cfquery>

                            <cfloop query="getTeamsinGroup">
                                <cfset ArrayAppend(teamNames, getTeamsinGroup.vaNICKNAME)>
                            </cfloop>

                            <cfoutput>
                            <tr>
                                <td class=clsField1>#daysOfWeek[dayIndex]#</td>
                                <td class=clsValue1>
                                    <!--- query: get all groups for selection --->
                                    <cfquery name="getAllGroups" datasource="intro" >
                                        SELECT DISTINCT iGROUPID
                                        FROM TEAM_DATA
                                        WHERE iGROUPID IS NOT NULL
                                        GROUP BY iGROUPID
                                    </cfquery>
                                    
                                    
                                    <select id="update-group-#month#" name="update_group" class="form-select" onblur="DoReq(this)" chkname="List of Groups" CHKREQUIRED>
                                        <option selected value="#groupIDDay#">#ArrayToList(teamNames, '/')#</option> <!--- The day's compulsory --->
                                        <cfloop query="getAllGroups">
                                            <cfset groupIDSelect = getAllGroups.iGROUPID>
                                            <cfset teamNames = []>

                                            <!--- Query: gets the teams based on the groupID to display in the table --->
                                            <cfquery name="getTeamsinGroup" datasource="intro">
                                                SELECT vaNICKNAME
                                                FROM TEAM_DATA
                                                WHERE iGROUPID = <cfqueryparam cfsqltype="cf_sql_integer" value="#groupIDSelect#">
                                            </cfquery>

                                            <cfloop query="getTeamsinGroup">
                                                <cfset ArrayAppend(teamNames, getTeamsinGroup.vaNICKNAME)>
                                            </cfloop>
                                            <cfif groupIDSelect neq groupIDDAY>
                                                <option value="#groupIDSelect#">#ArrayToList(teamNames, '/')#</option>
                                            </cfif>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            </cfoutput>
                        </cfloop>
                    </table>

                    <!-- Hidden input field for ID -->
                    <input type="hidden" name="update_month" value="#month#">

                    <input type="button" value="UPDATE" onclick="if (checkDuplicateSelections(#month#)) this.form.submit();" class="clsButton">
                    </div>
                </form>
            </div>
        </cfoutput>
    </cfloop>
<cfelse>
<cfset firstDayOfMonth = DateFormat(createDate(year(now()), url.month, 1))>

<cfif dayOfWeek(firstDayOfMonth) neq 2>
    <!-- If the first day of the month is not Monday, set startDay to the next Monday -->
    <cfset startDay = DateFormat(dateAdd("d", 9 - dayOfWeek(firstDayOfMonth), firstDayOfMonth), "YYYY-MM-DD")>
</cfif>
<cfoutput query="groupSpecific">
    <div id="popup-#url.month#" class="popup-container">
        <h1>Update #monthAsString(url.month)#'s Schedule</h1>
        <form action="index.cfm?fusebox=admin&fuseaction=act_updatemonthlyschedule&#session.urltoken#" method="POST" name="updatemonthlyschedulespecificform">
            <table  border=3 cellpadding=3 width=100%>
                <col width=25% style=font-weight:bold;background-color:lightyellow>
                <col width=75% style=background-color:gainsboro>
                <cfloop from="1" to="5" index="dayIndex">
                    <!--- query: get the groupid for the days --->
                    <cfquery name="group" datasource="intro">
                        SELECT TOP 1 a.iGROUPID
                        FROM TEAM_DATA a
                        INNER JOIN DATE_HDDATA b ON a.iGROUPID = b.iGROUPID
                        WHERE DATEPART(WEEKDAY, b.dtDATE) = #dayIndex + 1#
                            AND MONTH(b.dtDATE) = #url.month#
                            <cfif dayOfWeek(firstDayOfMonth) neq 2>
                            AND b.dtDATE >= <cfqueryparam value="#startDay#" cfsqltype="cf_sql_date">
                            </cfif>
                    </cfquery>

                    <cfset groupIDDay = group.iGROUPID>
                    <cfset teamNames = []>

                    <!--- Query: gets the teams based on the groupID to display in the table --->
                    <cfquery name="getTeamsinGroup" datasource="intro">
                        SELECT vaNICKNAME
                        FROM TEAM_DATA
                        WHERE iGROUPID = <cfqueryparam cfsqltype="cf_sql_integer" value="#groupIDDay#">
                    </cfquery>

                    <cfloop query="getTeamsinGroup">
                        <cfset ArrayAppend(teamNames, getTeamsinGroup.vaNICKNAME)>
                    </cfloop>

                    <cfoutput>
                    <tr>
                        <td class=clsField1>#daysOfWeek[dayIndex]#</td>
                        <td class=clsValue1>
                            <!--- query: get all groups for selection --->
                            <cfquery name="getAllGroups" datasource="intro" >
                                SELECT DISTINCT iGROUPID
                                FROM TEAM_DATA
                                WHERE iGROUPID IS NOT NULL
                                GROUP BY iGROUPID
                            </cfquery>
                            
                            
                            <select id="update-group-#url.month#" name="update_group" class="form-select" onblur="DoReq(this)" chkname="List of Groups" CHKREQUIRED>
                                <option selected value="#groupIDDay#">#ArrayToList(teamNames, '/')#</option> <!--- The day's compulsory --->
                                <cfloop query="getAllGroups">
                                    <cfset groupIDSelect = getAllGroups.iGROUPID>
                                    <cfset teamNames = []>

                                    <!--- Query: gets the teams based on the groupID to display in the table --->
                                    <cfquery name="getTeamsinGroup" datasource="intro">
                                        SELECT vaNICKNAME
                                        FROM TEAM_DATA
                                        WHERE iGROUPID = <cfqueryparam cfsqltype="cf_sql_integer" value="#groupIDSelect#">
                                    </cfquery>

                                    <cfloop query="getTeamsinGroup">
                                        <cfset ArrayAppend(teamNames, getTeamsinGroup.vaNICKNAME)>
                                    </cfloop>
                                    <cfif groupIDSelect neq groupIDDAY>
                                        <option value="#groupIDSelect#">#ArrayToList(teamNames, '/')#</option>
                                    </cfif>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                    </cfoutput>
                </cfloop>
            </table>

            <!-- Hidden input field for ID -->
            <input type="hidden" name="update_month" value="#url.month#">

            <input type="button" value="UPDATE" onclick="if (checkDuplicateSelections(#url.month#)) this.form.submit();" class="clsButton">
            </div>
        </form>
    </div>
</cfoutput>
</cfif>

<script>
    function checkDuplicateSelections(month) {
        var selectedValues = [];
        var dropdowns = document.querySelectorAll('#popup-' + month + ' select');

        for (var i = 0; i < dropdowns.length; i++) {
            var value = dropdowns[i].value;
            if (selectedValues.includes(value)) {
                alert('Please select unique values for each day.');
                return false;
            }
            selectedValues.push(value);
        }

        return true;
    }
</script>

<div class="overlay" id="overlay" onclick="hideAllPopups()"></div>
