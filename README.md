<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
consul-install-windows

- [Vault changelog](#vault-changelog)
- [TODO follow along on this thread](#todo-follow-along-on-this-thread)
- [standalone curl windows with ssl](#standalone-curl-windows-with-ssl)
- [install](#install)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Vault changelog
===============

-   <https://github.com/hashicorp/vault/blob/master/CHANGELOG.md>

TODO follow along on this thread
================================

-   Follow up here:
    <https://www.vaultproject.io/intro/getting-started/apis.html>
-   <https://goo.gl/dX6dXx>

standalone curl windows with ssl
================================

-   <http://curl.haxx.se/download.html>
-   <http://goo.gl/KnjCfs>
-   <http://www.paehl.com/open_source/?CURL_7.45.0>
-   <http://www.paehl.com/open_source/?download=curl_745_0_ssl.zip&PHPSESSID=bddfc7e7e19a5daf19e7879f5f5f5496>

install
=======

-   install consul
    <https://github.com/TaylorMonacelli/consul-install-windows/tree/wip#install>
-   bootstrap consul
    <https://github.com/TaylorMonacelli/consul-install-windows/tree/wip#solution-re-bootstrap>
-   install vault:

<!-- -->

    powershell -noprofile -executionpolicy unrestricted -command "(new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/TaylorMonacelli/vault-install-windows/wip/nssminstall.ps1','nssminstall.ps1')"
    powershell -noprofile -executionpolicy unrestricted -file nssminstall.ps1

    powershell -noprofile -executionpolicy unrestricted -command "(new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/TaylorMonacelli/vault-install-windows/wip/vaultinstall.ps1','vaultinstall.ps1')"
    powershell -noprofile -executionpolicy unrestricted -file vaultinstall.ps1

    powershell -noprofile -executionpolicy unrestricted -command "(new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/TaylorMonacelli/vault-install-windows/wip/getcurl.ps1','getcurl.ps1')"
    powershell -noprofile -executionpolicy unrestricted -file getcurl.ps1

    REM curl.exe for testing:
    powershell -noprofile -executionpolicy unrestricted -command "(new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/TaylorMonacelli/vault-install-windows/wip/getcurl.ps1','getcurl.ps1')"
    powershell -noprofile -executionpolicy unrestricted -file getcurl.ps1

-   start vault

<!-- -->

    vault server -config=vf.hcl
    REM OR
    vault server -config=vc.hcl

<https://vaultproject.io/intro/getting-started/deploy.html>

-   open another `cmd.exe` and

<!-- -->

    set VAULT_ADDR=http://127.0.0.1:8200
    curl -v -X PUT -d "{\"secret_shares\":1, \"secret_threshold\":1}" http://localhost:8200/v1/sys/init




