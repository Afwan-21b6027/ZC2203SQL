# Lab 01 Report

## Author

Afif Afwan Mohamad Rezal
21B6027

## Progression

### Installation

The database that was installed for this module was MariaDB.

### Starting and Stopping MariaDB

To start MariaDB, by accessing the CMD interface (Command Prompt, Windows Powershell) as an administrator and run the command `net start MariaDB`.

For example:

`C:\ net start MariaDB`

To stop the MariaDB, we replace the `start` with `stop`.

For example:

`C:\ net stop MariaDB`

### Accessing MariaDB

To access MariaDB, after the inital command mentioned, input: `MariaDB -u root -p`

This will return an output:
`Enter password:`

Once password is inputted, the user is brought to the opening menu.

### Creation of New User

In the opening page, to create a new user, we use the following command (For this scenario, we create a user name "stu", which can be logged into with the password "stu"):

```SQL
CREATE USER 'stu'@'localhost' IDENTIFIED BY 'stu';
```

#### Observation 01

When checking if a new user was created, we can do the following step:

1. Switch to the master MySQL Database: `USE mysql;`
2. Enter the command: `SELECT User, Host FROM USER;`

The output from the command will be a table (in ASCII?) with header _user_ and _host_.

#### Observation 02

With the new account, we can attempt to create another new account again using the recently created account.

1. Logging into the account:
   `MariaDB -u stu -p`
2. Enter password:
   `Enter password: stu`
3. Enter CREATE USER command:

`CREATE USER 'newstu'@'localhost' IDENTIFIED BY 'newstu';`

The output of this command is that the database will be as below:

`ERROR 1227 (42000): Access denied; you need (at least one of) the CREATE USER privilege(s) for this operation`

The reason for this is that the recently created user 'stu' is / was not granted the
privileges of creating a new user.

Essentially the command `CREATE USER` helps create a new account which does not come any privileges.

We can see this using the command:
`SHOW GRANTS FOR 'stu'@'localhost';`

The output will be:

```SQL
+------------------------------------------------------------------------------------------------------------+
| Grants for stu@localhost                                                                                   |
+------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `stu`@`localhost` IDENTIFIED BY PASSWORD '*47D07F0722D7F401B3C11861E8CB6CE5FC17C223' |
+------------------------------------------------------------------------------------------------------------+
```

### Granting Access(es) to New Accounts

To grant accesses or privileges to any account, as a _**root account**_ we use the command `GRANT`. For example, we wish to grant the user 'stu' the privileges to access the database Company, thus the command should look like:

```SQL
GRANT ALL ON COMPANY.* FOR 'stu'@'localhost';
```

We can check the result of this command using the command found in the `Creation of New User\Observation 2.h3`.

### Creating a Database

To create a database, use the command `CREATE SCHEMA (database_name)`. For example:

```SQL
CREATE SCHEMA COMPANY;
```

You can check that the database is created by the command `SHOW DATABASES`, such as the example (with the following result):

```SQL
MariaDB [(none)]> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| company            |
| information_schema |
+--------------------+
2 rows in set (0.032 sec)
```

We can use the database created, we use the command `USE (database_name)`. For example:

```SQL
USE COMPANY;
```

### Creating Tables

We can create tables either on the command line interface (CLI) or written in a script and excute it. For this scenario, we have a script so we will use the command `SOURCE`.

It is done as below, and we can see the result in the next line:

```SQL
source D:/MySQL_Lab/lab01_file/department.sql;
SHOW TABLES;
```

To check the table, we use the `DESCRIBE (table_name)` command. For example:

```SQL
DESCRIBE DEPARTMENT;
```

The results of these commands are:

```SQL
MariaDB [COMPANY]> SHOW TABLES;
+-------------------+
| Tables_in_company |
+-------------------+
| department        |
+-------------------+
1 row in set (0.005 sec)
```

```SQL
MariaDB [COMPANY]> DESCRIBE DEPARTMENT;
+--------------+-------------+------+-----+---------+-------+
| Field        | Type        | Null | Key | Default | Extra |
+--------------+-------------+------+-----+---------+-------+
| Dname        | varchar(25) | NO   | UNI | NULL    |       |
| Dnumber      | int(4)      | NO   | PRI | NULL    |       |
| Mgrssn       | char(9)     | NO   |     | NULL    |       |
| Mgrstartdate | date        | YES  |     | NULL    |       |
+--------------+-------------+------+-----+---------+-------+
4 rows in set (0.030 sec)
```

#### Task 1

Given `employee.sql`, add `EMPLOYEE` schema to the database by adding a new `SOURCE` statement in `company_tables.sql` and then execute.
You may have to drop `EMPLOYEE` table first before the two `SOURCE` statements in `company_tables.sql` due to foreign key constraint. You can add a DROP statement in company_tables.sql.

##### Task 1 Answer

- `company_tables.sql` file:

  ```SQL
  source D:/MySQL_Lab/lab01_file/department.sql
  source D:/MySQL_Lab/lab01_file/employee.sql
  ```

- Result:

```SQL
MariaDB [COMPANY]> source D:/MySQL_Lab/lab01_file/company_tables.sql
Query OK, 0 rows affected (0.029 sec)

Query OK, 0 rows affected (0.032 sec)

Query OK, 0 rows affected, 1 warning (0.020 sec)

Query OK, 0 rows affected (0.038 sec)

MariaDB [COMPANY]> SHOW TABLES;
+-------------------+
| Tables_in_company |
+-------------------+
| department        |
| employee          |
+-------------------+
2 rows in set (0.001 sec)
```

