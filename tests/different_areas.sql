# Доступ к разным участкам таблицы (Таблицы заполнены 30,000 записями)

SELECT first_name,
       last_name
FROM tasks.t_1_myisam
WHERE (id > 10 AND id < 2400)
   OR (id > 9000 AND id < 10560)
   OR (id > 25000 AND id < 28800)
LIMIT 10000
#Выбрано 7 747 строк (0.030 s)


SELECT first_name,
       last_name
FROM tasks.t_1_innodb
WHERE (id > 10 AND id < 2400)
   OR (id > 9000 AND id < 10560)
   OR (id > 25000 AND id < 28800)
LIMIT 10000

#Выбрано 7 747 строк (0.014 s)