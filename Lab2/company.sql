/* 
 * this version of the employee table definitions (p 91 of Elmasri-Navathe 6th ed)
 * uses the ALTER TABLE option so that foreign key declarations do not precede
 * the relevant table definition
 *
 * Also, tabs were eliminated for easier copy/paste
 *
 * if things get wedged, foreign-key constraints can be DROPPED:
 * alter table employee DROP foreign key dno;
 *
 */

DROP SCHEMA IF EXISTS company;
CREATE SCHEMA company COLLATE = utf8_general_ci;
USE company;

create table employee (
        fname             varchar(15)         not null,
        minit             char, 
        lname             varchar(15)         not null,
        ssn               char(9)             not null,
        bdate             DATE,
        address           varchar(30), 
        sex               char, 
        salary            decimal(10,2),
        super_ssn         char(9),
        dno               int                 not null,
    primary key (ssn)
    -- foreign key (super_ssn) references employee(ssn)
    -- foreign key (dno) references department(dnumber)
) ;

create table department  (
        dname           varchar(15)     not null,
        dnumber         int             not null,
        mgr_ssn         char(9)         not null,
        mgr_start       date,
    primary key (dnumber),
    unique (dname),
    foreign key (mgr_ssn) references employee(ssn)
) ;


create table dept_locations (
        dnumber          int                not null,
        dlocation        varchar(15)        not null,
    primary key (dnumber, dlocation),
    foreign key (dnumber) references department(dnumber)
) ;

create table project (
        pname            varchar(15)        not null,
        pnumber          int                not null,
        plocation        varchar(15),
        dnum             int                not null,
    primary key (pnumber),
    unique (pname),
    foreign key (dnum) references department(dnumber)
) ;

create table works_on (
        essn               char(9)            not null,
        pno                int                not null,
        hours              decimal(3,1)       ,
    primary key (essn, pno),
    foreign key (essn) references employee(ssn),
    foreign key (pno) references project(pnumber)
) ;

create table dependent (
        essn               char(9)            not null,
        dependent_name     varchar(15)        not null,
        sex                char,
        bdate              date,
        relationship       varchar(8),
    primary key (essn, dependent_name),
    foreign key (essn) references employee (ssn)
) ;


/* set foreign_key_checks=0; */

/* for INSERT INTO employee, note that we insert James Borg *first*,
 * because he is the only employee with NULL super_ssn, and otherwise 
 * we violate the super_ssn foreign key constraint.
 */

INSERT INTO employee
(fname, minit, lname, ssn, bdate, address, sex, salary, super_ssn, dno)
values
('James', 'E', 'Borg', '888665555', '1937-11-10', '450 Stone, Houston TX', 'M', 55000, NULL, 1),
('John', 'B', 'Smith', '123456789', '1965-01-09', '731 Fondren, Houston TX', 'M', 30000, '333445555', 5),
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638 Voss, Houston TX', 'M', 40000, '888665555', 5),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321 Castle, Spring TX', 'F', 25000, '987654321', 4),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291 Berry, Bellaire TX', 'F', 43000, '888665555', 4),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975 Fire Oak, Humble TX', 'M', 38000, '333445555', 5),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631 Rice, Houston TX', 'F', 25000, '333445555', 5),
('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980 Dallas, Houston TX', 'M', 25000, '987654321', 4);

INSERT INTO department 
(dname, dnumber, mgr_ssn, mgr_start)
values
('Research', 5, '333445555', '1988-05-22'),
('Administration', 4, '987654321', '1995-01-01'),
('Headquarters', 1, '888665555', '1981-06-19');

INSERT INTO dependent
(essn, dependent_name, sex, bdate, relationship)
values
('333445555', 'Alice', 'F', '1986-04-05', 'daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'son'),
('333445555', 'Joy', 'F', '1958-05-03', 'spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'son'),
('123456789', 'Alice', 'F', '1988-12-30', 'daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'spouse');

INSERT INTO dept_locations
(dnumber, dlocation)
values
(1, 'Houston'),
(4,'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

INSERT INTO project
(pname, pnumber, plocation, dnum)
values
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

INSERT INTO works_on
(essn, pno, hours)
values
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, NULL);


/* set foreign_key_checks=1;  */

alter table employee ADD foreign key (super_ssn) references employee(ssn);
alter table employee ADD foreign key (dno) references department(dnumber);
