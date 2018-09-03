![logo](https://www.mysql.com/common/logos/logo-mysql-170x115.png)

# What is MySQL Router?

MySQL Router is part of InnoDB cluster, and is lightweight middleware that
provides transparent routing between your application and back-end MySQL
Servers. It can be used for a wide variety of use cases, such as providing high
availability and scalability by effectively routing database traffic to
appropriate back-end MySQL Servers. The pluggable architecture also enables
developers to extend MySQL Router for custom use cases.

# Supported Tags and Respective Dockerfile Links

* MySQL Router 8.0, Release Candidate (tag: [`latest`, `8.0`, `8.0.4-rc`](https://github.com/mysql/mysql-docker/blob/mysql-router/8.0/Dockerfile)) ([mysql-router/8.0/Dockerfile](https://github.com/mysql/mysql-docker/blob/mysql-router/8.0/Dockerfile))

Images are updated when new MySQL Server maintenance releases and development milestones are published. Please note that non-GA releases are for preview purposes only and should not be used in production setups.

# How to Use the MySQL Router Images

The image currently uses the following variables:

| Variable                     | Description                                 |
| ---------------------------- | ------------------------------------------- |
| MYSQL_HOST                   | MySQL host to connect to                    |
| MYSQL_PORT                   | Port to use                                 |
| MYSQL_USER                   | User to connect with                        |
| MYSQL_PASSWORD               | Password to connect with                    |
| MYSQL_INNODB_CLUSTER_MEMBERS | The number of cluster instances to wait for |

Running in a container requires a working InnoDB cluster. The run script waits
for the given mysql host to be up, the InnoDB cluster to have
MYSQL_INNODB_CLUSTER_MEMBERS members and then uses the given server for its
bootstrap mode
[Bootstrapping](https://dev.mysql.com/doc/mysql-router/8.0/en/mysql-router-deploying-bootstrapping.html).

The image can be run via:

```
docker run -e MYSQL_HOST=localhost -e MYSQL_PORT=3306 -e MYSQL_USER=mysql -e MYSQL_PASSWORD=mysql -e MYSQL_INNODB_CLUSTER_MEMBERS=3 -ti mysql-router
```

It can be verified by typing:

```
docker ps
```

The following output should be displayed:

```
4954b1c80be1        mysql-router:8.0                         "/run.sh mysqlrouter"    About a minute ago   Up About a minute (healthy)   6447/tcp, 64460/tcp, 0.0.0.0:6446->6446/tcp, 64470/tcp                   innodbcluster_mysql-router_1
```

