<!--- Switch case for fuseaction (file)--->
<cfswitch EXPRESSION=#attributes.FUSEACTION#>	
    <!---     login page for admin --->
	<cfcase VALUE="dsp_loginadmin">
        <cfinvoke component="index" method="dsp_loginadmin" ArgumentCollection=#Attributes#>
    </cfcase>
<!---     home page for admin --->
	<cfcase VALUE="dsp_homeadmin">
        <cfinvoke component="index" method="dsp_homeadmin" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---    staff page --->
    <cfcase VALUE="dsp_staff">
        <cfinvoke component="index" method="dsp_staff" ArgumentCollection=#Attributes#>
    </cfcase>
<!---     create user (staff) page --->
    <cfcase VALUE="dsp_createstaff">
        <cfinvoke component="index" method="dsp_createstaff" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---     create user staff action --->
    <cfcase VALUE="act_createstaff">
        <cfinvoke component="index" method="act_createstaff" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---     update staff modal  --->
    <cfcase VALUE="dsp_updatestaffmodal">
        <cfinvoke component="index" method="dsp_updatestaffmodal" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---     update staff action  --->
    <cfcase VALUE="act_updatestaff">
        <cfinvoke component="index" method="act_updatestaff" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---     delete staff action  --->
    <cfcase VALUE="act_deletestaff">
        <cfinvoke component="index" method="act_deletestaff" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---  display week page  --->
    <cfcase VALUE="dsp_week">
        <cfinvoke component="index" method="dsp_week" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---  update hot desk info (day) page  --->
    <cfcase VALUE="dsp_updateday">
        <cfinvoke component="index" method="dsp_updateday" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---  update hot desk info (day) action  --->
    <cfcase VALUE="act_updateday">
        <cfinvoke component="index" method="act_updateday" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---  Display monthly schedule page  --->
    <cfcase VALUE="dsp_monthlyschedule">
        <cfinvoke component="index" method="dsp_monthlyschedule" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---  Update hot desk page  --->
    <cfcase VALUE="dsp_updatehotdesk">
        <cfinvoke component="index" method="dsp_updatehotdesk" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---  Action: Update hot desk page  --->
    <cfcase VALUE="act_updatehotdesk">
        <cfinvoke component="index" method="act_updatehotdesk" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---  Action: Update hot seat approval --->
    <cfcase VALUE="act_approval">
        <cfinvoke component="index" method="act_approval" ArgumentCollection=#Attributes#>
    </cfcase>
    <!---  Action: Download report --->
    <cfcase VALUE="act_downloadPDF">
        <cfinvoke component="index" method="act_downloadPDF" ArgumentCollection=#Attributes#>
    </cfcase>
    <!--- Display : Holiday Page --->
    <cfcase VALUE="dsp_holiday">
        <cfinvoke component="index" method="dsp_holiday" ArgumentCollection=#Attributes#>
    </cfcase>
    <!--- Action : Create Holiday Page --->
    <cfcase VALUE="act_createholiday">
        <cfinvoke component="index" method="act_createholiday" ArgumentCollection=#Attributes#>
    </cfcase>
    <!--- Action : Update Holiday Page --->
    <cfcase VALUE="act_updateholiday">
        <cfinvoke component="index" method="act_updateholiday" ArgumentCollection=#Attributes#>
    </cfcase>
    <!--- Action : Delete Holiday Page --->
    <cfcase VALUE="act_deleteholiday">
        <cfinvoke component="index" method="act_deleteholiday" ArgumentCollection=#Attributes#>
    </cfcase>
    <!--- Action : Create Team Page --->
    <cfcase VALUE="act_createteam">
        <cfinvoke component="index" method="act_createteam" ArgumentCollection=#Attributes#>
    </cfcase>
    <!--- Action : Update Team Page --->
    <cfcase VALUE="act_updateteam">
        <cfinvoke component="index" method="act_updateteam" ArgumentCollection=#Attributes#>
    </cfcase>
    <!--- Action : Delete Team Page --->
    <cfcase VALUE="act_deleteteam">
        <cfinvoke component="index" method="act_deleteteam" ArgumentCollection=#Attributes#>
    </cfcase>
    <!--- Display : Update Monthly Schedule Page --->
    <cfcase VALUE="dsp_updatemonthlyschedule">
        <cfinvoke component="index" method="dsp_updatemonthlyschedule" ArgumentCollection=#Attributes#>
    </cfcase>
    <!--- Action : Update Monthly Schedule --->
    <cfcase VALUE="act_updatemonthlyschedule">
        <cfinvoke component="index" method="act_updatemonthlyschedule" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfdefaultcase>
        do nothing
<!---         <cfinvoke component="auth.index" method="dsp_login" ArgumentCollection=#Attributes#>         --->
    </cfdefaultcase>
</cfswitch>