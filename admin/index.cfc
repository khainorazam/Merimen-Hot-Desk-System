<cfcomponent displayname="adminservices" hint="">
    <!--- Display the admin login page --->
    <cffunction name="dsp_loginadmin" hint="Display the admin login page." returntype="any" output="true">
        <CFINCLUDE template="dsp_loginadmin.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display the admin home page --->
    <cffunction name="dsp_homeadmin" hint="Display the admin home page." returntype="any" output="true">
        <CFINCLUDE template="dsp_homeadmin.cfm">
        <CFRETURN>
    </cffunction>
    <!---     Display staff page --->
    <cffunction name="dsp_staff" hint="Display  staff page." returntype="any" output="true">
        <CFINCLUDE template="user/dsp_staff.cfm">
        <CFRETURN>
    </cffunction>
    <!---     Display create staff page --->
    <cffunction name="dsp_createstaff" hint="Display create staff page." returntype="any" output="true">
        <CFINCLUDE template="user/dsp_createstaff.cfm">
        <CFRETURN>
    </cffunction>
    <!---     Create staff action --->
    <cffunction name="act_createstaff" hint="Display create staff page." returntype="any" output="true">
        <CFINCLUDE template="user/act_createstaff.cfm">
        <CFRETURN>
    </cffunction>
    <!---     Display update staff modal --->
    <cffunction name="dsp_updatestaffmodal" hint="Display create staff page." returntype="any" output="true">
        <CFINCLUDE template="user/dsp_updatestaffmodal.cfm">
        <CFRETURN>
    </cffunction>
    <!---     Update staff action --->
    <cffunction name="act_updatestaff" hint="Display create staff page." returntype="any" output="true">
        <CFINCLUDE template="user/act_updatestaff.cfm">
        <CFRETURN>
    </cffunction>
    <!---     Delete staff action --->
    <cffunction name="act_deletestaff" hint="Display create staff page." returntype="any" output="true">
        <CFINCLUDE template="user/act_deletestaff.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display week page --->
    <cffunction name="dsp_week" hint="Display create staff page." returntype="any" output="true">
        <CFINCLUDE template="hotdesk/dsp_week.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display update hot desk info (day) page --->
    <cffunction name="dsp_updateday" hint="Display update hot desk info day page." returntype="any" output="true">
        <CFINCLUDE template="hotdesk/dsp_updateday.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action: update hot desk info (day) page --->
    <cffunction name="act_updateday" hint="Action: update hot desk info day page." returntype="any" output="true">
        <CFINCLUDE template="hotdesk/act_updateday.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display : monthly schedule --->
    <cffunction name="dsp_monthlyschedule" hint="Display monthly schedule" returntype="any" output="true">
        <CFINCLUDE template="hotdesk/dsp_monthlyschedule.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display : update hot desk --->
    <cffunction name="dsp_updatehotdesk" hint="Display update hot desk page" returntype="any" output="true">
        <CFINCLUDE template="hotdesk/dsp_updatehotdesk.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action : update hot desk --->
    <cffunction name="act_updatehotdesk" hint="Update hot desk page" returntype="any" output="true">
        <CFINCLUDE template="hotdesk/act_updatehotdesk.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action : update hot seat approval --->
    <cffunction name="act_approval" hint="Approve/reject hot seat" returntype="any" output="true">
        <CFINCLUDE template="hotdesk/act_approval.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action : download report --->
    <cffunction name="act_downloadPDF" hint="Download Report" returntype="any" output="true">
        <CFINCLUDE template="hotdesk/act_downloadPDF.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display : Holiday Page --->
    <cffunction name="dsp_holiday" hint="Holiday" returntype="any" output="true">
        <CFINCLUDE template="holiday/dsp_holiday.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action : Create Holiday Page --->
    <cffunction name="act_createholiday" hint="Holiday" returntype="any" output="true">
        <CFINCLUDE template="holiday/act_createholiday.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action : Update Holiday Page --->
    <cffunction name="act_updateholiday" hint="Holiday" returntype="any" output="true">
        <CFINCLUDE template="holiday/act_updateholiday.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action : Delete Holiday Page --->
    <cffunction name="act_deleteholiday" hint="Holiday" returntype="any" output="true">
        <CFINCLUDE template="holiday/act_deleteholiday.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action : Create Team Page --->
    <cffunction name="act_createteam" hint="Team" returntype="any" output="true">
        <CFINCLUDE template="team/act_createteam.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action : Update Team Page --->
    <cffunction name="act_updateteam" hint="Team" returntype="any" output="true">
        <CFINCLUDE template="team/act_updateteam.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action : Delete Team Page --->
    <cffunction name="act_deleteteam" hint="Team" returntype="any" output="true">
        <CFINCLUDE template="team/act_deleteteam.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display : Update Monthly Schedule Page --->
    <cffunction name="dsp_updatemonthlyschedule" hint="Monthly Schedule" returntype="any" output="true">
        <CFINCLUDE template="monthlyschedule/dsp_updatemonthlyschedule.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action : Update Monthly Schedule  --->
    <cffunction name="act_updatemonthlyschedule" hint="Monthly Schedule" returntype="any" output="true">
        <CFINCLUDE template="monthlyschedule/act_updatemonthlyschedule.cfm">
        <CFRETURN>
    </cffunction>
</cfcomponent>