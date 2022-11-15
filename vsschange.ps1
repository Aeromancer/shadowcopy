$sender = 'CPVSS <CPVSS@cpflexpack.com>'
$recepient = 'Alex Brown <abrown@cpflexpack.com>'
$computer = $env:computername
$subject = 'VSS update on: ' + $computer
$body = ''

$drives = vssadmin list shadowstorage 

$pattern = '(?<=\().?(?=:\))'

$reg = [regex]::Matches($drives, $pattern).Value

$start = "("
$end = ":)"

$body = $drives + '`r`n'


[bool] $test = $true
$errorCodes = [System.Collections.ArrayList]::New()
$errorMessages = @( 'Error Code Zero: No error detected', 
                    'Error Code One: No Shadow Volume Drives Detected'
                    'Error Code Two: Wrong number of drives detected')

if($reg.Count % 2 != 0){
    [void]$errorCodes.Add(2)
    $test = $false 
}

if($reg.Count == 0){
    [void]$errorCodes.Add(1)
    $test = $false 
}



$count = 0

if($test){
    while($count -ne $reg.Count){

        $target = $reg[$count] + ":" 

        $count++

        $storage = $reg[$count] + ":"

        $count++

        $body = $body + "Target drive is " + $target + ": and is being stored on " + $storage + ": `r`n" 

        vssadmin resize shadowstorage /For=$target /On=$storage /MaxSize=20%

    }

    $drives = vssadmin list shadowstorage 

    $body = $body + $drives + '`r`n'
} else {
    while($count -ne $errorCodes){
    $body = $body + $errorMessages[$errorCodes[$count]] + '`r`n'
    }
}









Send-MailMessage -From $sender -To $recepient -Subject $subject -Body $body -SmtpServer 'cpflexpack-com.mail.protection.outlook.com'  