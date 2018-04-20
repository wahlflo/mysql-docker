#!/bin/bash

source 8.0/VERSION

REPO_ARG="ARG REPO=https://repo.mysql.com"
MYSQL_SERVER_PACKAGE_URL_ARG="ARG MYSQL_SERVER_PACKAGE_URL=\$REPO/yum/mysql-8.0-community/docker/x86_64/mysql-community-server-minimal-$MYSQL_SERVER_RPM_VERSION.el7.x86_64.rpm"
MYSQL_ROUTER_PACKAGE_URL_ARG="ARG MYSQL_ROUTER_PACKAGE_URL=\$REPO/yum/mysql-tools-community/el/7/x86_64/mysql-router-$MYSQL_ROUTER_RPM_VERSION.el7.x86_64.rpm"

sed -i -e "s#ARG REPO.*#$REPO_ARG#" 8.0/Dockerfile

sed -i -e "s#ARG MYSQL_SERVER_PACKAGE_URL.*#$MYSQL_SERVER_PACKAGE_URL_ARG#" 8.0/Dockerfile
sed -i -e "s#ARG MYSQL_ROUTER_PACKAGE_URL.*#$MYSQL_ROUTER_PACKAGE_URL_ARG#" 8.0/Dockerfile
sed -i -e "s/with_version.*/with_version('$MYSQL_ROUTER_PACKAGE_VERSION')/" 8.0/spec/Dockerfile_spec.rb
