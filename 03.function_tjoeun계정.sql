/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과를 반환
    
    - 단일행 함수 : n개의 값을 읽어들여 n개의 결과값 반환(매 행마다 함수 실행)
    - 그룹 함수 : n개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
    
    >> SELECT절에 단일행 함수와 그룹함수를 함께 사용할 수 없음
    
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
*/

--------------------------------- 단일행 함수 -------------------------
---=====================
 --<문자 처리 함수>
--=====================
/*
    * LENGTH / LENGTHB  => NUMBER로 반환
    
    LENGTH(컬럼|'문자열') : 해당 문자열의 글자수를 반환
    LENGTHB(컬럼|'문자열') : 해당 문자열의 byte를 반환
        - 한글 : XE버전일 때 => 1글자당 3byte (ㄱ, ㅏ, 등도 1글자에 해당)
                   EE버전일 때 => 1글자당 2byte
        - 그외 : 1글자당 1byte
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;      -- 오라클에서 제공해주는 가상테이블

SELECT LENGTH('oracle'), LENGTHB('oracle')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

---------------------------------------------------------------
/*
    * ***INSTR : 문자열로 부터 특정 문자의 시작위치(INDEX)를 찾아서 반환(반환형 : NUMBER)
        - ORACLE은 INDEX번호는 1번부터 시작, 찾는 문자가 없을 때 0반환
        
    INSTR(컬럼|'문자열', '찾고자하는 문자', [찾을위치의 시작값, [순번]])
       - 찾을 위치값
         1: 앞에서부터 찾기(기본값)
         -1 : 뒤에서부터 찾기
*/

SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A') FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1) FROM DUAL;  
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 3) FROM DUAL;  
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1) FROM DUAL;

SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1, 3) FROM DUAL;    -- 앞에서부터 3번째 나오는 A의 INDEX번호
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1, 2) FROM DUAL; 

SELECT EMAIL, INSTR(EMAIL, '_') "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;

---------------------------------------------------------
/*
    * ***SUBSTR : 문자열에서 특정 문자열을 추출하여 반환(반환형 : CHARACTER)
    
      SUBSTR('문자열', POSITION, [LENGTH])
        - POSITION : 문자열을 추출할 시작위치  INDEX
        - LENGTH : 추출할 문자의 갯수(생략시 맨 마지막까지 추출)
*/

SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -3) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -7, 4) FROM DUAL;

-- EMPLOYEE테이블에서 주민번호에서 성별만 추출하여 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 주민번호에서 성별만 추출하여 여성 사원만 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- EMPLOYEE테이블에서 주민번호에서 성별만 추출하여 남성 사원만 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_N0, 8, 1)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

-- EMPLOYEE테이블에서 EMAIL에서 아이디만 추출하여 사원명, 이메일, 아이디를 조회
--SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL,1,INSTR(EMAIL,'@'

-----------------------------------
/*
    *LPAD / RPAD : 문자열을 조회할 때 통일감있게 자리수에 맞춰서 조회하고자 할 때 (반환형 : CHARACTER)
    
    LPAD / FPAD('문자열', 최종적으로 반환할 문자의 길이[덧붙히고자 하는 문자])
    문자열에 덧붙이고자 하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 n길이만큼의 문자열 반환
*/

SELECT EMP_NAME, LPAD(EMAIL,25)  --공백을 채움
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL,25,'#')  --#을 채움
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL,25,'#')  --#을 채움
FROM EMPLOYEE;

--EMPLOYEE테이블에서 주민번호를 형식123456-1***** 사번, 사원명, 주민번호 조회
SELECT EMP_ID,EMP_NAME, SUBSTR(EMP_NO,1,8)주민번호
FROM EMPLOYEE;

SELECT EMP_ID,EMP_NAME, RPAD(SUBSTR(EMP_NO,1,8),14,'*') 주민번호
FROM EMPLOYEE;

