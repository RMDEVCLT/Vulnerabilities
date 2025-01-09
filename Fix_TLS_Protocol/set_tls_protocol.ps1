function TLS-HotFix {

    # Set error handling preference
    $ErrorActionPreference = 'SilentlyContinue'
    # Get the current computer name
    $server = get-content env:computername;
    
    # Execute commands on the local machine
    Invoke-Command -ComputerName $server {
        $rootpath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"

        function Show-Protocols {
            $array = @()
            foreach ($protocol in ("TLS 1.0", "TLS 1.1", "TLS 1.2")) {
                foreach ($role in ("Client", "Server")) {
                    try {
                        $enabled = Get-ItemPropertyValue -Path $rootpath\$protocol\$role -Name Enabled
                    } catch {
                        $enabled = $null
                    }
                    try {
                        $disabledbydefault = Get-ItemPropertyValue -Path $rootpath\$protocol\$role -Name DisabledByDefault
                    } catch {
                        $disabledbydefault = $null
                    }

                    $array += @{
                        Protocol = $protocol;
                        Role = $role;
                        Enabled = if ($null -eq $enabled) {"key missing"} else {[boolean]$enabled};
                        DisabledByDefault = if ($null -eq $disabledbydefault) {"key missing"} else {[boolean]$disabledbydefault};
                    }
                }
            }
            $array | ForEach {[PSCustomObject]$_} | Format-Table -Property Protocol,Role,Enabled,DisabledByDefault -GroupBy Protocol
        }
        
        # Prompt user to turn TLS 1.0/1.1 OFF or ON
        Write-Output "Turn TLS 1.0/1.1 OFF or ON?"
        $userinput = "OFF"
        while ($userinput -ne "on" -and $userinput -ne "off") {
            $userinput = Read-Host -Prompt "Turn them"
        }
        
        # Function to set protocol values
        function Set-ProtocolValue ($protocol, $type, $enabledValue, $disabledByDefaultValue) {
            if ($null -eq (Get-Item "$rootpath\$protocol\$type" -ErrorAction SilentlyContinue)) {
                New-Item "$rootpath\$protocol\$type" -force
                New-ItemProperty -Path "$rootpath\$protocol\$type" -PropertyType "DWord" -Name "Enabled" 
                New-ItemProperty -Path "$rootpath\$protocol\$type" -PropertyType "DWord" -Name "DisabledByDefault"
            }
            Set-ItemProperty -Path "$rootpath\$protocol\$type" -Name "Enabled" -Value $enabledValue
            Set-ItemProperty -Path "$rootpath\$protocol\$type" -Name "DisabledByDefault" -Value $disabledByDefaultValue
        }

        # Configure TLS 1.0 and TLS 1.1 protocols
        foreach ($protocol in ("TLS 1.0", "TLS 1.1")) {
            foreach ($type in ("Client", "Server")) {
                Set-ProtocolValue $protocol $type $(if ($userinput -eq "on") {1} else {0}) $(if ($userinput -eq "on") {0} else {1})
            }
        }

        # Configure TLS 1.2 protocol
        foreach ($protocol in ("TLS 1.2")) {
            foreach ($type in ("Client", "Server")) {
                Set-ProtocolValue $protocol $type $(if ($userinput -eq "on") {0} else {1}) $(if ($userinput -eq "on") {1} else {0})
            }
        }

        Show-Protocols
    }
}

# Run the TLS-HotFix function
TLS-HotFix
