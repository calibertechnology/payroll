-- as payroll_admin:
USE payroll;
DROP TABLE IF EXISTS employers;
CREATE TABLE employers (
  er_id INT NOT NULL,
  company VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  city VARCHAR(255),
  state VARCHAR(255),
  zip VARCHAR(255),
  PRIMARY KEY(er_id)
);
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
  id INT NOT NULL,
  employer INT NOT NULL REFERENCES employer(er_id),
  last VARCHAR(255) NOT NULL,
  first VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  city VARCHAR(255),
  state VARCHAR(255),
  zip VARCHAR(255),
  PRIMARY KEY(id)
);
DROP TABLE IF EXISTS employee_tax_names;
CREATE TABLE employee_tax_names (
  emp_id INT NOT NULL REFERENCES employees(id),
  taxname VARCHAR(255) NOT NULL,
  PRIMARY KEY(emp_id,taxname)
);

INSERT INTO employers (er_id, company, address, city, state, zip)
  VALUES(1, 'National Park Service', '520 Chestnut St', 'Philadelphia', 'PA', '19106');
INSERT INTO employees (id, employer, last, first, address, city, state, zip)
  VALUES(1, 1, 'Schmoe', 'Joe', '123 Main St', 'Aliquippa', 'PA', '15001');
INSERT INTO employee_tax_names VALUES (1,'Federal Income Tax');
INSERT INTO employee_tax_names VALUES (1,'FUTA With Credit Reduction');
INSERT INTO employee_tax_names VALUES (1,'PA');
INSERT INTO employee_tax_names VALUES (1,'PA Unemployment');
INSERT INTO employee_tax_names VALUES (1,'PA Unemployment Employee');
INSERT INTO employee_tax_names VALUES (1,'PA Philadelphia EIT');
