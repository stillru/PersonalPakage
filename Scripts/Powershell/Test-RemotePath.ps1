param( [string] $server,
       [string] $user,
       [string] $password,
       [string] $path ) 
    
if ($server -eq $null) {
	$server = read-host "FTP Server [localhost]"
	if ($server -eq $null) { 
		$server = "localhost" 
	}
}      
    
$results = (get-ftp -server $server -user $user -password $password -path "$($path)*")
return ($results -ne $null)
	
trap{
	write-host "Exception occurred (please find more information below), script execution was terminated."
	break
}