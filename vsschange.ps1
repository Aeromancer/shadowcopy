$drives = vssadmin list shadowstorage 

$testText = 'Peter <peter@gmail.com>, Paul <paul@gmail.com>' 

$pattern = '(?<=\().?(?=:\))'

$reg = [regex]::Matches($drives, $pattern).Value

$start = "("
$end = ":)"

Write-host($reg)

$count = 0

while($count -ne $reg.Count){
    
    $target = $reg[$count] +":" 

    $count++

    $storage = $reg[$count] +":"

    $count++

    vssadmin resize shadowstorage /For=$target /On=$storage /MaxSize=20%

}