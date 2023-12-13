<!--- Pop Up for Update Team --->

<!-- Hidden pop-up container for Update Button -->
<cfoutput query="getTeams">
    <div id="popup-#getTeams.iTEAMID#" class="popup-container">
        <h1>Update #getTeams.vaNAME# Team</h1>
        <form action="index.cfm?fusebox=admin&fuseaction=act_updateteam&#session.urltoken#" method="POST" name="updateteamform">
            <table  border=3 cellpadding=3 width=100%>
                <col width=25% style=font-weight:bold;background-color:lightyellow>
                <col width=75% style=background-color:gainsboro>
                <tr>
                    <td class=clsField1>Team Nickname</td>
                    <td class=clsValue1><input type=text id="update-nickname-#getTeams.iTEAMID#" name="update_nickname" autocomplete="off" CHKREQUIRED onblur="DoReq(this)" value="#getTeams.vaNICKNAME#">*</td>
                </tr>
                <tr>
                    <td class=clsField1>Group</td>
                    <td class=clsValue1><input type=text id="update-group-#getTeams.iTEAMID#-#getTeams.iGROUPID#" name="update_group" autocomplete="off" CHKREQUIRED onblur="DoReq(this)" value="#getTeams.iGROUPID#">*</td>
                </tr>
            </table>

            <!-- Hidden input field for ID -->
            <input type="hidden" name="update_id" value="#getTeams.iTEAMID#">

            <input type="button" value="UPDATE" onclick="if (checkGroupBalance(#getTeams.iTEAMID#, #getTeams.iGROUPID#) && FormVerify(document.all('updateteamform'))) this.form.submit();" class="clsButton">
            </div>
        </form>
    </div>
</cfoutput>
<div class="overlay" id="overlay" onclick="hideAllPopups()"></div>

<cfquery name="allTeamsGroup" datasource="intro">
    SELECT iGROUPID
    FROM TEAM_DATA
    WHERE iTEAMID != 7
</cfquery>

<script>
    function checkGroupBalance(id, groupid) {
        var updatedGroup = document.getElementById("update-group-" + id + "-" + groupid).value;
        console.log(groupid);
        console.log(updatedGroup);

        // If the updated group is not the previous group, then proceed to check
        if (updatedGroup != groupid){
            console.log("New group");

            // Initialize an empty object to keep track of the number of teams in each group
            var groupCount = {};

            // Add the rows to the group array
            <cfloop query="allTeamsGroup">
                var groupId = "<cfoutput>#allTeamsGroup.iGROUPID#</cfoutput>";
                // Initialize an array for the group if not already present
                groupCount[groupId] = groupCount[groupId] || [];

                // Add the current iGROUPID to the array
                groupCount[groupId].push("<cfoutput>#allTeamsGroup.iGROUPID#</cfoutput>");
            </cfloop>

            console.log(groupCount);

            // Check if adding a team to the updated group will keep it balanced
            var isBalanced = true;
            groupCount[updatedGroup].push(updatedGroup); 

            // Count teams in each group
            for (var group in groupCount) {
                if (groupCount.hasOwnProperty(group)) {
                    // If any group has more teams than the expected count, set isBalanced to false and break the loop
                    if (groupCount[group].length > Math.ceil("<cfoutput>#allTeamsGroup.RecordCount#</cfoutput>" / Object.keys(groupCount).length)) {
                        isBalanced = false;
                        break;
                    }
                }
            }

            if (isBalanced) {
                return true;
                // Proceed with form submission
            } else {
                // Display an error message
                alert("The group is full at the moment. Please pick another group.");
                return false;
            }
        }

    return true;
    }
</script>

