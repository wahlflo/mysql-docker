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
    sed -i -e "s#ARG REPO.*#$REPO_ARG#" $MAJOR_VERSION/Dockerfile
    # update test template
    sed -i -e "s/with_version.*/with_version('${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]}')/" $MAJOR_VERSION/spec/Dockerfile_spec.rb

    ROUTER_REPOPATH=yum/mysql-tools-community/el/7/x86_64
    MYSQL_ROUTER_PACKAGE_URL=$ROUTER_REPOPATH/$(get_full_filename $REPO/$ROUTER_REPOPATH mysql-router-${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]})

    MYSQL_ROUTER_PACKAGE_URL_ARG='ARG MYSQL_ROUTER_PACKAGE_URL=$REPO/'$MYSQL_ROUTER_PACKAGE_URL
    sed -i -e "s#ARG MYSQL_ROUTER_PACKAGE_URL.*#$MYSQL_ROUTER_PACKAGE_URL_ARG#" $MAJOR_VERSION/Dockerfile

    SERVER_REPOPATH=yum/mysql-$MAJOR_VERSION-community/docker/x86_64
    MYSQL_SERVER_PACKAGE_URL=$SERVER_REPOPATH/$(get_full_filename $REPO/$SERVER_REPOPATH mysql-community-server-minimal-${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]})

    MYSQL_SERVER_PACKAGE_URL_ARG='ARG MYSQL_SERVER_PACKAGE_URL=$REPO/'$MYSQL_SERVER_PACKAGE_URL
    sed -i -e "s#ARG MYSQL_SERVER_PACKAGE_URL.*#$MYSQL_SERVER_PACKAGE_URL_ARG#" $MAJOR_VERSION/Dockerfile
done
