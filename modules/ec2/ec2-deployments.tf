resource "aws_instance" "utility_instance" {
  ami           = "ami-042e8287309f5df03"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = var.ssm_policy
  monitoring = true

  tags = {
    Name = "Utility Instance"
    Defender = "true"
  }
}

/*
resource "aws_instance" "web_instance" {
  ami           = "ami-042e8287309f5df03"
  instance_type = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id, aws_security_group.allow_http.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = var.ssm_policy
  monitoring = true

  tags = {
    Name = "Web Instance"
    Defender = "true"
  }
}
*/

resource "aws_instance" "web-server" {
  ami               = "ami-042e8287309f5df03" 
  instance_type     = "t2.micro"
  key_name = var.key_pair
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id, aws_security_group.allow_http.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = var.ssm_policy
  monitoring = true

  user_data = <<-EOF
    #!/bin/bash
    set -ex
    # install Docker runtime
    sudo apt update -y
    sudo apt install ca-certificates curl gnupg lsb-release -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker ubuntu
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
    # install Defender
    sudo apt install jq -y
    AUTH_DATA="$(printf '{ "username": "%s", "password": "%s" }' "${var.pcc_username}" "${var.pcc_password}")"
    TOKEN=$(curl -sSLk -d "$AUTH_DATA" -H 'content-type: application/json' "${var.pcc_url}/api/v1/authenticate" | jq -r ' .token ')
    DOMAIN_NAME=`echo $URL | cut -d'/' -f3 | cut -d':' -f1`
    curl -sSLk -H "authorization: Bearer $TOKEN" -X POST "${var.pcc_url}/api/v1/scripts/defender.sh" | sudo bash -s -- -c $DOMAIN_NAME -d "none" -m
    # setup environments for Log4Shell demo
    ##docker network create dirty-net
    ##docker container run -itd --rm --name vul-app-1 --network dirty-net ${var.vul_app_image}
    ##docker container run -itd --rm --name vul-app-2 --network dirty-net ${var.vul_app_image}
    ##docker container run -itd --rm --name att-svr --network dirty-net ${var.att_svr_image}
    ##docker container run -itd --rm --network dirty-net --name attacker-machine ${var.attacker_machine_name}
    # stop learning for vulnerable app container
    ##PROFILE_ID=$(curl -k -X GET -H "authorization: Bearer $TOKEN" -H 'Content-Type: application/json' "${var.pcc_url}/api/v21.08/profiles/container" | jq -r ' .[] | select(.image == "${var.vul_app_image}") | ._id ')
    ##curl -k -X POST -H "authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d '{"state": "manualActive"}' "${var.pcc_url}/api/v1/profiles/container/$PROFILE_ID/learn"
    # add collections
    ##curl -k -X POST -H "authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d '{"name":"Log4Shell demo - vul-app-1","images":["${var.vul_app_image}"],"containers":["vul-app-1"],"hosts":["*"],"namespaces":["*"],"labels":["*"],"accountIDs":["*"],"clusters":["*"]}' "${var.pcc_url}/api/v21.08/collections"
    ##curl -k -X POST -H "authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d '{"name":"Log4Shell demo - vul-app-2","images":["${var.vul_app_image}"],"containers":["vul-app-2"],"hosts":["*"],"namespaces":["*"],"labels":["*"],"accountIDs":["*"],"clusters":["*"]}' "${var.pcc_url}/api/v21.08/collections"
    # add runtime rules
    ##NEW_RULES='[{"name":"vul-app-2","previousName":"","collections":[{"name":"Log4Shell demo - vul-app-2"}],"advancedProtection":true,"processes":{"effect":"prevent","blacklist":[],"whitelist":[],"checkCryptoMiners":true,"checkLateralMovement":true,"checkParentChild":true,"checkSuidBinaries":true},"network":{"effect":"alert","blacklistIPs":[],"blacklistListeningPorts":[],"whitelistListeningPorts":[],"blacklistOutboundPorts":[],"whitelistOutboundPorts":[],"whitelistIPs":[],"skipModifiedProc":false,"detectPortScan":true,"skipRawSockets":false},"dns":{"effect":"prevent","blacklist":[],"whitelist":[]},"filesystem":{"effect":"prevent","blacklist":[],"whitelist":[],"checkNewFiles":true,"backdoorFiles":true,"skipEncryptedBinaries":false,"suspiciousELFHeaders":true},"kubernetesEnforcement":true,"cloudMetadataEnforcement":true,"wildFireAnalysis":"alert"},{"name":"vul-app-1","previousName":"","collections":[{"name":"Log4Shell demo - vul-app-1"}],"advancedProtection":true,"processes":{"effect":"alert","blacklist":[],"whitelist":[],"checkCryptoMiners":true,"checkLateralMovement":true,"checkParentChild":true,"checkSuidBinaries":true},"network":{"effect":"alert","blacklistIPs":[],"blacklistListeningPorts":[],"whitelistListeningPorts":[],"blacklistOutboundPorts":[],"whitelistOutboundPorts":[],"whitelistIPs":[],"skipModifiedProc":false,"detectPortScan":true,"skipRawSockets":false},"dns":{"effect":"alert","blacklist":[],"whitelist":[]},"filesystem":{"effect":"alert","blacklist":[],"whitelist":[],"checkNewFiles":true,"backdoorFiles":true,"skipEncryptedBinaries":false,"suspiciousELFHeaders":true},"kubernetesEnforcement":true,"cloudMetadataEnforcement":true,"wildFireAnalysis":"alert"}]'
    ##ALL_RULES=$(curl -k -X GET -H "authorization: Bearer $TOKEN" -H 'Content-Type: application/json' "${var.pcc_url}/api/v21.08/policies/runtime/container" | jq --argjson nr "$NEW_RULES" ' .rules = $nr + .rules ')
    ##curl -k -X PUT -H "authorization: Bearer $TOKEN" -H 'Content-Type: application/json' "${var.pcc_url}/api/v21.08/policies/runtime/container" -d "$ALL_RULES"
    # add WAAS rule
    ##NEW_RULES='[{"name":"vul-app-2","collections":[{"name":"Log4Shell demo - vul-app-2"}],"applicationsSpec":[{"appID":"app-0001","sessionCookieSameSite":"Lax","customBlockResponse":{},"banDurationMinutes":5,"certificate":{"encrypted":""},"tlsConfig":{"minTLSVersion":"1.2","metadata":{"notAfter":"0001-01-01T00:00:00Z","issuerName":"","subjectName":""},"HSTSConfig":{"enabled":false,"maxAgeSeconds":31536000,"includeSubdomains":false,"preload":false}},"dosConfig":{"enabled":false,"alert":{},"ban":{}},"apiSpec":{"endpoints":[{"host":"*","basePath":"*","exposedPort":0,"internalPort":8080,"tls":false,"http2":false}],"effect":"disable","fallbackEffect":"disable","skipLearning":false},"botProtectionSpec":{"userDefinedBots":[],"knownBotProtectionsSpec":{"searchEngineCrawlers":"disable","businessAnalytics":"disable","educational":"disable","news":"disable","financial":"disable","contentFeedClients":"disable","archiving":"disable","careerSearch":"disable","mediaSearch":"disable"},"unknownBotProtectionSpec":{"generic":"disable","webAutomationTools":"disable","webScrapers":"disable","apiLibraries":"disable","httpLibraries":"disable","botImpersonation":"disable","browserImpersonation":"disable","requestAnomalies":{"threshold":9,"effect":"disable"}},"sessionValidation":"disable","interstitialPage":false,"jsInjectionSpec":{"enabled":false,"timeoutEffect":"disable"},"reCAPTCHASpec":{"enabled":false,"siteKey":"","secretKey":{"encrypted":""},"type":"checkbox","allSessions":true,"successExpirationHours":24}},"networkControls":{"advancedProtectionEffect":"alert","subnets":{"enabled":false,"allowMode":true,"fallbackEffect":"alert"},"countries":{"enabled":false,"allowMode":true,"fallbackEffect":"alert"}},"body":{"inspectionSizeBytes":131072},"intelGathering":{"infoLeakageEffect":"alert","removeFingerprintsEnabled":true},"maliciousUpload":{"effect":"disable","allowedFileTypes":[],"allowedExtensions":[]},"csrfEnabled":true,"clickjackingEnabled":true,"sqli":{"effect":"alert","exceptionFields":[]},"xss":{"effect":"alert","exceptionFields":[]},"attackTools":{"effect":"alert","exceptionFields":[]},"shellshock":{"effect":"alert","exceptionFields":[]},"malformedReq":{"effect":"alert","exceptionFields":[]},"cmdi":{"effect":"alert","exceptionFields":[]},"lfi":{"effect":"alert","exceptionFields":[]},"codeInjection":{"effect":"alert","exceptionFields":[]},"remoteHostForwarding":{},"customRules":[{"_id":37,"action":"audit","effect":"prevent"},{"_id":36,"action":"audit","effect":"prevent"}]}]}]'
    ##ALL_RULES=$(curl -k -X GET -H "authorization: Bearer $TOKEN" -H 'Content-Type: application/json' "${var.pcc_url}/api/v21.08/policies/firewall/app/container" | jq --argjson nr "$NEW_RULES" ' .rules = $nr + .rules ')
    ##curl -k -X PUT -H "authorization: Bearer $TOKEN" -H 'Content-Type: application/json' "${var.pcc_url}/api/v21.08/policies/firewall/app/container" -d "$ALL_RULES"
    # enable WildFire
    ##curl -k -X PUT -H "authorization: Bearer $TOKEN" -H 'Content-Type: application/json' "${var.pcc_url}/api/v1/settings/wildfire" -d '{"region":"sg","runtimeEnabled":true,"complianceEnabled":true,"uploadEnabled":true,"graywareAsMalware":false}'
    EOF

  tags = {
    Name = "web-server"
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }
}
