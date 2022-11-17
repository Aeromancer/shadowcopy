$sendingEmail = 'CPVSS <CPVSS@cpflexpack.com>'
[string[]]$recepient = 'Alex Brown <abrown@cpflexpack.com>'#, 'Layne Paules <lpaules@cpflexpack.com>'
$computer = $env:computername
$subject = 'VSS update on: ' + $computer
$body = ''



$drives = vssadmin list shadowstorage 

$pattern = '(?<=\().?(?=:\))'

$reg = [regex]::Matches($drives, $pattern).Value

$start = '('
$end = ':)'




[bool] $test = $true
$errorCodes = [System.Collections.ArrayList]::New()
$errorMessages = @( 'Error Code Zero: No error detected', 
                    'Error Code One: No Shadow Volume Drives Detected'
                    'Error Code Two: Wrong number of drives detected')

if($reg.Count % 2 -ne 0){
    [void]$errorCodes.Add(2)
    $test = $false 
}

if($reg.Count -eq 0){
    [void]$errorCodes.Add(1)
    $test = $false 
}



$count = 0

if($test){
    while($count -ne $reg.Count){

        $body = $body + $drives[6 + ($count * 8)] +  "`r`n" + $drives[7  + ($count * 8)] +  "`r`n" + $drives[8 + ($count * 8)] +  "`r`n"
        $count = $cold
        $target = $reg[$count] + ':' 

        $count++

        $storage = $reg[$count] + ':'

        $count++

        $body = $body + 'Target drive is ' + $target + '\ and is being stored on ' + $storage + "\ `r`n`r`n" 
        
        vssadmin resize shadowstorage /For=$target /On=$storage /MaxSize=20%

        $newstate = vssadmin list shadowstorage

        $body = $body + $newstate[6 + ($cold * 8)] +  "`r`n" + $newstate[7  + ($cold * 8)] +  "`r`n" + $newstate[8 + ($cold * 8)] +  "`r`n"

    }

    $drives = vssadmin list shadowstorage 
    $body = $body + "The drives have been updated with the following:  `r`n`r`n"
    $body = $body + $drives + "`r`n"
} else {
    while($count -lt $errorCodes.length){
    $body = $body + $errorMessages[$errorCodes[$count]] + "`r`n"
    Write-Host($count)
    Write-Host($errorCodes)
    
    Write-host($errorMessages[$errorCodes[$count]]) 
    $count++
    }
}









Send-MailMessage -From $sendingEmail -To $recepient -Subject $subject -Body $body -SmtpServer 'cpflexpack-com.mail.protection.outlook.com'  