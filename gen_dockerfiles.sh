#!/bin/bash
set -e

source ./VERSION

REPO=https://repo.mysql.com; [ -n "$1" ] && REPO=$1

for MAJOR_VERSION in "${!MYSQL_ROUTER_VERSIONS[@]}"; do
    sed 's#%%MYSQL_SERVER_PACKAGE%%#'"mysql-community-server-minimal-${MYSQL_SERVER_VERSIONS[${MAJOR_VERSION}]}"'#g' template/Dockerfile > tmpFile
    sed -i 's#%%MYSQL_ROUTER_PACKAGE%%#'"mysql-router-community-${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]}"'#g' tmpFile
    sed -i 's#%%REPO%%#'"${REPO}"'#g' tmpFile
    REPO_VERSION=${MAJOR_VERSION//\./}
    sed -i 's#%%REPO_VERSION%%#'"${REPO_VERSION}"'#g' tmpFile
    mv tmpFile $MAJOR_VERSION/Dockerfile

    # update test template
    sed -e 's#%%MYSQL_SERVER_PACKAGE_VERSION%%#'"${MYSQL_SERVER_VERSIONS[${MAJOR_VERSION}]}"'#g' template/control.rb > tmpFile
    sed -i -e 's#%%MYSQL_ROUTER_PACKAGE_VERSION%%#'"${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]}"'#g' tmpFile
    if [ ! -d "${MAJOR_VERSION}/inspec" ]; then
      mkdir "${MAJOR_VERSION}/inspec"
    fi
    mv tmpFile "${MAJOR_VERSION}/inspec/control.rb"
done
