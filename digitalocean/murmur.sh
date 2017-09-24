#!/bin/sh

# UPDATES
apt-get update
#apt-get -y upgrade

# PASSWORDS
apt-get install -y pwgen

SUPERUSER_PASSWORD="$(pwgen)"
SERVER_PASSWORD="$(pwgen)"
MAX_USERS=10
IFTTT_EVENT="murmur_setup"
IFTTT_KEY="your_key"
IFTTT_EMAILS="emails_to_alert" # SPACE OR COMMA SEPARATED

# MUMBLE
apt-get install -y mumble-server
apt install debconf-utils

# CONFIGURE SERVER
echo "mumble-server   mumble-server/start_daemon      boolean true" | debconf-set-selections
echo "mumble-server   mumble-server/use_capabilities  boolean true" | debconf-set-selections
echo "mumble-server   mumble-server/password password $SUPERUSER_PASSWORD" | debconf-set-selections
dpkg-reconfigure -f noninteractive mumble-server

# EDIT INI FILE
sed -i "s/^serverpassword=/serverpassword=$SERVER_PASSWORD/" /etc/mumble-server.ini
sed -i "s/^users=100/users=$MAX_USERS/" /etc/mumble-server.ini
sed -i "s/^#autoban/autoban/" /etc/mumble-server.ini # ENABLE AUTOBAN

# RESTART
service mumble-server restart

# FIREWALL
ufw allow OpenSSH
ufw allow 64738 # MUMBLE/MURMUR
ufw --force enable

# ALERT SUCCESS
PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)

curl -X POST -H "Content-Type: application/json" -d "{\"value1\":\"$IFTTT_EMAILS\",\"value2\":\"IP: $PUBLIC_IPV4 | SuperUser pass: $SUPERUSER_PASSWORD | Server pass: $SERVER_PASSWORD \"}" https://maker.ifttt.com/trigger/$IFTTT_EVENT/with/key/$IFTTT_KEY
