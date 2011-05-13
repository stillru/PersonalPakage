function Get-MD5([string]$Content)
{
	$cryptoServiceProvider = [System.Security.Cryptography.MD5CryptoServiceProvider];
	$hashAlgorithm = new-object $cryptoServiceProvider
	$bytes = [System.Text.Encoding]::Default.GetBytes($Content)
	$hashByteArray = $hashAlgorithm.ComputeHash($bytes);
	$formattedHash = [string]::join(" ",($hashByteArray | foreach {$_.tostring("X2")}))
	return $formattedHash;
}