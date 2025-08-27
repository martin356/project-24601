#!/bin/bash

set -euo pipefail

BRIDGE="$(printf '%s' 'dmlyYnIx' | base64 -d)"
DOMAIN="$(printf '%s' 'fmRldi50aGVwcm9qZWN0' | base64 -d)"
GATEWAY_IP="$(printf '%s' 'MTkyLjE2OC4xMzAuMQ==' | base64 -d)"

echo "Bridge $BRIDGE"
echo "Domain $DOMAIN"
echo "Gateway IP $GATEWAY_IP"

echo "Update via resolvectl requires sudo"
sudo resolvectl dns $BRIDGE $GATEWAY_IP
sudo resolvectl domain $BRIDGE $DOMAIN
sudo resolvectl default-route $BRIDGE false
resolvectl status $BRIDGE
