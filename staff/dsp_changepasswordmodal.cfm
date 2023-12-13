<!--- Pop Up for Update Profile --->
<!-- Hidden pop-up container for Update Button -->
<div id="popup-changePassword" class="popup-container">
    <h1>Change Password</h1>
    <form action="index.cfm?fusebox=staff&fuseaction=act_updatepassword&#session.urltoken#" method="POST" name="changepasswordform">
        <table  border=3 cellpadding=3 width=100%>
            <col width=25% style=font-weight:bold;background-color:lightyellow>
            <col width=75% style=background-color:gainsboro>
            <tr>
                <td class=clsField1>Current Password</td>
                <td class=clsValue1>
                    <input type="password" id="currentpassword" name="currentpassword" onblur="DoReq(this)" CHKREQUIRED> 
                    <span class="password-toggle" onmousedown="startTogglePassword('currentpassword')" onmouseup="stopTogglePassword()">👁️‍🗨️</span>
                </td>
            </tr>
            <tr>
                <td class=clsField1>Password</td>
                <td class=clsValue1>
                    <input type="password" id="password1" name="password1" onblur="DoReq(this)" CHKREQUIRED>
                    <span class="password-toggle" onmousedown="startTogglePassword('password1')" onmouseup="stopTogglePassword()">👁️‍🗨️</span>
                </td>
            </tr>
            <tr>
                <td class=clsField1>Re-enter Password</td>
                <td class=clsValue1>
                    <input type="password" id="password2" name="password2" onblur="DoReq(this)" CHKREQUIRED>
                    <span class="password-toggle" onmousedown="startTogglePassword('password2')" onmouseup="stopTogglePassword()">👁️‍🗨️</span>
                </td>
            </tr>
        </table>

        <!-- Hidden input field for ID -->
        <cfoutput query="userInfo">
        <input type="hidden" name="update_id" value="#userInfo.iUSID#">
        </cfoutput>

        <input type="button" value="UPDATE" onclick="checkPasswords();" style="margin-top:5px;" class="clsButton">

    </form>
</div>
<div class="overlay" id="overlay" onclick="hideAllPopups()"></div>

<script>
    var toggleInterval;

        function startTogglePassword(inputId) {
            var input = document.getElementById(inputId);
            input.type = "text";
            toggleInterval = setInterval(function() {
                input.type = "text";
            }, 100);
        }

        function stopTogglePassword() {
            clearInterval(toggleInterval);
            // Change the type back to password when the user releases the mouse button
            document.getElementById('currentpassword').type = "password";
            document.getElementById('password1').type = "password";
            document.getElementById('password2').type = "password";
        }

    function checkPasswords() {
        var password1 = document.getElementById("password1").value;
        var password2 = document.getElementById("password2").value;

        if (password1 !== password2) {
            alert("Passwords do not match. Please re-enter your password.");
        } else {
            // Passwords match, submit the form
            if (FormVerify(document.all('changepasswordform'))) {
                document.changepasswordform.submit();
            }
        }
    }
</script>