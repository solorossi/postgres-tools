-- Sample data for testing.

alter table if exists EMPLOYEE drop constraint if exists FK_EMPLOYEE_TO_EMPLOYEE_ROLE;

drop table if exists EMPLOYEE_ROLE cascade;
drop table if exists EMPLOYEE cascade;

drop sequence if exists EMPLOYEE_ROLE_ID_SEQ;
drop sequence if exists EMPLOYEE_ID_SEQ;

create table EMPLOYEE_ROLE
(
    ID        bigserial    not null,
    ROLE_NAME varchar(128) not null,
    primary key (ID)
);

create table EMPLOYEE
(
    ID               bigserial    not null,
    FIRST_NAME       varchar(128),
    LAST_NAME        varchar(128) not null,
    USERNAME         varchar(128) not null,
    EMPLOYEE_ROLE_ID bigint       not null,
    primary key (ID)
);

alter table EMPLOYEE
    add constraint FK_EMPLOYEE_TO_EMPLOYEE_ROLE foreign key (EMPLOYEE_ROLE_ID) references EMPLOYEE_ROLE;

create index IX_EMPLOYEE_TO_EMPLOYEE_ROLE on EMPLOYEE (EMPLOYEE_ROLE_ID);

alter sequence EMPLOYEE_ROLE_ID_SEQ restart with 50000;
alter sequence EMPLOYEE_ID_SEQ restart with 50000;

insert into EMPLOYEE_ROLE (ID, ROLE_NAME)
values (100, 'Administrator'),
       (200, 'Manager'),
       (300, 'Employee');

insert into EMPLOYEE (ID, FIRST_NAME, LAST_NAME, USERNAME, EMPLOYEE_ROLE_ID)
values (500, 'John', 'Smith', 'jsmith', 100),
       (501, 'Lisa', 'Nelson', 'lnelson', 200),
       (502, 'Jonas', 'Latham', 'jlatham', 300);