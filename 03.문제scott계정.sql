--연습문제--

----1 COMM값이 NULL이 아닌 정보
SELECT COMM
FROM EMP
WHERE COMM IS NOT NULL;

--2 커미션을 받지 못하는 직원 조회
SELECT ENAME
FROM EMP
WHERE COMM = '0';

--3 관리자가 업는 직원
SELECT ENAME
FROM EMP
WHERE MGR IS NULL;

--4 급여를 많이 받는 직원 순
SELECT ENAME, SAL
FROM EMP
ORDER BY SAL DESC;

--5 급여가 같을 경우 커미션을 내림차순 정렬
SELECT ENAME, SAL, COMM
FROM EMP
ORDER BY COMM DESC;

--6 사원번호 ,사원명, 직급, 입사일 조회(오름차순)
SELECT EMPNO, ENAME, DEPTNO, HIREDATE 
FROM EMP
ORDER BY HIREDATE;

--7 사원번호, 사원명 조회(사원번호 내림차순)
SELECT EMPNO, ENAME
FROM EMP
ORDER BY EMPNO DESC;

--8 사번, 입사일, 사원명, 급여조회 (부서번호 빠른순, 같을땐 입사일순)



--9오늘 날짜에 대한 정보 조회
SELECT SYSDATE FROM DUAL;

--10 사번, 사원명, 급여 조회(100단위 내림차순)
SELECT EMPNO, ENAME, SAL
FROM EMP;

--11 사원번호가 홀수인 사원 조회
SELECT ENAME
FROM EMP
WHERE MOD(EMPNO,2) = 1;

--12 사원명, 입사일 조회(입사일은 년도와 월을 분리)
SELECT ENAME, HIREDATE, 
    SUBSTR(HIREDATE,1,2)||'년' 년, SUBSTR(HIREDATE,1,2)||'월'월
FROM EMP;

--13 9월에 입사한 직원의 정보
SELECT *
FROM EMP
WHERE SUBSTR(HIREDATE,5,1) = '9';

--14 81년도에 입사한 직원
SELECT *
FROM EMP
WHERE SUBSTR(HIREDATE,1,2) = '81';

--15 이름이 'E'로 끝나는 직원 조회
SELECT ENAME
FROM EMP
WHERE ENAME LIKE '%E';

--16 이름의 세번째 글자가 'R'인 직원의 정보 조회
SELECT *
FROM EMP
WHERE ENAME LIKE '__R%';

SELECT *
FROM EMP
WHERE SUBSTR(ENAME,3,1) = 'R';

--17 사번, 사원명, 입사일, 입사일로부터 40년 되는 날짜
SELECT EMPNO, ENAME, HIREDATE, ADD_MONTHS(HIREDATE,40*12)
FROM EMP;

--18 입사일로부터 38년 이상 근무한 직원
SELECT *
FROM EMP
WHERE SYSDATE-HIREDATE = 38*12;


--19 오늘 날짜에서 년도만 추출
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;


