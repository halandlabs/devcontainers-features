#!/bin/bash

# This test file will be executed against one of the scenarios devcontainer.json test that
# includes the 'color' feature with "greeting": "hello" option.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "cacerts file created on host" bash -c "ls /usr/local/share/ca-certificates/dev-*.crt"
check "cacerts passed to host correctly (1/2)" bash -c "cat /usr/local/share/ca-certificates/dev-*.crt | grep 'MLBNos802jtjjP659ErvM3m2gXMfi8cLUuwg5PiNdncdlQbmBexHHdhOVL16SFs='"
check "cacerts passed to host correctly (2/2)" bash -c "cat /usr/local/share/ca-certificates/dev-*.crt | grep 'joTa9EgvsdkgDp6ft+UQQP1KLk2sDRApDRv7DjikSf/8P4ldwVH+hZubsqX11HA='"
check "cacerts passed to node.js correctly (1/3)" bash -c "echo $NODE_EXTRA_CA_CERTS | grep '/usr/local/share/npm-global/devcontainers.crt'"
check "cacerts passed to node.js correctly (2/3)" bash -c "cat /usr/local/share/npm-global/devcontainers.crt | grep 'MLBNos802jtjjP659ErvM3m2gXMfi8cLUuwg5PiNdncdlQbmBexHHdhOVL16SFs='"
check "cacerts passed to node.js correctly (3/3)" bash -c "cat /usr/local/share/npm-global/devcontainers.crt | grep 'joTa9EgvsdkgDp6ft+UQQP1KLk2sDRApDRv7DjikSf/8P4ldwVH+hZubsqX11HA='"
check "cacerts passed to java correctly (1/2)" bash -c "keytool -list -cacerts -rfc | grep 'MLBNos802jtjjP659ErvM3m2gXMfi8cLUuwg5PiNdncdlQbmBexHHdhOVL16SFs='"
check "cacerts passed to java correctly (2/2)" bash -c "keytool -list -cacerts -rfc | grep 'joTa9EgvsdkgDp6ft+UQQP1KLk2sDRApDRv7DjikSf/8P4ldwVH+hZubsqX11HA='"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
