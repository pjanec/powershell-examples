Add-Type -AssemblyName System.Windows.Forms

$bootime = (Get-WmiObject -Class win32_operatingsystem).ConverttoDateTime((Get-WmiObject -Class win32_Operatingsystem).LastBootUpTime)

	$buttonGetUptime_Click={
		$Getdata = (Get-WmiObject -Class win32_operatingsystem).ConverttoDateTime((Get-WmiObject -Class win32_Operatingsystem).LastBootUpTime)
		$label2.Text = $Getdata
	}

$Form = New-Object system.Windows.Forms.Form
$Form.Text = 'Get-Uptime'
$Form.Width = 300
$Form.Height = 200

$label2 = New-Object system.windows.Forms.Label
$label2.AutoSize = $true
$label2.Width = 25
$label2.Height = 10
$label2.location = new-object system.drawing.size(71,89)
$label2.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($label2)

$button4 = New-Object system.windows.Forms.Button
$button4.add_Click($buttonGetUptime_Click)
$button4.Text = 'Get-Uptime'
$button4.Width = 100
$button4.Height = 30
$button4.location = new-object system.drawing.size(15,15)
$button4.Font = "Microsoft Sans Serif,10"
$button4.AutoEllipsis
$Form.controls.Add($button4)

$Form.ShowDialog()
