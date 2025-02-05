/*
    <GROUP BY절>
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/

--각 부서 별 총 급여액
SELECT DEPT_CODE, SUM(SALARY)  
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서 별 사원 수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, SUM(SALARY), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 직급별 사원 수와 급여의 총합
SELECT JOB_CODE, SUM(SALARY), COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

--직급별 사원 수와 보너스를 받는 사원수, 급여합, 평균급여, 최저급여, 최고급여
SELECT JOB_CODE, COUNT(*), COUNT(BONUS), SUM(SALARY), ROUND(AVG(SALARY)), MIN(SALARY), MAX(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

--남, 여별 사원 수
SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여'), COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);

--GROUP BY 절에 여러 컬럼 기술 가능
SELECT DEPT_CODE,JOB_CODE,COUNT(*),SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE, JOB_CODE;

-----------------------------------------
/*
    <HAVING 절>
    그룹에 대한 조건을 제시할 때 사용되는 구문
*/

-- 각 부서별 평균 급여가 300만원인 부서들만 조회
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;

------실습문제-----
--1. 직급별 총 급여합(단, 직급별 급여 합이 1000만원 이상인 직급만 조회), 직급코드, 급여합 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

--2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드를 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

--------------------------------------------
/*
    <SELECT문 실행 순서>
    FROM
    ON : 조인 조건 확인
    JOIN : 테이블간의 조인
    WHERE
    GROUP BY
    HAVING
    SELECT  -- 이 위엔 별칭 못함
    DISTINCT
    ORDER BY
*/

--------------------------------------------
/*
    <집계함수>
    그룹별로 산출된 결과 값에 중간집계를 계산해주는 함수
    
    ROLLUP, CUBE
    -> GROUP BY 절에서 기술하는 함수
    
    -ROLLUP(컬럼1, 컬럼2): 컬럼1을 가지고 다시 중간집계를 내는 함수
    -CUBE(컬럼1, 컬럼2): 컬럼1을 가지고 중간집계를 내고, 컬럼 2도 중간집계를 냄
*/

-- 각 직급 별 급여의 합
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

--컬럼이 1개 일때는 CUBD, ROLLUP 안쓴것과 동일
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY JOB_CODE;

--컬럼이 2개일때 사용
SELECT JOB_CODE, DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE, DEPT_CODE
ORDER BY JOB_CODE, DEPT_CODE;

--ROLLUP
SELECT JOB_CODE, DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE, DEPT_CODE)  --JOB_CODE를 기준으로 겹칠 때 중간집계
ORDER BY JOB_CODE, DEPT_CODE;

--CUBE
SELECT JOB_CODE, DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE, DEPT_CODE)  -- 두 컬럼 다 중간집계
ORDER BY JOB_CODE, DEPT_CODE;
-----------------------------------
/*
    <집합 연산자>
    여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
    
    - UNION : OR | 합집합
    - INTERSECT: AND | 교집합
    - UNION ALL : 합집합 + 교집합
    - MINUS : 차집합
*/

----------------------------------------
-- 부서코드가 'D5' 인 사원 또는 급여가 300만원 초과인 사원 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;




