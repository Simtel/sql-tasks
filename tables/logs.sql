create table logs
(
    id         int auto_increment,
    type       varchar(10) null,
    value      varchar(255) null,
    created_at datetime DEFAULT CURRENT_TIMESTAMP(),
    constraint logs_pk
        primary key (id)
);
