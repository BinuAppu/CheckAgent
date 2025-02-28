# check Service status across ad server
Clear-Host
Write-Host " ========================================= " -ForegroundColor Gray
Write-Host " Script to check the Agent Running Status " -ForegroundColor DarkGreen
Write-Host " ========================================= " -ForegroundColor Gray
# tzautoupdate, EventSystem, Dnscache, AppVClient
Import-Module activedirectory
$alldomain = Get-ADDomainController -Filter * | Select-Object -ExpandProperty Name
# $alldomain = "192.168.1.120"
$agent = Read-Host "Enter the Agent names in CSV format [agent1, agent2] "
$agent1 = $agent.Split(",")
$agents = $agent1.Trim()
foreach($eachDomain in $alldomain){
    Write-Host "Checking for $eachDomain >>>>> " -ForegroundColor Yellow
    foreach($eachAgent in $agents){    
        $status = (Get-CimInstance -Class Win32_Service -Filter "Name = '$eachAgent'" -server $eachDomain | Select-Object state).state
        # Write-Host "Each Agent - $status"
        if($status -eq "Running"){
            Write-Host "     - $eachAgent - Running " -ForegroundColor Green
        }
        else{
            Write-Host "     - $eachAgent - STOPPED " -ForegroundColor Red
        }
        $eachAgent = $null
        $status = $null
    }
    Write-Host " --------------------------------- " -ForegroundColor White
    Write-Host " "
}