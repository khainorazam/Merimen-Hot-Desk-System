<!--- Monthly Schedule Page --->

<html>
    <head>
        <title>Monthly Schedule Page - Hot Desk System</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap 4 CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

        <style>
            /* Highlighted row styles */
            .highlighted-cell {
                background-color: black;
                font-weight: bold;
                color: white;
            }

        </style>
    </head>
<!--- for Merimen CSS    --->
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCSS"> 
<!--- JQuery --->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <body>
        <!--- Calculate the current month and day --->
        <cfset currentMonth = Month(Now())>
        <cfset currentDay = DayOfWeek(Now())>

        <!-- Monthly Schedule -->
        <div class="container text-center" style="margin-top:50px;">
            <cfoutput>
            <h3>Team Monthly Schedule #Year(Now())#</h3>
            </cfoutput>
        </div>
        <div class="container">
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Day/Month</th>
                        <cfoutput>
                            <cfloop from="1" to="12" index="month">
                                <th>#monthAsString(month)#</th>
                            </cfloop>
                        </cfoutput>
                    </tr>
                </thead>
                <tbody>
                    <cfset daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]>
                    <cfloop from="1" to="5" index="dayIndex">
                        <tr>
                            <td><cfoutput>#daysOfWeek[dayIndex]#</cfoutput></td>
                            <cfset startDay = "">
                            <cfloop from="1" to="12" index="month">
                                <cfset firstDayOfMonth = DateFormat(createDate(year(now()), month, 1))>

                                <cfif dayOfWeek(firstDayOfMonth) neq 2>
                                    <!-- If the first day of the month is not Monday, set startDay to the next Monday -->
                                    <cfset startDay = DateFormat(dateAdd("d", 9 - dayOfWeek(firstDayOfMonth), firstDayOfMonth), "YYYY-MM-DD")>
                                </cfif>

                                <!--- 
                                Query: gets the top 1 groupID to display for the month.
                                Why take the top 1? Because in a week, the week might change to other month but teams have not changed yet,
                                so can cause overlapping of teams in a month while actually only not as much team for that month.
                                Also joins with DATE_HDDATA to get the iGROUPID for that date based on the dayIndex and month
                                --->

                                <cfquery name="team" datasource="intro">
                                    SELECT TOP 1 a.iGROUPID, b.dtDATE
                                    FROM TEAM_DATA a
                                    INNER JOIN DATE_HDDATA b ON a.iGROUPID = b.iGROUPID
                                    WHERE DATEPART(WEEKDAY, b.dtDATE) = #dayIndex + 1#
                                        AND MONTH(b.dtDATE) = #month#
                                        AND b.dtDATE >= <cfqueryparam value="#startDay#" cfsqltype="cf_sql_date">
                                </cfquery>


                                <cfset groupID = team.iGROUPID>
                                <cfset teamNames = []>

                                <!--- Query: gets the teams based on the groupID to display in the table --->
                                <cfquery name="getTeamsinGroup" datasource="intro">
                                    SELECT vaNICKNAME
                                    FROM TEAM_DATA
                                    WHERE iGROUPID = <cfqueryparam cfsqltype="cf_sql_integer" value="#groupID#">
                                </cfquery>

                                <cfloop query="getTeamsinGroup">
                                    <cfset ArrayAppend(teamNames, getTeamsinGroup.vaNICKNAME)>
                                </cfloop>

                                <td <cfif month == currentMonth and dayIndex + 1 == currentDay> class="highlighted-cell"</cfif>>
                                    <cfoutput query="team">
                                        #ArrayToList(teamNames, '/')#
                                    </cfoutput>
                                </td>
                            </cfloop>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
            <!--- Download the Hot Seat Information --->
            <button id="viewMonthlySchedule" class="btn btn-primary" >View More</button> 
        </div>

        <script>
            document.getElementById('viewMonthlySchedule').addEventListener('click', function() {
                // Go to update monthly schedule page
                <cfoutput>
                window.location.href = 'index.cfm?fusebox=admin&fuseaction=dsp_updatemonthlyschedule&#session.urltoken#';
                </cfoutput>
            });
        </script>

        <!--- Make another table that shows all teams and can add team  --->
        <cfinclude  template="../team/dsp_team.cfm">


    </body>
</html>

