#$arr = ConvertFrom-Json -InputObject "[{""LaneId"":1,""TraineeInfo"":{""CheckInId"":""1"",""Name"":""T1""},""WeaponsInfo"":[{""Name"":""T1-1"",""BTrackId"":1,""WeaponId"":10,""WeaponClass"":""Firearm"",""WeaponType"":""M4"",""SightType"":""iron"",""AmmoType"":""5.56mm"",""MagazineCapacity"":30,""TracerInterval"":7,""LaneIds"":[1],""IgModelName"":"""",""Ident"":{""BTrackId"":1,""WeaponId"":10},""IsDworak"":false}]}]"
$arr = ConvertFrom-Json -InputObject '[{"LaneId":1,"TraineeInfo":{"CheckInId":"1","Name":"T1"},"WeaponsInfo":[{"Name":"T1-1","BTrackId":1,"WeaponId":10,"WeaponClass":"Firearm","WeaponType":"M4","SightType":"iron","AmmoType":"5.56mm","MagazineCapacity":30,"TracerInterval":7,"LaneIds":[1],"IgModelName":"","Ident":{"BTrackId":1,"WeaponId":10},"IsDworak":false}]}]'
foreach ($elem in $arr) {
  $index += 1;
  Write-Output "#$index $($elem.LaneId) $($elem.TraineeInfo.Name)"
}