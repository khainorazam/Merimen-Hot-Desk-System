<!--- DSP: Create Staff Page--->
<!--- <cfinclude template="../admin_header.cfm"> --->
<cfinclude template="../../merimenform.cfm">

<!--- SSP: get data from roles --->
<cfstoredproc procedure="sspGetTableData" datasource="intro">
    <cfprocparam type="in" cfsqltype="cf_sql_varchar" value="ROL_DATA">
    <cfprocresult name="roles">
</cfstoredproc>

<!--- SSP: get data from roles --->
<cfstoredproc procedure="sspGetTableData" datasource="intro">
    <cfprocparam type="in" cfsqltype="cf_sql_varchar" value="TEAM_DATA">
    <cfprocresult name="teams">
</cfstoredproc>

<html>
<head>
    <title>Create Staff - Hot Desk System</title>
</head>

<body>
    <div class=clsDocBody>
        <h3 align="center"> Create Staff</h3>
    </div>
    <cfoutput>
    <form action="index.cfm?fusebox=admin&fuseaction=act_createstaff&#session.urltoken#" method="post" name="createstaffform">
    </cfoutput>
        <div class="container">
            <div class="table-container">
                <table  border=5 cellpadding=5 width=100%>
                    <col width=25% style=font-weight:bold;background-color:lightyellow><col width=75% style=background-color:gainsboro>
                    <tr class=header><td colspan=2>Staff Details</td></tr>
                    <tr>
                        <td class=clsField1>Name</td>
                        <td class=clsValue1><input type=text id="name" name="name" autocomplete="off" CHKREQUIRED onblur="DoReq(this)">*</td>
                    </tr>
                    <tr>
                        <td class=clsField1>Username</td>
                        <td class=clsValue1><input type=text id="username" name="username" autocomplete="off" onblur="DoReq(this)" CHKREQUIRED>*</td>
                    </tr>
                    <tr>
                        <td class=clsField1>Role</td>
                        <td class=clsValue1>
                        <select id="role" name="role" onchange="toggleTeamSelect()">                             
                                <cfoutput>
                                    <cfloop query="#roles#">
                                        <option value="#roles.iROLEID#">#roles.vaname#</option>
                                    </cfloop>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr id="teamRow" style="display:none;">
                        <td class="clsField1">Team</td>
                        <td class="clsValue1">
                            <select id="team" name="team" value="7"> <!-- Set default value to 7 -->
                                <!---  displays list of teams when "TEAM LEAD" role is selected --->
                                <cfoutput>
                                    <cfloop query="#teams#">
                                        <option value="#teams.iTEAMID#">#teams.vaname#</option>
                                    </cfloop>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" value="Create" onclick="if (FormVerify(document.all('createstaffform'))) this.form.submit();" class="clsButton">
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>


<script>
        function toggleTeamSelect() {
            var roleSelect = document.getElementById("role");
            var teamRow = document.getElementById("teamRow");
            var teamSelect = document.getElementById("team");


            if (roleSelect.value == 2) {
                teamRow.style.display = "table-row";
            } 
            else {
                teamRow.style.display = "none";
            }
        }
</script>
