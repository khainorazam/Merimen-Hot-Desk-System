<!--- Pop Up for Update Staff --->
<cfinclude template="../../merimenform.cfm">

<!--- SSP: get data from roles --->
<cfstoredproc procedure="sspGetTableData" datasource="intro">
    <cfprocparam type="in" cfsqltype="cf_sql_varchar" value="ROL_DATA">
    <cfprocresult name="roles">
</cfstoredproc>

<!-- Hidden pop-up container for Update Button -->
<cfoutput query="userQuery">
    <div id="popup-#userQuery.iUSID#" class="popup-container">
        <h1>Update #userQuery.a_VANAME#'s  Role</h1>
        <form action="index.cfm?fusebox=admin&fuseaction=act_updatestaff&#session.urltoken#" method="POST">
            <table  border=3 cellpadding=3 width=100%>
                <col width=25% style=font-weight:bold;background-color:lightyellow>
                <col width=75% style=background-color:gainsboro>
                <tr>
                    <td class=clsField1>Role</td>
                    <td class=clsValue1>
                        <select class="form-select" id="update-role-#userQuery.iUSID#" name="update_role">
                            <cfloop query="#roles#">
                                <option value="#roles.iROLEID#" <cfif userQuery.c_vaNAME eq #roles.vaname#>selected</cfif>>#roles.vaname#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
            </table>

            <!-- Hidden input field for ID -->
            <input type="hidden" name="update_id" value="#userQuery.iUSID#">

            <button type="submit" class="btn btn-primary mt-3">Update</button>
            </div>
        </form>
    </div>
</cfoutput>
<div class="overlay" id="overlay" onclick="hideAllPopups()"></div>
