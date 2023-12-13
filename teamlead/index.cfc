<cfcomponent displayname="services" hint="">
    <!--- Display staff home page --->
    <cffunction name="dsp_hometl" hint="Display home page for team lead." returntype="any" output="true">
        <CFINCLUDE template="dsp_hometl.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Display team page --->
    <cffunction name="dsp_team" hint="Display team page." returntype="any" output="true">
        <CFINCLUDE template="dsp_team.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Add team action --->
    <cffunction name="act_addteam" hint="Add team action." returntype="any" output="true">
        <CFINCLUDE template="act_addteam.cfm">
        <CFRETURN>
    </cffunction>
    <!--- Remove from team action --->
    <cffunction name="act_removeteam" hint="Remove from team action." returntype="any" output="true">
        <CFINCLUDE template="act_removeteam.cfm">
        <CFRETURN>
    </cffunction>
</cfcomponent>