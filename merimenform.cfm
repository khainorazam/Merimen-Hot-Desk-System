<style>
    .code {color:blue; font-family: 'courier sans ms'}
    .quest { color:red;}
    /* Custom CSS for centering the table container */
    .table-container {
        text-align: center; /* Center the content horizontally */
        margin: 0 auto; /* Center the container horizontally */
    }
</style>

<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="JQUERY">
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCMAIN">
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCAL">
<CFMODULE TEMPLATE="#request.apppath#services/CustomTags/SVCaddfile.cfm" FNAME="SVCCSS">
<script>
    AddOnloadCode("MrmPreprocessForm()");
</script>

