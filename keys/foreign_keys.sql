create table users
(
    id   int auto_increment
        primary key,
    name varchar(255) null
);



create table user_profiles
(
    id      int auto_increment
        primary key,
    user_id int null,
    email   varchar(255) null,
    constraint user_profiles_users_id_fk
        foreign key (user_id) references users (id)
);
