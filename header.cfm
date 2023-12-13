<cfparam name="url.fusebox" default="">
<cfparam name="url.fuseaction" default="">
<head>
    <!-- Bootstrap 4 CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>

<!--- 
RoleID:
1 - staff
2 - teamlead
3 -admin 
--->
<cfparam  name="session.vars.roleid" default="">

<cfif session.vars.roleid neq "">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <cfif session.vars.roleid eq 1>
        <a class="navbar-brand mx-auto" href="">Hot Desk System</a>
    <cfelseif session.vars.roleid eq 2>
        <a class="navbar-brand" href="#">Hot Desk System (Team Lead)</a>
    <cfelseif session.vars.roleid eq 3>
        <a class="navbar-brand" href="#">Hot Desk System (Admin)</a>
    </cfif>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav ml-auto">
            <cfoutput>
                <li class="nav-item <cfif #url.fuseaction# EQ 'dsp_home'>active</cfif>">
                    <a class="nav-link" href="index.cfm?fusebox=hotdesk&fuseaction=dsp_home&#session.urltoken#">Home
                    <span 
                        class="sr-only">(current)
                    </span>
                    </a>
                </li>
            </cfoutput>
            <cfif session.vars.roleid eq 1>
                <cfoutput>
                <li class="nav-item">
                    <a class="nav-link active" href="index.cfm?fusebox=staff&fuseaction=dsp_profile&#session.urltoken#">#session.vars.name#</a>
                </li>
                </cfoutput>
            <cfelseif session.vars.roleid eq 2>
                <cfoutput>
                    <li class="nav-item <cfif #url.fuseaction# EQ 'dsp_team'>active</cfif>">
                        <a class="nav-link"
                            href="index.cfm?fusebox=teamlead&fuseaction=dsp_team&#session.urltoken#">Team</a>
                    </li>
                    <li class="nav-item">
                            <a class="nav-link active" href="index.cfm?fusebox=staff&fuseaction=dsp_profile&#session.urltoken#">#session.vars.name#</a>
                    </li>
                </cfoutput>
            <cfelseif session.vars.roleid eq 3>
                <cfoutput>
                    <li class="nav-item <cfif #url.fuseaction# EQ 'dsp_monthlyschedule'>active</cfif>">
                        <a class="nav-link"
                            href="index.cfm?fusebox=admin&fuseaction=dsp_monthlyschedule&#session.urltoken#">Monthly Schedule</a>
                    </li>
                    <li class="nav-item <cfif #url.fuseaction# EQ 'dsp_holiday'>active</cfif>">
                        <a class="nav-link"
                            href="index.cfm?fusebox=admin&fuseaction=dsp_holiday&#session.urltoken#">Holiday</a>
                    </li>
                    <li class="nav-item <cfif #url.fuseaction# EQ 'dsp_staff'>active</cfif>">
                        <a class="nav-link"
                            href="index.cfm?fusebox=admin&fuseaction=dsp_staff&#session.urltoken#">Staff</a>
                    </li>
                </cfoutput>
            </cfif>
            <li class="nav-item">
                <a class="nav-link" href="index.cfm?fusebox=auth&fuseaction=act_logout">Logout</a>
            </li>
        </ul>
    </div>
</nav>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


<style>
    /* Custom CSS for adding space to the bottom of the navbar */
    .navbar {
        margin-bottom: 20px; /* You can adjust the margin value as needed */
    }
</style>

</cfif>
