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


<!-- List of Teams -->
    <div class="container text-center" style="margin-top:80px;">
            <h3>Teams</h3>
    </div>
    <div class="container" style="margin-bottom:50px;">
        <div class="table-container">
            <div class="row">
                <div class="col-md-12 text-right">
                    <button class="btn btn-primary" id="create-team-button" style="margin-bottom: 10px;">Create Team</button>
                </div>
            </div>
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Name</th>
                        <th>Nickname</th>
                        <th>Group</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!--- query: get team Details --->
                    <cfquery name="getTeams" datasource="intro">
                        SELECT vaNAME, vaNICKNAME, iGROUPID, iTEAMID
                        FROM TEAM_DATA
                        WHERE iTEAMID != 7
                    </cfquery>

                    <cfoutput>
                        <cfloop query="getTeams">
                            <tr>
                                <td>#getTeams.vaNAME#</td>
                                <td>#getTeams.vaNICKNAME#</td>
                                <td>#getTeams.iGROUPID#</td>
                                <td>
                                    <button class="btn btn-primary action-btn" onclick="showPopup(#getTeams.iTEAMID#)">Update</button>
                                    <button class="btn btn-danger action-btn" onclick="showDeletePrompt(#getTeams.iTEAMID#)">Delete</button>
                                </td>
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
        </div>
    </div>

    <!---  "Create Team" form below the button, initially hidden --->
    <div id="create-team-form" style="display: none; margin-bottom:100px;">
    <cfinclude template="../../merimenform.cfm">
    <html>
    <head>
        <title>Create Team - Hot Desk System</title>
    </head>

    <body>
        <div class=clsDocBody>
            <h3 align="center"> Create Team</h3>
        </div>
        <cfoutput>
        <form action="index.cfm?fusebox=admin&fuseaction=act_createteam&#session.urltoken#" method="post" name="createteamform">
        </cfoutput>
            <div class="container">
                <div class="table-container">
                    <table  border=5 cellpadding=5 width=100%>
                        <col width=25% style=font-weight:bold;background-color:lightyellow><col width=75% style=background-color:gainsboro>
                        <tr class=header><td colspan=2>Team Details</td></tr>
                        <tr>
                            <td class=clsField1>Name</td>
                            <td class=clsValue1><input type=text id="name" name="name" autocomplete="off" CHKREQUIRED onblur="DoReq(this)">*</td>
                        </tr>
                        <tr>
                            <td class=clsField1>Nickname</td>
                            <td class=clsValue1><input type=text id="nickname" name="nickname" autocomplete="off" CHKREQUIRED onblur="DoReq(this)">*</td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" value="CREATE" onclick="if (FormVerify(document.all('createteamform'))) this.form.submit();" class="clsButton">
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </form>
    </body>
    </html>
    </div>

<!--- Update Pop Up Modal, hidden by default--->
<cfinclude template="dsp_updateteammodal.cfm">


<script>

    // Pop-up for Update button 
    function showPopup(id) {
        var popup = document.getElementById("popup-" + id);
        var overlay = document.getElementById("overlay");
        popup.style.display = "block";
        overlay.style.display = "block";
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
        if (confirm("Are you sure you want to delete this team?")) {
            window.location.href = "index.cfm?fusebox=admin&fuseaction=act_deleteteam&id=" + id;
        }
    }

    //To load create staff form if button is clicked
     $(document).ready(function() {
        $("#create-team-button").click(function() {
            // Check if the form is being displayed or hidden
            var isFormVisible = $("#create-team-form").is(":visible");

            $("#create-team-form").toggle();

            // Scroll to the form only when it's being opened
            if (!isFormVisible) {
                $('html, body').animate({
                    scrollTop: $("#create-team-form").offset().top
                }, 500);
            }
        });
    });

</script>