$drives = vssadmin list shadowstorage 

$pattern = '(?<=\().?(?=:\))'

$reg = [regex]::Matches($drives, $pattern).Value

$start = "("
$end = ":)"

Write-host($drives)


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

        Write-host("Target drive is " + $target + ": and is being stored on " + $storage + ": ")

        vssadmin resize shadowstorage /For=$target /On=$storage /MaxSize=20%

    }

    $drives = vssadmin list shadowstorage 

    Write-host($drives)
} else {
    while($count -ne $errorCodes){
    Write-host($errorMessages[$errorCodes[$count]])
    }
}

