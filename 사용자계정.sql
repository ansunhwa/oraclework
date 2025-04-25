ALTER SESSION SET "_oracle_script" = true;
CREATE USER semi IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO semi;
ALTER USER semi default tablespace users quota unlimited on users;
ALTER TABLE food_logs ADD MEAL_TIME VARCHAR2(20);