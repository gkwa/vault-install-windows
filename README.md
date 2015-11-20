<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
consul-install-windows

- [powershell -noprofile -executionpolicy unrestricted -file unseal.ps1](#powershell--noprofile--executionpolicy-unrestricted--file-unsealps1)
- [start fresh](#start-fresh)
  - [delete vault key/value store from consul using curl](#delete-vault-keyvalue-store-from-consul-using-curl)
  - [delete vault key/value store from consul using webui](#delete-vault-keyvalue-store-from-consul-using-webui)
- [Vault changelog](#vault-changelog)
- [TODO follow along on this thread](#todo-follow-along-on-this-thread)
- [standalone curl windows with ssl](#standalone-curl-windows-with-ssl)
- [install](#install)
  - [Initialize vault](#initialize-vault)
    - [oneline for repeated tests](#oneline-for-repeated-tests)
    - [manual steps](#manual-steps)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

powershell -noprofile -executionpolicy unrestricted -file unseal.ps1
====================================================================

    $Env:VAULT_ADDR='http://127.0.0.1:8200'
    powershell -noprofile -executionpolicy unrestricted -file unseal.ps1

start fresh
===========

Clear consul data using curl on consul.

delete vault key/value store from consul using curl
---------------------------------------------------

<https://www.consul.io/intro/getting-started/kv.html>

Deleting keys is simple as well, accomplished by using the DELETE verb.
We can delete a single key by specifying the full path, or we can
recursively delete all keys under a root using "?recurse":

    curl http://localhost:8500/v1/kv/?recurse
    curl -X DELETE http://localhost:8500/v1/kv/?recurse

delete vault key/value store from consul using webui
----------------------------------------------------

<http://localhost:8500/ui/#/seattle/kv/>

Vault changelog
===============

-   <https://github.com/hashicorp/vault/blob/master/CHANGELOG.md>

TODO follow along on this thread
================================

-   Follow up here:
    <https://www.vaultproject.io/intro/getting-started/apis.html>
-   <https://groups.google.com/d/msg/vault-tool/wq2qF_RBRv0/J0egNVx9AgAJ>

standalone curl windows with ssl
================================

-   <http://curl.haxx.se/download.html>
-   <http://goo.gl/KnjCfs>
-   <http://www.paehl.com/open_source/?CURL_7.45.0>
-   <http://www.paehl.com/open_source/?download=curl_745_0_ssl.zip&PHPSESSID=bddfc7e7e19a5daf19e7879f5f5f5496>

curl <http://localhost:8500/v1/kv/web?recurse> curl
<http://localhost:8500/v1/secret>

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

Initialize vault
----------------

### oneline for repeated tests

-   delete vault data from consul
-   vault initialize to consul backend
-   write out commands to unseal

Powershell

    $Env:VAULT_ADDR='http://127.0.0.1:8200'
    curl --silent -X DELETE http://localhost:8500/v1/kv/?recurse | out-null; vault init | Foreach { if ($_ -match '^Key (.): (\w+)') { "vault unseal " + $matches[2] }elseif ($_ -match '^Initial Root Token: ([-\w]+)') { "vault auth " + $matches[1] }} | clip.exe

**\*\***

&lt;\# output is similar to this:

curl -X PUT -d '{key:
2109177006b3a2aff51143ae2ff26df182a5976dd72c648bf908a461c176dc2201"}'
<http://127.0.0.1:8200/v1/sys/unseal> curl -X PUT -d '{key:
676244d5f7f76933e4ccc2a4d635ea1ce2561a88be90258993107f76b893abee02"}'
<http://127.0.0.1:8200/v1/sys/unseal> curl -X PUT -d '{key:
2eb75d900ae901485df68250c8d560ae48af46b6ca627e340da0fc98a6483c6e03"}'
<http://127.0.0.1:8200/v1/sys/unseal> curl -X PUT -d '{key:
3487615d7a9a40452e848589a581f57d85e9cd5460b08d06f592989e66abe97d04"}'
<http://127.0.0.1:8200/v1/sys/unseal> curl -X PUT -d '{key:
7d5278188784283e97bec57dbb617fcf2f10916a1442d6bb6b221b7078707efd05"}'
<http://127.0.0.1:8200/v1/sys/unseal> curl -X POST -H
"X-Vault-Token:472dcf42-8a9e-1413-9c80-8817667270e2" -d '{type:äpp-id"}'
<http://127.0.0.1:8200/v1/sys/auth/app-id>

\#&gt;

set VAULT~ADDR~=<http://127.0.0.1:8200> vault unseal
760fb1d2765e98b54b336228767dba1f759dd83ac0efc77c779c48ff8f32ebee01 vault
unseal
1af33b0b46cc169041f56d228287af787ee19f1202fa98b474aa231a4899de0402 vault
unseal
c51880161fd9a7473cb3c078fce2bb0f6afd69db8ebbd0e03e4d5321bccb62fd03 vault
unseal
8c8f0389bcdc549ada5e316fc472089d833a5491ff738bdbf6d2cff530e6dbf404 vault
unseal
5364b894e5c9e54da7189c35ba171cea9726a2587332c38fbc35bfcec4b4670d05 vault
auth a29c7fd6-2027-691a-6fa8-666347cc231f

\$Env:VAULT~ADDR~='<http://127.0.0.1:8200>' curl --silent -X DELETE
<http://localhost:8500/v1/kv/?recurse> | out-null; vault init | Foreach
{ if (\$\_ -match '^Key^ (.): (\w+)') { "vault unseal " + \$matches\[2\]
}elseif (\$\_ -match '^Initial^ Root Token: (\[-\w\]+)') { "vault auth "
+ \$matches\[1\] }} | clip.exe

### manual steps

-   check what vault data is already in consul
-   delete vault data from consul
-   initialze
-   unseal

<!-- -->

    curl http://localhost:8500/v1/kv/?recurse
    curl -X DELETE http://localhost:8500/v1/kv/?recurse
    vault init
    vault unseal <key1>
    vault unseal <key2>
    vault unseal <key3>
    vault auth <root token>
    vault write secret/hello value=world

