<!--- query: get list of dates that needs approval --->
<cfquery name="getApprovalList" datasource="intro">
    SELECT a.dtDATE, b.vaNAME, b.iUSID
    FROM HD_DATA a
    JOIN USR_DATA b ON a.iUSID = b.iUSID
    WHERE (a.dtDATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(startDate, "yyyy-mm-dd")#"/> 
    AND a.dtDATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(endDate, "yyyy-mm-dd")#"/>)
    AND a.iREQAPPROVAL = 1
</cfquery>

<cfset approvListCount = 0>
<div class="container text-center" style="margin-top:50px;">
    <h2><b>Approval List</b></h2>
</div>
<div class="container" style="max-width: 35%; margin: 0 auto;">
    <div class="table-container">
        <table class="table table-bordered table-striped">
            <thead class="thead-dark">
                <tr>
                    <th>No.</th>
                    <th>Name</th>
                    <th>Date</th>
                    <th>Day</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <cfif getApprovalList.RecordCount>
                    <cfloop query="getApprovalList">
                        <tr> 
                            <cfoutput>
                            <td>#approvListCount + 1#</td>
                            <td>#getApprovalList.vaNAME#</td>
                            <td>#DateFormat(getApprovalList.dtDATE, "dd/mm/yyyy")#</td>
                            <td>#DateFormat(getApprovalList.dtDATE, "dddd")#</td>
                            <td>
                                <button class="btn btn-primary action-btn" onclick="updateApprovalList('#getApprovalList.dtDATE#', #getApprovalList.iUSID#, 1)">Approve</button>
                                <button class="btn btn-danger action-btn" onclick="updateApprovalList('#getApprovalList.dtDATE#', #getApprovalList.iUSID#, 2)">Reject</button>
                            </td>
                            </cfoutput>
                        </tr>
                    </cfloop>
                <cfelse>
                    <tr>
                       <td colspan=5 class="text-center">NONE</td> 
                    </tr>
                </cfif>
            </tbody>
        </table>
    </div>
</div>

<script>
    function updateApprovalList(date, id, status) {
        console.log("updateApprovalList");
        <cfoutput>
        window.location.href = "index.cfm?fusebox=admin&fuseaction=act_approval&date=" + date + "&id=" + id + "&status=" + status + "&#session.urltoken#" ;
        </cfoutput>
    }
</script>