/*
    서브쿼리
    하나의 SQL 문 안에 포함된 또 다른 SELECT문
    메인 SQL 문의 보조역할 하는 쿼리 문
*/
-- 간단한 서브쿼리 예1
-- 박정보 사원과 같은 부서에 속한 사원들 조회
--1. 박정보 사원의 부서
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME ='박정보';

--2. 부서코드가 D9인 사원 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 위의 2개의 쿼리문을 합치면
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME ='박정보');

-- 전 직원의 평균 급여보다 더 많은 급여를 받는 사원의 사번, 사원명, 직급코드, 급여조회
-- 1. 평균급여
SELECT AVG(SALARY)
FROM EMPLOYEE;

--2. 평균급여보다 더 많은 급여를 받는 사원
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3047662;

-- 2개 합치면
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE);
                
---------------------------------------------------
/*
    서브쿼리의 구분
    서브쿼리를 수행한 결과값이 몇행 몇 열이냐에 다라 분류
    - 단일행 서브쿼리 : 서브쿼리를 실행한 결과 오로지 1개일 때(1행, 1열)
    - 다중행 서브쿼리 : 서브쿼리를 실행한 결과 여러행 일 때 (여러행 1열)
    - 다중열 서브쿼리 : 서브쿼리를 실행한 결과 여러열 일 때 (1행 여러열)
    - 다중행, 다중열 서브쿼리 : 실행한 결과 여러행, 여러 열 일 때(여러행, 여러열)
    
    >> 서브쿼리의 종류가 무엇이냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/

/*
    1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
      -비교 연산자 사용가능  =,!=,>,<...
*/
-- 전 직원의 평균급여보다 급여를 더 적게 받는 사원들의 직원명, 직급코드 급여조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY SALARY;

--최저 급여를 받는 사원의 사번, 사원명, 급여, 입사일조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
            FROM EMPLOYEE);

-- 박정보사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 직급코드, 급여조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY   --같은 값(급여)비교니까 같은 컬럼이 나와야 함
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');

--JOIN
--박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서이름, 급여조회
-- >>오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID 
AND SALARY > (SELECT SALARY 
             FROM EMPLOYEE
            WHERE EMP_NAME = '박정보');

-- >>ANSI구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) 
WHERE SALARY > (SELECT SALARY 
             FROM EMPLOYEE
            WHERE EMP_NAME = '박정보');
            
--서브쿼리에 나온 결과는 제외하여 조회하고 싶을 때
-- 지정보사원과 같은 부서원들의 사번, 사원명, 부서명 조회 단, 지정보는 제외
-- >>오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
    AND DEPT_CODE = ( SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '지정보')
    AND EMP_NAME != '지정보';

-->> ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = ( SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '지정보')
    AND EMP_NAME != '지정보';
    
-- GROUP BY
-- 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
--1. 부서별 급여 합 중에서 가장 큰 값 조회
SELECT MAX(SUM(SALARY))   -- 급여의 합중에 가장 큰 값
FROM EMPLOYEE
GROUP BY DEPT_CODE;  -- 부서별로

--급여합이 17700000과 같은 행 조회
SELECT DEPT_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

-- 두 문장을 합치면
SELECT DEPT_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))   
                    FROM EMPLOYEE
                    GROUP BY DEPT_CODE); 
-------------------------------------------
/*
    다중행 서브쿼리
     - IN 서브쿼리 : 여러개의 결과값 중 한개라도 일치하는 값이 있다면 (얘를 좀 씀) 거의 단일행 씀
     
     - > ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 클 경우
                    즉, 결과값 중 가장 작은값 보다 클 경우
     - < ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 작은 경우
                    즉, 결과값 중 가장 큰값 보다 작을 경우    
     - ALL : 서브쿼리의 값들 중 가장 큰값보다 더 큰 값을 얻어올 때               
*/

-- 조정연 또는 지정보 사원과 같은 직급을 가진 사원들의 사번, 사원명, 직급코드, 급여조회
--1. 조정연 도는 지정보 사원의 직급
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '조정연' OR EMP_NAME = '지정보';
--WHERE EMP_NAME IN('조정연','지정보');

