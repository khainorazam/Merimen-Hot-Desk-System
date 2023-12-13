<!--- Update Hot Seat Planning (Week) Action  --->
<cfparam name="form.id" default="">
<cfparam name="form.date" default="">
<cfparam name="form.checkboxDateReqApproval" default="">
<cfparam name="session.vars.id" default="">

<cfset jsonStr = Form.checkboxDateReqApproval> <!-- Retrieve the JSON data from the form -->

<cfif Len(Trim(jsonStr)) EQ 0>
    <cfset checkboxDateReqApproval = []> <!-- Empty JSON object -->
<cfelse>
    <cfset checkboxDateReqApproval = DeserializeJSON(jsonStr)> <!-- Deserialize JSON if not empty -->
</cfif>


<cfset dateArray = ListToArray("#form.date#")>

<cfoutput>
<cfif structKeyExists(form, "date")>
<cftry>
    <!--- check if date is already in table --->
    <cfquery name="getDates" datasource="intro">
        SELECT *
        FROM HD_DATA
        WHERE iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#"/>
        AND (dtDATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#session.vars.startDate#"/> AND dtDATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#session.vars.endDate#"/>)
    </cfquery>

    <!--- 1. If there is date value (have added before)--->
    <cfif getDates.RecordCount>
    <cfset DatesDB = []> <!-- Initialize an empty array to store dates from the database -->

    <!-- Loop through the getDates query results and populate the DatesDB array -->
    <cfloop query="getDates">
        <cfset arrayAppend(DatesDB, getDates.dtDATE)>
    </cfloop>

    <!-- Initialize flags for conditions -->
    <cfset dateExist = false>
    <cfset newDate = false>
    <cfset dateNotExist = false>

    <!-- Loop through dateArray and compare them to DatesDB -->
    <cfloop array="#dateArray#" index="selectedDate">
        <!--- 
            if dateArray(form dates) is not in DatesDB, add them to the table 
            else, proceed with the next part
        --->
        <cfif !ArrayFind(DatesDB, selectedDate)> 
            <cfset newDate = true>

            <!-- selectedDate is not in the JSON date list, execute the normal query -->
            <cfquery name="insertHotDesk" datasource="intro">
            INSERT INTO HD_DATA (iUSID, dtDATE <cfif ArrayFind(checkboxDateReqApproval, selectedDate)>,iREQAPPROVAL</cfif>)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#selectedDate#">
                <!---If selectedDate is in checkboxDateReqApproval, set Request Approval = true --->
                <cfif ArrayFind(checkboxDateReqApproval, selectedDate)>
                ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">   
                </cfif>
            )
            </cfquery>
            <!--- SSP: iSEAT_OCCUPIED + 1 --->
            <cfstoredproc  PROCEDURE="sspUpdateSeatOccupied" DATASOURCE="intro" RETURNCODE="YES">
                <cfprocparam TYPE="IN" DBVARNAME="@adt_dtDATE" VALUE="#selectedDate#" cfsqltype="CF_SQL_DATE">
                <cfprocparam TYPE="IN" DBVARNAME="@asi_siMode" VALUE=1 cfsqltype="CF_SQL_SMALLINT">

                <cfif isDefined("cfstoredproc.StatusCode")>
                    <cfif cfstoredproc.StatusCode LT 0>
                        <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspUpdateSeatOccupied-UPDATEADD(#cfstoredproc.StatusCode#)">
                    </cfif>
                </cfif>
            </cfstoredproc>
        </cfif>
    </cfloop>

    <!-- Loop through DatesDB and compare them to dateArray -->
    <cfloop array="#DatesDB#" index="selectedDate">
        <!---  if DatesDB is not in dateArray(form dates), delete them from the table --->
        <cfif !ArrayFind(dateArray, selectedDate)> 
            <!--- SSP:  Delete row where the date is not in dateArray --->
            <cfstoredproc  PROCEDURE="sspDeleteHotDesk" DATASOURCE="intro" RETURNCODE="YES">
                <cfprocparam TYPE="IN" DBVARNAME="@adt_dtDATE" VALUE="#selectedDate#" cfsqltype="CF_SQL_DATE">
                <cfprocparam TYPE="IN" DBVARNAME="@ai_iUSID" VALUE="#form.id#" cfsqltype="CF_SQL_INTEGER">

                <cfif isDefined("cfstoredproc.StatusCode")>
                    <cfif cfstoredproc.StatusCode LT 0>
                        <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspDeleteHotDesk-DELETE(#cfstoredproc.StatusCode#)">
                    </cfif>
                </cfif>
            </cfstoredproc>

            <!--- SSP: iSEAT_OCCUPIED - 1 --->
            <cfstoredproc  PROCEDURE="sspUpdateSeatOccupied" DATASOURCE="intro" RETURNCODE="YES">
                <cfprocparam TYPE="IN" DBVARNAME="@adt_dtDATE" VALUE="#selectedDate#" cfsqltype="CF_SQL_DATE">
                <cfprocparam TYPE="IN" DBVARNAME="@asi_siMode" VALUE=2 cfsqltype="CF_SQL_SMALLINT">

                <cfif isDefined("cfstoredproc.StatusCode")>
                    <cfif cfstoredproc.StatusCode LT 0>
                        <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspUpdateSeatOccupied-UPDATE_SUBTRACT(#cfstoredproc.StatusCode#)">
                    </cfif>
                </cfif>
            </cfstoredproc>
        </cfif>
    </cfloop>

    <cfelse> <!--- 2. If first time add in the week --->
        <!--- Insert the dates to table --->
        <cfloop array="#dateArray#" index="selectedDate">

            <!-- selectedDate is not in the JSON date list, execute the normal query -->
            <cfquery name="insertHotDeskFirstTime" datasource="intro">
            INSERT INTO HD_DATA (iUSID, dtDATE <cfif ArrayFind(checkboxDateReqApproval, selectedDate)>,iREQAPPROVAL</cfif>)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#selectedDate#">
                <!---If selectedDate is in checkboxDateReqApproval, set Request Approval = true --->
                <cfif ArrayFind(checkboxDateReqApproval, selectedDate)>
                ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">   
                </cfif>
            )
            </cfquery>
            <!--- SSP: iSEAT_OCCUPIED + 1 --->
            <cfstoredproc  PROCEDURE="sspUpdateSeatOccupied" DATASOURCE="intro" RETURNCODE="YES">
                <cfprocparam TYPE="IN" DBVARNAME="@adt_dtDATE" VALUE="#selectedDate#" cfsqltype="CF_SQL_DATE">
                <cfprocparam TYPE="IN" DBVARNAME="@asi_siMode" VALUE=1 cfsqltype="CF_SQL_SMALLINT">

                <cfif isDefined("cfstoredproc.StatusCode")>
                    <cfif cfstoredproc.StatusCode LT 0>
                        <cfthrow TYPE=EX_DBERROR ErrorCode="act_approval-sspUpdateSeatOccupied-UPDATE_ADD(#cfstoredproc.StatusCode#)">
                    </cfif>
                </cfif>
            </cfstoredproc>
        </cfloop>
    </cfif>


<!--- after updating, redirect to week page with success message --->
    <script>
        alert("You have successfully updated hot seat planning!");
        // Redirect to the week page
        window.location.href = "index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#&week=#session.vars.week#"; 
    </script>
    <cfcatch type="Database">
        <!--- Database error occurred, handle it --->
            <script>
                alert("Error: Failed to update hot seat planning! Please try again.");
                // Redirect to the previous page 
                window.location.href = "index.cfm?fusebox=hotdesk&fuseaction=dsp_week&#session.urltoken#&week=#session.vars.week#"; 
            </script>
    </cfcatch>
</cftry>
<cfelse>
    fail
</cfif>
</cfoutput>
