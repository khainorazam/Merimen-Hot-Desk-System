<!--- Home Page --->
<cfset structDelete(session.vars, "week")>
<cfset structDelete(session.vars, "startDate")>
<cfset structDelete(session.vars, "endDate")>
<html>
    <head>
        <title>Home Page - Hot Desk System</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap 4 CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

        <style>
            /* Custom styles for the modern dashboard */
            .dashboard {
                padding: 20px;
                background-color: #f8f9fa;
            }

            .dashboard-title {
                font-size: 28px;
                font-weight: bold;
                margin-bottom: 20px;
            }

            .data-table {
                border: 1px solid #e9e9e9;
                border-collapse: collapse;
                width: 100%;
                background-color: #fff;
            }

            .data-table th,
            .data-table td {
                border: 1px solid #e9e9e9;
                padding: 15px;
                text-align: center;
            }

            #downloadButton {
                position: absolute;
                bottom: 20px;
                right: 20px;
            }

            /* Highlighted row styles */
            .highlighted-row {
                background-color: black;
                font-weight: bold;
                color: white;
            }

            /* Highlighted cell styles */
            .highlighted-cell {
                background-color: black;
                color: white;
            }

           .modern-link {
                text-decoration: none;
                color: #3498db;
                font-weight: bold;
                transition: color 0.3s ease-in-out;
                cursor: pointer;
            }

            .modern-link:hover {
                color: #1abc9c;
            }
        </style>
    </head>

