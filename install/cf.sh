#!/bin/bash
GitUser="3v1ltw1n0x01"
#IZIN SCRIPT
MYIP=$(curl -sS ipv4.icanhazip.com)
# Valid Script
VALIDITY() {
     today=$(date -d "0 days" +"%Y-%m-%d")
     Exp1=$(curl https://raw.githubusercontent.com/${GitUser}/multi-access/main/access | grep $MYIP | awk '{print $4}')
     if [[ $today < $Exp1 ]]; then
          echo -e "\e[32mYOUR SCRIPT ACTIVE..\e[0m"
     else
          echo -e "\e[31mYOUR SCRIPT HAS EXPIRED!\e[0m"
          echo -e "\e[31mPlease renew your ipvps first\e[0m"
          exit 0
     fi
}
IZIN=$(curl https://raw.githubusercontent.com/${GitUser}/multi-access/main/access | awk '{print $5}' | grep $MYIP)
if [ $MYIP = $IZIN ]; then
     echo -e "\e[32mPermission Accepted...\e[0m"
     VALIDITY
else
     echo -e "\e[31mPermission Denied!\e[0m"
     echo -e "\e[31mPlease buy script first\e[0m"
     exit 0
fi
clear
apt install jq curl -y
DOMAIN=ironsnout.tech
sub=$(tr </dev/urandom -dc a-z0-9 | head -c4)
SUB_DOMAIN=${sub}.ironsnout.tech
CF_ID=lemah@gmail.com
CF_KEY=14b348d2fd20de44e30e5c02a6ede439d6af8
set -euo pipefail
IP=$(wget -qO- icanhazip.com)
echo "Updating DNS for ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
          -H "X-Auth-Email: ${CF_ID}" \
          -H "X-Auth-Key: ${CF_KEY}" \
          -H "Content-Type: application/json" \
          --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
echo "Host : $SUB_DOMAIN"
echo "IP=" >>/var/lib/premium-script/ipvps.conf
echo $SUB_DOMAIN >/root/domain
rm -f /root/cf.sh
