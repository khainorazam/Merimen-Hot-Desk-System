<!--- DSP: Update Week Page--->
<cfinclude template="../../merimenform.cfm">
<cfparam name=url.date default="">

<!--- query: get the date's hot desk information --->
<cfquery name="date" datasource="intro">
    SELECT iSEAT_TOTAL, iSEAT_OCCUPIED, iSEAT_EMERGENCY
    FROM DATE_HDDATA
    WHERE dtDATE = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(url.date, "yyyy-mm-dd")#"/> 
</cfquery>

<cfset currentDate = #DateFormat(#url.date#, "dd/mm/yyyy")#>
<html>
<head>
    <title>Update Hot Desk Information (Day) - Hot Desk System</title>
</head>
<body>
    <cfoutput>
    <div class=clsDocBody>
        <h3 align="center">Update #currentDate# Hot Desk Information</h3>
    </div>
    <form action="index.cfm?fusebox=admin&fuseaction=act_updateday&#session.urltoken#" method="post" name="updatedayform">
    </cfoutput>
    <cfoutput query="date">
        <div class="container">
            <div class="table-container">
                <table  border=5 cellpadding=5 width=100%>
                    <col width=25% style=font-weight:bold;background-color:lightyellow><col width=75% style=background-color:gainsboro>
                    <tr class=header><td colspan=2>#currentDate# - Hot Desk Details</td></tr>
                    <!---hidden date value --->
                    <input type="hidden" name="date" value="#DateFormat(url.date, "yyyy-mm-dd")#">
                    <tr>
                        <td class=clsField1>Day</td>
                        <td class=clsValue1><input type=text id="name" name="name" CHKREQUIRED onblur="DoReq(this)" value="#DateFormat(currentDate, "dddd")#" readonly></td>
                    </tr>
                    <tr>
                        <td class=clsField1>Total Seats</td>
                        <td class=clsValue1><input type=number id="totalseat" name="totalseat" onblur="DoReq(this)" value="#date.iSEAT_TOTAL#" CHKREQUIRED>*</td>
                    </tr>
                    <tr>
                        <td class=clsField1>Emergency Seats</td>
                        <td class=clsValue1><input type=number id="emergencyseat" name="emergencyseat" onblur="DoReq(this)" value="#date.iSEAT_EMERGENCY#" CHKREQUIRED>*</td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" value="UPDATE" onclick="if (FormVerify(document.all('updatedayform'))) this.form.submit();" class="clsButton">
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </cfoutput>
    </form>
</body>
</html>


