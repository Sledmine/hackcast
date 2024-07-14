#!/bin/bash

DEVICE_MODEL=$1
JSON_PAYLOAD='{"version": 1, "vendor": "'$DEVICE_MODEL'", "mac_address": "authorshxj", "softap_ssid": "000000-00000000", "firmware_version": "0"}'

RESPONSE=$(curl -X POST \
  --url http://www.iezvu.com/upgrade/ota_rx.php \
  --header 'Content-Type: application/json' \
  --data "$JSON_PAYLOAD"
)

curl $(echo $RESPONSE | jq -r '.ota_fw_file') -O
