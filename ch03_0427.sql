---- DDL(Data Definition Language)
-- 테이블 생성 : CREATE
-- 테이블 속성 변경 : ALTER
-- 테이블 삭제 : DROP
---- DML(Data Manipulation Language)
-- 데이터 조회 : SELECT
-- 데이터 삽입 : INSERT
-- 데이터 수정 : UPDATE
-- 데이터 삭제 : DELETE
---- DCL(Data Control Language)
-- 권한 부여 : GRANT
-- 권한 회수 : REVOKE
-- 연산 완료 : COMMIT
-- 연산 철회 : ROLLBACK

---- 연산자 ----
DESC employees;

SELECT employee_id || '-' || emp_name AS employee_info
    FROM employees
    WHERE ROWNUM < 5;


---- 표현식 ----
SELECT employee_id, salary,
    CASE WHEN salary <= 5000 THEN 'C등급'
         WHEN salary > 5000 AND salary <= 15000 THEN 'B등급'
         ELSE 'A등급'
    END AS salary_grade
    FROM employees;


---- 조건식 ----
-- 비교 조건식 (ANY, SOME, ALL)
-- ANY : OR의 의미를 가진다.
SELECT employee_id, salary
    FROM employees
    WHERE salary = ANY(2000,3000,4000)
    ORDER BY employee_id;

-- ALL : AND의 의미를 가진다.
SELECT employee_id, salary
    FROM employees
    WHERE salary = ALL(2000,3000,4000)
    ORDER BY employee_id;

-- SOME : ANY와 동일한 결과
SELECT employee_id, salary
    FROM employees
    WHERE salary = SOME(2000,3000,4000)
    ORDER BY employee_id;


-- 논리 조건식 (AND, OR, NOT)
-- NOT
SELECT employee_id, salary
    FROM employees
    WHERE NOT (salary >= 2500)
    ORDER BY employee_id;
    
-- BETWEEN AND 조건식
SELECT employee_id, salary
    FROM employees
    WHERE salary BETWEEN 2000 AND 2500
    ORDER BY employee_id;

-- IN 조건식
SELECT employee_id, salary
    FROM employees
    WHERE salary IN(2000,3000,4000)
    ORDER BY employee_id;

SELECT employee_id, salary
    FROM employees
    WHERE salary NOT IN(2000,3000,4000)
    ORDER BY employee_id;

-- EXISTS (서브쿼리만 가능)
SELECT department_id, department_name
    FROM departments a
    WHERE EXISTS( SELECT *
                    FROM employees b
                    WHERE a.department_id = b.department_id
                        AND b.salary > 3000)
    ORDER BY a.department_name;

-- Like 조건식
SELECT emp_name
    FROM employees
    WHERE emp_name LIKE 'Al%'
    ORDER BY emp_name;

SELECT emp_name
    FROM employees
    WHERE emp_name LIKE '_a%'
    ORDER BY emp_name;
    
SELECT emp_name
    FROM employees
    WHERE emp_name LIKE '%n_'
    ORDER BY emp_name;

SELECT emp_name
    FROM employees
    WHERE emp_name LIKE '_a%l_'
    ORDER BY emp_name;

---- Self-Check ----
-- 1.
-- ex3_6이라는 테이블을 만들고,
-- 사원 테이블(employees)에서 관리자 사번이 124번이고 급여가 2000~ 3000 사이인 사원의
-- 사번, 사원명, 급여, 관리자 사번을 입력하는 INSERT문을 작성해 보자.
CREATE TABLE ex3_6 (
    employee_id NUMBER(6)
    , emp_name VARCHAR2(80)
    , salary NUMBER(8,2)
    , manager_id NUMBER(6)
);

INSERT INTO ex3_6
    (SELECT employee_id, emp_name, salary, manager_id
                FROM employees
                WHERE manager_id = 124
                    AND salary BETWEEN 2000 AND 3000);

-- 2.
-- 다음 문장을 실행해 보자.
DELETE ex3_3;
INSERT INTO ex3_3 (employee_id)
    SELECT e.employee_id
    FROM employees e, sales s
    WHERE e.employee_id = s.employee_id
    AND s.SALES_MONTH BETWEEN '200010' AND '200012'
    GROUP BY e.employee_id;
    
-- (manager_id)이 145번인 사원을 찾아 위 테이블에 있는 사원의 사번과 일치하면
-- 보너스 금액(bonus_amt)에 자신의 급여의 1%를 보너스로 갱신하고,
-- ex3_3 테이블에 있는 사원의 사번과 일치하지 않는 사원을
-- 신규로 입력(이때 보너스 금액은 급여의 0.5%)하는 MERGE문을 작성해 보자.
MERGE INTO ex3_3 d
    USING (SELECT employee_id
                , salary
                , manager_id
            FROM employees
            WHERE manager_id = 145) b
        ON (d.employee_id = b.employee_id)
    WHEN MATCHED THEN
        UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01
    WHEN NOT MATCHED THEN
        INSERT (d.employee_id, d.bonus_amt)
            VALUES (b.employee_id, b.salary * 0.005);

-- 3.
-- 사원 테이블(employees)에서 커미션(commission_pct) 값이 없는 사원의
-- 사번과 사원명을 추출하는 쿼리를 작성해 보자.

SELECT employee_id, emp_name
    FROM employees
    WHERE commission_pct IS NULL;

-- 4.
-- 아래의 쿼리를 논리 연산자로 변환해 보자.
/*
SELECT employee_id, salary
    FROM employees
    WHERE salary BETWEEN 2000 AND 2500
    ORDER BY employee_id;
*/

SELECT employee_id, salary
    FROM employees
    WHERE salary >= 2000 AND salary <= 2500
    ORDER BY employee_id;

-- 5.
-- 다음의 두 쿼리를 ANY, ALL을 사용해서 동일한 결과를 추출하도록 변경해 보자.
/*
SELECT employee_id, salary
    FROM employees
    WHERE salary IN (2000, 3000, 4000)
    ORDER BY employee_id;

SELECT employee_id, salary
    FROM employees
    WHERE salary NOT IN (2000, 3000, 4000)
    ORDER BY employee_id;
*/

SELECT employee_id, salary
    FROM employees
    WHERE salary = ANY(2000, 3000, 4000)
    ORDER BY employee_id;

SELECT employee_id, salary
    FROM employees
    WHERE salary <> ALL(2000, 3000, 4000)
    ORDER BY employee_id;