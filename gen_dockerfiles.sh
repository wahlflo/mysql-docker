#!/bin/bash
set -e

function get_full_filename() {
        FILEPATH=$1
        PACKAGE_STRING=$2
        FILENAME=$(curl -s $FILEPATH/ | grep $PACKAGE_STRING | sed -e 's/.*href=\"//i' -e 's/\".*//')
        if [ -z "$FILENAME" ]; then
            echo &< "Unable to locate package for $PACKAGE_STRING. Aborting"
            exit 1
        fi
	COUNT=$(echo $FILENAME | tr " " "\n" | wc -l)
        if [ $COUNT -gt 1 ]; then
            echo &<2 "Found multiple file names for package $PACKAGE_STRING. Aborting"
            exit 1
        fi
	echo $FILENAME
}

if [ -z "$1" ]; then
  REPO=https://repo.mysql.com
else
  REPO=$1
fi
REPO_ARG="ARG REPO=$REPO"

source VERSION

for MAJOR_VERSION in "${!MYSQL_ROUTER_VERSIONS[@]}"
do
    # update repo information
    sed -e "s#ARG REPO.*#$REPO_ARG#" template/Dockerfile > $MAJOR_VERSION/Dockerfile
    # update test template
    sed -e 's#%%MYSQL_SERVER_PACKAGE_VERSION%%#'"${MYSQL_SERVER_VERSIONS[${MAJOR_VERSION}]}"'#g' template/control.rb > tmpFile
    sed -i -e 's#%%MYSQL_ROUTER_PACKAGE_VERSION%%#'"${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]}"'#g' tmpFile
    if [ ! -d "${MAJOR_VERSION}/inspec" ]; then
      mkdir "${MAJOR_VERSION}/inspec"
    fi
    mv tmpFile "${MAJOR_VERSION}/inspec/control.rb"

    MYSQL_ROUTER_REPOPATH=yum/mysql-tools-community/el/7/x86_64
    MYSQL_ROUTER_PACKAGE_URL=\$REPO/$MYSQL_ROUTER_REPOPATH/$(get_full_filename $REPO/$MYSQL_ROUTER_REPOPATH mysql-router-${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]})
    MYSQL_ROUTER_PACKAGE_URL_ARG='ARG MYSQL_ROUTER_PACKAGE_URL='$MYSQL_ROUTER_PACKAGE_URL
    MYSQL_SERVER_REPOPATH=yum/mysql-8.0-community/docker/x86_64
    MYSQL_SERVER_PACKAGE_URL=\$REPO/$MYSQL_SERVER_REPOPATH/$(get_full_filename $REPO/$MYSQL_SERVER_REPOPATH mysql-community-server-minimal-${MYSQL_SERVER_VERSIONS[${MAJOR_VERSION}]})
    MYSQL_SERVER_PACKAGE_URL_ARG='ARG MYSQL_SERVER_PACKAGE_URL='$MYSQL_SERVER_PACKAGE_URL
    sed -e "s#ARG MYSQL_SERVER_PACKAGE_URL.*#$MYSQL_SERVER_PACKAGE_URL_ARG#" template/Dockerfile > tmpFile
    sed -i -e "s#ARG MYSQL_ROUTER_PACKAGE_URL.*#$MYSQL_ROUTER_PACKAGE_URL_ARG#" tmpFile
    mv tmpFile $MAJOR_VERSION/Dockerfile
done
