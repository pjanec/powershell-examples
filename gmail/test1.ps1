$email = "bagiraczech@gmail.com" 
 
$pass = "ScyrXX1+" 
 
$smtpServer = "smtp.gmail.com" 
 
 
$msg = new-object Net.Mail.MailMessage 
$smtp = new-object Net.Mail.SmtpClient($smtpServer) 
$smtp.EnableSsl = $true 
$msg.From = "$email"  
$msg.To.Add("$email") 
$msg.BodyEncoding = [system.Text.Encoding]::Unicode 
$msg.SubjectEncoding = [system.Text.Encoding]::Unicode 
$msg.IsBodyHTML = $true  
$msg.Subject = "Crash" 
$msg.Body = "<h2> Test mail from PS  #3</h2> 
</br> 
Hi there 
"  
$SMTP.Credentials = New-Object System.Net.NetworkCredential("$email", "$pass"); 
$smtp.Send($msg)