--2. J3,J7인 직원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN('J3','J7');

-- 2개 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN(SELECT JOB_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '조정연' OR EMP_NAME = '지정보');
                
-- 대리직급임에도 과장의 급여의 최소급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여
--1. 과장들의 급여
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

--2. 대리인데 220보다 큰사람
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > 2200000;

--3 ANY 구문으로 하면
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ANY(2000000,2500000,3760000000); 
--가장 작은값(2200000)보다 큰 수 - 여러개의 값 중 가장 작은값보다 큰 값이 나옴

-- 단일 행 서브쿼리로도 가능
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ANY(SELECT SALARY
            FROM EMPLOYEE
            JOIN JOB USING(JOB_CODE)
            WHERE JOB_NAME = '과장'); 

-- 차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급명, 급여 조회
-- 과장의 가장 큰 금액보다 적게 받는 차장
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장'  --376
    AND SALARY < ANY(SELECT SALARY
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME = '과장');

--ALL : 서브쿼리의 값들 중 가장 큰값보다 더 큰값을 얻어올 때
-- 차장의 가장 큰 급여보다 더 많이 받는 과장 사번, 사원명, 직급명, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
    AND SALARY > ALL(SELECT SALARY
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME = '차장');

------------------------------------------------------
/*
    다중열 서브쿼리
     : 서브쿼리의 결과값이 행은 하나, 열은 여러개
*/
-- 구정하 사원과 같은 부서코드, 직급코드에 해당하는 사원들의 사번, 사원명, 부서코드, 직급코드
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 구정하 부서코드
    AND JOB_CODE = 구정하 직급코드;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '구정하')
    AND JOB_CODE = (SELECT JOB_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '구정하');

-- >>다중행, 서브쿼리
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                            FROM EMPLOYEE
                            WHERE EMP_NAME = '구정하');

-- 하정연 사원의 직급코드와 사수가 같은 사원의 사번. 사원명, 직급코드 사수ID
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '하정연')
        AND MANAGER_ID = (SELECT MANAGER_ID
                        FROM EMPLOYEE
                        WHERE EMP_NAME = '하정연');
                        
-------------------------------------------------------
/*
    다중행 다중열 서브쿼리
      서브쿼리의 결과값이 여러행은 여러열의 결과
*/

-- 각 직급별 최소급여를 받는 사원의 사번, 사원명, 직급코드, 급여조회
-- 1. 직급별 최소급여 금액과 직급코드 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;   --7행 2열

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
GROUP BY JOB_CODE = 'J5' AND SALARY = 2200000 
        OR JOB_CODE = 'J6' AND SALARY = 2000000
        ....;
        

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE(JOB_CODE, SALARY) = ('J5', 2000000)
   OR(JOUB_CODE, SALARY) = ('J6', 2000000);
   
-- 서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE(JOB_CODE, SALARY) IN (SELECT JOB_CODE,MIN(SALARY)
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE);

-- 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE(DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                            FROM EMPLOYEE
                            GROUP BY DEPT_CODE);

-----------------------------------------------
/*
    인라인 뷰(INLINE VIEW)
    FROM 절에 서브쿼리 작성
    
    서브쿼리 결과를 마치 테이블처럼 사용
*/
-- 사원들의 사번, 사원명, 보너스포함연봉(별칭), 부서코드 조회
-- NULL나오지 않게
--보너스 포함 연봉이 3000만원 이상인 사원들만 조회

SELECT EMP_ID, EMP_NAME, SALARY*NVL(1+BONUS,1)*12 연봉, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY*NVL(1+BONUS,1)*12 >= 30000000;

--WHERE절에 연봉이라는 별칭을 쓰고싶으면
SELECT EMP_NAME, 연봉                 --FROM 테이블에 있는 정보를 가져오세요
FROM (SELECT EMP_ID, EMP_NAME, SALARY*NVL(1+BONUS,1)*12 연봉, DEPT_CODE
      FROM EMPLOYEE)   --여기에 있는 FROM이 테이블이 됨
