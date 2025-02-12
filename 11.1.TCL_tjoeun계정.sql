/*
    TCL(TRANSACTION CONTROL LANGUAGE) : 트랜잭션 제어언어
    
    트랜잭션
     - 데이터베이스의 논리적 연산단위
     - 데이터의 변경사항(DML)들을 하나의 트랜잭션에 묶어서 처리
       DML문 한개를 수행할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
                            트랜잭션이 존재하지 않으면 트랜잭션을 만들어서 묶어서 처리
       COMMIT 하기 전까지 변경사항들을 하나의 트랜잭션에 담는다
     - 트랜잭션의 대상이 되는 SQL : INSERT, UPDATE, DELETE
     
     *COMMIT (트랜잭션 종류 처리 후 확정)
       - 한 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영시킴(트랜잭션 없어짐) 
     *ROLLBACK (트랜잭션 취소)
       - 트랜잭션에 담겨있는 변경사항들을 삭제(취소) 한 후 마지막 COMMIT시점으로 돌아감
     *SAVEPOINT (임시저장)
       - 현재 이 시점에 해당포인트명으로 임시저장점을 정의해둠
        ROLLBACK 진행 시 변경사항들을 다 삭제 하는게 아니라 일부만 삭제 가능
*/

SELECT * FROM EMP_01;

--사번이 301번인 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 301;
-- 트랜잭션 생성됨 DELETE 301

-- 사번210 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 210;
-- 트랜잭션에 추가 됨 DELETE 301, 210

ROLLBACK; -- 트랜잭션에 있는 내용 + 트랜잭션 삭제/지웠던 201,210 복원

----------------------------------------------------------------
--사번이 201 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID= 201;
--트랜잭션 생성 DELETE 201

SELECT * FROM EMP_01;

INSERT INTO EMP_01 
    VALUES('302','홍길동','D4'); 
-- 트랜잭션 추가 DELETE201, INSERT 302

COMMIT;  -- (확정)트랜잭션에 추가된 내용들이 실제DB로 추가됨 / 트랜잭션 사라짐

ROLLBACK; --COMMIT이 되었기 때문에 롤백 안됨

---------------------------------------------------------------
DELETE FROM EMP_01
WHERE EMP_ID IN(210,217,214);
-- 트랜잭션 생성 DELETE 210,217,214

--사원 추가
INSERT INTO EMP_01
    VALUES('303','이순신','D2');

SAVEPOINT SP; -- 이름은 마음대로 지정해도 됨
-- 트랜잭션 DELETE210,217,214, INSERT 303, SP

--218 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 218;
---- 트랜잭션 DELETE210,217,214, INSERT 303, SP, DELETE218

-- 내가 임시저장한 곳까지만 롤백
ROLLBACK TO SP;  -- SP 쓰지 않으면 트랜잭션에 담긴거 다 지워짐

SELECT * FROM EMP_01; --218은 살아남

COMMIT; --모든 트랜잭션이 실행됨

-------------------------------------------------------
/*
    * 자동 COMMIT이 되는 경우
      - 정상 종료
      - DCL과 DDL명령문이 수행된 경우
      
    * 자동 ROLLBACK이 되는 경우
      - 비정상 종료
      - 전원 꺼짐. 정전. 컴퓨터 DOWN 
*/

--사번 302, 303지우기
DELETE FROM EMP_01
WHERE EMP_ID IN('302','303');

--사번205 지우기
DELETE FROM EMP_01
WHERE EMP_ID = '205';
-- 트랜잭션 DELETE 302,303,205

--DDL문, 테이블 생성
CREATE TABLE TEST(
    TID NUMBER
    );
--DDL문은 COMMIT을 쓰지 않아도 바로 실제DB문 작성됨
--DELETE문도 같이 자동으로 COMMIT이 됨
--DDL문(CREATE, ALTER, DROP)을 수행하는 순간 기존의 트랜잭션에 있던 변경사항들을 무조건 COMMIT해줌

ROLLBACK;
--ROLLBACK 안됨

SELECT * FROM EMP_01;
--DDL문(CREATE, ALTER, DROP)을 수행하는 순간 기존의 트랜잭션에 있던 변경사항들을 무조건 COMMIT해줌
















