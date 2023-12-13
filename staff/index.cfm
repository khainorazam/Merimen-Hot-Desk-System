<!--- Switch case for fuseaction (file)--->
<cfswitch EXPRESSION=#attributes.FUSEACTION#>	
	<cfcase VALUE="dsp_loginstaff">
        <cfinvoke component="index" method="dsp_loginstaff" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="act_loginstaff">
        <cfinvoke component="index" method="act_loginstaff" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="dsp_week">
        <cfinvoke component="index" method="dsp_week" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="dsp_hotdesk">
        <cfinvoke component="index" method="dsp_hotdesk" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="dsp_updatehotdesk">
        <cfinvoke component="index" method="dsp_updatehotdesk" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="dsp_profile">
        <cfinvoke component="index" method="dsp_profile" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="act_updatedefaultdays">
        <cfinvoke component="index" method="act_updatedefaultdays" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="act_updatepassword">
        <cfinvoke component="index" method="act_updatepassword" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="act_updateprofile">
        <cfinvoke component="index" method="act_updateprofile" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfdefaultcase>
        do nothing
    </cfdefaultcase>
</cfswitch>