-- as root user:
CREATE DATABASE IF NOT EXISTS payroll;
CREATE USER IF NOT EXISTS payroll_admin@localhost IDENTIFIED BY 'monkey123';
GRANT ALL ON payroll.* to payroll_admin@localhost;
