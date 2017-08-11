#!/bin/bash

DYING=0

RED="\033[0;31m"
GREEN="\033[32m"
YELLOW="\033[33m"
NC="\033[0m" #No color

_log() {
    echo -e ${0##*/}: "${@}" 1>&2
}

_warn() {
    _log "${YELLOW}WARNING:${NC} ${@}"
}

_success() {
    _log "${GREEN}SUCCESS:${NC} ${@}"
}

_die() {
    _log "${RED}FATAL:${NC} ${@}"
    if [ "${DYING}" -eq 0 ]; then
        DYING=1
    fi
    exit 1
}

# Check if dependencies are installed
dependencies=(
    "jq"
    "curl"
)

for program in "${dependencies[@]}"; do
    command -v "${program}" >/dev/null 2>&1 || _die "${program} is not installed."
done

read content

config_path="${HOME}"/.2slack/config.json
if [ ! -f "${config_path}" ]; then
    mkdir -p $(dirname "${config_path}")
    touch "${config_path}"

cat << EOF > "${config_path}"
{
  "webhook": ""
}
EOF
fi

#Read/validate webhook url from config
webhook_url=$(cat "${config_path}" | jq --raw-output .webhook)
[[ -z "${webhook_url// }" ]] && _die "webhook url is undefined. Update the value in ${config_path}"

#Split string into array delimited by spaces
IFS=' ' read -r -a options <<< "${content}"

#Check if message is intended for a specific channel/user
if [[ "${options[0]}" == \@*  ]] || [[ "${options[0]}" == \#*  ]]; then
    channel="${options[0]}"
    message="${options[@]:1}"
else
    message="${options[@]}"
fi

payload=$(cat << EOF
{
  "channel": "${channel}",
  "username": "$(whoami)-$(hostname)",
  "text": "${message}"
}
EOF
)

curl -sS -X POST -H 'Content-type: application/json' --data "${payload}" "${webhook_url}" || _die "Failed to send message."
