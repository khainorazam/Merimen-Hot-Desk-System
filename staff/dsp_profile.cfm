<!--- Profile Page --->
<cfinclude template="../merimenform.cfm">

<!--- query: get user info --->
<cfquery name="userInfo" datasource="intro">
    SELECT a.vaNAME AS staff_name, a.vaUSERNAME, a.vaDEFAULTDAYS, a.iUSID, b.vaNAME AS team_name, a.iUPDATEPWD, c.vaNAME AS role_name
    FROM USR_DATA a
    JOIN TEAM_DATA b ON a.iTEAMID = b.iTEAMID
    JOIN ROL_DATA c ON a.iROLEID = c.iROLEID
    WHERE a.iUSID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.vars.usid#">
</cfquery>

<!DOCTYPE html>
<html>
<head>
    <title>Profile Page - Hot Desk System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    

    <style>
    /* Style the cards */
    .card {
        margin: 20px;
        border: 1px solid black;
        background-color: #f9f9f9;
        border-radius: 0px;
    }

    /* Style card titles */
    .card-title {
        color: #333;
        font-size: 24px;
    }

    .light-text {
        color: #ffffff; /* or any other light color */
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
<cfoutput>
<body>
    <cfif #userInfo.iUPDATEPWD#>
        <div class="container">
        <header>
            <h1 class="text-center">User Profile</h1>
        </header>
        <main>
            <div class="card border-dark" style="margin-bottom:50px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
                <div class="card-header bg-dark text-white rounded-0">
                    <h2 class="card-title mb-0 light-text">Personal Information</h2>
                </div>
                <div class="card-body">
                    <p class="card-text"><strong>Name:</strong> #userInfo.staff_name#</p>
                    <p class="card-text"><strong>Username:</strong> #userInfo.vaUSERNAME#</p>
                    <p class="card-text"><strong>Team:</strong> #userInfo.team_name#</p>
                    <p class="card-text"><strong>Role:</strong> #userInfo.role_name#</p>
                </div>
                <div class="d-flex justify-content-center" style="margin-bottom:10px;">
                    <button class="btn btn-primary action-btn mr-2" onclick="showPopup(#userInfo.iUSID#)">Update</button>
                    <button class="btn btn-secondary action-btn" onclick="showPasswordChangePopup()">Change Password</button>
                </div>            
            </div>
            <cfoutput>
            <div class=clsDocBody>
                <h3 align="center">Days for Hot Seat Planning (Default)</h3>
            </div>
            <form action="index.cfm?fusebox=staff&fuseaction=act_updatedefaultdays&#session.urltoken#" method="post" name="defaulthotseatform">
            </cfoutput>
            <cfoutput>
                <div class="container">
                    <div class="table-container">
                        <table  border=5 cellpadding=5 width=100%>
                            <col width=25% style=font-weight:bold;background-color:lightyellow><col width=75% style=background-color:gainsboro>
                            <tr class=header><td colspan=2>Default Days (3)</td></tr>
                            <!---hidden id value --->
                            <input type="hidden" name="id" value="#session.vars.usid#">
                            <tr>
                                <tr>
                                    <td class=clsField1>Days</td>
                                    <td class=clsValue1>
                                        <cfoutput>
                                        <div>
                                            <input type="checkbox" name="days" value="2" id="monday" <cfif ListFind(userInfo.vaDEFAULTDAYS, "2")>checked</cfif>>
                                            <label class="form-check-label" for="monday">Monday</label>
                                        </div>
                                        <div>
                                            <input type="checkbox" name="days" value="3" id="tuesday" <cfif ListFind(userInfo.vaDEFAULTDAYS, "3")>checked</cfif>>
                                            <label class="form-check-label" for="tuesday">Tuesday</label>
                                        </div>
                                        <div>
                                            <input type="checkbox" name="days" value="4" id="wednesday" <cfif ListFind(userInfo.vaDEFAULTDAYS, "4")>checked</cfif>>
                                            <label class="form-check-label" for="wednesday">Wednesday</label>
                                        </div>
                                        <div>
                                            <input type="checkbox" name="days" value="5" id="thursday" <cfif ListFind(userInfo.vaDEFAULTDAYS, "5")>checked</cfif>>
                                            <label class="form-check-label" for="thursday">Thursday</label>
                                        </div>
                                        <div>
                                            <input type="checkbox" name="days" value="6" id="friday" <cfif ListFind(userInfo.vaDEFAULTDAYS, "6")>checked</cfif>>
                                            <label class="form-check-label" for="friday">Friday</label>
                                        </div>
                                        </cfoutput>
                                    </td>
                                </tr>
                            </tr>
                            <tr>
                                <td>
                                    <input type="button" value="UPDATE" onclick="validateForm(this.form);" class="clsButton">
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </cfoutput>
            </form>
        </main>
    </div>
    <cfelse>
        <!--- Update Password --->
        <cfinclude  template="dsp_updatepassword.cfm">
    </cfif>
    <!--- Update Pop Up Modal, hidden by default--->
    <cfinclude template="dsp_updateprofilemodal.cfm">
    <cfinclude template="dsp_changepasswordmodal.cfm">

</body>
</cfoutput>

<script>
    // Pop-up for Update button 
    function showPopup(id) {
        var popup = document.getElementById("popup-" + id);
        var overlay = document.getElementById("overlay");
        popup.style.display = "block";
        overlay.style.display = "block";

        // Populate form fields with existing data
        var existingName = document.getElementById("update-name-" + id).value;

        var updateForm = popup.querySelector("form");
        updateForm.querySelector("[name='update_name']").value = existingName;
    }

    function showPasswordChangePopup(id) {
        var popup = document.getElementById("popup-changePassword");
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

    function validateForm(form) {

        const checkboxes = form.querySelectorAll('input[type="checkbox"]');
        let checkedCount = 0;

        //check for boxes that are checked, using checkCount
        checkboxes.forEach(checkbox => {
            if (checkbox.checked) {
                checkedCount++;
            }
        });

        if (checkedCount != 3) {
            alert('Please select 3 days.');
            return;
        }

        // If the validation passes, submit the form
        if (FormVerify(document.all('defaulthotseatform')))        
        form.submit();
    }
    </script>

</html>
