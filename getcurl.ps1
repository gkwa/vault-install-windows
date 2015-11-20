$curl_url = 'http://www.paehl.com/open_source/?download=curl_745_0_ssl.zip&PHPSESSID=bddfc7e7e19a5daf19e7879f5f5f5496'
$curl_zip = 'curl.zip'

$cdir = (Get-Location).Path

if(!(test-path "$cdir\7za.exe"))
{
    (new-object System.Net.WebClient).DownloadFile("http://installer-bin.streambox.com/7za.exe", "7za.exe")
}
$env:path = "$pwd;$env:path"

if(!(test-path "$cdir\$curl_zip"))
{
    (new-object System.Net.WebClient).DownloadFile($curl_url, $curl_zip)
}

& 7za x -y $curl_zip | out-null

$result = new-item -ItemType Directory -Force -Path C:\ProgramData\curl
Copy-Item .\curl.exe C:\ProgramData\curl

if(!(test-path $env:windir\system32\curl.exe)){
				cmd /c mklink $env:windir\system32\curl.exe C:\ProgramData\curl\curl.exe | out-file install.org
}
