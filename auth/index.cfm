<!--- Switch case for fuseaction (file)--->
<cfswitch EXPRESSION=#attributes.FUSEACTION#>	
	<cfcase VALUE="act_loginstaff">
        <cfinvoke component="index" method="act_loginstaff" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="act_login">
        <cfinvoke component="index" method="act_login" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfcase VALUE="act_logout">
        <cfinvoke component="index" method="act_logout" ArgumentCollection=#Attributes#>
    </cfcase>
    <cfdefaultcase>
        <cfinvoke component="auth.index" method="dsp_login" ArgumentCollection=#Attributes#>        
    </cfdefaultcase>
</cfswitch>