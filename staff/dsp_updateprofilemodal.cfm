<!--- Pop Up for Update Profile --->
<!-- Hidden pop-up container for Update Button -->
<cfoutput query="userInfo">
    <div id="popup-#userInfo.iUSID#" class="popup-container">
        <h1>Update Profile</h1>
        <form action="index.cfm?fusebox=staff&fuseaction=act_updateprofile&#session.urltoken#" method="POST">
            <table  border=3 cellpadding=3 width=100%>
                <col width=25% style=font-weight:bold;background-color:lightyellow>
                <col width=75% style=background-color:gainsboro>
                <tr>
                    <td class=clsField1>Name</td>
                    <td class=clsValue1><input type=text id="update_name" name="update_name" value="#userInfo.staff_name#" autocomplete="off" CHKREQUIRED onblur="DoReq(this)">*</td>
                </tr>
            </table>

            <!-- Hidden input field for ID -->
            <input type="hidden" name="update_id" value="#userInfo.iUSID#">

            <button type="submit" class="btn btn-primary mt-3">Update</button>
            </div>
        </form>
    </div>
</cfoutput>
<div class="overlay" id="overlay" onclick="hideAllPopups()"></div>
