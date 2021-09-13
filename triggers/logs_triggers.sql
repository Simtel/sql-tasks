# Триггер на создание записи о том что добавлена запись
# с использованием оригинальных данных
DELIMITER //
CREATE TRIGGER INSERT_ROWS
    AFTER INSERT
    ON tasks.t_1_innodb
    FOR EACH ROW
    insert into tasks.logs (type, value) VALUE ('insert', CONCAT(NEW.first_name, NEW.last_name)) //
DELIMITER ;

# Изменим данные перед сохранением
DELIMITER //
CREATE TRIGGER ADD_CHAR_NAME
    BEFORE INSERT
    ON tasks.t_1_innodb
    FOR EACH ROW
    IF NEW.first_name = 'Pavel' THEN
        SET NEW.first_name = 'Pavel P';
    end if //

DELIMITER ;

# Валидация данных
DELIMITER //
CREATE TRIGGER VALIDATE_NAME
    BEFORE INSERT
    ON tasks.t_1_innodb
    FOR EACH ROW
    IF NEW.first_name = 'Simtel' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Данное имя запрещено';
    end if //

DELIMITER ;

# Валидация данных
DELIMITER //
CREATE TRIGGER UPDATE_LOG
    AFTER UPDATE
    ON tasks.t_1_innodb
    FOR EACH ROW
    insert into tasks.logs (type, value) VALUE ('update',CONCAT_WS('-->',CONCAT_WS('-', OLD.first_name, OLD.last_name),CONCAT_WS('-', NEW.first_name, NEW.last_name)))


DELIMITER ;