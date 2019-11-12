-- Simple create a schema and a table:

create schema deleteme;
set schema deleteme;


create or replace table test (
   id int  not null generated always as identity primary key,
   text  varchar(128) not null
); 
   

insert into deleteme.test (text) values('Hello');

