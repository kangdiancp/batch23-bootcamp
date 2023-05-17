create table regions (
	region_id serial primary key,
	region_name varchar(255)
)

create table countries (
	country_id char(2),
	country_name varchar(255),
	region_id integer,
	foreign key (region_id) references regions(region_id)
)

select * from regions
select * from countries

alter table regions add column region_x varchar(255)
alter table regions rename column region_x to region_xx
alter table regions alter column region_xx type varchar(25)
alter table regions alter column region_xx type integer using region_xx::integer
alter table regions alter column region_xx type varchar(255)
alter table regions drop column region_xx

alter table countries add constraint country_id_pk primary key (country_id)

drop table regions
drop table regions cascade

insert into regions (region_id, region_name) values(1, 'artic')
insert into regions (region_name) values('anartic')
insert into regions (region_name)
values
('antartic'),
('indonesia'),
('rusia'),
('amerika')

update regions set region_name = 'arab' where region_id = 2

select * from regions

delete from regions where region_id = 1