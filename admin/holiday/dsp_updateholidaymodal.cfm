<!--- Pop Up for Update Holiday --->

<!-- Hidden pop-up container for Update Button -->
<cfoutput query="getHolidays">
    <div id="popup-#getHolidays.iHOLIDAYID#" class="popup-container">
        <h1>Update #DateFormat(getHolidays.dtDATE, "dd/mm/yyyy")# Holiday</h1>
        <form action="index.cfm?fusebox=admin&fuseaction=act_updateholiday&#session.urltoken#" method="POST" name="updateholidayform">
            <table  border=3 cellpadding=3 width=100%>
                <col width=25% style=font-weight:bold;background-color:lightyellow>
                <col width=75% style=background-color:gainsboro>
                <tr>
                    <td class=clsField1>Holiday Name</td>
                    <td class=clsValue1><input type=text id="update-name-#getHolidays.iHOLIDAYID#" name="update_name" autocomplete="off" CHKREQUIRED onblur="DoReq(this)" value="#getHolidays.vaNAME#">*</td>
                </tr>
            </table>

            <!-- Hidden input field for ID -->
            <input type="hidden" name="update_id" value="#getHolidays.iHOLIDAYID#">

            <input type="button" value="UPDATE" onclick="if (FormVerify(document.all('updateholidayform'))) this.form.submit();" class="clsButton">
            </div>
        </form>
    </div>
</cfoutput>
<div class="overlay" id="overlay" onclick="hideAllPopups()"></div>
