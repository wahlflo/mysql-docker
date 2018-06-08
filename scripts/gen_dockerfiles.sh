#!/bin/bash
set -e

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

    # update package urls
    scripts/gen_package_urls.sh $REPO $MAJOR_VERSION
    source PACKAGE_URLS
    rm -f PACKAGE_URLS
    MYSQL_ROUTER_PACKAGE_URL_ARG='ARG MYSQL_ROUTER_PACKAGE_URL=$REPO/'$MYSQL_ROUTER_PACKAGE_URL
    MYSQL_SERVER_PACKAGE_URL_ARG='ARG MYSQL_SERVER_PACKAGE_URL=$REPO/'$MYSQL_SERVER_PACKAGE_URL
    sed -i -e "s#ARG MYSQL_SERVER_PACKAGE_URL.*#$MYSQL_SERVER_PACKAGE_URL_ARG#" $MAJOR_VERSION/Dockerfile
    sed -i -e "s#ARG MYSQL_ROUTER_PACKAGE_URL.*#$MYSQL_ROUTER_PACKAGE_URL_ARG#" $MAJOR_VERSION/Dockerfile
done
