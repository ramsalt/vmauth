#!/usr/bin/env sh
set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

mkdir -p /etc/vmauth
gotpl "/etc/gotpl/config.yml.tmpl" > /etc/vmauth/config.yml

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec /vmauth-prod -auth.config=/etc/vmauth/config.yml "${@}"
fi
