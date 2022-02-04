-- СОЗДАНИЕ ТАБЛИЦ


-- Тарифы
CREATE TABLE tariffs
(
 name             varchar(64) NOT NULL,
 subscription_fee  smallint NOT NULL,
 internet_traffic decimal(4,2) NOT NULL,
 minutes          smallint NOT NULL,
 sms              smallint NOT NULL,
 CONSTRAINT PK_10 PRIMARY KEY ( name )
);


-- Места прописок
CREATE TABLE places_of_registration
(
 "id"                    serial NOT NULL,
 place_of_registration varchar(255) NOT NULL,
 CONSTRAINT PK_37 PRIMARY KEY ( "id" )
);


-- Клиенты
CREATE TABLE clients
(
 passport                 bigint NOT NULL,
 full_name                varchar(128) NOT NULL,
 place_of_registration_id serial NOT NULL,
 date_of_birth            date NOT NULL,
 CONSTRAINT PK_31 PRIMARY KEY ( passport ),
 CONSTRAINT FK_66 FOREIGN KEY ( place_of_registration_id ) REFERENCES places_of_registration ( "id" )
);

CREATE INDEX FK_68 ON clients
(
 place_of_registration_id
);


-- Абоненты
CREATE TABLE subscribers
(
 account          varchar(20) NOT NULL,
 balance          decimal(8, 2) DEFAULT 0,
 connected_tariff varchar(64) NULL,
 passport         bigint NOT NULL,
 CONSTRAINT PK_41 PRIMARY KEY ( account ),
 CONSTRAINT FK_71 FOREIGN KEY ( passport ) REFERENCES clients ( passport ),
 CONSTRAINT FK_74 FOREIGN KEY ( connected_tariff ) REFERENCES tariffs ( name )
);

CREATE INDEX FK_73 ON subscribers
(
 passport
);

CREATE INDEX FK_76 ON subscribers
(
 connected_tariff
);


-- Телефонные номера
CREATE TABLE phone_numbers
(
 phone_number       bigint NOT NULL,
 subscriber_account varchar(20) NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( phone_number ),
 CONSTRAINT FK_77 FOREIGN KEY ( subscriber_account ) REFERENCES subscribers ( account ) ON DELETE SET NULL
);

CREATE INDEX FK_79 ON phone_numbers
(
 subscriber_account
);


-- Типы пользователей
CREATE TABLE user_types
(
 "id"        serial NOT NULL,
 user_type varchar(32) NOT NULL,
 CONSTRAINT PK_86 PRIMARY KEY ( "id" )
);


-- Пользователи
CREATE TABLE users
(
 login        varchar(32) NOT NULL,
 password     varchar(32) NOT NULL,
 user_type_id serial NOT NULL,
 CONSTRAINT PK_82 PRIMARY KEY ( login ),
 CONSTRAINT FK_88 FOREIGN KEY ( user_type_id ) REFERENCES user_types ( "id" )
);

CREATE INDEX FK_90 ON users
(
 user_type_id
);


-- ВСТАВКА СПРАВОЧНЫХ ДАННЫХ

INSERT INTO public.phone_numbers (phone_number)
	VALUES
        (9845927417),
        (9844625724),
        (9843453234),
        (9845252276),
        (9848064233),
        (9842465830),
        (9842346245),
        (9849473455),
        (9842570531),
        (9846882432);


INSERT INTO public.tariffs (name, subscription_fee, internet_traffic, minutes, sms)
	VALUES
        ('Стандартный', 150, 0.1, 50, 50),
        ('Супер SMART', 600, 15, 600, 600),
        ('Всегда в сети', 550, -1, 50, 50),
        ('Мой бизнес', 1000, 35, -1, -1);


INSERT INTO public.user_types (user_type)
    VALUES
        ('Менеджер'),
        ('Продавец-консультант'),
        ('Абонент');

INSERT INTO public.users (login, password, user_type_id)
    VALUES
        ('manager', '1111', (SELECT id FROM public.user_types WHERE user_type='Менеджер')),
        ('shop-assistant', '1111', (SELECT id FROM public.user_types WHERE user_type='Продавец-консультант'));