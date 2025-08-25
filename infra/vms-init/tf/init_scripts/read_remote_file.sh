#!/bin/bash

set -euo pipefail

# Reads JSON on stdin
# {
#   "host": "10.0.0.10",
#   "user": "ubuntu",
#   "identity_file": "/path/to/id_rsa",
#   "path": "/etc/rancher/k3s/k3s.yaml",
#   "port": "22"  # optional
# }

QUERY_JSON="$(cat)"

host=$(jq -r '.host' <<<"$QUERY_JSON")
user=$(jq -r '.user' <<<"$QUERY_JSON")
identity_file=$(jq -r '.identity_file' <<<"$QUERY_JSON")
remote_path=$(jq -r '.path' <<<"$QUERY_JSON")
port=$(jq -r '.port // "22"' <<<"$QUERY_JSON")

ssh_cmd=(ssh -i "$identity_file" -p "$port" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${user}@${host}")
remote_cmd=(sudo bash -lc "base64 -w0 < \"$remote_path\"")

if ! content=$("${ssh_cmd[@]}" "${remote_cmd[@]}"); then
  echo "{\"error\":\"failed to read $remote_path over ssh\"}" >&2
  exit 1
fi

jq -n --arg content "$content" '{content:$content}'
