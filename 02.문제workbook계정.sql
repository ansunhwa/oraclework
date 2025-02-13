----1
select DEPARTMENT_NAME "학과 명", CATEGORY 계열
FROM TB_DEPARTMENT;
 -----2
SELECT DEPARTMENT_NAME||'의 정원은'||CAPACITY||'명 입니다'
FROM TB_DEPARTMENT;
-------3
SELECT STUDENT_NAME, STUDENT_NO
FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY STUDENT_NAME DESC;
 ------4
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;
-----5
SELECT PROFESSOR_NAME
FROM tb_professor
WHERE DEPARTMENT_NO IS NULL;
-----------------6
SELECT STUDENT_NAME
FROM tb_student
WHERE DEPARTMENT_NO IS NULL;
---------------7
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;
------------8
SELECT DISTINCT CATEGORY
FROM tb_department;
--------9
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '%전주%' AND
    ABSENCE_YN = 'N' AND
    EXTRACT(YEAR FROM ENTRANCE_DATE)='2002';
    
-----------------------------------------------------------------------------
--01 002학생들의 학번,이름, 입학년도 
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, ENTRANCE_DATE 입학년도
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '002'
ORDER BY ENTRANCE_DATE;

-- 2이름이 세글자가 아닌 교수의 이름, 주민번호
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';

-- 3남자교수들의 이름가 나이 오름차순
SELECT PROFESSOR_NAME, EXTRACT(YEAR FROM SYSDATE)-(19||SUBSTR(PROFESSOR_SSN,1,2))나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN,8,1) ='1'
ORDER BY 나이;

-- 4교수 이름 중 성을 제외한 이름만
SELECT SUBSTR(PROFESSOR_NAME,2,2)이름
FROM TB_PROFESSOR;

--5 재수생 입학자 19살에 입학하면 재수를 하지 않은것
SELECT STUENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE ;

-- 2020년 크리스마스는 무슨 요일 인가요



--7 


--8 2000이후 입학자들은 학번이A 2000이전학번 학생들의 학번, 이름조회
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT;


--06.3.SQL3_select 연습문제

--14
SELECT STUDENT_NAME 학생이름, NVL(PROFESSOR_NAME, '지도교수미지정')지도교수
FROM TB_STUDENT S
LEFT JOIN TB_PROFESSOR ON (PROFESSOR_NO = COACH_PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '서반아어학과'
ORDER BY STUDENT_NO;

--15
SELECT STUDENT_NO, STUDENT_NAME, CLASS_NAME, AVG(POINT) 평점
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4;

--18
SELECT MAX(AVG(POINT))
FROM  TB_GRADE
JOIN TB_STUDENT USING(STUDENT_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '국어국문학과'
GROUP BY STUDENT_NO;

SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_GRADEUSING(STUDENT_NO)
WHERE DEPARTMENT_NAME = '국어국문학과';



    
--==================DDL=====
--1.
CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y');
--2.    
CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10) );

--3***
ALTER TABLE TB_CATAGORY ADD NAME PRIMARY KEY;

--4 NULL값이 들어가지 않도록
ALTER TABLE TB_CLASS_TYPE MODIFY CLASS_TYPE_NAME VARCHAR2(20) DEFAULT '이름없음';


--5
ALTER TABLE TB_CLASS_TYPE MODIFY NO VARCHAR2(10);
ALTER TABLE TB_CLASS_TYPE MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CATEGORY MODIFY NAME VARCHAR2(20);

--6 
ALTER TABLE TB_CLASS_TYPE 
    RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE 
    RENAME COLUMN NAME TO CLASS_TYPE_NAME;

ALTER TABLE TB_CATEGORY
    RENAME COLUMN NAME TO CATEGORY_NAME;
    
--7 PRIMARY KEY


--8
INSERT INTO TB_CATEGORY VALUES ('공학', 'Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학', 'Y');
INSERT INTO TB_CATEGORY VALUES ('의학', 'Y');
INSERT INTO TB_CATEGORY VALUES ('예체능', 'Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회', 'Y');
COMMIT;

--9 FOREIGN KEY




--10 VIEW
CREATE VIEW VW_학생일반정보
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT;

SELECT * FROM VW_학생일반정보;

--11
CREATE OR REPLACE VIEW VW_지도면담
AS SELECT STUDENT_NAME, DEPARTMENT_NAME, PROFESSOR_NAME
   FROM TB_STUDENT
  LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
   JOIN TB_PROFESSOR ON( COACH_PROFESSOR_NO = PROFESSOR_NO);
  
SELECT * FROM VW_지도면담;

--12
CREATE OR REPLACE VIEW VW_학과별학생수
AS SELECT DEPARTMENT_NAME, COUNT(*)학생수
   FROM TB_DEPARTMENT
   JOIN TB_STUDENT USING(DEPARTMENT_NO)
   GROUP BY DEPARTMENT_NAME;

SELECT * FROM VW_학과별학생수;

--13 
UPDATE VW_학생일반정보
SET STUDENT_NAME = '땡땡땡'
WHERE STUDENT_NO = 'A213046';

SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO = 'A213046';

--14
/*
CREATE VIEW VW_학생일반정보
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT
    WITH READ ONLY;
*/

--15



--==============DML========
--1
INSERT INTO TB_CLASS_TYPE(CLASS_TYPE_NO, CLASS_TYPE_NAME) VALUES(01,'전공필수');
INSERT INTO TB_CLASS_TYPE(CLASS_TYPE_NO, CLASS_TYPE_NAME) VALUES(02,'전공선택');
INSERT INTO TB_CLASS_TYPE(CLASS_TYPE_NO, CLASS_TYPE_NAME) VALUES(03,'교양필수');
INSERT INTO TB_CLASS_TYPE(CLASS_TYPE_NO, CLASS_TYPE_NAME) VALUES(04,'교양선택');
INSERT INTO TB_CLASS_TYPE(CLASS_TYPE_NO, CLASS_TYPE_NAME) VALUES(05,'논문지도');

--2
CREATE TABLE TB_학생일반정보 (
    STUDENT_NO VARCHAR2(10),
    STUDENT_NAME VARCHAR2(20),
    STUDENT_ADDRESS VARCHAR2(200)
    );
    
INSERT INTO TB_학생일반정보
(SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT);
    
--3
CREATE TABLE TB_국어국문학과 (
    STUDENT_NO VARCHAR2(10),
    STUDENT_NAME VARCHAR2(20),
    STUDENT_YEAR VARCHAR2(10),
    PROFESSOR_NAME VARCHAR2(20)
    );

INSERT INTO TB_국어국문학과
(SELECT STUDENT_NO, STUDENT_NAME, SUBSTR(STUDENT_SSN,1,2), PROFESSOR_NAME
    FROM TB_STUDENT
    JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO);








