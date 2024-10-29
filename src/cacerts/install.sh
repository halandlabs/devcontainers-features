#!/bin/sh

set -e

echo 'Activating feature "cacerts"'

echo "The effective dev container remoteUser is '$_REMOTE_USER'"
echo "The effective dev container remoteUser's home directory is '$_REMOTE_USER_HOME'"

echo "The effective dev container containerUser is '$_CONTAINER_USER'"
echo "The effective dev container containerUser's home directory is '$_CONTAINER_USER_HOME'"

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

. /etc/os-release

if [ "${ID}" = "debian" ] || [ "${ID_LIKE}" = "debian" ]; then
    ADJUSTED_ID="debian"
else
    echo "Linux distro ${ID} not supported."
    exit 1
fi

if [ -z "${BASE64_ENCODED_CACERTS_STR}" ]; then
    echo 'No cacerts provided for option "base64_encoded_cacerts"'
    exit 0
fi

echo "The provided base64 encoded cacerts string is: ${BASE64_ENCODED_CACERTS_STR}"

apt-get update
apt-get install --assume-yes ca-certificates

# host
BASE64_ENCODED_CACERTS=$(echo $BASE64_ENCODED_CACERTS_STR | tr ";" "\n")

for BASE64_ENCODED_CACERT in $BASE64_ENCODED_CACERTS
do
    echo "${BASE64_ENCODED_CACERT}" | base64 --decode | tee "/usr/local/share/ca-certificates/dev-$(cat /proc/sys/kernel/random/uuid).crt"
done

update-ca-certificates

# node.js
if command -v node 2>&1 >/dev/null
then
    [ -d /usr/local/share/npm-global/ ] || mkdir /usr/local/share/npm-global/
    cat /usr/local/share/ca-certificates/dev-*.crt | tee /usr/local/share/npm-global/devcontainers.crt
    echo 'export NODE_EXTRA_CA_CERTS=/usr/local/share/npm-global/devcontainers.crt' | tee /etc/profile.d/node_extra_ca_certs.sh
fi

# java
if command -v keytool 2>&1 >/dev/null
then
    for CACERT in /usr/local/share/ca-certificates/dev-*.crt
    do
        BASENAME=$(basename -- $CACERT)
        if keytool -list -cacerts -rfc | grep "Alias name: ${BASENAME}" 2>&1 >/dev/null
        then
            echo "Certificate already added to cacerts with alias '${BASENAME}'"
        else
            keytool -importcert -cacerts -noprompt -alias "${BASENAME}" -file "${CACERT}"
        fi
    done
fi