<!--- for Merimen CSS    --->
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCSS"> 
<!--- JQuery --->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<body>
    <cfset currentDate = now()>
    <cfset weekNumber = DatePart("ww", currentDate)>

    <cfset daysToMonday = 2 - DayOfWeek(currentDate)>
    <cfset daysToFriday = 6 - DayOfWeek(currentDate)>

    <!-- Calculate the startDate (Monday) and endDate (Friday) -->
    <cfset startDate = DateAdd("d", daysToMonday, currentDate)>
    <cfset endDate = DateAdd("d", daysToFriday, currentDate)>

    <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
        <cfquery name="getTeamName" datasource="intro">
            SELECT vaNAME
            FROM TEAM_DATA
            WHERE iTEAMID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.vars.teamid#"/>
        </cfquery>
    </cfif>

    <!--- Dashboard of Current Week's Info --->
    <div class="dashboard">
        <div class="container">
            <div class="dashboard-title">
                Current Week Hot Desk
            </div>
            <table class="data-table table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                        <th colspan = "9">
                        <cfelseif session.vars.roleid eq 3>
                        <th colspan = "7">
                        </cfif>
                            <cfoutput>
                            Week #weekNumber# : #DateFormat(startDate, "dd/mm/yyyy")# - #DateFormat(endDate, "dd/mm/yyyy")#
                            </cfoutput>
                        </th>
                    </tr>
                    <tr>
                        <th>Date</th>
                        <th>Day</th>
                        <th>Total Seat</th>
                        <th>Seat(s) Available</th>
                        <th>Seat(s) Occupied</th>
                        <th>Emergency/Unplanned Seats</th>
                        <th>Compulsory Team</th>
                        <cfif (session.vars.roleid eq 1 || session.vars.roleid eq 2) and session.vars.teamid neq 7 >
                            <cfoutput>
                            <th>#getTeamName.vaNAME# Seats</th>
                            <th>#session.vars.name#'s Hot Desk Status</th>
                            </cfoutput>
                        </cfif>
                    </tr>
                </thead>
                <tbody>
                    <!-- Loop to populate table rows with data -->
                    <cfloop from="#startDate#" to="#endDate#" index="currentDate">
                        <cfset currentDateDBFormat = DateFormat(currentDate, "yyyy-mm-dd")>
                        <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                        <!--- query: get information for hot desk --->
                        <cfquery name="GetHotDeskInformation" datasource="intro">
                            SELECT
                            a.dtDATE,
                            MAX(a.iSEAT_TOTAL) AS iSEAT_TOTAL,
                            MAX(a.iSEAT_OCCUPIED) AS iSEAT_OCCUPIED,
                            MAX(a.iSEAT_EMERGENCY) AS iSEAT_EMERGENCY,
                            MAX(a.iWEEKEND) AS iWEEKEND,
                            MAX(b.vaNICKNAME) AS vaNICKNAME,
                            MAX(a.iHOLIDAY) AS iHOLIDAY,
                            MAX(a.iGROUPID) AS iGROUPID,
                            (
                                SELECT COUNT(*) AS DateCount
                                FROM HD_DATA
                                WHERE iUSID IN (
                                    SELECT iUSID
                                    FROM USR_DATA
                                    WHERE iTEAMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.vars.teamid#"/>
                                )
                                AND dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#currentDateDBFormat#">
                                AND iREQAPPROVAL = <cfqueryparam cfsqltype="cf_sql_integer" value="0" />
                            ) AS TotalTeamRecordCount
                            FROM DATE_HDDATA a
                            INNER JOIN TEAM_DATA b ON a.iGROUPID = b.iGROUPID
                            WHERE a.dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#currentDateDBFormat#"/>
                            GROUP BY a.dtDATE
                        </cfquery>


                        <!--- query: get iREQAPPROVAL status for user on the date --->
                        <cfquery name="getReqApproval" datasource="intro">
                            SELECT iREQAPPROVAL
                            FROM HD_DATA
                            WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#currentDateDBFormat#"/>
                            AND iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.vars.usid#"/> 
                        </cfquery>

                        <cfelseif session.vars.roleid eq 3>
                        <cfstoredproc  PROCEDURE="sspGetHotDeskInfo" DATASOURCE="intro" RETURNCODE="YES">
                            <cfprocparam TYPE="IN" DBVARNAME="@adt_dtDATE" VALUE="#currentDateDBFormat#" cfsqltype="CF_SQL_DATE">

                            <cfif isDefined("cfstoredproc.StatusCode")>
                                <cfif cfstoredproc.StatusCode lt 0>
                                    <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspGetHotDeskInfo-SELECT(#cfstoredproc.StatusCode#)">
                                </cfif>
                            </cfif>

                            <cfprocresult name="GetHotDeskInformation">
                        </cfstoredproc>
                        </cfif>

                        <cfset groupID = GetHotDeskInformation.iGROUPID>
                        <cfset teamNames = []>
                        <cfset isHoliday = false>

                        <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                        <!--- Setting status for hot desk status column --->
                        <cfset status = "-">
                        <cfset approveStatus = false>
                        <cfset pendingStatus = false>
                        <cfset rejectStatus = false>

                        <cfif getReqApproval.RecordCount>
                            <cfif getReqApproval.iREQAPPROVAL eq 0>
                                <cfset approveStatus = true>
                                <cfset status = "APPROVED">
                            <cfelseif getReqApproval.iREQAPPROVAL eq 1>
                                <cfset pendingStatus = true>
                                <cfset status = "PENDING">
                            <cfelseif getReqApproval.iREQAPPROVAL eq 2>
                                <cfset rejectStatus = true>
                                <cfset status = "REJECTED">
                            </cfif>
                        </cfif>

                        <!--- Setting compulsory color on hot desk status column --->
                        <cfset compulsoryStatus = false>

                        <cfif groupID eq session.vars.groupID>
                            <cfset compulsoryStatus = true>
                            <cfset status = "COMPULSORY">
                        </cfif>
                        </cfif>

                        <!--- Query: gets the teams based on the groupID to display in the table --->
                        <cfquery name="getTeamsinGroup" datasource="intro">
                            SELECT vaNICKNAME
                            FROM TEAM_DATA
                            WHERE iGROUPID = <cfqueryparam cfsqltype="cf_sql_integer" value="#groupID#">
                        </cfquery>

                        <cfloop query="getTeamsinGroup">
                            <cfset ArrayAppend(teamNames, getTeamsinGroup.vaNICKNAME)>
                        </cfloop>
                       
                        <cfoutput query="GetHotDeskInformation">
                            <!--- Check if date is holiday --->
                            <cfif GetHotDeskInformation.iHOLIDAY eq 1>
                                <cfset isHoliday = true>

                            <cfquery name="getHoliday" datasource="intro">
                                SELECT vaNAME 
                                FROM HOLIDAY_DATA
                                WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(currentDate, "yyyy-mm-dd")#">
                            </cfquery>
                            </cfif>

                            <cfif !isHoliday>
                                <cfset isToday = currentDateDBFormat == DateFormat(now(), "yyyy-mm-dd")>
                                <cfif #GetHotDeskInformation.iWEEKEND# == 0>
                                    <tr <cfif isToday>class="highlighted-row" style="background-color: black;"</cfif>> <!--- If date is today, highlight the row ---> 
                                        <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                                        <td>#DateFormat(currentDate, 'dd/mm/yyyy')#</td>
                                        <cfelseif session.vars.roleid eq 3>
                                        <td>
                                            <button class="date-button" data-toggle="modal" data-target="##myModal" data-date="#DateFormat(currentDate, 'dd/mm/yyyy')#" style="background-color:##303030; color:white;">
                                                #DateFormat(currentDate, 'dd/mm/yyyy')#
                                            </button>
                                        </td>
                                        </cfif>
                                        <td>#DateFormat(currentDate, "dddd")#</td>
                                        <td>#GetHotDeskInformation.iSEAT_TOTAL#</td>
                                        <td>#GetHotDeskInformation.iSEAT_TOTAL - GetHotDeskInformation.iSEAT_EMERGENCY - GetHotDeskInformation.iSEAT_OCCUPIED#</td>
                                        <td>#GetHotDeskInformation.iSEAT_OCCUPIED#</td>
                                        <td>#GetHotDeskInformation.iSEAT_EMERGENCY#</td>
                                        <td>#ArrayToList(teamNames, '/')#</td>
                                        <cfif (session.vars.roleid eq 1 || session.vars.roleid eq 2) and session.vars.teamid neq 7 >
                                        <td>#GetHotDeskInformation.TotalTeamRecordCount#</td>
                                        <td 
                                            <cfif compulsoryStatus>class="highlighted-cell" style="background-color: yellow; color:black;"</cfif>
                                            <cfif approveStatus>class="highlighted-cell" style="background-color: green;"</cfif>
                                            <cfif pendingStatus>class="highlighted-cell" style="background-color: grey;"</cfif>
                                            <cfif rejectStatus>class="highlighted-cell" style="background-color: ##DC3545;"</cfif>
                                        >
                                            #status#
                                        </td>
                                        </cfif>
                                    </tr>
                                </cfif>
                            <cfelse> <!--- If date is holiday, highlight the row grey and show holiday --->
                                <cfset colspanValue = (session.vars.roleid eq 1 || session.vars.roleid eq 2) ? 9 : 8>

                                <tr class="highlighted-row" style="background-color: grey;">
                                    <td colspan="#colspanValue#" style="text-align: center; vertical-align: middle;">#DateFormat(currentDate, "dd/mm/yyyy")#, #DateFormat(currentDate, "dddd")# : HOLIDAY (#UCase(getHoliday.vaNAME)#)</td>
                                </tr>
                            </cfif>
                        </cfoutput>
                    </cfloop>
                </tbody>
            </table>
        </div>
    </div>

    <!-- List of Week -->
    <div class="container text-center">
        <cfoutput>
        <h3>List of Week #Year(Now())#</h3>
        </cfoutput>
    </div>
    

    <div class="container">
        <div class="table-container">
            <cfif session.vars.roleid eq 3>
                <cfoutput>
                <script>sysdt=new Date();</script>
                <cfinclude  template="../merimenform.cfm">
                <form action="index.cfm?fusebox=hotdesk&fuseaction=dsp_home&#session.urltoken#" method="post" name="listOfWeekForm">
                </cfoutput>
                    <label for="searchDate">Search by Date:</label>
                    <input MRMOBJ="CALDATE" type="text" id="searchDate" name="searchDate" chkname="Date" placeholder="dd/mm/yyyy">
                    <cfoutput>
                    <button type="button" id="currentWeekButton" style="margin-left: 5px;" onclick="window.location.href='index.cfm?fusebox=hotdesk&fuseaction=dsp_home&week=currentweek&#session.urltoken#'">Current Week</button>
                    </cfoutput>
                    <input type="submit" value="Search" style="margin-left: 1px;">
                    <cfparam name="form.searchDate" default="">
                    <cfparam name="url.week" default="">
                    <cfif form.searchDate neq "" or url.week neq "">
                        <cfoutput>
                        <button type="button" onclick="window.location.href = 'index.cfm?fusebox=hotdesk&fuseaction=dsp_home&#session.urltoken#';">Reset</button>
                        </cfoutput>
                    </cfif>
                </form>
            </cfif>
            <table class="table table-bordered table-striped">
                
                <thead class="thead-dark">
                    <tr>
                        <th>Week</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                    </tr>
                </thead>
                <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                <tbody>
                    <cfset currentDate = Now()>
                    <cfset currentWeekNumber = Week(currentDate)>
                    <cfparam name="form.upcomingWeeks" default="3">
                    <cfparam name="form.searchDate" default="">
                    
                    <!--- If searchDate exist, get searchDate week info --->
                    <cfif form.searchDate neq "">
                        <cfset parsedDate = parseDateTime(form.searchDate)>
                        <cfset currentDate = DateFormat(parsedDate, "DD/MM/YYYY")>
                        <cfset currentWeekNumber = Week(currentDate)>
                    </cfif>
                    <cfoutput>
                        <cfloop from="0" to="#form.upcomingWeeks#" index="weekOffset">
                            <cfset weekNumber = currentWeekNumber + weekOffset>
                            <cfset currentDate = DateAdd("d", 2 - DayOfWeek(currentDate), currentDate)>
                            <cfset weekStartDate = DateAdd("ww", weekOffset, currentDate)>
                            <cfset weekEndDate = DateAdd("d", 4, weekStartDate)>
                            <tr>
                                <td><a href="index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#&week=#weekNumber#" class="modern-link">#weekNumber#</a></td>
                                <td>#DateFormat(weekStartDate, "dd/mm/yyyy")#</td>
                                <td>#DateFormat(weekEndDate, "dd/mm/yyyy")#</td>
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
                <cfelseif session.vars.roleid eq 3>
                <tbody>
                    <cfoutput>
                    <cfset currentDate = Now()>
                    <cfset currentWeekNumber = Week(currentDate)>
                    
                    <!--- If searchDate exist, get searchDate week info --->
                    <cfif form.searchDate neq "">
                        <cfset parsedDate = parseDateTime(form.searchDate)>
                        <cfset currentDate = DateFormat(parsedDate, "DD/MM/YYYY")>
                        <cfset currentWeekNumber = Week(currentDate)>

                    <!--- display the date in a row --->
                    <tr>
                        <td><a href="index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#&week=#currentWeekNumber#" class="modern-link">#currentWeekNumber#</a></td>
                        <td><cfoutput><cfset startDate = DateAdd("ww", currentWeekNumber - 1, CreateDate(Year(currentDate), 1, 1))>#DateFormat(startDate, "dd/mm/yyyy")#</cfoutput></td>
                        <td><cfoutput><cfset endDate = DateAdd("d", 6, startDate)>#DateFormat(endDate, "dd/mm/yyyy")#</cfoutput></td>
                    </tr>
                    <cfelse>
                        <cfif url.week eq "currentweek">
                            <tr>
                                <td><a href="index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#&week=#currentWeekNumber#" class="modern-link">#currentWeekNumber#</a></td>
                                <td><cfoutput><cfset startDate = DateAdd("ww", currentWeekNumber - 1, CreateDate(Year(currentDate), 1, 1))>#DateFormat(startDate, "dd/mm/yyyy")#</cfoutput></td>
                                <td><cfoutput><cfset endDate = DateAdd("d", 6, startDate)>#DateFormat(endDate, "dd/mm/yyyy")#</cfoutput></td>
                            </tr>
                        <cfelse>
                            <cfloop from="1" to="52" index="week">
                                <tr>
                                    <td><a href="index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#&week=#week#" class="modern-link">#week#</a></td>
                                    <td><cfoutput><cfset startDate = DateAdd("ww", week - 1, CreateDate(Year(now()), 1, 1))>#DateFormat(startDate, "dd/mm/yyyy")#</cfoutput></td>
                                    <td><cfoutput><cfset endDate = DateAdd("d", 6, startDate)>#DateFormat(endDate, "dd/mm/yyyy")#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </cfif>
                    </cfif>
                    </cfoutput>
                </tbody>
                </cfif>
            </table>
        </div>
        <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
        <cfoutput>
        <script>sysdt=new Date();</script>
        <cfinclude  template="../merimenform.cfm">
        <form action="index.cfm?fusebox=hotdesk&fuseaction=dsp_home&#session.urltoken#" method="post" name="listOfWeekForm">
        </cfoutput>
            <label for="upcomingWeeks">Number of Upcoming Weeks:</label>
            <input type="number" id="upcomingWeeks" name="upcomingWeeks" value="3">
            <label for="searchDate">Search by Date:</label>
            <input MRMOBJ="CALDATE" type="text" id="searchDate" name="searchDate" chkname="Date" placeholder="dd/mm/yyyy">
            <br>
            <cfoutput>
            <button type="button" id="currentWeekButton" onclick="window.location.href='index.cfm?fusebox=hotdesk&fuseaction=dsp_home&#session.urltoken#'">Current Week</button>
            </cfoutput>
            <input type="submit" value="Submit">
        </form>
        </cfif>
    </div>

<!--- API : Malaysia Holiday --->
<!--- <cfset apiKey = 'a7948c54-12ea-4cc9-a706-179aeaa6f5f2'>
<cfset apiUrl = 'https://holidayapi.com/v1/holidays'>

<cfhttp method="GET" url="#apiUrl#">
    <cfhttpparam type="url" name="key" value="#apiKey#">
    <cfhttpparam type="url" name="country" value="MY">
    <cfhttpparam type="url" name="year" value="2022">
</cfhttp>
--->
</body>
</html>
