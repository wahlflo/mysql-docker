![logo](https://www.mysql.com/common/logos/logo-mysql-170x115.png)

# What is MySQL Router?

MySQL Router is part of InnoDB cluster, and is lightweight middleware that
provides transparent routing between your application and back-end MySQL
Servers. It can be used for a wide variety of use cases, such as providing high
availability and scalability by effectively routing database traffic to
appropriate back-end MySQL Servers. The pluggable architecture also enables
developers to extend MySQL Router for custom use cases.

# Supported Tags and Respective Dockerfile Links

* MySQL Router 8.0 (tag: [`latest`, `8.0`, `8.0.12`](https://github.com/mysql/mysql-docker/blob/mysql-router/8.0/Dockerfile)) ([mysql-router/8.0/Dockerfile](https://github.com/mysql/mysql-docker/blob/mysql-router/8.0/Dockerfile))

Images are updated when new MySQL Server maintenance releases and development milestones are published. Please note that non-GA releases are for preview purposes only and should not be used in production setups.

# How to Use the MySQL Router Images

The image currently uses the following variables:

| Variable                     | Description                                 |
| ---------------------------- | ------------------------------------------- |
| MYSQL_HOST                   | MySQL host to connect to                    |
| MYSQL_PORT                   | Port to use                                 |
| MYSQL_USER                   | User to connect with                        |
| MYSQL_PASSWORD               | Password to connect with                    |

Running in a container requires a working InnoDB cluster. The container runs
tries to bootstrap from the given MYSQL_HOST in bootstrap mode
[Bootstrapping](https://dev.mysql.com/doc/mysql-router/8.0/en/mysql-router-deploying-bootstrapping.html).

Note this means the router container will fail if it can't bootstrap via the
given host. We recommend to use a "restart: on-failure" setting to be more
lenient here.

The image can be run via:

```
docker run --restart on-failure -e MYSQL_HOST=localhost -e MYSQL_PORT=3306 -e MYSQL_USER=mysql -e MYSQL_PASSWORD=mysql -ti mysql/mysql-router:8.0
```

It can be verified by typing:

```
docker ps
```

The following output should be displayed:

```
4954b1c80be1        mysql-router:8.0                         "/run.sh mysqlrouter"    About a minute ago   Up About a minute (healthy)   6447/tcp, 64460/tcp, 0.0.0.0:6446->6446/tcp, 64470/tcp                   innodbcluster_mysql-router_1
```

