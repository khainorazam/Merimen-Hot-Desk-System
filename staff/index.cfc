<cfcomponent displayname="services" hint="">
    <!--- Display the login staff page --->
    <cffunction name="dsp_loginstaff" hint="Display the login page for staff." returntype="any" output="true">
        <CFINCLUDE template="dsp_loginstaff.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Login Staff Action --->
    <cffunction name="act_loginstaff" hint="Action for login staff." returntype="any" output="true">
        <CFINCLUDE template="act_loginstaff.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display week page --->
    <cffunction name="dsp_week" hint="Display week page for staff." returntype="any" output="true">
        <CFINCLUDE template="dsp_week.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display hot desk --->
    <cffunction name="dsp_hotdesk" hint="Display hotdesk page for staff." returntype="any" output="true">
        <CFINCLUDE template="dsp_hotdesk.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display hot desk --->
    <cffunction name="dsp_updatehotdesk" hint="Display update hotdesk page for staff." returntype="any" output="true">
        <CFINCLUDE template="dsp_updatehotdesk.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display profile page --->
    <cffunction name="dsp_profile" hint="Display profile page for staff." returntype="any" output="true">
        <CFINCLUDE template="dsp_profile.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Update default days action --->
    <cffunction name="act_updatedefaultdays" hint="Update default days for staff." returntype="any" output="true">
        <CFINCLUDE template="act_updatedefaultdays.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Update password first-time action --->
    <cffunction name="act_updatepassword" hint="Update password first-time for staff." returntype="any" output="true">
        <CFINCLUDE template="act_updatepassword.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Update profile --->
    <cffunction name="act_updateprofile" hint="Update profile first-time for staff." returntype="any" output="true">
        <CFINCLUDE template="act_updateprofile.cfm">
        <CFRETURN>
    </cffunction>
</cfcomponent>