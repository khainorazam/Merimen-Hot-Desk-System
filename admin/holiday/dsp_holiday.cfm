<!--- Holiday Page --->

<html>
    <head>
        <title>Holiday Page - Hot Desk System</title>
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
    <!-- List of Holidays -->
    <div class="container text-center">
            <h3>Holidays</h3>
    </div>
    <div class="container">
        <div class="table-container">
            <div class="row">
                <div class="col-md-12 text-right">
                    <button class="btn btn-primary" id="create-holiday-button" style="margin-bottom: 10px;">Add Holiday</button>
                </div>
            </div>
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Date</th>
                        <th>Day</th>
                        <th>Holiday</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!--- query: get Holiday Details --->
                    <cfquery name="getHolidays" datasource="intro">
                        SELECT vaNAME, dtDATE, iHOLIDAYID
                        FROM HOLIDAY_DATA
                    </cfquery>

                    <cfoutput>
                        <cfloop query="getHolidays">
                            <tr>
                                <td>#DateFormat(getHolidays.dtDATE, "dd/mm/yyyy")#</td>
                                <td>#DayOfWeekAsString(DayOfWeek(getHolidays.dtDATE))#</td>
                                <td>#getHolidays.vaNAME#</td>
                                <td>
                                    <button class="btn btn-primary action-btn" onclick="showPopup(#getHolidays.iHOLIDAYID#)">Update</button>
                                    <button class="btn btn-danger action-btn" onclick="showDeletePrompt(#getHolidays.iHOLIDAYID#)">Delete</button>
                                </td>
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

<!---  "Create Holiday" form below the button, initially hidden --->
<div id="create-holiday-form" style="display: none;">
<script>sysdt=new Date();</script>
<cfinclude template="../../merimenform.cfm">
<html>
<head>
    <title>Add Holiday - Hot Desk System</title>
</head>

<body>
    <div class=clsDocBody>
        <h3 align="center"> Add Holiday</h3>
    </div>
    <cfoutput>
    <form action="index.cfm?fusebox=admin&fuseaction=act_createholiday&#session.urltoken#" method="post" name="createholidayform">
    </cfoutput>
        <div class="container">
            <div class="table-container">
                <table  border=5 cellpadding=5 width=100%>
                    <col width=25% style=font-weight:bold;background-color:lightyellow><col width=75% style=background-color:gainsboro>
                    <tr class=header><td colspan=2>Holiday Details</td></tr>
                    <tr>
                        <td class=clsField1>Holiday Name</td>
                        <td class=clsValue1><input type=text id="name" name="name" autocomplete="off" CHKREQUIRED onblur="DoReq(this)">*</td>
                    </tr>
                    <tr>
                        <td class=clsField1>Date</td>
                        <td class=clsValue1><input MRMOBJ="CALDATE" type="text" id="date" autocomplete="off" name="date" CHKREQUIRED onblur="DoReq(this)" chkname="Date" placeholder="dd/mm/yyyy">*</td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" value="CREATE" onclick="validateDateAndSubmit()" class="clsButton">
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
<cfinclude template="dsp_updateholidaymodal.cfm">



<script>

        function validateDateAndSubmit() {
            var dateInput = document.getElementById("date");
            var dateValue = dateInput.value;

            // Regular expression for the dd/mm/yyyy format
            var datePattern = /^(0?[1-9]|[12][0-9]|3[01])\/(0?[1-9]|1[0-2])\/\d{4}$/;

            if (!datePattern.test(dateValue)) {
                // Invalid date format, show an error message
                var errorMessage = "Invalid date format. Please use dd/mm/yyyy.";
                alert(errorMessage);

            } else {
                // You can submit the form here
                if (FormVerify(document.all('createholidayform'))) {
                    document.createholidayform.submit();
                }
            }
        }


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
        if (confirm("Are you sure you want to delete this holiday?")) {
            window.location.href = "index.cfm?fusebox=admin&fuseaction=act_deleteholiday&id=" + id;
        }
        }

        //To load create staff form if button is clicked
        $(document).ready(function() {
        // Listen for the click event on the button
        $("#create-holiday-button").click(function() {
            $("#create-holiday-form").toggle();
        });
    });

</script>