SELECT EMP_ID,EMP_NAME, SUBSTR(EMP_NO,1,8)||'******'주민번호
FROM EMPLOYEE;

-----------------------------
/*
     LTRIM / RTRIM : 문자열에서 특저문자를 제거한 나머지 반환(반환형 : CHARACTER)
     TRIM : 문자열의 앞/ 뒤 양쪽에 있는 특정 문자를 제거한 나머지 반환
     
     [표현법]
     LTRIM / RTRIM('문자열', [제거하고자 하는 문자])
     TRIM[LEADING | TRAILING | BOTH] 제거하고자 하는 문자 FROM'문자열' => 제거하고자 하는 문자는 1개만 가능
*/

SELECT LTRIM('     TJOEUN     ')||'더조은' 
FROM DUAL;  -- 제거할 문자를 넣지 않으면 공백제거

SELECT RTRIM('     TJOEUN     ')||'더조은'
FROM DUAL;

SELECT LTRIM('JAVAJAVASCRIPTJAVA','JAVA')
FROM DUAL;
SELECT LTRIM('BBAABCABACFDSIA','ABC')  --ABC이외의 다른 글자 나오면 제거안함
FROM DUAL;
SELECT LTRIM('17284DKS323','0123456789')
FROM DUAL;

SELECT TRIM('    TJOEUN    ')||'더조은'
FROM DUAL;

SELECT TRIM(LEADING'A' FROM 'AAABKADISKSLAAA')
FROM DUAL;
SELECT TRIM(TRAILING 'A' FROM 'AAABKADISKSLAAA')
FROM DUAL;

SELECT TRIM(BOTH 'A' FROM'AAAABKADISKASALAA')
FROM DUAL;   --앞, 뒤모두 다
SELECT TRIM('A' FROM 'AABKADAISAA') --앞과 뒤 모두 삭제 글자 하나!!
FROM DUAL;    --BOTH와 같음

---------------------------------------------
/*
    LOWER / UPPER / INTCAP : 문자열을 모두 대문자로 혹은 소문자로, 첫글자만대문자로 변환(반환형 : CHARACTER)
    
    [표현법]
    LOWER / UPPER/ INTCAP(문자열)
    
*/

SELECT LOWER('JAVA JAVASCRIPT Oracle')
from DUAL;

SELECT UPPER('JAVA JAVASCRIPT Oracle')
from DUAL;
SELECT INTCAP('JAVA JAVASCRIPT Oracle')
FROM DUAL;

------------------------------------
/*
    CONCAT : 문자열 2개를 전달받아 하나로 합친 문자 반환
    
    [표현법]
    DONCAT('문자열','문자열'
    */
SELECT CONCAT('Oracle', '오라클')
FROM DUAL;
SELECT 'Oracle'||'오라클'   -- 여러문자 가능
FROM DUAL;

--SELECT CONCAT('Oracal', '참', ' 재미있어요') 문자열 2개만 가능

------------------------------------------------
/*
    REPLACE : 기존문자열을 새로운 문자열로 바꿈
    
    [표현법]
    REPLACE('문자열','기존문자열','바꿀문자열')
*/

SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'TJOEUN.OR.KR','NAVER.COM')
FROM DUAL;

--=====================
 --<숫자처리함수>
--=====================

/*
    ABS : 숫자의 절대값을 구해주는 함수
    
    ABS(NUMBER)
*/

-----------------------------
/*
    MOD : 두수를 나눈 나머지값을 반환해주는 함수
    
    [표현법]
    MOD(NUMBER,NUMBER)
*/

SELECT MOD(10,3) FROM DUAL;

------------------------------
/*
    ROUND : 반올림한 결과를 반환해주는 함수
    
    [표현법]
    ROUND(NUMBER,[위치])
*/

