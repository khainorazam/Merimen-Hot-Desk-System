<!--- Hot Desk Page - shows weekly hot desk planning  --->
<html>
    <body>
        <!--- Variables received from dsp_week.cfm --->
        <!--- startDate : startDate of the week --->
        <!--- endDate : endDate of the week --->
        <div class="container text-center" style="margin-top: 100px; margin-bottom: 30px;" >
        <cfoutput>
            <h2><b>Hot Seat Plan</b></h2>
        </cfoutput>
        </div>
        <cfset tableCount = 0> <!-- Initialize a counter for the tables -->

        <cfloop query="getTeamDetails">
            <!-- Check if the current table should start a new row, if mod 2 eq 0, make a new row -->
            <cfif tableCount MOD 2 eq 0>
                <div class="row">
            </cfif>

            <div class="col-md-6">
            <div class="container team-container centered-table">
                <cfoutput>
                <h2>#getTeamDetails.vaNAME#</h2>
                <div class="table-container">
                        <table class="table table-bordered table-striped text-center">
                            <thead class="thead-dark">
                                <tr>
                                    <th>Name</th>
                                    <cfloop from="#startDate#" to="#endDate#" index="currentDate">

                                    <!---   1. get the total for team members in current day. How?
                                            a. get the id for who have same teamid as getTeamDetails.teamid (done)
                                            b. get the number of dates where id = id and date = currentDate 
                                    --->

                                        <cfquery name="getTotalTeam" datasource="intro">
                                            SELECT COUNT(*) AS DateCount
                                            FROM HD_DATA
                                            WHERE iUSID IN (
                                                SELECT iUSID
                                                FROM USR_DATA
                                                WHERE iTEAMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getTeamDetails.iTEAMID#"/>
                                            )
                                            AND dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#currentDate#"> 
                                            AND iREQAPPROVAL = <cfqueryparam cfsqltype="cf_sql_integer" value="0" />

                                        </cfquery>

                                        <cfset dayOfWeek = DayOfWeek(currentDate)>
                                        <!-- Check if the day is not a weekend (1 for Sunday, 7 for Saturday) -->
                                        <cfif dayOfWeek neq 1 and dayOfWeek neq 7>
                                            <th>
                                                #DateFormat(currentDate, "dddd")# 
                                                <br>(#getTotalTeam.DateCount#)
                                            </th>
                                        </cfif>
                                    </cfloop>
                                    <th>Action</th>
                                </tr>
                            </thead>
                </cfoutput>
                            <tbody>
                                <!--- cfquery: to get team member details by team id --->
                                <cfquery name="getUserTeam" datasource="intro">
                                    SELECT a.iUSID, a.vaNAME AS staff_name, a.iTEAMID, b.vaNAME AS team_name, b.iGROUPID, c.dtDATE
                                    FROM USR_DATA a
                                    INNER JOIN TEAM_DATA b ON a.iTEAMID = b.iTEAMID
                                    LEFT JOIN HD_DATA c ON a.iUSID = c.iUSID
                                    WHERE a.iTEAMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getTeamDetails.iTEAMID#"/>
                                </cfquery>


                                <cfif getUserTeam.RecordCount>
                                    <cfoutput>
                                    <cfset staffDates = {}>

                                    <!--- Create a structure to store dates for each staff_name --->
                                    <cfloop query="getUserTeam">
                                        <cfif not structKeyExists(staffDates, getUserTeam.staff_name)>
                                            <cfset staffDates[getUserTeam.staff_name] = []>
                                        </cfif>
                                        <cfset arrayAppend(staffDates[getUserTeam.staff_name], getUserTeam.dtDATE)>
                                    </cfloop>
                                    <cfloop query="getUserTeam" group="staff_name">
                                        
                                        <tr 
                                        <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                                            <cfif session.vars.name == getUserTeam.staff_name>class="highlighted-row" style="background-color: black;"
                                            </cfif>
                                        </cfif>
                                        >

                                            <!---staff name --->
                                            <td>#getUserTeam.staff_name#</td>
                                            
                                            <!---dates that staff comes to office --->
                                            <cfloop from="#startDate#" to="#endDate#" index="currentDate">
                                                    <cfset dayOfWeek = DayOfWeek(currentDate)>
                                                    <cfset status = '-'> <!-- Default status is 'X' for other values -->
                                                    <cfif dayOfWeek neq 1 and dayOfWeek neq 7>
                                                        <cfif arrayFind(staffDates[getUserTeam.staff_name], DateFormat(currentDate, "yyyy-mm-dd"))>
                                                            <!-- If the date exists in the list, get the iREQAPPROVAL from a subquery -->
                                                            <cfquery name="getReqApproval" datasource="intro">
                                                                SELECT iREQAPPROVAL
                                                                FROM HD_DATA
                                                                WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(currentDate, 'yyyy-mm-dd')#">
                                                                AND iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getUserTeam.iUSID#">
                                                            </cfquery>

                                                            <cfset approveStatus = false>
                                                            <cfset pendingStatus = false>
                                                            <cfset rejectStatus = false>


                                                            <!-- Set the status based on the iREQAPPROVAL value -->
                                                            <cfif getReqApproval.RecordCount>
                                                                <cfif getReqApproval.iREQAPPROVAL EQ 0>
                                                                    <cfset approveStatus = true>
                                                                    <cfset status = '/'>
                                                                <cfelseif getReqApproval.iREQAPPROVAL EQ 1>
                                                                    <cfset pendingStatus = true>
                                                                    <cfset status = '&##9203;'>
                                                                <cfelseif getReqApproval.iREQAPPROVAL EQ 2>
                                                                    <cfset rejectStatus = true>
                                                                    <cfset status = 'X'>
                                                                </cfif>
                                                            </cfif>
                                                        </cfif>

                                                        <cfset isDateFull = false> <!-- check if the date is full -->
                                                        <cfset isDateCompulsory = false>
                                                        <cfset isHoliday = false>

                                                        <!-- Query DATE_HDDATA table to check seat occupancy for the current date -->
                                                        <cfquery name="checkOccupancy" datasource="intro">
                                                            SELECT iSEAT_OCCUPIED, iSEAT_TOTAL, iSEAT_EMERGENCY, iGROUPID, iHOLIDAY
                                                            FROM DATE_HDDATA
                                                            WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat(currentDate, 'yyyy-mm-dd')#">
                                                        </cfquery>

                                                        <cfif checkOccupancy.RecordCount>
                                                            <cfset iSEAT_OCCUPIED = checkOccupancy.iSEAT_OCCUPIED>
                                                            <cfset iSEAT_TOTAL = checkOccupancy.iSEAT_TOTAL>
                                                            <cfset iSEAT_EMERGENCY = checkOccupancy.iSEAT_EMERGENCY>
                                                            <cfset iHOLIDAY = checkOccupancy.iHOLIDAY>

                                                            <!-- Check if the seats are occupied beyond a limit -->
                                                            <cfif (iSEAT_OCCUPIED gte (iSEAT_TOTAL - iSEAT_EMERGENCY))>
                                                                <cfset isDateFull = true>
                                                            </cfif>

                                                            <!--- Check if date is compulsory for team  --->
                                                            <cfif checkOccupancy.iGROUPID eq getUserTeam.iGROUPID>
                                                                <cfset isDateCompulsory = true>
                                                            </cfif>

                                                            <!--- Check if date is holiday --->
                                                            <cfif iHOLIDAY eq 1>
                                                                <cfset isHoliday = true>
                                                            </cfif>
                                                        </cfif>

                                                        <cfif !isHoliday>
                                                            <td 
<!---                                                           <cfif session.vars.name eq getUserTeam.staff_name and approveStatus >class="highlighted-row" style="background-color: green;"</cfif>
                                                                <cfif session.vars.name eq getUserTeam.staff_name and pendingStatus >class="highlighted-row" style="background-color: grey;"</cfif>
                                                                <cfif session.vars.name eq getUserTeam.staff_name and rejectStatus >class="highlighted-row" style="background-color: ##DC3545;"</cfif>
--->                                                            <cfif isDateCompulsory>class="highlighted-row" style="background-color: yellow; color:black;"</cfif> 
                                                                <cfif isDateFull>class="highlighted-row" style="background-color: ##DC3545;"</cfif>
                                                                style="font-weight:bold;"
                                                            >
                                                            <cfif isDateCompulsory> <!--- If date must come --->
                                                                <!--- if date is found in DB, just set status --->
                                                                <cfquery name="findDate" datasource="intro">
                                                                    SELECT dtDATE
                                                                    FROM HD_DATA
                                                                    WHERE iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getUserTeam.iUSID#"/>
                                                                    AND dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat(currentDate, 'yyyy-mm-dd')#"/>
                                                                </cfquery>

                                                                <!--- 1. If there is no date value (have not been added before)--->
                                                                <cfif !findDate.RecordCount>
                                                                    <!--- Set for personal date in HD_DATA --->
                                                                    <cfquery name="insertHotDeskPersonal" datasource="intro">
                                                                        INSERT INTO HD_DATA (iUSID, dtDATE)
                                                                        VALUES (
                                                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#getUserTeam.iUSID#">,
                                                                            <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat(currentDate, 'yyyy-mm-dd')#">
                                                                        )
                                                                    </cfquery>
                                                                    <!--- SSP: iSEAT_OCCUPIED + 1 in Hot Desk Info--->
                                                                    <cfstoredproc  PROCEDURE="sspUpdateSeatOccupied" DATASOURCE="intro" RETURNCODE="YES">
                                                                        <cfprocparam TYPE="IN" DBVARNAME="@adt_dtDATE" VALUE="#dateFormat(currentDate, 'yyyy-mm-dd')#" cfsqltype="CF_SQL_DATE">
                                                                        <cfprocparam TYPE="IN" DBVARNAME="@asi_siMode" VALUE=1 cfsqltype="CF_SQL_SMALLINT">

                                                                        <cfif isDefined("cfstoredproc.StatusCode")>
                                                                            <cfif cfstoredproc.StatusCode LT 0>
                                                                                <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspUpdateSeatOccupied-UPDATEADD(#cfstoredproc.StatusCode#)">
                                                                            </cfif>
                                                                        </cfif>
                                                                    </cfstoredproc>
                                                                </cfif>
                                                                    <cfset status = "/">
                                                            </cfif>
                                                            #status#
                                                            </td>
                                                        <cfelse>
                                                            <td class="highlighted-row" style="background-color: grey;">HOLIDAY</td> 
                                                        </cfif>
                                                    </cfif>
                                                </cfloop>

                                            <!--- Update button --->
                                            <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                                                <cfif Week(startDate) gte Week(Now()) && session.vars.name == getUserTeam.staff_name>
                                                    <td>
                                                        <button class="btn btn-primary action-btn" onclick="redirectToUpdateHotDesk(#getUserTeam.iUSID#)">Update</button>
                                                    </td>
                                                <cfelse>
                                                    <td>-</td>
                                                </cfif>
                                            <cfelseif session.vars.roleid eq 3>
                                            <td>
                                                <button class="btn btn-primary action-btn" onclick="redirectToUpdateHotDesk(#getUserTeam.iUSID#)">Update</button>
                                            </td>
                                            </cfif>
                                        </tr>
                                    </cfloop>
                                    </cfoutput>
                                <cfelse>
                                    <tr>
                                        <td colspan=7 class="text-center">NO TEAM MEMBERS</td>
                                    </tr>
                                </cfif>
                            </tbody>
                         </table>
                    </div>
                </div>
            </div>

            <!-- Check if the current table should end the current row -->
            <cfif tableCount MOD 2 eq 1 or tableCount EQ getTeamDetails.RecordCount>
                </div>
            </cfif>

            <!-- Increment the table counter -->
            <cfset tableCount = tableCount + 1>
        </cfloop>
    </body>
<script>
    function redirectToUpdateHotDesk(id) {
        console.log("redirectToUpdateHotDesk");
        <cfoutput>
        window.location.href = "index.cfm?fusebox=hotdesk&fuseaction=dsp_updatehotdesk&id=" + id + "&#session.urltoken#" ;
        </cfoutput>
 }
</script>

</html>
