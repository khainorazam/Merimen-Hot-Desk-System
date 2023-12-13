<!--- Hot Desk Week Page - shows weekly hotdesk information --->

<cfparam name="url.week" default="1"> <!-- Default to week 1 if not provided -->
<cfset session.vars.week = #url.week#>
<cfoutput>
<html>
    <head>
        <title>Week Page - Hot Desk System</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap 4 CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

        <!--- STYLE : Action button and pop-up modal --->
        <style>
            <!--- Styles the action button --->
                .action-btn {
                    width: 80px; 
                }

                /* Custom CSS for centering the table */
                .table-container {
                    max-width: 2000px; /* Adjust the maximum width as needed */
                    margin: 0 auto; /* Center the container horizontally */
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

        </style>
    </head>
    <body>
        <cfset startDate = DateAdd("ww", url.week - 1, CreateDate(Year(now()), 1, 1))>
        <cfset endDate = DateAdd("d", 6, startDate)>
        <cfset session.vars.startDate = startDate>
        <cfset session.vars.endDate = endDate>

        <!--- Settings for Hot Desk Info --->
        <cfinclude  template="hotdesksettings.cfm">
        
        <div class="container text-center">
            <h2><b>Week #url.week#</b></h2>
            <h2>#DateFormat(startDate, "dd/mm/yyyy")# - #DateFormat(endDate, "dd/mm/yyyy")#</h2>
        </div>
        <div class="container">
            <table class="table table-bordered table-striped text-center">
                <thead class="thead-dark">
                    <tr>
                        <th>Date</th>
                        <th>Day</th>
                        <th>Total Seat</th>
                        <th>Seat(s) Available</th>
                        <th>Seat(s) Occupied</th>
                        <th>Emergency/Unplanned Seats</th>
                        <th>Compulsory Team</th>
                        <cfif session.vars.roleid eq 3>
                        <th>Action</th>
                        </cfif>
                        <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                        <th>#session.vars.name#'s Hot Desk Status</th>
                        </cfif>
                    </tr>
                </thead>
                <tbody>
</cfoutput>
                        <!--- loop the days of the week --->
                    <cfloop from="#startDate#" to="#endDate#" index="currentDate">

                        <cfset currentDateDBFormat = DateFormat(currentDate, "yyyy-mm-dd")>

                        <!-- Get the current date in the same format as currentDateDBFormat -->
                        <cfset currentDateFormatted = DateFormat(Now(), "yyyy-mm-dd")>

                        <!-- Determine if the currentDate matches the current date -->
                        <cfset isToday = (currentDateDBFormat == currentDateFormatted)>


                        <!--- SSP: Get daily hot desk information using currentDate --->
                        <cfstoredproc  PROCEDURE="sspGetHotDeskInfo" DATASOURCE="intro" RETURNCODE="YES">
                            <cfprocparam TYPE="IN" DBVARNAME="@adt_dtDATE" VALUE="#currentDateDBFormat#" cfsqltype="CF_SQL_DATE">

                            <cfif isDefined("cfstoredproc.StatusCode")>
                                <cfif cfstoredproc.StatusCode lt 0>
                                    <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspGetHotDeskInfo-SELECT(#cfstoredproc.StatusCode#)">
                                </cfif>
                            </cfif>

                            <cfprocresult name="GetHotDeskInformation">
                        </cfstoredproc>

                        <cfset isDateFull = false> <!--- check if the date is full --->
                        <cfset isHoliday = false> <!--- check if the date is a Holiday --->

                        <cfif GetHotDeskInformation.RecordCount>
                            <cfset iSEAT_OCCUPIED = GetHotDeskInformation.iSEAT_OCCUPIED>
                            <cfset iSEAT_TOTAL = GetHotDeskInformation.iSEAT_TOTAL>
                            <cfset iSEAT_EMERGENCY = GetHotDeskInformation.iSEAT_EMERGENCY>
                            <cfset iHOLIDAY = GetHotDeskInformation.iHOLIDAY>

                            <!-- Check if the seats are occupied beyond a limit -->
                            <cfif (iSEAT_OCCUPIED gte (iSEAT_TOTAL - iSEAT_EMERGENCY))>
                                <cfset isDateFull = true>
                            </cfif>

                            <!--- Check if date is holiday --->
                            <cfif iHOLIDAY eq 1>
                                <cfset isHoliday = true>

                            <cfquery name="getHoliday" datasource="intro">
                                SELECT vaNAME 
                                FROM HOLIDAY_DATA
                                WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(currentDate, "yyyy-mm-dd")#">
                            </cfquery>
                            </cfif>
                        </cfif>

                        <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                            <!--- query: get iREQAPPROVAL status for user on the date --->
                            <cfquery name="getReqApproval" datasource="intro">
                                SELECT iREQAPPROVAL
                                FROM HD_DATA
                                WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#currentDateDBFormat#"/>
                                AND iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.vars.usid#"/> 
                            </cfquery>

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

                            <cfif #GetHotDeskInformation.iWEEKEND# eq 0>
                                <cfif GetHotDeskInformation.iGROUPID eq session.vars.groupID>
                                    <cfset compulsoryStatus = true>
                                    <cfset status = "COMPULSORY">
                                </cfif>
                            </cfif>
                        </cfif>

                            

                        <cfoutput query="GetHotDeskInformation">
                        <cfif #GetHotDeskInformation.iWEEKEND# eq 0>
                            <!--- Setting for compulsory teamNames for the day --->
                            <cfset groupID = GetHotDeskInformation.iGROUPID>
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
                            <cfif !isHoliday>
                                <tr <cfif isToday>class="highlighted-row" style="background-color: black;"</cfif> <cfif isDateFull> class="highlighted-row" style="background-color: ##DC3545;"</cfif>> <!--- If date is today, highlight the row black. If full, highlight red --->
                                    <td>#DateFormat(currentDate, "dd/mm/yyyy")#</td>
                                    <td>#DateFormat(currentDate, "dddd")#</td>
                                    <td>#GetHotDeskInformation.iSEAT_TOTAL#</td>
                                    <td>#GetHotDeskInformation.iSEAT_TOTAL - GetHotDeskInformation.iSEAT_EMERGENCY - GetHotDeskInformation.iSEAT_OCCUPIED#</td>
                                    <td>#GetHotDeskInformation.iSEAT_OCCUPIED#</td>
                                    <td>#GetHotDeskInformation.iSEAT_EMERGENCY#</td>
                                    <td>#ArrayToList(teamNames, '/')#</td> 
                                    <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                                    <td 
                                        <cfif compulsoryStatus>class="highlighted-cell" style="background-color: yellow; color:black;"</cfif>
                                        <cfif approveStatus>class="highlighted-cell" style="background-color: green;"</cfif>
                                        <cfif pendingStatus>class="highlighted-cell" style="background-color: grey;"</cfif>
                                        <cfif rejectStatus>class="highlighted-cell" style="background-color: ##DC3545;"</cfif>
                                    >
                                        #status#
                                    </td>
                                    </cfif>
                                    <cfif session.vars.roleid eq 3>
                                    <td>
                                        <button class="btn btn-primary action-btn" onclick="redirectToUpdatePage(#currentDate#)">Update</button>
                                    </td>
                                    </cfif>
                                </tr>
                            <cfelse> <!--- If date is holiday, highlight the row grey and show holiday --->
                                <tr class="highlighted-row" style="background-color: grey;"> 
                                    <td colspan="8" style="text-align: center; vertical-align: middle;">#DateFormat(currentDate, "dd/mm/yyyy")#, #DateFormat(currentDate, "dddd")# : HOLIDAY (#UCase(getHoliday.vaNAME)#)</td>
                                </tr>
                            </cfif>
                            
                        </cfif>
                        </cfoutput>
                    </cfloop>
                </tbody>
            </table>
            <cfif session.vars.roleid eq 3>
                <!--- Download the Hot Seat Information --->
                <button id="downloadButton" class="btn btn-primary">Download Report</button>

                <!---Approval List --->
                <cfinclude  template="../admin/hotdesk/dsp_approval.cfm">

                <script>
                    function redirectToUpdatePage(date) {
                        console.log("redirectToUpdatePage");
                        <cfoutput>
                        window.location.href = "index.cfm?fusebox=admin&fuseaction=dsp_updateday&date=" + date + "&#session.urltoken#" ;
                        </cfoutput>
                    }

                    document.getElementById('downloadButton').addEventListener('click', function() {
                        // Generate and download the PDF
                        <cfoutput>
                        window.location.href = 'index.cfm?fusebox=admin&fuseaction=act_downloadPDF&week=#url.week#&#session.urltoken#';
                        </cfoutput>
                    });
                </script>
            </cfif>
        </div>

        <!--- Hot Desk --->
        <cfinclude  template="dsp_hotdesk.cfm">
    </body>
</html>





