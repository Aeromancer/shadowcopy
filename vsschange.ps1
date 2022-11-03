$drives = vssadmin list shadowstorage 

$testText = 'Peter <peter@gmail.com>, Paul <paul@gmail.com>' 

$pattern = '(?<=\().?(?=:\))'

$reg = [regex]::Matches($drives, $pattern).Value

$start = "("
$end = ":)"

Write-host($drives)


[bool] $test = $true

if($reg.Count % 2 != 0){
    Write-host("Incorrect number of drive locations reported:" + $reg.Count + ". Must be divisible by 2")
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
    
}

$drives = vssadmin list shadowstorage 

Write-host($drives)