$IP1 = "1.2.3.4"
$IP2 = "5.6.7.8"

"IP1: $IP1"
"IP2: $IP2"

"$IP1" | Out-File "IPs.txt" -encoding ascii 
"$IP2" | Out-File "IPs.txt" -encoding ascii -Append 
