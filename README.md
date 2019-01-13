# Spring Boot 2.1 Rest API application

Development environment

* OpenJDK 11.0.1
* Spring Boot 2.1.2.RELEASE
* MySQL 8.0.13
* JUnit 5.3.2
* Maven 3.5.4

```text
openjdk version "11.0.1" 2018-10-16
OpenJDK Runtime Environment 18.9 (build 11.0.1+13)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.1+13, mixed mode)
```

## compile

```text
mvn clean package
```

## run

### executable jar

```text
java -jar .\target\demo-exec.jar
```

Specify a profile

```text
java -jar -Dspring.profiles.active=dev .\target\demo-exec.jar
```

### spring boot maven plugin

```text
mvn spring-boot:run
```

Specify a profile

```text
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

## database

**database**

resources/scripts/sql/create_database.sql

```sql
CREATE DATABASE IF NOT EXISTS demo_db
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci;
```

**user**

resources/scripts/sql/create_user.sql

```sql
CREATE USER IF NOT EXISTS 'demo_user'@'localhost'
  IDENTIFIED BY 'demo_pass'
  PASSWORD EXPIRE NEVER;

GRANT ALL ON demo_db.* TO 'demo_user'@'localhost';
```

### Using Memo API

**table**

resources/scripts/sql/create_memo_table.sql

switch to demo_db.

```sql
DROP TABLE IF EXISTS memo;

CREATE TABLE IF NOT EXISTS memo (
  id BIGINT AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  done BOOLEAN NOT NULL DEFAULT FALSE,
  updated TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET = utf8mb4,
COLLATE utf8mb4_general_ci;
```

**create test data**

resources/scripts/sql/insert_memo_data.sql

```sql
INSERT INTO memo (id, title, description, done, updated) VALUES
  (1, 'memo shopping', 'memo1 description', false, '2018-01-04 12:01:00'),
  (2, 'memo job', 'memo2 description', false, '2018-01-04 13:02:10'),
  (3, 'memo private', 'memo3 description', false, '2018-01-04 14:03:21'),
  (4, 'memo job', 'memo4 description', false, '2018-01-04 15:04:32'),
  (5, 'memo private', 'memo5 description', false, '2018-01-04 16:05:43'),
  (6, 'memo travel', 'memo6 description', false, '2018-01-04 17:06:54'),
  (7, 'memo travel', 'memo7 description', false, '2018-01-04 18:07:05'),
  (8, 'memo shopping', 'memo8 description', false, '2018-01-04 19:08:16'),
  (9, 'memo private', 'memo9 description', false, '2018-01-04 20:09:27'),
  (10,'memo hospital', 'memoA description', false, '2018-01-04 21:10:38')
;
```

### using Customer API

**table**

resources/scripts/sql/v2_schema.sql
resources/scripts/sql/v2_constraint.sql

```sql
show tables;

+-------------------+
| Tables_in_demo_db |
+-------------------+
| category          |
| customer          |
| customer_order    |
| customer_review   |
| item              |
| item_stock        |
| location          |
| memo              |
+-------------------+
8 rows in set (0.03 sec)
```

**create test data**

resources/scripts/sql/v2_proc_create_test_data.sql

compile

```sql
source v2_proc_create_test_data.sql
```

This process takes about 90 - 120 minutes.

```sql
call proc_create_test_data();
```

results

```text
demo_user@localhost [demo_db] > select count(*) from customer;
+----------+
| count(*) |
+----------+
|   250000 |
+----------+
1 row in set (0.13 sec)

demo_user@localhost [demo_db] > select count(*) from customer_order;
+----------+
| count(*) |
+----------+
|  2805940 |
+----------+
1 row in set (2.53 sec)

demo_user@localhost [demo_db] > select count(*) from customer_review;
+----------+
| count(*) |
+----------+
|   131880 |
+----------+
1 row in set (0.03 sec)
```
