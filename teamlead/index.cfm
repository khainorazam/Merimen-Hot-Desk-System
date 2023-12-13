<!--- Switch case for fuseaction (file)--->
<cfswitch EXPRESSION=#attributes.FUSEACTION#>	
    <cfcase VALUE="dsp_hometl">
        <cfinvoke component="index" method="dsp_hometl" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="dsp_team">
        <cfinvoke component="index" method="dsp_team" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="act_addteam">
        <cfinvoke component="index" method="act_addteam" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="act_removeteam">
        <cfinvoke component="index" method="act_removeteam" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfdefaultcase>
        do nothing (team lead)
    </cfdefaultcase>
</cfswitch>