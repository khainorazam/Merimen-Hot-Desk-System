<cfcomponent displayname="services" hint="">
    <!--- Display the home page --->
    <cffunction name="dsp_home" hint="Display the home page." returntype="any" output="true">
        <CFINCLUDE template="dsp_home.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display the week page --->
    <cffunction name="dsp_week" hint="Display the week page." returntype="any" output="true">
        <CFINCLUDE template="dsp_week.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display the update hotdesk page --->
    <cffunction name="dsp_updatehotdesk" hint="Display the update hot desk page." returntype="any" output="true">
        <CFINCLUDE template="dsp_updatehotdesk.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Action: update the week page --->
    <cffunction name="act_updatehotdesk" hint="update hot desk page." returntype="any" output="true">
        <CFINCLUDE template="act_updatehotdesk.cfm">
        <CFRETURN>
    </cffunction>
</cfcomponent>