WHERE 연봉 >= 30000000;
--FROM 테이블에 없는 컬럼은 SELECT에 불러 올 수 없음
--가지고 오고 싶으면 FROM테이블에 추가를 하면 SELECT에 쓸 수 있음

------------> 인라인 뷰를 주로 사용하는 예) TOP-N 분석(상위 몇위까지만 가져오기)
-- 직원들 중 급여를 가장 많이 받는 사원의 상위 5위까지
------> ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 순번을 부여해주는 컬럼
-- (컬럼처럼 사용, 데이터베이스에 적힌 내용 수행 후 번호를 붙힘

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE;

-- 우선 SELECT절의 이름과 급여를 가져와서 그 결과에 번호를 매긴 후 급여의 내림차순 정렬
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <=5
ORDER BY SALARY DESC;

-- 테이블 서브쿼리외의 다른 컬럼을 사용할 때는 서브쿼리에 별칭을 부여한 후 별칭.*으로만 사용가능
-- FROM 먼저 해주고(내림차순) ROWNUM
SELECT ROWNUM, E.*  --E테이블의,*모든 것
FROM(SELECT EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY SALARY DESC) E
WHERE ROWNUM <=5;

-- 가장 최근에 입사한 사원 3명의 사원명, 급여, 입사일 조회
SELECT ROWNUM, E.*
FROM(SELECT EMP_NAME, SALARY, HIRE_DATE
    FROM EMPLOYEE
    ORDER BY HIRE_DATE DESC) E
WHERE ROWNUM <=3;

-- 각 부서별 평균급여가 높은 3개의 부서코드, 평균급여
SELECT  E.*   --SELECT 에 ROWNUM 을 써주면 컬럼으로 들어감 안써줘도 됨
FROM(SELECT DEPT_CODE, CEIL(AVG(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY CEIL(AVG(SALARY)) DESC)E
WHERE ROWNUM <=3;
--------------------------------------------------------------
/*
    WITH
    서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름을 FROM절에 기술
    
    -장점
    같은 서브쿼리가 여러 번 사용될 경우 중복작성을 피할 수 있다
    실행속도도 빠르다
*/
 
 --서브쿼리처럼 쓰고 이름을 붙혀줄 수 있다
 WITH TOP_SAL AS(SELECT DEPT_CODE, CEIL(AVG(SALARY))평균급여
                 FROM EMPLOYEE
                 GROUP BY DEPT_CODE
                 ORDER BY 평균급여 DESC)
                 
SELECT *
FROM TOP_SAL
WHERE ROWNUM <=3;
-- MINUS, UNION 을 쓸 때 유용 

-- 세미콜론을 쓰면 위에 TOP_SAL 을 사용할 수가 없다
SELECT *
FROM TOP_SAL
WHERE ROWNUM <=3;

-------------------------------
/*
    순위를 매기는 함수RANK
    RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
    - RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너뛰어 순위 계산
                            EX)공동1위가 2명이면 다음순위는 3위
    - DENSE_RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 무조건 1 증가 시킴
                            EX)공동1위가 2명이면 다음순위는 2위
    >> SELECT절에서만 사용 가능   
*/
 
--급여가 높은 순서대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC)순위
FROM EMPLOYEE;
-- 공동순위 19위가 2명 -> 그 다음 순위는 21위

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC)순위
FROM EMPLOYEE;
-- 공동순위 19위가 2명 -> 그 다음 순위는 20위

--급여가 상위 5위인 사원의 사원명, 급여, 순위조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC)순위
FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY DESC) <=5;  
--오류 RANK는 SELECT절에서만 사용할 수 있음

-- ORDER BY 가 들어가게 되면 인라인뷰를 쓸 수밖에 없음
-- 인라인뷰를 사용할 수밖에없음 (FROM을 테이블로 쓰기)
SELECT *
FROM(SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC)순위
    FROM EMPLOYEE)
WHERE 순위 <= 5;

--WITH와 함께 사용
WITH TOPN_SAL AS (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC)순위
                 FROM EMPLOYEE)
