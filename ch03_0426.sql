---- SELECT ----
DESC EMPLOYEES;

-- 사원 테이블에서 급여가 5000이 넘는 사원번호와 사원명을 조회한다.
SELECT EMPLOYEE_ID, EMP_NAME
    FROM EMPLOYEES
    WHERE SALARY > 5000;
    
SELECT EMPLOYEE_ID, EMP_NAME
    FROM EMPLOYEES
    WHERE SALARY > 5000
    ORDER BY EMPLOYEE_ID;

-- 급여가 5000 이상이고 JOB_ID가 'IT_PROG'인 사원 조회
SELECT EMPLOYEE_ID, EMP_NAME, SALARY
    FROM EMPLOYEES
    WHERE SALARY > 5000
        AND JOB_ID = 'IT_PROG'
    ORDER BY EMPLOYEE_ID;

SELECT EMPLOYEE_ID, EMP_NAME, SALARY
    FROM EMPLOYEES
    WHERE SALARY > 5000
        AND JOB_ID = 'it_prog' -- 데이터의 대소문자 구분
    ORDER BY EMPLOYEE_ID;

-- 급여가 5000 이상이고 JOB_ID가 'IT_PROG'인 사원 조회
SELECT EMPLOYEE_ID, EMP_NAME, SALARY
    FROM EMPLOYEES
    WHERE SALARY > 5000
        OR JOB_ID = 'IT_PROG'
    ORDER BY EMPLOYEE_ID;

---- INSERT ----
CREATE TABLE ex3_1 (
    COL1 VARCHAR2(10)
    , COL2 NUMBER
    , COL3 DATE
);

-- 각 컬럼별 데이터 삽입
INSERT INTO ex3_1(COL1, COL2, COL3)
    VALUES ('ABC', 10, SYSDATE);

-- 컬럼 순서를 바꿔도 됨
INSERT INTO ex3_1(COL3, COL1, COL2)
    VALUES (SYSDATE, 'DEF', 20);

-- 컬럼 타입이 다르면 안 됨
INSERT INTO ex3_1(COL1, COL2, COL3)
    VALUES ('ABC', 10, 30);
-- SQL 오류: ORA-00932: 일관성 없는 데이터 유형: DATE이(가) 필요하지만 NUMBER임
-- 00932. 00000 -  "inconsistent datatypes: expected %s got %s"

-- 모든 컬럼에 값을 삽입할 때는 컬럼명 생략해도 됨
INSERT INTO ex3_1
    VALUES ('GHI', 10, SYSDATE);

INSERT INTO ex3_1  (col1, col2 )
    VALUES ('GHI', 20);

INSERT INTO ex3_1
    VALUES ('GHI', 30);
-- SQL 오류: ORA-00947: 값의 수가 충분하지 않습니다
-- 00947. 00000 -  "not enough values"

-- INSERT ~ SELECT 형태 (실무에서 자주 사용)
CREATE TABLE ex3_2 (
           emp_id    NUMBER,
           emp_name  VARCHAR2(100));

INSERT INTO ex3_2 ( emp_id, emp_name )
    SELECT employee_id, emp_name
      FROM employees
     WHERE salary > 5000;
        
INSERT INTO ex3_1 (col1, col2, col3)
    VALUES (10, '10', '2014-01-01');


---- UPDATE ----
-- ALTER : 테이블 속성 변경
-- UPDATE : 데이터 값을 변경
UPDATE ex3_1
       SET col2 = 50;
       
SELECT *
      FROM ex3_1;

UPDATE ex3_1
       SET col3 = SYSDATE
     WHERE col3 = '';

UPDATE ex3_1
       SET col3 = SYSDATE
     WHERE col3 IS NULL;
    
     
---- MERGE ----
CREATE TABLE ex3_3 (
    employee_id NUMBER,
    bonus_amt   NUMBER DEFAULT 0
);

INSERT INTO ex3_3 (employee_id)
    SELECT e.employee_id
      FROM employees e, sales s
     WHERE e.employee_id = s.employee_id
       AND s.SALES_MONTH BETWEEN '200010' AND '200012'
     GROUP BY e.employee_id;

SELECT *
      FROM ex3_3
     ORDER BY employee_id;

-- 서브 쿼리 활용
-- (1) 관리자 사번(manager_id)이 146번인 사원 찾기
-- (2) ex3_3 테이블에 있는 사원의 사번과 일치하면
--     보너스 금액에 자신의 급여 1%를 보너스로 갱신
-- (3) ex3_3 테이블에 있는 사원의 사번과 일치하지 않으면
--     (1)의 결과의 사원을 신규로 입력 (이때 보너스 급액은 급여의 0.1%)
-- (4) 이때 급여가 8000 미만인 사원만 처리하기

-- ex3_3 테이블에 있는 사원의 사번, 관리자 사번, 급여, 보너스(급여*1%) 조회
SELECT employee_id, manager_id, salary, salary * 0.01 AS bonus
    FROM employees
    WHERE employee_id IN (SELECT employee_id FROM ex3_3)

-- 사원 테이블에서 관리자 사번이 146인 것 중에서
-- ex3_3 테이블에 없는 사원의 사번, 관리자 사번, 급여, 보너스(급여*0.1%) 조회
SELECT employee_id, manager_id, salary, salary * 0.01 AS bonus
    FROM employees
    WHERE employee_id NOT IN (SELECT employee_id FROM ex3_3)
        AND manager_id = 146;

MERGE INTO ex3_3 d
    USING (SELECT
                employee_id
                , salary
                , manager_id
            FROM employees
            WHERE manager_id = 146) b
        ON (d.employee_id = b.employee_id)
    WHEN MATCHED THEN
            UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01
    WHEN NOT MATCHED THEN
            INSERT (d.employee_id, d.bonus_amt)
                VALUES (b.employee_id, b.salary *.001)
                WHERE (b.salary < 8000);

SELECT * FROM ex3_3
    ORDER BY employee_id;
    
-- UPDATE 절에 DELETE WHERE 구문을 추가할 수 있음
-- 특정 조건에 맞는 데이터를 삭제하는 구문
MERGE INTO ex3_3 d
    USING (SELECT
                employee_id
                , salary
                , manager_id
            FROM employees
            WHERE manager_id = 146) b
        ON (d.employee_id = b.employee_id)
    WHEN MATCHED THEN
            UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01
            DELETE WHERE (b.employee_id = 161)
    WHEN NOT MATCHED THEN
            INSERT (d.employee_id, d.bonus_amt)
                VALUES (b.employee_id, b.salary *.001)
                WHERE (b.salary < 8000);
                
SELECT * FROM ex3_3 ORDER BY employee_id;

---- DELETE ----
DELETE ex3_3;

SELECT * FROM ex3_3 ORDER BY employee_id;


---- Commit / Rollback / Truncate ----
-- Commit : 변경한 데이터를 DB에 반영
-- Rollback : Commit을 수행한 데이터를 변경하기 이전 상태로 되돌림
CREATE TABLE ex3_4 (
    employee_id NUMBER
);

INSERT INTO ex3_4 VALUES(100);

SELECT * FROM ex3_4;

commit;
rollback;

-- DELETE문은 데이터 삭제 후 COMMIT 필요, ROLLBACK으로 복구 가능
-- TRUNCATE문은 바로 데이터가 삭제되고 ROLLBACK으로 복구할 수 없음
SELECT * FROM ex3_4;
TRUNCATE TABLE ex3_4;