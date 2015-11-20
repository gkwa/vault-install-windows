set-psdebug -Strict -Trace 2

function open_firewall()
{
    # firewall
    netsh advfirewall firewall delete rule name="Consul HashiCorp UDP" protocol=UDP localport="8300,8301,8302,8400,8500,8600" | out-null
    netsh advfirewall firewall delete rule name="Consul HashiCorp TCP" protocol=TCP localport="8300,8301,8302,8400,8500,8600" | out-null

    # allow binary
    ##############################
    netsh advfirewall firewall delete rule name="Vault HashiCorp App" program="C:\ProgramData\vault\vault.exe" | out-null
    netsh advfirewall firewall add rule name="Vault HashiCorp App" dir=in action=allow program="C:\ProgramData\vault\vault.exe" enable=yes | out-null
}


function main()
{
    $vault_url = 'https://releases.hashicorp.com/vault/0.3.1/vault_0.3.1_windows_386.zip'
    $vault_config1_url='https://raw.githubusercontent.com/TaylorMonacelli/vault-install-windows/wip/vf.hcl'
    $vault_config2_url='https://raw.githubusercontent.com/TaylorMonacelli/vault-install-windows/wip/vc.hcl'

    $vault_version = $vault_url -replace '\D+/([\d\.]+)/.*','$1'
    $vault_zip = $vault_url -replace '.*/(.*?.zip)$','$1'

    # Check if there is an update
    $webclient = New-Object System.Net.WebClient
    $url = 'https://raw.githubusercontent.com/hashicorp/vault/master/version/version.go'
    $s = $webclient.DownloadString($url)
    $new_vault_version = $s | select-string -casesensitive 'const Version =.*?\"([\d\.]+)\"' -allmatches |
      foreach-object {$_.matches} | foreach-object {$_.groups[1].value} | Select-Object -Unique
    if([version]$new_vault_version -gt [version]$vault_version)
    {
        Write-Host "Vault v$new_vault_version is available.  You're using v$vault_version"
    }

    $env:path = "$pwd;$env:path"
    $odir = (Get-Location).Path
    $cdir = (Get-Location).Path


    if(!(test-path "$cdir\$vault_zip"))
    {
        (new-object System.Net.WebClient).DownloadFile($vault_url, $vault_zip)
    }

    (new-object System.Net.WebClient).DownloadFile($vault_config1_url, 'vf.hcl')
    (new-object System.Net.WebClient).DownloadFile($vault_config2_url, 'vc.hcl')



    if(!(test-path "$cdir\7za.exe"))
    {
        (new-object System.Net.WebClient).DownloadFile("http://installer-bin.streambox.com/7za.exe", "7za.exe")
    }
    $env:path = "$pwd;$env:path"

    & 7za x -y $vault_zip | out-null





    $services = @(Get-Service Vault -ErrorAction SilentlyContinue)
    foreach ($service in $services)
    {
        if ($service.Status -eq 'Running')
        {
            $service | Stop-Service
        }
        nssm remove Vault confirm | out-file install.log
    }

    $vault = Get-Process Vault -ErrorAction SilentlyContinue
    if ($vault)
    {
        $vault | Stop-Process -Force | out-null
    }
    Remove-Variable vault





#    Remove-Item -Recurse -ErrorAction SilentlyContinue -Force C:\ProgramData\vault\data



    $result = new-item -ItemType Directory -Force -Path C:\ProgramData\vault



    set-location C:\ProgramData\vault

    Get-Process | Where-Object {$_.Path -like "C:\ProgramData\vault\nssm.exe"} | Stop-Process
    Copy-Item "$odir\nssm.exe" C:\ProgramData\vault
    Copy-Item "$odir\vault.exe" C:\ProgramData\vault
    Copy-Item "$odir\vf.hcl" C:\ProgramData\vault
    Copy-Item "$odir\vc.hcl" C:\ProgramData\vault

    # $ws = New-Object -comObject WScript.Shell
    # $Dt = $ws.SpecialFolders.item("Desktop")
    # $URL = $ws.CreateShortcut($Dt + "\Vault.url")
    # $URL.TargetPath = "http://localhost:8500/ui"
    # $URL.Save()

    set-location C:\ProgramData\vault

    # Ensure that the nssm.exe we're calling is the one from
    # C:\ProgramData\vault
    $env:path = "C:\ProgramData\vault;$env:path"

    nssm install Vault C:\ProgramData\vault\vault.exe confirm | out-file install.log
    nssm set Vault AppDirectory C:\ProgramData\vault | out-file install.log
    nssm set Vault AppParameters server -config=C:\ProgramData\vault\vc.hcl | out-file install.log
    nssm set Vault DisplayName Vault | out-file install.log
    nssm set Vault Description Vault from HashiCorp | out-file install.log
    nssm set Vault Start SERVICE_AUTO_START | out-file install.log
    # open_firewall


    if(test-path "$env:windir\system32\vault.exe")
    {
        remove-item $env:windir\system32\vault.exe -Force
    }

    cmd /c mklink $env:windir\system32\vault.exe C:\ProgramData\vault\vault.exe | out-file install.org

    # nssm start Vault | out-file install.log

}

main
