-- 3. 권한 부여 받은 후
CREATE TABLE TEST(
    TEST_ID NUMBER,
    TEST_NAME VARCHAR2(20)
    );
    
-- 4. 권한 부여 후
INSERT INTO TEST VALUES(1,'HI');

-- 5. 권한 부여 후
SELECT *
FROM TJOEUN.EMPLOYEE;

-- 6. 권한 부여 후
INSERT INTO TJOEUN.EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE) 
                    VALUES(302, '홍길동', '21324-2947493','J2') ;
                    
        COMMIT;  --다른계정 테이블에도 접근 가능

        