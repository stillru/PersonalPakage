# SSH Agent Functions
# Mark Embling (http://www.markembling.info/)
#
# How to use:
# - Place this file into %USERPROFILE%\Documents\WindowsPowershell (or location of choice)
# - Import into your profile.ps1:
#   e.g. ". (Resolve-Path ~/Documents/WindowsPowershell/ssh-agent-utils.ps1)" [without quotes]
# - Enjoy
#
# Note: ensure you have ssh and ssh-agent available on your path, from Git's Unix tools or Cygwin.

# Retrieve the current SSH agent PId (or zero). Can be used to determine if there
# is an agent already starting.
function Get-SshAgent() {
    $agentPid = [Environment]::GetEnvironmentVariable("SSH_AGENT_PID",  "User")
    if ([int]$agentPid -eq 0) {
        $agentPid = [Environment]::GetEnvironmentVariable("SSH_AGENT_PID", "Process")
    }
    
    if ([int]$agentPid -eq 0) {
        0
    } else {
        # Make sure the process is actually running
        $process = Get-Process -Id $agentPid -ErrorAction SilentlyContinue
		
        if(($process -eq $null) -or ($process.ProcessName -ne "ssh-agent")) {
            # It is not running (this is an error). Remove env vars and return 0 for no agent.
            [Environment]::SetEnvironmentVariable("SSH_AGENT_PID", $null, "Process")
            [Environment]::SetEnvironmentVariable("SSH_AGENT_PID", $null, "User")
            [Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", $null, "Process")
            [Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", $null, "User")
            0
        } else {
            # It is running. Return the PID.
            $agentPid
        }
    }
}

# Start the SSH agent.
function Start-SshAgent() {
    # Start the agent and gather its feedback info
    [string]$output = ssh-agent
    
    $lines = $output.Split(";")
    $agentPid = 0
    
    foreach ($line in $lines) {
        if (([string]$line).Trim() -match "(.+)=(.*)") {
            # Set environment variables for user and current process.            
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "User")
            
            if ($matches[1] -eq "SSH_AGENT_PID") {
                $agentPid = $matches[2]
            }
        }
	}
    
    # Show the agent's PID as expected.
    Write-Host "SSH agent PID:", $agentPid
}

# Stop a running SSH agent
function Stop-SshAgent() {
    [int]$agentPid = Get-SshAgent
    if ([int]$agentPid -gt 0) {
        # Stop agent process
        $proc = Get-Process -Id $agentPid
        if ($proc -ne $null) {
            Stop-Process $agentPid
        }
        
        # Remove all enviroment variables
        [Environment]::SetEnvironmentVariable("SSH_AGENT_PID", $null, "Process")
        [Environment]::SetEnvironmentVariable("SSH_AGENT_PID", $null, "User")
        [Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", $null, "Process")
        [Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", $null, "User")
    }
}

# Add a key to the SSH agent
function Add-SshKey() {
    if ($args.Count -eq 0) {
        # Add the default key (~/id_rsa)
        ssh-add
    } else {
        foreach ($value in $args) {
            ssh-add $value
        }
    }
}

# Start the agent if not already running; provide feedback
$agent = Get-SshAgent
if ($agent -eq 0) {
	Write-Host "Starting SSH agent..."
	Start-SshAgent		# Start agent
	Add-SshKey			# Add my default key
} else {
	Write-Host "SSH agent is running (PID $agent)"
}
# SIG # Begin signature block
# MIIENQYJKoZIhvcNAQcCoIIEJjCCBCICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZ0h5AATHtLc42MMhfNeLh8eR
# M2qgggI/MIICOzCCAaigAwIBAgIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xMTA5MDYwOTE2MjdaFw0zOTEyMzEyMzU5NTlaMBwxGjAYBgNVBAMTEVN0ZXZl
# IElsbGljaGV2c2t5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCP2GX9CepT
# TosFGyayZCiwGku0xeC+phBn0IJs/VT6AE3psG86Adk8m2eF5udNeXAC4LiCkcvB
# wvzgX0sWeT5TFaY4/GEu7h3MlOzpH8RJxl/tanffPoISepI/SETnhGkSm1tff3iN
# ajMv5jIaD5SJAKGXtBaUPMEEHsgubVKf/QIDAQABo3YwdDATBgNVHSUEDDAKBggr
# BgEFBQcDAzBdBgNVHQEEVjBUgBCYGrfsOOE7vOZlQROePY+IoS4wLDEqMCgGA1UE
# AxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290ghADONQyDz8llUyc
# bN6PIkcUMAkGBSsOAwIdBQADgYEAgy71zdWvr5JJLqPyWQLahrEYPxiyALa3Tkzu
# m6N1Mp9hawya6ZQlWOug+VdPJrQ/TFLpVzpvSl3RjMvAeHYVxC1ZwMS9VdbxqHcE
# Pt6/2ge9Kg1/o6SE83m8YnIKfNZbhxbawS4qASPzOBWjUXcWgzr94tngYBt2XxS4
# LTNXNIIxggFgMIIBXAIBATBAMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwg
# Q2VydGlmaWNhdGUgUm9vdAIQF8TVzVFpdJBDr0IsOg3x8zAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQU8Fkzmody6mvuRUYAzjWCtUUquUswDQYJKoZIhvcNAQEBBQAEgYBcgTBBMUDA
# so1diX7XL7kQxs5AkQa3ilUvjs7JBFalzSPlf9F8sEs7YONziigiJiOEUzc9He6y
# QRWGQ1K9v0az7FQ3wBmOQgqe76LWitKiEohD2BeDXBYWn/Bd7Lg09EJLIpR5KE4v
# 71K6DNj5Wp1ZrpFy9rPot5QZhQKvHlEttw==
# SIG # End signature block
