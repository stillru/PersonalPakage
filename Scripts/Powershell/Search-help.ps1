#############################################################################
#
# Search-Help.ps1
#
# Search for PowerShell help documentation for a given keyword or reg-exp
#
# Example:
#  Search-help hashtable
#  Search-help "(datetime|ticks)"
#############################################################################

param($pattern = $(throw "Please enter content to search for"))

$helpNames = $(Get-Help * | Where-Object { $_.category -ne "Alias" })

foreach ($helpTopic in $helpNames)
{
        $content = Get-Help -Full $helpTopic.Name | Out-String
        if($content -match $pattern)
        {
                $helpTopic | Select-Object Name,Synopsis
        }
}
