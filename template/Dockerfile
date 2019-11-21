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
FROM oraclelinux:8-slim

ARG MYSQL_SERVER_PACKAGE=%%MYSQL_SERVER_PACKAGE%%
ARG MYSQL_ROUTER_PACKAGE=%%MYSQL_ROUTER_PACKAGE%%

RUN microdnf update && echo "[main]" > /etc/dnf/dnf.conf \
  && dnf module disable -y mysql \
  && dnf install -y \
      yum-utils \
      %%REPO%%/mysql-community-minimal-release-el7.rpm \
      %%REPO%%/mysql-community-release-el7.rpm \
  && dnf config-manager --enable mysql%%REPO_VERSION%%-server-minimal \
  && dnf config-manager --enable mysql-tools-community \
  && dnf install -y \
      $MYSQL_SERVER_PACKAGE \
      $MYSQL_ROUTER_PACKAGE \
      libpwquality \
      # password generation
      cracklib-dicts \
  && dnf clean all

COPY run.sh /run.sh
HEALTHCHECK \
	CMD mysqladmin --port 6446 --protocol TCP ping 2>&1 | grep Access || exit 1
EXPOSE 6446 6447 64460 64470
ENTRYPOINT ["/run.sh"]
CMD ["mysqlrouter"]
