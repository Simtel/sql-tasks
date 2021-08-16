select count(*) from tasks.t_1_myisam WHERE id > 5 AND id < 9999
#0.004

select count(*) from tasks.t_1_innodb WHERE id > 5 AND id < 9999
#0.010