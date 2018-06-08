#!/bin/bash
set -ex

source VERSION

if [ -z "$1" ]; then
  REPO=https://repo.mysql.com
else
  REPO=$1
fi
MAJOR_VERSION=$2

ROUTER_REPOPATH=yum/mysql-tools-community/el/7/x86_64
SERVER_REPOPATH=yum/mysql-$MAJOR_VERSION-community/docker/x86_64

echo "mysql-router-${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]}"
ROUTER_FILENAME=$(curl -s $REPO/$ROUTER_REPOPATH/ | grep "mysql-router-${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]}" | sed -e 's/.*href=\"//i' -e 's/\".*//')
if [ -z "$ROUTER_FILENAME" ];
then
    echo "Unable to locate router package for $MYSQL_ROUTER_VERSION. Aborting"
    exit 1
fi

SERVER_FILENAME=$(curl -s $REPO/$SERVER_REPOPATH/ | grep "mysql-community-server-minimal-${MYSQL_SERVER_VERSIONS[${MAJOR_VERSION}]}" | sed -e 's/.*href=\"//i' -e 's/\".*//')
if [ -z "$SERVER_FILENAME" ];
then
    echo "Unable to locate server package for $MYSQL_SERVER_VERSION. Aborting"
    exit 1
fi

echo MYSQL_ROUTER_PACKAGE_URL=$ROUTER_REPOPATH/$ROUTER_FILENAME > PACKAGE_URLS
echo MYSQL_SERVER_PACKAGE_URL=$SERVER_REPOPATH/$SERVER_FILENAME >> PACKAGE_URLS