### Loading Data into the Table

We use the command `INSERT INTO` or `LOAD DATA`. The former can help add new records and the latter is the faster version.

For this scenario, we use a script which would be inserted into the `company_tables.sql`:

```SQL
source D:/MySQL_Lab/lab01_file/load-department.sql
```

The result of this command is as below:

```SQL
MariaDB [COMPANY]> source D:/MySQL_Lab/lab01_file/company_tables.sql
ERROR 1451 (23000) at line 1 in file: 'D:\MySQL_Lab\lab01_file\department.sql': Cannot delete or update a parent row: a foreign key constraint fails
ERROR 1050 (42S01) at line 3 in file: 'D:\MySQL_Lab\lab01_file\department.sql': Table 'department' already exists
Query OK, 0 rows affected (0.031 sec)

Query OK, 0 rows affected (0.035 sec)

Query OK, 6 rows affected (0.018 sec)
Records: 6  Deleted: 0  Skipped: 0  Warnings: 0

MariaDB [COMPANY]> SELECT * FROM DEPARTMENT;
+----------------+---------+-----------+--------------+
| Dname          | Dnumber | Mgrssn    | Mgrstartdate |
+----------------+---------+-----------+--------------+
| Headquarters   |       1 | 888665555 | 1971-06-19   |
| Administration |       4 | 987654321 | 1985-01-01   |
| Research       |       5 | 333445555 | 1978-05-22   |
| Software       |       6 | 111111100 | 1999-05-15   |
| Hardware       |       7 | 444444400 | 1998-05-15   |
| Sales          |       8 | 555555500 | 1997-01-01   |
+----------------+---------+-----------+--------------+
6 rows in set (0.001 sec)
```

#### Task 2

Write a similar script called load-employee.sql to load the given
employee.dat into EMPLOYEE table.

Due to the self-referencing nature of the Super_ssn attribute, you may encounter foreign key constraint violation - an employee cannot be supervised by another who was not in the table. To solve this problem, rearrange the employee records in employee.dat.

Data in the .dat files are prepared in what is called the CSV (comma-separated values) format – each line contains fields separated by commas. CSV is not a standard, but it is a very simple format widely used across all computer platforms. Most spreadsheet and
database applications support CSV format. Many applications can also export data in CSV format.

Parsing department.dat poses no problem since each field in the records can be adequately distinguished between commas. However, this is not true for employee.dat. In particular, addresses already contain multiple commas. Therefore, a record now has more commas than the exact number of fields that they try to separate. One solution is to enclosed the values (e.g. for the address field) with character symbol such as '”' and specify the enclosing character using FIELDS ENCLOSED BY in the LOAD DATA INFILE statement.

To complete this task, all 40 records must be loaded successfully.

##### Task 2 Answer

There were some errors in entering all 40 data sets from the `employee.dat` into the database. After some adjustment and entering the new file called `new_employee.dat`, the result are as below:

`load-employee.sql`

```SQL
LOAD DATA LOCAL INFILE 'D:/MySQL_Lab/lab01_file/new_employee.dat' INTO TABLE EMPLOYEE
FIELDS ENCLOSED BY '"' TERMINATED BY ',';
```

`company_tables.sql`

```SQL
DROP TABLE IF EXISTS employee;

source D:/MySQL_Lab/lab01_file/department.sql
source D:/MySQL_Lab/lab01_file/employee.sql
source D:/MySQL_Lab/lab01_file/load-department.sql
source D:/MySQL_Lab/lab01_file/load-employee.sql
```

### Adding Constraints

Using the scenario used entirely, we can add foreign key constraint with the `ALTER TABLE` command. For example:

```SQL
MariaDB [COMPANY]> SHOW CREATE TABLE DEPARTMENT;
+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table      | Create Table                                                                                                                                                                                                                                                                         |
+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| DEPARTMENT | CREATE TABLE `department` (
  `Dname` varchar(25) NOT NULL,
  `Dnumber` int(4) NOT NULL,
  `Mgrssn` char(9) NOT NULL,
  `Mgrstartdate` date DEFAULT NULL,
  PRIMARY KEY (`Dnumber`),
  UNIQUE KEY `Dname` (`Dname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci |
+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.002 sec)

MariaDB [COMPANY]> ALTER TABLE DEPARTMENT ADD FOREIGN KEY (Mgrssn)
    -> REFERENCES EMPLOYEE(Ssn);
Query OK, 6 rows affected (0.091 sec)
Records: 6  Duplicates: 0  Warnings: 0

MariaDB [COMPANY]> SHOW CREATE TABLE DEPARTMENT;
+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table      | Create Table                                                                                                                                                                                                                                                                                                                                                                                           |
+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| DEPARTMENT | CREATE TABLE `department` (
  `Dname` varchar(25) NOT NULL,
  `Dnumber` int(4) NOT NULL,
  `Mgrssn` char(9) NOT NULL,
  `Mgrstartdate` date DEFAULT NULL,
  PRIMARY KEY (`Dnumber`),
  UNIQUE KEY `Dname` (`Dname`),
  KEY `Mgrssn` (`Mgrssn`),
  CONSTRAINT `department_ibfk_1` FOREIGN KEY (`Mgrssn`) REFERENCES `employee` (`Ssn`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci |
+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.022 sec)
```

We can see the difference in the two.

### TASK 3

Add the rest of the tables, `DEPT_LOCATIONS`, `PROJECT`, `WORKS_ON`, and `DEPENDENT`, to the database [Elmasri, pg. 237].

#### TASK 3 Answer
