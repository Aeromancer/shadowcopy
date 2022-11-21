﻿$sendingEmail = 'Sender name<From email goes here>'
[string[]]$recepient = 'Recepient Email 1 <Email goes here>'#, 'Recepient Email 2 <Email2 goes here>'
$computer = $env:computername
$subject = 'VSS update on: ' + $computer
$body = ''



$drives = vssadmin list shadowstorage 

$pattern = '(?<=\().?(?=:\))'

$reg = [regex]::Matches($drives, $pattern).Value

$start = '('
$end = ':)'

Write-Host($reg)


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
        Write-host("Here")
        Write-host($reg[0]) 
        $body = $body +  "`r`n The old state was:`r`n" + $drives[6 + ($count * 7)  / 2] +  "`r`n" + $drives[7  + ($count * 7) / 2] +  "`r`n" + $drives[8 + ($count * 7) / 2] +  "`r`n"
        Write-Host($body)
        $cold = $count
        $target = $reg[$count] + ':'
        Write-Host("`r`n`r`n" + 'This is the target ' + $target  + 'This is reg 0 ' + $reg[0])   
        $storage = $reg[$count + 1] + ':'
        Write-Host('This is the storage ' + $storage)   
        $body = $body + "`r`n`r`n"+ 'Target drive is ' + $target + '\ and is being stored on ' + $storage + "\ `r`n`r`n" 


        $count++

 

        $count++

        
        vssadmin resize shadowstorage /For=$target /On=$storage /MaxSize=20%

        $newstate = vssadmin list shadowstorage
        Write-host($cold)
        Write-host("Now here" + $newstate[6 + ($cold * 8) / 2])
        $body = $body + $newstate[6 + ($cold * 7) / 2] +  "`r`n" + $newstate[7  + ($cold * 7) / 2] +  "`r`n" + $newstate[8 + ($cold * 7) / 2] +  "`r`n`r`n" + "------------------------------------------------------------" +  "`r`n"

    }

    $drives = vssadmin list shadowstorage 
    #$body = $body + "The drives have been updated with the following:  `r`n`r`n"
    #$body = $body + $drives + "`r`n"
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