SELECT *  -- 순위,EMP_ID, SALARY  ->테이블의 출력 순서를 적어줘도 됨
FROM TOPN_SAL
WHERE 순위 <=5;



                        
---------------------------------------------------------------
--1. 70년대 생(1970~1979)중 여자면서 전씨인 사원의 사원명, 주민번호, 부서명, 직급
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE SUBSTR(EMP_NO,1,2)BETWEEN 70
    AND 79 AND SUBSTR(EMP_NO,8,1)IN('2','4')
    AND EMP_NAME LIKE '전%';


--2.나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, 
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')) 나이
    ,DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM SYSDATE) -EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')) = 
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE) -EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))
FROM EMPLOYEE);

--막내
EXTRACT(YEAR FROM SYSDATE) -EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')) = 
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE) -EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))
FROM EMPLOYEE;


--3.이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회

SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '%하%';

-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE DEPT_CODE IN ('D5','D6');

-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
 JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
 JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
 WHERE BONUS IS NOT NULL;
 
-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
LEFT JOIN LOCATION ON( LOCATION_ID = LOCAL_CODE);

 -- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 
 SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
 FROM EMPLOYEE
 JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
 JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
 JOIN NATIONAL USING (NATIONAL_CODE)
 WHERE NATIONAL_NAME IN('한국','일본');
 
 -- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
 SELECT EMP_NAME, DEPT_CODE
 FROM EMPLOYEE
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하정연');

- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회 (NVL 이용)
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE NVL(BONUS,0) = 0
AND JOB_CODE IN ('J4','J7');

-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
SELECT COUNT(ENT_YN)
FROM EMPLOYEE
WHERE ENT_YN = 'N';
SELECT COUNT(ENT_YN)
FROM EMPLOYEE
WHERE ENT_YN = 'Y';
--그룹으로 묶으면 둘 다 나오잖아~
SELECT COUNT(*)
FROM EMPLOYEE
GROUP BY ENT_YN;

 --**다시**11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
 SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, 순위
 FROM(SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE,
                SALARY*NVL(1+BONUS,1)*12연봉,
                RANK() OVER(ORDER BY(SALARY*NVL(1+BONUS,1)*12)DESC)순위
        FROM EMPLOYEE)
 JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
 JOIN JOB USING(JOB_CODE);
 

--**다시**12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--12-1. JOIN과 HAVING 사용    
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2
                    FROM EMPLOYEE);
-- 12-2. 인라인 뷰 사용     
SELECT *
FROM(SELECT DEPT_TITLE, SUM(SALARY)급여합
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
    GROUP BY DEPT_TITLE)
WHERE 급여합 > (SELECT SUM(SALARY)*0.2
                    FROM EMPLOYEE);

--12-3. WITH 사용
WITH SSUM AS(SELECT DEPT_TITLE, SUM(SALARY)급여합
            FROM EMPLOYEE
            JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
            GROUP BY DEPT_TITLE)
SELECT *
FROM SSUM
WHERE 급여합 > (SELECT SUM(SALARY)*0.2
                    FROM EMPLOYEE);

 --13. 부서명별 급여 합계 조회(NULL도 조회되도록)
 SELECT DEPT_TITLE,SUM(SALARY)
 FROM EMPLOYEE
 LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
 GROUP BY DEPT_TITLE;
 
 
 -- 안함 14. WITH를 이용하여 급여합과 급여평균 조회
 WITH SUM_SAL AS (SELECT SUM(SALARY)
                FROM EMPLOYEE)
SELECT *
FROM SUM_SAL;

WITH AVG_SAL AS (SELECT CEIL(AVG(SALARY))
                FROM EMPLOYEE)
SELECT *
FROM AVG_SAL;
---두개 한꺼번에 할 수 있음!!
WITH SUM_SAL AS (SELECT SUM(SALARY) FROM EMPLOYEE),
     AVG_SAL AS (SELECT CEIL(AVG(SALARY))FROM EMPLOYEE)
SELECT *
FROM SUM_SAL, AVG_SAL;