<!--- DSP: Update Week Page--->
<cfinclude template="../merimenform.cfm">
<cfparam name=url.id default="">

<cfset startDate = DateAdd("ww", session.vars.week - 1, CreateDate(Year(now()), 1, 1))>
<cfset endDate = DateAdd("d", 6, startDate)>

<!--- query: get the user's information --->
<cfquery name="userDetails" datasource="intro">
    SELECT a.vaNAME, a.vaDEFAULTDAYS, a.iTEAMID, b.iGROUPID
    FROM USR_DATA a
    INNER JOIN TEAM_DATA b ON a.ITEAMID = b.iTEAMID
    WHERE iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>


<!-- Second query to retrieve dates from HD_DATA -->
<cfquery name="hotDeskDates" datasource="intro">
    SELECT dtDATE
    FROM HD_DATA
    WHERE iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
    AND dtDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#startDate#">
    AND <cfqueryparam cfsqltype="cf_sql_date" value="#endDate#">
</cfquery>




<html>
<head>
    <title>Update Hot Desk Information (Week) - Hot Desk System</title>
</head>
<body>
    <cfoutput>
    <div class=clsDocBody>
        <h3 align="center">Update #userDetails.vaNAME#'s Hot Seat Planning (#DateFormat(startDate, "dd/mm/yyyy")# - #DateFormat(endDate, "dd/mm/yyyy")#)</h3>
    </div>
    <form action="index.cfm?fusebox=hotdesk&fuseaction=act_updatehotdesk&#session.urltoken#" method="post" name="updatehotdeskform">
    </cfoutput>
    <cfoutput>
        <div class="container">
            <div class="table-container">
                <table  border=5 cellpadding=5 width=100%>
                    <col width=25% style=font-weight:bold;background-color:lightyellow><col width=75% style=background-color:gainsboro>
                    <tr class=header><td colspan=2>Hot Seat Planning Details (#DateFormat(startDate, "dd/mm/yyyy")# - #DateFormat(endDate, "dd/mm/yyyy")#)</td></tr>
                    <!---hidden date value --->
                    <input type="hidden" name="id" value="#url.id#">
                    <tr>
                        <td class="clsField1">Date</td>
                        <td class="clsValue1">
                            <cfloop from="#startDate#" to="#endDate#" index="currentDate">
                                <cfset dayOfWeek = DayOfWeek(currentDate)>

                                <cfif dayOfWeek neq 1 and dayOfWeek neq 7><!-- Exclude Sunday (1) and Saturday (7) -->
                                    <div>
                                        <cfset isDateSelected = false>
                                        <cfset isDateFull = false> 
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
                                            <cfset iGROUPID = checkOccupancy.iGROUPID>
                                            <cfset iHOLIDAY = checkOccupancy.iHOLIDAY>


                                            <!-- Check if the seats are occupied beyond a limit -->
                                            <cfif (iSEAT_OCCUPIED gte (iSEAT_TOTAL - iSEAT_EMERGENCY))>
                                                <cfset isDateFull = true>
                                            </cfif>

                                            <!--- Check if date is compulsory for team  --->
                                            <cfif iGROUPID eq #userDetails.iGROUPID#>
                                                <cfset isDateCompulsory = true>
                                            </cfif>

                                            <!--- Check if date is holiday --->
                                            <cfif iHOLIDAY eq 1>
                                                <cfset isHoliday = true>
                                            </cfif>
                                        </cfif>

                                        <cfloop query="hotDeskDates">
                                            <cfif isDateSelected>
                                                <!-- If a date has already been selected, no need to continue the loop -->
                                                <cfbreak>
                                            </cfif>
                                            <cfif StructKeyExists(hotDeskDates, "dtDATE") AND IsDate(hotDeskDates.dtDATE)>
                                                <cfif DateCompare(hotDeskDates.dtDATE, currentDate) eq 0>
                                                    <cfset isDateSelected = true>
                                                    <cfbreak>
                                                </cfif>
                                            </cfif>
                                        </cfloop>
                                        <cfif isHoliday> <!--- if Holiday, disable and put cross on the date and no checkbox input--->
                                            <label class="form-check-label" style="text-decoration: line-through;"for="hbDate_#dateFormat(currentDate, 'yyyy-mm-dd')#">#dateFormat(currentDate, 'dddd, dd/mm/yyyy')# 
                                                <span style="color: ##grey !important; font-weight:bold;">(HOLIDAY)</span>
                                            </label>
                                        <cfelse>
                                            <input type="checkbox" id="hbDate_#dateFormat(currentDate, 'yyyy-mm-dd')#" name="date" value="#dateFormat(currentDate, 'yyyy-mm-dd')#"
                                                <cfif isDateSelected>checked="checked"</cfif>
                                                <cfif isDateFull>disabled="disabled"</cfif>
                                                <cfif isDateCompulsory>checked="checked" disabled="disabled"</cfif>
                                            >
                                            <cfif isDateCompulsory>
                                                <input type="hidden" name="date" value="#dateFormat(currentDate, 'yyyy-mm-dd')#">
                                                <!--- set vaDEFAULTDAYS to add the Date compulsory and remove one day --->
                                            </cfif>
                                            <label class="form-check-label" for="hbDate_#dateFormat(currentDate, 'yyyy-mm-dd')#">#dateFormat(currentDate, 'dddd, dd/mm/yyyy')# 
                                                <cfif isDateFull><span style="color: red !important; font-weight:bold;">(FULL)</span></cfif>
                                                <cfif isDateCompulsory><span style="color: ##555500 !important; font-weight:bold;">(TEAM COMPULSORY)</span></cfif>
                                            </label>
                                        </cfif>
                                    </div>
                                </cfif>
                            </cfloop>
                        </td>
                    </tr>
                    <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
                    <!-- Hidden input field to store JSON data -->
                    <input type="hidden" name="checkboxDateReqApproval" id="checkboxDateReqApproval" value="">
                    <tr>
                        <td>
                            <input type="button" value="DEFAULT" onclick="setDefaultDays(this.form, '#userDetails.vaDEFAULTDAYS#');" class="clsButton">
                        </td>

                        <td>
                            <input type="button" value="UPDATE" onclick="validateForm(this.form);" class="clsButton">
                        </td>
                    </tr>

                    <cfelseif session.vars.roleid eq 3>
                    <tr>
                        <td>
                            <input type="button" value="UPDATE" onclick="if (FormVerify(document.all('updatehotdeskform'))) this.form.submit();" class="clsButton">
                        </td>
                    </tr>
                    </cfif>
                    
                </table>
            </div>
        </div>
    </cfoutput>
    </form>

    <cfif session.vars.roleid eq 1 || session.vars.roleid eq 2>
    <script>
    function setDefaultDays(form, defaultDays) {
        const checkboxes = form.querySelectorAll('input[type="checkbox"]');

        // Uncheck all checkboxes that are not both checked and disabled (compulsory day)
        checkboxes.forEach(checkbox => {
            if (!checkbox.checked || !checkbox.disabled) {
                checkbox.checked = false;
            }
        });

        checkboxes.forEach(checkbox => {
            const checkboxValue = new Date(checkbox.value); // Parse the date from the checkbox value
            const dayOfWeek = checkboxValue.getDay()+1; // Get the day of the week as a number (0 = Sunday, 1 = Monday, ...)

            // Check if the day of the week (as a number) is in the defaultDays list
            if (defaultDays.split(',').includes(dayOfWeek.toString())) {
                checkbox.checked = true;
            }
        });
    }

    function validateForm(form) {
        const currentDate = new Date();
        const minDate = new Date();
        const maxDate = new Date();
        const tomorrow = new Date();
        tomorrow.setDate(currentDate.getDate() + 1);
        const Sunday = 0;
        minDate.setDate(currentDate.getDate() + 2); // Calculate the date 2 days after today


        const checkboxes = form.querySelectorAll('input[type="checkbox"]');
        let checkedCount = 0;
        const checkboxDateReqApproval = [];

        

        //check for boxes that are checked, using checkCount
        checkboxes.forEach(checkbox => {
            const checkboxDate = new Date(checkbox.value);

            const formattedDate = checkboxDate.toISOString().split('T')[0];
            console.log(formattedDate);

            <cfquery name="DBDatesExist" datasource="intro">
                SELECT dtDATE
                FROM HD_DATA
                WHERE (dtDATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#session.vars.startDate#"/> AND dtDATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#session.vars.endDate#"/>) 
                AND iREQAPPROVAL = <cfqueryparam cfsqltype="cf_sql_integer" value="0" />
                AND iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.vars.usid#"/>
            </cfquery>

            var exist = false;

            // Compare with dates from DBDatesExist (assuming it's an array of dates)
            <cfloop query="DBDatesExist">
                if (formattedDate == "<cfoutput>#DBDatesExist.dtDATE#</cfoutput>") {
                    exist = true;
                }
            </cfloop>

            //If its Sunday, they can just check anything without needing approval.
            //Only ask for approval for changes on weekdays
            if (currentDate.getDay() !== Sunday && checkbox.checked) {
                    if(checkboxDate < maxDate && !checkbox.disabled && !exist) {
                        checkboxDateReqApproval.push(checkbox.value);
                    }
                checkedCount++;
            }
        });

        const totalCheckboxes = checkboxes.length;
        const minRequiredCheckboxes = Math.floor((totalCheckboxes + 1) / 2);

        if (checkedCount < minRequiredCheckboxes) {
            alert(`Please select at least ${minRequiredCheckboxes} dates.`);
            return;
        }

        // Join the dates into a single string
        const datesToApprove = checkboxDateReqApproval.map(dateValue => {
            const checkboxDate = new Date(dateValue);
            const day = checkboxDate.getDate();
            const month = checkboxDate.getMonth() + 1; // Note: Months are zero-based
            const year = checkboxDate.getFullYear();
            return `${day}/${month}/${year}`;
        }).join(', ');

        // Display a single alert with all the dates
        if (datesToApprove.length > 0) {
            alert(`Checkboxes with values ${datesToApprove} require approval from the admin.`);
        }


        // Before submitting the form, set the JSON value to the hidden input field
        document.getElementById("checkboxDateReqApproval").value = JSON.stringify(checkboxDateReqApproval);
        // If the validation passes, submit the form
        if (FormVerify(document.all('updatehotdeskform')))        
        form.submit();
    }
    </script>
    </cfif>
</body>
</html>


