$drives = vssadmin list shadowstorage 

$testText = 'Peter <peter@gmail.com>, Paul <paul@gmail.com>' 

$pattern = '(?<=\().?(?=:\))'

$reg = [regex]::Matches($drives, $pattern).Value

$start = "("
$end = ":)"

Write-host($drives)

$count = 0

if($reg.Count % 2 == 0){
    while($count -ne $reg.Count){

        $target = $reg[$count] +":" 

        $count++

        $storage = $reg[$count] +":"

        $count++

        Write-host("Target drive is " + $target + " Is being stored on " + $storage)

        vssadmin resize shadowstorage /For=$target /On=$storage /MaxSize=20%

    }
    else{
        Write-host("Incorrect number of drive locations reported:" + $reg.Count + ". Must be divisible by 2")
    }
}

$drives = vssadmin list shadowstorage 

Write-host($drives)