SELECT ROUND(1234.567)FROM DUAL; --위치 생략시 0
SELECT ROUND(12.345)FROM DUAL;
SELECT ROUND(1234.56789 , 2) FROM DUAL;
SELECT ROUND(12.34, 4) FROM DUAL;
SELECT ROUND(1234.5678, -2) FROM DUAL;

-------------------------------
/*
    CEIL : 무조건 올림
    
    [표현법]
    CEIL(NUMBER)
*/
SELECT CEIL(123.45) FROM DUAL;
SELECT CEIL(-123.45) FROM DUAL;

---------------------
/*
    FLOOR : 무조건 내림
    
    [표현법]
    FLOOR(NUMBER) 
*/
SELECT FLOOR(123.45) FROM DUAL;
SELECT FLOOR(-123.45) FROM DUAL;

----------------------
/*
    TRUNC : 위치 지정 가능한 버림처리 함수
    
    [표현법]
    TRUNC(NUMBER,[위치])
*/

SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.789,1) FROM DUAL;
SELECT TRUNC(123.789,-1) FROM DUAL;


--===========================
--        <날짜처리함수>
--==============================
/*
    SYSDATE : 시스템 날짜 및 시간 반환
*/
SELECT SYSDATE FROM DUAL;

------------------------------------------
/*
    MONTHS_BETWEEN(DATE1, DATE2) : 두 날자 사이의 개월 수 반환
*/
--EMPLOYEE에서 오늘날짜까지 근무 일수( 소수점까지 나옴)
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE 근무일수
FROM EMPLOYEE;

--EMPLOYEE에서 오늘날짜까지 근무 일수( 정수 - 올림하기 )
SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE - HIRE_DATE) 근무일수
FROM EMPLOYEE;

--EMPLOYEE에서 오늘날짜까지 근무 개월 수( 소수점)
SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE)근무개월수
FROM EMPLOYEE;

--EMPLOYEE에서 오늘날짜까지 근무 개월 수(정수 - 올림)
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))||'개월차' 근무개월수
FROM EMPLOYEE;

--------------------------------
/*
    ADD_MONTHS(DATE,NUMBER): 특정 날짜에 해당 숫자만큼의 개월수를 더해 그 날짜를 반환
*/
SELECT ADD_MONTHS(SYSDATE,1) FROM DUAL;  --오늘 날짜의 1달 후

--EMPLOYEE테이블에서 사원명, 입사일, 정직원이 된 날짜(입사일에서 6개월 후)

SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) 
FROM EMPLOYEE;

------------------------------------
/*
    NEXT_DAY(DATE,요일(숫자|문자)) : 특정 날자 이후에 가장 가까운 해당 요일의 날짜를 반환해주는 함수
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE,'월요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE,'금') FROM DUAL;

-- 1 : 일요일, 2 : 월요일, 3 : 화요일
SELECT SYSDATE, NEXT_DAY(SYSDATE,2) FROM DUAL;
--SELECT SYSDATE, NEXT_DAY(SYSDATE,'FRIDAY')FROM DUAL; 영어라서 오류

--언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE,'FRIDAY')FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE,'금') FROM DUAL;  --언어변경안해서 안됨

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-------------------------
/*
    LAST_DAY(DATE) : 해당 월의 마지막 날짜를 반환해 주는 함수
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;

--EMPLOYEE테이블에서 사워명, 입사일, 입사한 달의 마지막 날짜 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

----------------------------------
/*
    EXTRACT : 특정날짜로 부터 년|월|일 값을 추출하여 반환해주는 함수 ( 반환형 : NUMBER)
    
    EXTRACT(YEAR FROM DATE) : 년도만 추출
    EXTRACT(NOMTH FROM DATE) : 월만 추출
    EXTRACT(DAY FROM DATE) : 일만 추출
*/

--사원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME
, EXTRACT(YEAR FROM HIRE_DATE) 입사년도
, EXTRACT(MONTH FROM HIRE_DATE) 입사월
, EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
ORDER BY 2, 3, 4;

