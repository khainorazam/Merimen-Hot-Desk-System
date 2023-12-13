<!--- DSP: Create Staff Page--->
<!--- <cfinclude template="../admin_header.cfm"> --->
<cfinclude template="../merimenform.cfm">
<html>
<head>
    <title>Update Password Page - Hot Desk System</title>
</head>
<body>
    <div class=clsDocBody>
        <h3 align="center">Update Password (First-Time)</h3>
    </div>
    <cfoutput>
    <form action="index.cfm?fusebox=staff&fuseaction=act_updatepassword&#session.urltoken#" method="post" name="updatepasswordform">
    </cfoutput>
        <div class="container">
            <div class="table-container">
                <table  border=5 cellpadding=5 width=100%>
                    <col width=25% style=font-weight:bold;background-color:lightyellow><col width=75% style=background-color:gainsboro>
                    <tr class=header><td colspan=2>Password</td></tr>
                    <tr>
                        <td class=clsField1>Password</td>
                        <td class=clsValue1><input type=password id="password1" name="password1" onblur="DoReq(this)" CHKREQUIRED>*</td>
                    </tr>
                    <tr>
                        <td class=clsField1>Re-enter Password</td>
                        <td class=clsValue1><input type=password id="password2" name="password2" onblur="DoReq(this)" CHKREQUIRED>*</td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" value="UPDATE" onclick="checkPasswordsFirstTime()" class="clsButton">
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>


<script>
    function checkPasswordsFirstTime() {

        var password1 = document.getElementById("password1").value;
        var password2 = document.getElementById("password2").value;

        if (password1 !== password2) {
            alert("Passwords do not match. Please re-enter your password.");
        } else {
            // Passwords match, submit the form
            if (FormVerify(document.all('updatepasswordform'))) {
                document.updatepasswordform.submit();
            }
        }
    }
</script>
