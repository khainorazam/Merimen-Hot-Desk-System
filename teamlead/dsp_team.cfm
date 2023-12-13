<!--- Main Admin Page --->

<html>
    <head>
        <title>Team - Hot Desk System</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap 4 CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    </head>

<!--- for Merimen CSS    --->
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCSS"> 
<!--- JQuery --->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<!--- STYLE : Action button and pop-up modal --->
    <style>
        <!--- Styles the action button --->
            .action-btn {
                width: 80px; 
            }

            /* Custom CSS for centering the table */
            .table-container {
                max-width: 2000px; /* Adjust the maximum width as needed */
                margin: 0 auto; /* Center the container horizontally */
            }
    </style>
    </head>
    <body>
        <!--- SSP: gets all team member details --->
        <cfstoredproc procedure="sspGetTeamMembers" datasource="intro">
            <cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" value="#session.vars.teamid#">
            <cfprocparam type="in" cfsqltype="CF_SQL_INTEGER" value="#session.vars.usid#">
            <cfprocresult name="team">
        </cfstoredproc>

        <!-- List of Team Members -->
        <div class="container text-center" style="margin-top:40px;">
            <cfoutput>
                <h3>List of #session.vars.teamname# Team Members</h3>
            </cfoutput>
        </div>
        <div class="container">
            <div class="table-container">
                <table class="table table-bordered table-striped">
                    <thead class="thead-dark">
                        <tr>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput>
                            <cfif team.RecordCount>
                                <cfloop query="team">                                
                                    <tr>
                                        <td>#team.NAME#</td>
                                        <td>#team.vaUSERNAME#</td>
                                        <td>#team.roleNAME#</td>  
                                        <td>
                                            <button class="btn btn-danger action-btn" onclick="showRemovePrompt(#team.iUSID#)">Remove</button>
                                        </td>
                                    </tr>
                                </cfloop> 
                            <cfelse>
                                <tr>
                                    <td colspan=4 class="text-center">NONE</td>
                                </tr>
                            </cfif>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>

        <!--- QUERY: query for users w/o team --->
        <cfquery name="noteam" datasource="intro">
        SELECT iUSID, vaNAME, vaUSERNAME
        FROM USR_DATA
        WHERE iTEAMID = 7 AND siSTATUS = 0
        </cfquery>

        <!-- List of Users w/o team -->
        <div class="container text-center">
            <cfoutput>
                <h3>List of Users (No Team)</h3>
            </cfoutput>
        </div>
        <div class="container">
            <div class="table-container">
                <table class="table table-bordered table-striped">
                    <thead class="thead-dark">
                        <tr>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput>
                            <cfif noteam.RecordCount>
                                <cfloop query="noteam">                                
                                    <tr>
                                        <td>#noteam.vaNAME#</td>
                                        <td>#noteam.vaUSERNAME#</td>
                                        <td>
                                            <button class="btn btn-primary action-btn" onclick="showAddPrompt(#noteam.iUSID#)">Add</button>
                                        </td>
                                    </tr>
                                </cfloop> 
                            <cfelse>
                                <tr>
                                    <td colspan=3 class="text-center">NONE</td>
                                </tr>
                            </cfif>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>


<cfoutput>
<script>

    function showAddPrompt(id) {
    if (confirm("Are you sure you want to add this staff to team?")) {
        console.log("here: ");

        window.location.href = "index.cfm?fusebox=teamlead&fuseaction=act_addteam&id=" + id + "&#session.urltoken#";

    }
    }

    function showRemovePrompt(id) {
    if (confirm("Are you sure you want to remove this staff from team?")) {
        window.location.href = "index.cfm?fusebox=teamlead&fuseaction=act_removeteam&id=" + id + "&#session.urltoken#";
    }
    }

    
</script>
</cfoutput>

