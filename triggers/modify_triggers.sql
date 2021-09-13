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

# Валидация данных и выкидывание ошибки
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