--========================================
--        <형변환함수>
--========================================
/*
    TO_CHAR : 숫자나 날짜를 문자 타입으로 변환시켜주는 함수
    
    TO_CHAR(숫자|날짜,[포맷])
*/
---------------숫자타입 -> 문자타입
/*
    9: 해당 자리의 숫자를 의미한다.
        - 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
    0: 해당 자리의 숫자를 의미한다
        -값이 없을 경우 0으로 표시하며, 숫자의 길이를 고정적으로 표시할 때 주로 사용
    FM: 해당 자리에 값이 없을경우 자리차지하지 않음
*/
SELECT TO_CHAR(1234)FROM DUAL;  --숫자-오른쪽정렬, 문자 - 왼쪽정렬
SELECT TO_CHAR(1234,'999999') FROM DUAL; -- 6칸 공간 확보, 왼쪽정렬 빈칸은 공백
SELECT TO_CHAR(1234,'000000') FROM DUAL; -- 6칸 공간 확보, 왼쪽정렬, 빈칸은 0으로 채움
SELECT TO_CHAR(1234,'L99999') FROM DUAL; --현재 설정된 나라(로컬)화폐단위(빈칸공백), 오른쪽정렬

SELECT TO_CHAR(1234,'L99,999') FROM DUAL;  --3자리마다 ,

--EMPLOYEE테이블에서 사원명, 급여, 연봉
SELECT EMP_NAME, TO_CHAR(SALARY,'L9,999,999') 급여, TO_CHAR(SALARY*12, 'L999,999,999') 연봉
FROM EMPLOYEE;

SELECT TO_CHAR(123.456,'FM999990.999')  --값이 없을때 자리차지 하지 않음
    , TO_CHAR(1234.56, 'FM9990,99')
    , TO_CHAR(0.1000, 'FM9999.999')
    , TO_CHAR(0.1000, 'FM9990.999')
    FROM DUAL;
    
    SELECT TO_CHAR(123.456,'999990.999')
    , TO_CHAR(1234.56, '9990,99')
    , TO_CHAR(0.1000, '9999.999')
    , TO_CHAR(0.1000, '9990.999')
    FROM DUAL;
--------------------------날자 타입 -> 문자 타입
--시간
SELECT TO_CHAR(SYSDATE,'AM HH:MI:SS') FROM DUAL;  --12시간 형식
SELECT TO_CHAR(SYSDATE,'HH24:MI:SS') FROM DUAL;  --24시간 형식

--날짜
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD-DAY DY') FROM DUAL;  -- DAY - 화요일, DY - 화
SELECT TO_CHAR(SYSDATE, 'MON,YYYY') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY"년 " MM"월 " DD"일 " DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL;

--입사일(25-03-20)형태로 출력
SELECT TO_CHAR(HIRE_DATE, 'YY-MM-DD') 
FROM EMPLOYEE;

-- 입사일(2024년 3월 20일 화요일)
SELECT TO_CHAR(HIRE_DATE, 'DL') 
FROM EMPLOYEE;

-- 입사일(25년 03월 20일)
SELECT TO_CHAR(HIRE_DATE, 'YY"년 " MM "월 " DD"일" ') 
FROM EMPLOYEE; 

--년도
/*
    YY는 무조건 앞에'20'이 붙는다
    rr는 50년을 기준으로 50보다 작으면 앞에 '20'을 붙이고, 50보다 크면 '19'를 붙인다
*/
select TO_CHAR(SYSDATE,'YYYY')
    , TO_CHAR(SYSDATE,'YY')
    ,TO_CHAR(SYSDATE,'rrrr')
    ,TO_CHAR(SYSDATE,'rr')
FROM DUAL;

--월
SELECT TO_CHAR(SYSDATE,'MM')
    , TO_CHAR(SYSDATE,'MON')  --영문일때 3글자만
    , TO_CHAR(SYSDATE,'MONTH')
    , TO_CHAR(SYSDATE,'RM')  --로마자
 FROM DUAL;
    
