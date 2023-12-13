<!--- Login Page --->

<!DOCTYPE html>
<html>
<head>
    <title>Hot Desk System</title>
    <!-- Include Bootstrap 4 CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        /* Add CSS to hide the admin form initially */
        #admin-form {
            display: none;
        }

		/* Custom style for green buttons */
		.green-button {
			background-color: green; /* Change to your desired green color */
			color: white; /* Text color */
			/* Add any other styles you want for the buttons */
		}

		/* Hover effect */
		.btn-block:hover {
			background-color: green; /* Change to your desired green color on hover */
		}

		.green-background {
			background-color: green !important;
			color: white;
		}
</style>

    </style>

	<!--- for Admin --->
	<!--- set the modules for the involved services files --->
	<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCADDFILE.cfm" FNAME="SVCLOGIN">
	<cfmodule TEMPLATE="#request.apppath#services/CustomTags\SVCADDFILE.cfm" FNAME="SVCMAIN">

	<!--- setting variables for login box --->
	<script>
		<CFSET APPNAME=Application.ApplicationName>
		<CFSET APPLOCID=Application.APPLOCID>
		<cfset currenttime="#DateFormat(now(),'mm/dd/yyyy')# #TimeFormat(now(),'HH:mm:ss')#">
		<cfset nonce=ToBase64(currenttime&Hash(currenttime&"boo$ga56"))><!--- that is our private key --->
	</script>
	<cfset showconame=0><!--- To display company name below the logo --->


	<!--- setting style for login box --->
	<style>
	.box-corner{
		color:black;
		background:#88a820;
		-moz-border-radius:10px 10px 10px 10px;
		-webkit-border-radius:10px 10px 10px 10px;
		border-radius:10px 10px 10px 10px;z-index:10;
		-webkit-box-shadow:4px 4px 5px 0 rgba(136,136,136,.75);
		-moz-box-shadow:4px 4px 5px 0 rgba(136,136,136,.75);
		box-shadow:4px 4px 5px 0 rgba(136,136,136,.75);
	}

	.login{    
		color: black; 
		margin:1%;
		padding:25px;
	}

	.b{
		color:black;
	}

	</style>

</head>
<body>
    <div class="container-fluid">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-md-6">
                <div class="card">
					<div class="card-header d-flex align-items-center justify-content-center">
						<img src="/services/mobile/fermionmerimen.png" alt="Fermion Merimen" class="img-fluid" style="width: 200px; height: 50;"> 
						<h2 class="ml-3"><b>Hot Desk System</b></h2>
                    </div>
                    <div class="card-body">
                        <!-- Buttons to toggle between admin and staff forms -->
                        <div class="text-center mb-3">
                            <button class="btn btn-primary" id="show-staff-form">Staff Login</button>
                            <button class="btn btn-primary" id="show-admin-form">Admin Login</button>
                        </div>
                        <!-- Staff Login Form -->
                        <form method="post" action="index.cfm?fusebox=auth&fuseaction=act_loginstaff" id="staff-form">
                            <div class="form-group">
                                <label for="username">Username:</label>
                                <input type="text" class="form-control" id="username" name="username" autocomplete="off" required>
                            </div>
                            <div class="form-group">
                                <label for="password">Password:</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-block">Login</button>
                        </form>
                        <!-- Admin Login Form (Initially Hidden) -->
                        <!-- ShowLogin Content Container (Initially Hidden) -->
						<div id="show-login-content" style="display: none;">
							<div class="col-sm-15 col-md-15 col-lg-15">
								<cfset showlogin(11,0,showconame)>
							</div>
						</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include Bootstrap 4 and jQuery JavaScript -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

	<script>
		// JavaScript to toggle between admin and staff forms
		$(document).ready(function() {
			$("#show-staff-form").click(function() {
				$("#staff-form").show();
				$("#show-login-content").hide(); // Hide the showLogin content
			});

			$("#show-admin-form").click(function() {
				$("#staff-form").hide();
				$("#show-login-content").show(); // Show the showLogin content
			});
		});

		// change button to green when clicked
		$(document).ready(function () {
        // Add a click event handler for the buttons
        $("#show-staff-form, #show-admin-form").click(function () {
            // Remove the "green-background" class from all buttons
            $(".btn-primary").removeClass("green-background");

            // Add the "green-background" class to the clicked button
            $(this).addClass("green-background");
        });
    });
	</script>
</body>
</html>


<!--- FUNCTION: showlogin --->
<cffunction name="showLogin" output="true">
	<!--- 	shows the border --->
	<cfargument name="border" default="4">
	<!--- 	if 0 use fermion logo, if not, no logo --->	
	<cfargument name="nologo" default="0">
	<!--- 	shows company name --->
	<cfargument name="coname" default="0">

	<!--- 	styling for box  --->
	<div align="center" class="box-corner login">
		<!--- 	if nologo == 0	 --->
		<div align=center>
			<!--- 		this is where the logo is displayed --->
			<br>
			<span>
				<img src="/services/mobile/fermionmerimen.png" class="img-responsive" width=150 border=0 align=center>
			</span>
		</div>
		<br>
		<script>
			JSVCDoLogin("#nonce#", 5 * 60 * 1000, "fusebox=auth&fuseaction=act_login&#session.urltoken#", 100 )
		</script>

		 <!--- <script type="text/javascript">


			document.addEventListener("DOMContentLoaded", function () {
				var form = document.getElementById("staff-form");

				form.addEventListener("submit", function (event) {
					console.log("Staff Initial");
					event.preventDefault(); // Prevent the default form submission

					<!--- 1. onSubmit, get the username (DONE)
							2. search the username in the query (DONE)
							3. if found, send to the act_loginstaff 
							4. if not found, assign username and password to sleUserName and slePassword and submit the JSVCLoginSubmit  
					--->

					var username = document.getElementById("username").value;
					var password = document.getElementById("password").value;

					var xhr = new XMLHttpRequest();
					xhr.open("POST", "check_login.cfm", true);
					xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
					xhr.onreadystatechange = function () {
						if (xhr.readyState === 4 && xhr.status === 200) {
							// Handle the response from the server
							if (xhr.responseText.includes("No username provided") || xhr.responseText.includes("User does not exist")) {
								// If the response indicates no username provided, proceed with the login
								console.log("Merimen Login");
								var form = document.getElementById("LoginMain");
								
								document.getElementById("sleUserName").value = username;
								document.getElementById("slePassword").value = password;

								form.submit();
								
							} else {
								form.action = "index.cfm?fusebox=staff&fuseaction=act_loginstaff&#session.urltoken#"; 
							}
						}
					};
					xhr.send("username=" + encodeURIComponent(username));
				});
			});
		</script> --->
		<br style="line-height:16px">
	</div>
	<br style="line-height:5px">
</cffunction>

