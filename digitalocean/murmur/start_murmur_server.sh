DIGITALOCEAN_TOKEN="${DIGITALOCEAN_TOKEN:=your_token}"
UUID="mumble-lon1-$(od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')" # https://serverfault.com/a/799198/157989

curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" -d '{"name":"'"$UUID"'","region":"lon1","size":"512mb","image":"ubuntu-16-04-x64","ssh_keys":null,"backups":false,"ipv6":false,"user_data":"'"#!/bin/bash
export MAX_USERS=${MAX_USERS:=10}
export IFTTT_EVENT=\\"${IFTTT_EVENT:=murmur_setup}\\"
export IFTTT_KEY=\\"${IFTTT_KEY:=your_ifttt_recipe_key}\\"
export IFTTT_EMAILS=\\"${IFTTT_EMAILS:=your_emails_to_alert}\\" # SPACE OR COMMA SEPARATED
bash <(curl https://raw.githubusercontent.com/harryjubb/cloudscripts/master/digitalocean/murmur/murmur_cloudinit.sh)"'","private_networking":null,"volumes": null,"tags":["mumble"]}' "https://api.digitalocean.com/v2/droplets"