--일
SELECT TO_CHAR(SYSDATE,'DDD') -- 년을 기준으로 몇일째
    , TO_CHAR(SYSDATE,'DD')   -- 월을 기준으로 몇일째
    , TO_CHAR(SYSDATE,'D')    -- 주를 기준으로 몇일째
 FROM DUAL;
    
--요일
SELECT TO_CHAR(SYSDATE,'DAY') -- 년을 기준으로 몇일째
    , TO_CHAR(SYSDATE,'DY')   -- 월을 기준으로 몇일째
 FROM DUAL;
 
 -------------------------------------------
 /*
    TO_DATE : 숫자 또는 문자 타입을 날짜타입으로 변환
    
    TO_DATE(숫자|문자,[포맷]
 */
 
SELECT TO_DATE(20241230)FROM DUAL;
SELECT TO_DATE(241230)FROM DUAL;

--SELECT TO_DATE(050101)FROM DUAL; --앞이 0일떄 오류 0을 없는 거로 봄 5자리 숫자임
SELECT TO_DATE('050101')FROM DUAL; -- 앞이 0일때는 문자형태로 넣어줘야 함

--SELECT TO_DATE('070204 142530', 'YYMMDD HHMISS') FROM DUAL; -- 오류 12시간제로 출력 14시는 없음
--SELECT TO_DATE('070204 142530', 'YY24MMDD HHMISS') FROM DUAL; -- 변환 후 사용해야함

SELECT TO_CHAR(TO_DATE('070204 022530','YYMMDD HHMISS'),'YY-MM-DD HH:MI:SS') FROM DUAL;

