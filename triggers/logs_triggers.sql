# Триггер на создание записи о том что добавлена запись
# с использованием оригинальных данных
DELIMITER //
CREATE TRIGGER INSERT_ROWS
    AFTER INSERT
    ON tasks.t_1_innodb
    FOR EACH ROW
    insert into tasks.logs (type, value) VALUE ('insert', CONCAT(NEW.first_name, NEW.last_name)) //
DELIMITER ;

# Лог обновления записи
DELIMITER //
CREATE TRIGGER UPDATE_LOG
    AFTER UPDATE
    ON tasks.t_1_innodb
    FOR EACH ROW
    insert into tasks.logs (type, value) VALUE ('update',CONCAT_WS('-->',CONCAT_WS('-', OLD.first_name, OLD.last_name),CONCAT_WS('-', NEW.first_name, NEW.last_name)))
DELIMITER ;