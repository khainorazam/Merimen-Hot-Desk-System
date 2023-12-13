<!--- query: get Team details --->
<cfquery name="getTeamDetails" datasource="intro">
    SELECT iTEAMID, vaNAME 
    FROM TEAM_DATA
    WHERE iTEAMID != 7
</cfquery>

<cfloop query="getTeamDetails">
    <cfquery name="getUserTeam" datasource="intro">
        SELECT a.iUSID, a.vaNAME AS staff_name, a.iTEAMID, b.vaNAME AS team_name, b.iGROUPID, c.dtDATE
        FROM USR_DATA a
        INNER JOIN TEAM_DATA b ON a.iTEAMID = b.iTEAMID
        LEFT JOIN HD_DATA c ON a.iUSID = c.iUSID
        WHERE a.iTEAMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getTeamDetails.iTEAMID#"/>
    </cfquery>

    <cfset staffDates = {}>

    <!--- Create a structure to store dates for each staff_name --->
    <cfloop query="getUserTeam">
        <cfif not structKeyExists(staffDates, getUserTeam.staff_name)>
            <cfset staffDates[getUserTeam.staff_name] = []>
        </cfif>
        <cfset arrayAppend(staffDates[getUserTeam.staff_name], getUserTeam.dtDATE)>
    </cfloop>

    <!--- Check for compulsory dates for each staff and update hotdesk info --->
    <cfloop query="getUserTeam" group="staff_name">
        <cfloop from="#startDate#" to="#endDate#" index="currentDate">
            <cfset dayOfWeek = DayOfWeek(currentDate)>
            <cfif dayOfWeek neq 1 and dayOfWeek neq 7>
                <cfset isDateCompulsory = false>

                <!-- Query DATE_HDDATA table to check seat occupancy for the current date -->
                <cfquery name="checkOccupancy" datasource="intro">
                    SELECT iGROUPID
                    FROM DATE_HDDATA
                    WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat(currentDate, 'yyyy-mm-dd')#">
                </cfquery>

                <cfif checkOccupancy.RecordCount>
                    <!--- Check if date is compulsory for team  --->
                    <cfif checkOccupancy.iGROUPID eq getUserTeam.iGROUPID>
                        <cfset isDateCompulsory = true>
                    </cfif>
                </cfif>
                <cfif isDateCompulsory> <!--- Date must come --->
                    <!--- if date is found in DB, can proceed with rest of code in dsp_week --->
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
                </cfif>
            </cfif>
        </cfloop>
    </cfloop>
</cfloop>