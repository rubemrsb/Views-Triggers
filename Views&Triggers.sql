-- Parte 1 – Personalizando acessos com views 
use company;

-- Número de empregados por departamento e localidade 
create view EmpregadoDepartamentoLocal
as
select Dname, count(*) as quantidade 
from employee, department 
where Dno = Dnumber  group by Dno;

-- Lista de departamentos e seus gerentes 
create view GerentesPorDepartamentos
as
select Dname, concat(fname, ' ', lname) 
from department, employee 
where Mgr_ssn = ssn;

-- Projetos com maior número de empregados (ex: por ordenação desc) 
create view EmpregadosPorProjeto
as
select Pname as Project, count(*) as NFuncionários 
from project, employee, works_on 
where employee.ssn = works_on.Essn 
and works_on.Pno = Pnumber 
group by Pname;

-- Lista de projetos, departamentos e gerentes 
create view ListaDeProjetos
as
select Pname, Dname, Fname 
from project, department, employee
 where project.Dnumber = department.Dnumber 
 and Mgr_ssn = ssn;

-- Quais empregados possuem dependentes e se são gerentes 
create view EmpregadosComDependentes
as
select distinct employee.Fname, count(*) as N_de_dependentes, if (employee.ssn = Mgr_ssn, 'Gerente', 'Não é gerente' ) as Cargo 
from employee, dependent, department
where ssn = Essn 
group by Fname;


-- CRIAÇÃO DE USUÁRIOS GERAL E VIEW_ESPECÍFICA
use mysql;
create user 'Curioso'@localhost identified by '123456';
create user 'adminDIO'@localhost identified by 'DIO123';
grant all privileges on company.* to 'adminDIO'@localhost;
grant all privileges on company.EmpregadosComDependetes to 'Curioso'@localhost;


-- Parte 2 Triggers de Remoção e UPDATE E-coomerce;

-- REMOVE -> fazendo backup de registro de clientes quando removidos
use ecommerce;

select* from oldclients;
select* from clients;
delete from clients where idclient = 5;

desc clients;
create table oldclients (
idClient int (11),
Fname varchar (15),
Minit char (3),
Lname varchar(20),
CPF char (11),
Address varchar (250),
Birthdate date);

create trigger Data_Backup before delete
on clients
for each row
insert into oldclients (Fname, Minit, Lname, CPF) values (old.Fname, old.Minit, old.Lname, old.CPF);


-- UPDATE
# atribuindo aumento de salario para um departamento especifico
use company;

select * from employee;

delimiter %
create trigger tr_salario before update
on employee
for each row
begin
	if Dno = 1 then
	set new.salary  =  salary * 1.20;
    end if;
end  % 
delimiter ;

