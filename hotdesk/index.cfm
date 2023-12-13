<!--- Switch case for fuseaction (file)--->
<cfswitch EXPRESSION=#attributes.FUSEACTION#>	
	<cfcase VALUE="dsp_home">
        <cfinvoke component="index" method="dsp_home" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="dsp_week">
        <cfinvoke component="index" method="dsp_week" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="dsp_updatehotdesk">
        <cfinvoke component="index" method="dsp_updatehotdesk" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="act_updatehotdesk">
        <cfinvoke component="index" method="act_updatehotdesk" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfdefaultcase>
        do nothing
    </cfdefaultcase>
</cfswitch>