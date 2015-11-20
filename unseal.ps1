net stop vault
net start vault

curl --silent -X DELETE http://localhost:8500/v1/kv/?recurse | out-null

$out1 = vault init | Foreach {
    if ($_ -match '^Key.*: (\w+)')
    {
        $key = $matches[1]
        @"
curl -X PUT -d '{\"key\": \"$key\"}' http://127.0.0.1:8200/v1/sys/unseal
"@
    } elseif ($_ -match '^Initial Root Token: ([-\w]+)') {
        $token = $matches[1]
        @"
curl -X POST -H "X-Vault-Token:$token" -d '{\"type\":\"app-id\"}' http://127.0.0.1:8200/v1/sys/auth/app-id
"@
    }
}

$out1
$Env:VAULT_ADDR='http://127.0.0.1:8200'

<# output is similar to this:

curl -X PUT -d '{\"key\": \"2109177006b3a2aff51143ae2ff26df182a5976dd72c648bf908a461c176dc2201\"}' http://127.0.0.1:8200/v1/sys/unseal
curl -X PUT -d '{\"key\": \"676244d5f7f76933e4ccc2a4d635ea1ce2561a88be90258993107f76b893abee02\"}' http://127.0.0.1:8200/v1/sys/unseal
curl -X PUT -d '{\"key\": \"2eb75d900ae901485df68250c8d560ae48af46b6ca627e340da0fc98a6483c6e03\"}' http://127.0.0.1:8200/v1/sys/unseal
curl -X PUT -d '{\"key\": \"3487615d7a9a40452e848589a581f57d85e9cd5460b08d06f592989e66abe97d04\"}' http://127.0.0.1:8200/v1/sys/unseal
curl -X PUT -d '{\"key\": \"7d5278188784283e97bec57dbb617fcf2f10916a1442d6bb6b221b7078707efd05\"}' http://127.0.0.1:8200/v1/sys/unseal
curl -X POST -H "X-Vault-Token:472dcf42-8a9e-1413-9c80-8817667270e2" -d '{\"type\":\"app-id\"}' http://127.0.0.1:8200/v1/sys/auth/app-id

#>