SELECT TO_DATE('040325', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('980630', 'YYMMDD') FROM DUAL;  -- 현재 세기 반영

SELECT TO_DATE('040325', 'RRMMDD') FROM DUAL;
SELECT TO_DATE('980630', 'RRMMDD') FROM DUAL; -- 50미만일 경우 현재세기, 50 이상이면 이전 세기 반영

---------------------------------------
/*
    TO_NUMBER : 문자타입을 숫자타입으로 변환
    
    TO_NUMBER(문자,[포맷])
*/
SELECT TO_NUMBER('012341234')FROM DUAL;
SELECT '1000000'+'5000000' FROM DUAL;   -- 오라클은 자동 형변환됨
--SELECT TO_NUMBER('1,000,000','9,999,999') + TO_NUMBER('5,000,000', 9,999,999') FROM DUAL;

--===============================
--     <NULL처리 함수>
--================================
/*
   *** NVL(컬럼, 해당컬럼이 NULL일 경우 반환할 값)
*/

SELECT  EMP_NAME, BONUS,NVL(BONUS,0)
FROM EMPLOYEE;

--전 사원의 이름, 보너스 포함 연봉
SELECT EMP_NAME, SALARY*(1+BONUS)*12
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY*(1+NVL(BONUS,0))*12
FROM EMPLOYEE;

--사원명, 부서코드(부서가 없으면'부서없음'
SELECT EMP_NAME, NVL(DEPT_CODE,'부서없음')
FROM EMPLOYEE;

-----------------------------
/*
    NVL2(컬럼, 반환값1, 반환값2)
    - 컬럼에 값이 존재하면 반환값1
    - 컬럼에 값이 존재하지 않으면 반환값2
*/

--사원명, 부서(부서에속해있으면'부서있음', 부서가 없으면 '부서없음'
SELECT EMP_NAME, NVL2(DEPT_CODE,'부서없음','부서없음')
FROM EMPLOYEE;

--사원명, 급여, 보너스, 성과급(보너스를 받는 사람은 30% 주고, 보너스 못받는 사람은 10%
SELECT EMP_NAME, BONUS, SALARY*NVL2(BONUS,0.4,0.1)
FROM EMPLOYEE;

---------------------------------------------
/*
    NULLIF(비교대상1, 비교대상2)
    - 두개의 값이 일치하면 NULL반환
    - 두개의 값이 일치하지 않으면 비교대상 1의 값 반환
*/
SELECT NULLIF('123','123') FROM DUAL;
SELECT NULLIF('123','345') FROM DUAL;

--===========================================
--               <선택함수>
--===========================================

/*
    DECODE(비교하고자 하는 대상(컬럼|산술연산|함수식), 비교값1, 결과값1, 비교값2, 결과값2,...)
    
    switch(비교대상){
    case 비교값1:
        결과값1;
        break;
    case 비교값2:
        결과값2;
    }
*/
-- 사번, 사원명, 주민번호, 성별(남,여)
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1),'1', '남', '2', '여', '3', '남', '4', '여')성별  --인덱스 번호 8번에서 글자 하나만 가져오세요
FROM EMPLOYEE;

--사원명, 직급코드, 기존급여, 인상된 급여
/*
    인상된 급여 -> SALARY*0.1+SALARY 인데 1.1 하면 바로 급여가 더해짐
    J7: 10%인상    SALARY*1.1
    J6: 15%인상    SALARY*1.15
    J5: 20%인상    SALARY*1.2
    그외: 5% 인상   SALARY*1.05
*/
SELECT EMP_NAME, JOB_CODE, SALARY
    ,DECODE(JOB_CODE,'J7',SALARY*1.1
                    ,'J6',SALARY*1.15
                    ,'J5',SALARY*1.2
                    ,SALARY*1.05) "인상된 급여"
FROM EMPLOYEE;

----------------------------------------------
/*
    CASE WHEN THEN
    END
    
    CASE WHEN 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값2
         ...
         ELSE 결과값
    END
    
    - IF문과 동일     
    IF(조건식){조건식이 참일 때 실행
    ELSE IF(조건식){조건식이 참일 때 실행}
    ELSE IF(조건식){조건식이 참일 때 실행}
    ...
    ELSE(실행문)
*/

-- 사원명, 급여, 등급, 급여에 따라 등급(5백이상 '고급', 5백~3백 '중급', 나머지 '초급')
SELECT EMP_NAME, SALARY
    , CASE WHEN SALARY >= 5000000 THEN'고급'
           WHEN SALARY >= 3000000 THEN'중급'
                ELSE '초급'
        END 등급
FROM EMPLOYEE;

--============================
--             <그룹함수>
--============================

/*
    SUM(숫자타입의 컬럼): 해당 컬럼 값들의 총 합계를 반환해주는 함수
*/

-- 전 사원의 총 급여의 합
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 남자사원의 총 급여의 합
SELECT SUM(SALARY)
FROM EMPLOYEE
--WHERE SUBSTR(EMP_NO,8,1) = '1' OR SUBSTR(EMP_NO,8,1) = '3'
WHERE SUBSTR(EMP_NO,8,1)IN('1','3');

-- 부서코드가 D5인 사원의 연봉의 총합
SELECT SUM(SALARY*12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 부서코드가 D5인 사원의 보너스를 포함한 연봉의 총합
SELECT SUM(SALARY*NVL(BONUS,1)*12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 전 사원의 총 급여의 합 형식000,000,000
SELECT TO_CHAR(SUM(SALARY),'L999,999,999') "총 급여의 합"
FROM EMPLOYEE;

-------------------------------------------
/*
    AVG(숫자타입의 컬럼) : 해당 컬럼값의 평균을 반환해주는 함수
*/

--전체 사원의 급여의 평균
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;


SELECT ROUND(AVG(SALARY),2)
FROM EMPLOYEE;

-------------------------------------------
/*
    MIN(모든타입의 컬럼) : 해당 컬럼값들 중 가장 작은값을 반환해 주는 함수
    MAX(모든타입의 컬럼) : 해당 컬럼값들 중 가장 큰값을 반환해 주는 함수
    (문자도 가능)
*/
SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;  --각자 다 따로인 값

SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

------------------------------------
/*
    ***COUNT(* |컬럼|DISTINCT 컬럼): 행 갯수 반환   
    
    COUNT(*) : 조회된 결과의 모든 행의 갯수 반환
    COUNT(컬럼): 컬럼의 NULL값을 제외한 행의 갯수 반환
    COUNT(DISTINCT 컬럼) : 컬럼값에서 중복을 제거한 행의 갯수 반환
*/

-- 전체 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE;

--여자사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)IN('2','4');

--보너스를 받는 사원의 수
SELECT COUNT(BONUS)  --NULL값을 제외
FROM EMPLOYEE;

--현재 사원들이 총 몇개의 부서에 분포되어 있는지
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;



------연습문제------
--1사원명과 주민번호를 이용해 생년, 월, 일 조회
SELECT EMP_NAME
, SUBSTR(EMP_NO,1,2) 년
, SUBSTR(EMP_NO,3,2) 월
, SUBSTR(EMP_NO,5,2) 일
FROM EMPLOYEE;

--2 사원명, 주민번호 조회(생년월일만보이게하고-다음값은*)
SELECT EMP_NAME, SUBSTR(EMP_NO,1,7)||'*******'
FROM EMPLOYEE;

--3 사원명, 입사일-오늘, 오늘-입사일 조회
SELECT EMP_NAME, FLOOR(ABS(HIRE_DATE - SYSDATE)) 근무일수1, FLOOR(SYSDATE - HIRE_DATE) 근무일수2
FROM EMPLOYEE;

--4 사번이 홀수인 직원들의 정보 모두 조회
SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID,2) = 1;
--WHERE MOD(TO_NUMBER(EMP_ID),2)=1;

--5 근무년수가 20년 이상인 직원
SELECT *
FROM EMPLOYEE
WHERE MONTHS_BETWEEN(SYSDATE,HIRE_DATE) > 20*12;

--6사원명, 급여조회
SELECT EMP_NAME, TO_CHAR(SALARY,'L9,000,000')
FROM EMPLOYEE;

--7 직원명, 부서코드, 생년월일, 나이조회(생년월일은 주민번호에서 추출
SELECT EMP_NAME, DEPT_CODE
, SUBSTR(EMP_NO,1,2)||'년 ' 년
, SUBSTR(EMP_NO,3,2)||'월 ' 월
, SUBSTR(EMP_NO,5,2)||'일 ' 일
, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RRRR')) AS 나이
FROM EMPLOYEE;

--8
SELECT EMP_ID, EMP_NAME, DEPT_CODE,
CASE
    WHEN DEPT_CODE = 'D5' THEN '총무부'
    WHEN DEPT_CODE = 'D6' THEN '기획부'
    WHEN DEPT_CODE = 'D9' THEN '영업부'
   END AS 부서명
FROM EMPLOYEE
WHERE DEPT_CODE IN('D5','D6','D9')
ORDER BY DEPT_CODE;

--9 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리
SELECT EMP_NAME, SUBSTR(EMP_NO,1,6), SUBSTR(EMP_NO,8), SUBSTR(EMP_NO,1,6)+SUBSTR(EMP_NO,8) 합
FROM EMPLOYEE
WHERE EMP_ID = '201';

--10 부서코드가 D5 인 직원의 보너스 포함 연봉의 합
SELECT SUM(SALARY*NVL(BONUS,1)*12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';


--11 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
SELECT COUNT(*) 전체직원수,
    COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),'2001', 1)) "2001년",
    COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),'2002', 1)) "2002년",
    COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),'2003', 1)) "2003년",
    COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),'2004', 1)) "2004년"
FROM EMPLOYEE;





