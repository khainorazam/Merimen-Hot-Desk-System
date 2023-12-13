<!--- Staff Page --->

<html>
    <head>
        <title>Staff Page - Hot Desk System</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap 4 CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    </head>

<!--- for Merimen CSS    --->
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCSS"> 
<!--- JQuery --->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


<!--- STYLE : Action button and pop-up modal --->
<style>
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

<body>
    <!--- SSP: gets Staff Details --->
    <cfstoredproc procedure="sspGetStaffDetails" datasource="intro">
        <cfprocresult name="userQuery">
    </cfstoredproc>

    <!-- List of Staff -->
    <div class="container text-center">
            <h3>List of Staff</h3>
    </div>
    <div class="container">
        <div class="table-container">
            <div class="row">
                <div class="col-md-12">
                    <div class="dropdown">
                        <cfparam name="url.teamid" default="">

                        <!--- query: get team for dropdown --->
                        <cfquery name="getTeam" datasource="intro">
                            SELECT vaNAME, iTEAMID
                            FROM TEAM_DATA
                        </cfquery>

                        <button class="btn btn-secondary dropdown-toggle" type="button" id="teamFilterDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Filter by Team
                        </button>

                        <div class="dropdown-menu" aria-labelledby="teamFilterDropdown">
                            <cfoutput>
                            <a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_staff&#session.urltoken#" <cfif url.teamid == "">class="active"</cfif>>ALL</a>
                            </cfoutput>
                        <cfloop query="getTeam">
                            <cfif #getTeam.vaNAME# eq "-">
                                <cfset getTeam.vaNAME = "NO TEAM">
                            </cfif>
                            <cfoutput>
                            <a class="dropdown-item" href="index.cfm?fusebox=admin&fuseaction=dsp_staff&teamid=#getTeam.iTEAMID#&#session.urltoken#" <cfif url.teamid == #getTeam.iTEAMID#>class="active"</cfif>>#getTeam.vaNAME#</a>
                            </cfoutput>
                        </cfloop>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 text-right">
                    <button class="btn btn-primary" id="create-staff-button" style="margin-bottom: 10px;">Create Staff</button>
                </div>
            </div>
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Name</th>
                        <th>Username</th>
                        <th>Team</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>

                    <!--- query: get Team Members Details --->
                    <cfquery name="getTeamStaffDetails" datasource="intro">
                        SELECT a.iUSID, a.vaNAME AS a_vaNAME, a.vaUSERNAME, 
                            b.vaNAME as b_vaNAME, 
                            c.vaNAME as c_vaNAME
                        FROM USR_DATA a
                        JOIN TEAM_DATA b ON a.iTEAMID = b.iTEAMID
                        JOIN ROL_DATA c ON a.iROLEID = c.iROLEID
                        WHERE 
                        <cfif url.teamid neq "">a.iTEAMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.teamid#"> AND</cfif> a.siSTATUS = 0;
                    </cfquery>

                    <cfoutput>
                        <cfif getTeamStaffDetails.RecordCount>
                            <cfloop query="getTeamStaffDetails">
                                <tr>
                                    <td>#getTeamStaffDetails.a_vaNAME#</td>
                                    <td>#getTeamStaffDetails.vaUSERNAME#</td>
                                    <td>#getTeamStaffDetails.b_vaNAME#</td>  
                                    <td>#getTeamStaffDetails.c_vaNAME#</td>
                                    <td>
                                        <button class="btn btn-primary action-btn" onclick="showPopup(#getTeamStaffDetails.iUSID#)">Update</button>
                                        <button class="btn btn-danger action-btn" onclick="showDeletePrompt(#getTeamStaffDetails.iUSID#)">Delete</button>
                                    </td>
                                </tr>
                            </cfloop>
                        <cfelse>
                            <tr>
                                <td colspan=5 class="text-center">NONE</td>
                            </tr>
                        </cfif>
                    </cfoutput>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

<!--- Update Pop Up Modal, hidden by default--->
<cfinclude template="dsp_updatestaffmodal.cfm">

<!--- create staff container --->
<div id="createstaff-container"></div>

<script>

        $(document).ready(function() {
            var dropdownText = "Filter by Team";

            <cfif url.teamid == "">
                dropdownText = "All";
            <cfelse>
                <cfloop query="getTeam">
                    <cfif url.teamid == getTeam.iTEAMID>
                        <cfoutput>
                        dropdownText = '#getTeam.vaNAME#';
                        </cfoutput>
                    </cfif>
                </cfloop>
            </cfif>

            // Update the dropdown button text
            $("#teamFilterDropdown").text(dropdownText);
        });

        // Pop-up for Update button 
        function showPopup(id) {
        var popup = document.getElementById("popup-" + id);
        var overlay = document.getElementById("overlay");
        popup.style.display = "block";
        overlay.style.display = "block";

        // Populate form fields with existing data
        var existingRole = document.getElementById("update-role-" + id).value;

        var updateForm = popup.querySelector("form");
        updateForm.querySelector("[name='update_role']").value = existingRole;

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

        // Delete staff action
        function showDeletePrompt(id) {
        if (confirm("Are you sure you want to delete this staff?")) {
            window.location.href = "index.cfm?fusebox=admin&fuseaction=act_deletestaff&id=" + id;
        }
        }

        //To load create staff form if button is clicked
        $(document).ready(function() {
        // Listen for the click event on the button
        $("#create-staff-button").click(function() {
            // Use AJAX to load the template into the container
            $("#createstaff-container").load("admin/user/dsp_createstaff.cfm");
        });
    });

</script>

