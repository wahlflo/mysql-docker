# Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
FROM oraclelinux:7-slim

ARG KEY=https://repo.mysql.com/RPM-GPG-KEY-mysql
ARG REPO=https://repo.mysql.com

ARG MYSQL_SERVER_PACKAGE_URL=$REPO/yum/mysql-8.0-community/docker/x86_64/mysql-community-server-minimal-8.0.12-1.el7.x86_64.rpm
ARG MYSQL_ROUTER_PACKAGE_URL=$REPO/yum/mysql-tools-community/el/7/x86_64/mysql-router-8.0.12-1.el7.x86_64.rpm

RUN rpmkeys --import $KEY \
    && yum install -y \
      $MYSQL_SERVER_PACKAGE_URL \
      $MYSQL_ROUTER_PACKAGE_URL \
    && yum clean all

COPY run.sh /run.sh
HEALTHCHECK \
	CMD mysqladmin --port 6446 --protocol TCP ping 2>&1 | grep Access || exit 1
EXPOSE 6446 6447 64460 64470
ENTRYPOINT ["/run.sh"]
CMD ["mysqlrouter"]
