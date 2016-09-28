#!/bin/bash 

ip=$(hostname -I | awk '{print $2}')

get_auth=$(curl -i -X POST -H 'Content-Type: application/json-rpc' -d '{"jsonrpc": "2.0", "method": "user.login", "params": {"user": "Admin", "password": "zabbix"}, "id": 1}' http://192.168.33.27/zabbix/api_jsonrpc.php | sed -n 's/.*result":"\(.*\)",.*/\1/p')

curl -i -X POST -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\": \"2.0\", \"method\": \"host.create\", \"params\": {\"host\": \"first json created host\", \"interfaces\": [{\"type\": 1, \"main\": 1, \"useip\": 1, \"ip\": \"$ip\", \"dns\": \"\", \"port\": \"10050\"}], \"groups\": [{\"groupid\": \"2\"}], \"templates\": [{\"templateid\": \"10106\"}], \"inventory_mode\": 0, \"inventory\": {\"macaddress_a\": \"01234\", \"macaddress_b\": \"56768\"}}, \"auth\": \"$get_auth\", \"id\": 1}" http://192.168.33.27/zabbix/api_jsonrpc.php
