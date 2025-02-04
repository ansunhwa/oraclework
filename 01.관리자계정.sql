-- 한줄주석 (단축기 : ctrl + /) 대소문자 상관없이 써도 됩니다
/*
 여러 줄 주석
 주석  (블럭잡고)
 alt + shift + C
*/

--나의 계정 보기
show USER;

-- 사용자 계정 조회
SELECT * FROM DBA_USERS;

SELECT USERNAME,ACCOUNT_STATUS FROM DBA_USERS;

-- 사용자 만들기
-- 오라클 12버전부터 일반사용자는 C##(대소문자 안가림)으로 시작하는 이름을 가져야 한다
CREATE USER C##user1 IDENTIFIED BY 1234;

-- c##을 회피하는 방법
ALTER SESSION SET "_oracle_script"= true;

CREATE USER user1 IDENTIFIED BY 1234;

--사용할 계정 만들기
--계정이름은 대소문자 상관없음
--비밀번호는 대소문자 구분해야함
CREATE USER tjoeun IDENTIFIED BY 1234;

-- 권한 생성   권한은 관리자 계정에서 줄 수있다
-- [표현법] GRANT 권한1, 권한2,... TO 계정명;
GRANT CONNECT TO TJOEUN;
GRANT RESOURCE TO tjoeun;
-- 사용자에게 줄 수 있는 디폴트 값 용량주기
-- insert 시 '테이블 스페이스users 에 대한 권한이 없습니다 / 라고 뜨면
ALTER USER tjoeun default tablespace users quota unlimited on users;
-- alter user tjoeun quota 50m on quota  이건 50m 만큼 공간 줌




