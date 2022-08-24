create database meubanco;
show databases;
use meubanco;
CREATE TABLE Clientes (
    ClienteID int,
    Nome varchar(50),
    Sobrenome varchar(50),
    Endereco varchar(150),
    Cidade varchar(50),
    Host varchar(50)
);
show tables;
select * from Clientes;
insert into Clientes (ClienteID, Nome, Sobrenome, Endereco, Cidade, Host) VALUES (1, 'Joao', 'Aparecido', 'Av. Paranaiba, 33', 'Goiania-GO', 'aws-1');
select * from Clientes;