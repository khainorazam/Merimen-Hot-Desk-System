<!--- Update Monthly Schedule Page --->
<html>
    <head>
        <title>Update Monthly Schedule Page - Hot Desk System</title>
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

            <!--- Styles the action button --->
            .action-btn {
                width: 80px; 
            }

            /* Styles for the custom pop-up */
            .popup-container {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                padding: 20px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
                z-index: 1000;
                max-height: 80%; /* Set maximum height for the pop-up */
                width: 70%; /* Set maximum width for the pop-up */
                overflow-y: auto; /* Enable vertical scrollbar if content exceeds max-height */     
            }

            /* Overlay to cover the background */
            .overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 999;
            }

            /* Custom CSS for centering the table */
            .table-container {
                max-width: 2000px; /* Adjust the maximum width as needed */
                margin: 0 auto; /* Center the container horizontally */
            }
        </style>
    </head>

<!--- for Merimen CSS    --->
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCSS"> 
<!--- JQuery --->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<body>
    <!--- Calculate the current month and day --->
    <cfset currentMonth = Month(Now())>
    <cfset currentDay = DayOfWeek(Now())>
    <!-- List of Week -->
    <div class="container text-center">
        <cfoutput>
        <h3>Monthly Schedule</h3>
        </cfoutput>
    </div>
    <div class="container">
        <div class="table-container">
            <div class="row">
                <div class="col-md-12">
                    <div class="dropdown">
                        <cfparam name="url.month" default="">
                        <button class="btn btn-secondary dropdown-toggle mx-auto d-block" type="button" id="MonthFilterDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Month
                        </button>

                        
                        <div class="dropdown-menu" aria-labelledby="MonthFilterDropdown">
                        <cfset months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]>
                        <cfoutput>
                            <a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_updatemonthlyschedule&#session.urltoken#" <cfif url.month == "">class="active"</cfif>>ALL</a>
                        </cfoutput>
                        <cfloop from="1" to="12" index="monthIndex">
                            <cfoutput>
                                <a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_updatemonthlyschedule&month=#monthIndex#&#session.urltoken#" <cfif url.month == monthIndex>class="active"</cfif>>#months[monthIndex]#</a>
                            </cfoutput>
                        </cfloop>
                        </div>
                    </div>
                </div>
            </div>
            <table class="table table-bordered table-striped" style="margin-top:15px;">
                <thead class="thead-dark">
                    <tr>
                        <th>Month/Day</th>
                        <cfset daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]>
                        <cfoutput>
                            <cfloop from="1" to="5" index="dayIndex">
                                <th>#daysOfWeek[dayIndex]#</th>
                            </cfloop>
                            </cfoutput>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput>
                        <cfset startDay = "">
                        <cfif url.month eq ""> <!--- For All Months --->
                            <cfloop from="1" to="12" index="month">
                                <cfset firstDayOfMonth = DateFormat(createDate(year(now()), month, 1))>

                                <cfif dayOfWeek(firstDayOfMonth) neq 2>
                                    <!-- If the first day of the month is not Monday, set startDay to the next Monday -->
                                    <cfset startDay = DateFormat(dateAdd("d", 9 - dayOfWeek(firstDayOfMonth), firstDayOfMonth), "YYYY-MM-DD")>
                                </cfif>
                                <tr>
                                    <td>#monthAsString(month)#</td>
                                    <cfloop from="1" to="5" index="dayIndex">
                                        <!--- query: get the groupid for the days --->
                                        <cfquery name="groupAll" datasource="intro">
                                            SELECT TOP 1 a.iGROUPID
                                            FROM TEAM_DATA a
                                            INNER JOIN DATE_HDDATA b ON a.iGROUPID = b.iGROUPID
                                            WHERE DATEPART(WEEKDAY, b.dtDATE) = #dayIndex + 1#
                                                AND MONTH(b.dtDATE) = #month#
                                                <cfif dayOfWeek(firstDayOfMonth) neq 2>
                                                AND b.dtDATE >= <cfqueryparam value="#startDay#" cfsqltype="cf_sql_date">
                                                </cfif>
                                        </cfquery>

                                        <cfset groupID = groupAll.iGROUPID>
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
                                            #ArrayToList(teamNames, '/')#
                                        </td>
                                    </cfloop>
                                    <td>
                                        <button class="btn btn-primary action-btn" onclick="showPopup(#month#)">Update</button>
                                    </td>
                                </tr>
                            </cfloop> 
                        <cfelse>
                            <!--- For specific months --->
                            <cfset firstDayOfMonth = DateFormat(createDate(year(now()), url.month, 1))>
                            <cfif dayOfWeek(firstDayOfMonth) neq 2>
                                <!-- If the first day of the month is not Monday, set startDay to the next Monday -->
                                <cfset startDay = DateFormat(dateAdd("d", 9 - dayOfWeek(firstDayOfMonth), firstDayOfMonth), "YYYY-MM-DD")>
                            </cfif>    
                            <tr>
                                <td>#monthAsString(url.month)#</td>
                                <cfloop from="1" to="5" index="dayIndex">
                                    <!--- query: get the groupid for the days --->
                                    <cfquery name="groupSpecific" datasource="intro">
                                        SELECT TOP 1 a.iGROUPID
                                        FROM TEAM_DATA a
                                        INNER JOIN DATE_HDDATA b ON a.iGROUPID = b.iGROUPID
                                        WHERE DATEPART(WEEKDAY, b.dtDATE) = #dayIndex + 1#
                                            AND MONTH(b.dtDATE) = #url.month#
                                            <cfif dayOfWeek(firstDayOfMonth) neq 2>
                                            AND b.dtDATE >= <cfqueryparam value="#startDay#" cfsqltype="cf_sql_date">
                                            </cfif>
                                    </cfquery>

                                    <cfset groupID = groupSpecific.iGROUPID>
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
                                        #ArrayToList(teamNames, '/')#
                                    </td>
                                </cfloop>
                                <td>
                                    <button class="btn btn-primary action-btn" onclick="showPopup(#url.month#)">Update</button>
                                </td>
                            </tr>
                        </cfif>
                    </cfoutput>
                </tbody>
            </table>
        </div>
    </div>
</body>

<!--- Update Pop Up Modal, hidden by default--->
<cfinclude template="dsp_updatemonthlyschedulemodal.cfm">

<script>

    // Pop-up for Update button 
    function showPopup(month) {
        var popup = document.getElementById("popup-" + month);
        var overlay = document.getElementById("overlay");
        popup.style.display = "block";
        overlay.style.display = "block";

        // Populate form fields with existing data
        var existingNickname = document.getElementById("update-nickname-" + month).value;

        var updateForm = popup.querySelector("form");
        updateForm.querySelector("[nickname='update_nickname']").value = existingNickname;

    }

    // Hide pop-up once done or press other than the popup container 
    function hideAllPopups() {
        var popups = document.querySelectorAll(".popup-container");
        var overlay = document.getElementById("overlay");
        popups.forEach(function(popup) {
            popup.style.display = "none";
        });
        overlay.style.display = "none";
    }

    $(document).ready(function() {
        var dropdownText = "Month";

        <cfset months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]>
        <cfloop from="1" to="12" index="monthIndex">
            <cfif url.month == monthIndex>
                <cfoutput>
                dropdownText = '#months[monthIndex]#';   
                </cfoutput>           
            </cfif>
        </cfloop>

        <cfif url.month == "">
            dropdownText = "Month";
        </cfif>

        // Update the dropdown button text
        $("#MonthFilterDropdown").text(dropdownText);
    });
</script>

</html>

