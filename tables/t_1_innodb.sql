CREATE TABLE tasks.t_1_innodb
(
    id         int          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name varchar(50)  NOT NULL,
    last_name  varchar(100) NOT NULL
) ENGINE='InnoDB';



select * from tasks.t_1_myisam
UNION
select * from tasks.t_1_innodb
UNION
select * from tasks.t_1_innodb