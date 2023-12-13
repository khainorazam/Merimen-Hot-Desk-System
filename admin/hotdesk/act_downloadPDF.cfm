<cfdocument format="PDF" localurl="yes" filename="Downloads/Week #session.vars.week# Hot Desk Report.pdf" overwrite="true">
    <html>
        <head>
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
            <style>
                body {
                    text-align: center; /* Center everything horizontally */
                }

                .container {
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    height: 100vh; /* Center everything vertically */
                }

                /* Table styles */
                table {
                    border: 1px solid #000;
                    border-collapse: collapse;
                    width: 100%;
                }

                th, td {
                    border: 1px solid black;
                    padding: 5px;
                }
            </style>
        </head>
        <body>
            <cfset startDate = session.vars.startDate>
            <cfset endDate = session.vars.endDate>
            <cfoutput>
            <div class="container">
                <h2><b>Week #session.vars.week#</b></h2>
                <h2>#DateFormat(startDate, "dd/mm/yyyy")# - #DateFormat(endDate, "dd/mm/yyyy")#</h2>
            </div>
            </cfoutput>
            <div class="container">
                <div class="table-container">
                    <table>
                        <thead class="thead-dark">
                            <tr>
                                <th>Date</th>
                                <th>Day</th>
                                <th>Total Seat</th>
                                <th>Seat(s) Available</th>
                                <th>Seat(s) Occupied</th>
                                <th>Emergency/Unplanned Seats</th>
                                <th>Compulsory Team</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!--- Loop the days of the week --->
                            <cfloop from="#startDate#" to="#endDate#" index="currentDate">
                                <cfset currentDateDBFormat = DateFormat(currentDate, "yyyy-mm-dd")>
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

                                <cfoutput query="GetHotDeskInformation">
                                    <cfif #GetHotDeskInformation.iWEEKEND# == 0>
                                        <!--- setting for group names --->
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

                                        <tr>
                                            <td>#DateFormat(currentDate, "dd/mm/yyyy")#</td>
                                            <td>#DateFormat(currentDate, "dddd")#</td>
                                            <td>#GetHotDeskInformation.iSEAT_TOTAL#</td>
                                            <td>#GetHotDeskInformation.iSEAT_TOTAL - GetHotDeskInformation.iSEAT_EMERGENCY - GetHotDeskInformation.iSEAT_OCCUPIED#</td>
                                            <td>#GetHotDeskInformation.iSEAT_OCCUPIED#</td>
                                            <td>#GetHotDeskInformation.iSEAT_EMERGENCY#</td>
                                            <td>#ArrayToList(teamNames, '/')#</td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </cfloop>
                        </tbody>
                    </table>
                </div>
            </div>
        </body>
    </html>
</cfdocument>
<cfoutput>
<script>
    alert('You have successfully downloaded Week #session.vars.week# Hot Desk Report to HDSystem/admin/hotdesk/Downloads folder');
    window.location.href = 'index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#&week=#session.vars.week#'; 
</script>
</cfoutput>
