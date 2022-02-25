USE payroll;

-- The employer(s).
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

-- The employees.
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

-- Taxes applied for each employee for each paycheck.
-- Some employees may opt for different filing status for
-- federal vs state taxes. For example, single for federal
-- but married for state.
-- Some tax formulas require extra information, which can be
-- carried in the exemptions, miscellaneous, or auxiliary fields.
DROP TABLE IF EXISTS employee_taxes;
CREATE TABLE employee_taxes (
  emp_id INT NOT NULL REFERENCES employees(id),
  taxname VARCHAR(255) NOT NULL,
  filing_status INT NOT NULL,
  exemptions NUMERIC,
  miscellaneous FLOAT,
  auxiliary FLOAT,
  PRIMARY KEY(emp_id,taxname)
);

INSERT INTO employers (er_id, company, address, city, state, zip)
  VALUES(1, 'National Park Service', '520 Chestnut St', 'Philadelphia', 'PA', '19106');
INSERT INTO employees (id, employer, last, first, address, city, state, zip)
  VALUES(1, 1, 'Poe', 'Edgar', '532 N 7th St', 'Philadelphia', 'PA', '19123');
INSERT INTO employee_taxes (emp_id, taxname, filing_status) VALUES (1,'Federal Income Tax', 0);
INSERT INTO employee_taxes (emp_id, taxname, filing_status) VALUES (1,'FUTA With Credit Reduction', 0);
INSERT INTO employee_taxes (emp_id, taxname, filing_status) VALUES (1,'FICA SS', 0);
INSERT INTO employee_taxes (emp_id, taxname, filing_status) VALUES (1,'FICA Med', 0);
INSERT INTO employee_taxes (emp_id, taxname, filing_status) VALUES (1,'PA', 0);
INSERT INTO employee_taxes (emp_id, taxname, filing_status) VALUES (1,'PA Unemployment', 0);
INSERT INTO employee_taxes (emp_id, taxname, filing_status) VALUES (1,'PA Unemployment Employee', 0);
INSERT INTO employee_taxes (emp_id, taxname, filing_status) VALUES (1,'PA Philadelphia EIT', 0);
