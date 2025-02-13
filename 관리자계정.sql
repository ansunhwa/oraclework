---- scott사용자 만들기
ALTER SESSION SET "_oracle_script" = true;
CREATE USER scott IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO scott;
ALTER USER scott default tablespace users quota unlimited on users;

-- workbook사용자 만들기
ALTER SESSION SET "_oracle_script" = true;
CREATE USER workbook IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO workbook;
ALTER USER workbook default tablespace users quota unlimited on users;

-- ddl사용자 만들기
ALTER SESSION SET "_oracle_script" = true;
CREATE USER ddl IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO ddl;
ALTER USER ddl default tablespace users quota unlimited on users;

GRANT CREATE VIEW TO WORKBOOK;