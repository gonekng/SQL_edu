---- 테이블 조인 ----
-- 연산자에 따른 구분 : 동등 조인, 안티 조인
-- 대상에 따른 구분 : 셀프 조인
-- 조건에 따른 구분 : 내부 조인, 외부 조인, 세미 조인, 카타시안 조인


---- 내부 조인(INNER JOIN) ----
-- 동등 조인(EQUI_JOIN) : 등호 연산자를 사용한 조건에 만족하는 데이터 추출
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
    FROM employees a, departments b
    WHERE a.department_id = b.department_id;

-- 세미 조인(SEMI_JOIN) : 서브쿼리에 존재하는 데이터만 메인 쿼리에서 추출
-- 일반 조인과 달리, 서브쿼리에 존재하는 메인쿼리 데이터가 여러 개 있어도 중복 없이 반환한다.
-- EXISTS : 조인 조건을 서브쿼리 안에서 명시
SELECT department_id, department_name
    FROM departments a
    WHERE EXISTS (SELECT *
                    FROM employees b
                    WHERE a.department_id = b.department_id
                        AND b.salary > 3000)
    ORDER BY a.department_name;

-- IN 사용 : 조인 조건을 서브쿼리 밖에서 명시
SELECT department_id, department_name
    FROM departments a
    WHERE a.department_id IN (SELECT b.department_id
                                FROM employees b
                                WHERE b.salary > 3000)
    ORDER BY a.department_name;

-- 안티 조인(ANTI_JOIN) : 세미 조인의 반대 개념
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
    FROM employees a, departments b
    WHERE a.department_id = b.department_id
        AND a.department_id NOT IN (SELECT department_id
                                        FROM departments
                                        WHERE manager_id IS NULL);

SELECT COUNT(*)
    FROM employees a
    WHERE NOT EXISTS (SELECT 1
                        FROM departments c
                        WHERE a.department_id = c.department_id
                            AND manager_id IS NULL);
-- 사원 테이블에는 부서 테이블에서 manager_id가 있는 부서의 사원들만 들어가 있음
-- 사원 테이블에 부서번호가 null인 사원이 1명 존재하는데,
-- NOT IN 연산에서는 출력되지 않고 NOT EXISTS 연산에서는 출력됨

-- 셀프 조인(SELF_JOIN) : 동일한 한 테이블을 사용하여 조인
-- 사원 테이블을 A, B로 나누고 같은 부서번호를 가진 사원 중 A 사원번호가 B 사원번호보다 작은 데이터 조회
SELECT a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
    FROM employees a, employees b
    WHERE a.employee_id < b.employee_id
        AND a.department_id = b.department_id
        AND a.department_id = 20;


---- 외부 조인(OUTER JOIN) ----
-- 내부 조인과 달리, 조인 조건에 만족하지 않더라도 데이터를 모두 추출함
SELECT a.department_id, a.department_name, b.job_id, b.department_id
    FROM departments a, job_history b
    WHERE a.department_id = b.department_id;

SELECT a.department_id, a.department_name, b.job_id, b.department_id
    FROM departments a, job_history b
    WHERE a.department_id = b.department_id (+);

SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
    FROM employees a, job_history b
    WHERE a.employee_id = b.employee_id (+)
        AND a.department_id = b.department_id (+);
-- 조인 대상 테이블 중 데이터가 없는 테이블 조인 조건에 (+)를 붙인다.
-- 외부 조인의 조인 조건이 여러 개일 경우에는 모든 조건에 (+)를 붙인다.
-- 한번에 한 테이블에만 외부 조인을 할 수 있다.
-- (+)연산자가 붙은 조건과 OR을 같이 사용할 수 없다.
-- (+)연산자가 붙은 조건에는 IN을 같이 사용할 수 없다. (IN절에 포함되는 값이 1개면 가능)


---- 카타시안 조인(CARTESIAN PRODUCT) ----
-- WHERE 절에 조인 조건이 없는 조인 (결과는 두 테이블 건수의 곱 형태)
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
    FROM employees a, departments b;

---- ANSI 조인 ----
-- ANSI SQL 문법을 사용한 조인 (FROM절에 조인 종류를, ON절에 조인 조건을 명시함)
-- 2003년 1월 1일 이후 입사한 사원의 사원번호, 사원명, 부서번호, 부서명 조회
-- ANSI 내부 조인
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
    FROM employees a
    INNER JOIN departments b
        ON (a.department_id = b.department_id)
        WHERE a.hire_date >= TO_DATE('2003-01-01', 'YYYY_MM_DD');

SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
    FROM employees a
    INNER JOIN departments b
        USING (department_id)
        WHERE a.hire_date >= TO_DATE('2003-01-01', 'YYYY_MM_DD');
-- ORA-25154: USING 절의 열 부분은 식별자를 가질 수 없음
-- 25154. 00000 -  "column part of USING clause cannot have qualifier"

SELECT a.employee_id, a.emp_name, department_id, b.department_name
    FROM employees a
    INNER JOIN departments b
        USING (department_id)
        WHERE a.hire_date >= TO_DATE('2003-01-01', 'YYYY_MM_DD');
-- 조인 조건이 되는 컬럼명이 동일하다면 ON 대신 USING 절 사용 가능
-- 이때 해당 컬럼명은 테이블명을 제외하고 기술해야 한다.

-- ANSI 외부 조인
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
    FROM employees a
    LEFT JOIN job_history b
        ON (a.employee_id = b.employee_id
            and a.department_id = b.department_id);

SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
    FROM job_history b
    RIGHT JOIN employees a
        ON (a.employee_id = b.employee_id
            and a.department_id = b.department_id);
            
-- CROSS 조인
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
    FROM employees a
    CROSS JOIN job_history b;

-- FULL OUTER 조인 (ANSI 문법으로만 구현 가능)
CREATE TABLE HONG_A (EMP_ID INT);
CREATE TABLE HONG_B (EMP_ID INT);
INSERT INTO HONG_A VALUES(10);
INSERT INTO HONG_A VALUES(20);
INSERT INTO HONG_A VALUES(40);
INSERT INTO HONG_B VALUES(10);
INSERT INTO HONG_B VALUES(20);
INSERT INTO HONG_B VALUES(30);
COMMIT;

SELECT a.emp_id, b.emp_id
    FROM hong_a a, hong_b b
    WHERE a.emp_id(+) = b.emp_id(+);
-- ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다
-- 01468. 00000 -  "a predicate may reference only one outer-joined table"

SELECT a.emp_id, b.emp_id
    FROM hong_a a
    FULL OUTER JOIN hong_b b
        ON (a.emp_id = b.emp_id);


---- 서브 쿼리(Sub-query) ----
-- SQL 문장 안에서 보조로 사용되는 또다른 SELECT 구문
-- 일반 서브 쿼리 : SELECT 절 안에 서브 쿼리 사용
-- 인라인 뷰 : FROM 절 안에 서브 쿼리 사용
-- 중첩 쿼리 : WHERE 절 안에 서브 쿼리 사용

-- 연관성 없는 서브 쿼리 : 메인 테이블과의 조인 조건이 없는 경우
-- 1) 사원 테이블의 평균 급여보다 많은 급여를 받는 건수
SELECT COUNT(*)
    FROM employees
    WHERE salary >= (SELECT AVG(salary)
                        FROM employees);

-- 2) parent_id가 null인 부서번호를 가진 총 사원의 건수
SELECT COUNT(*)
    FROM employees
    WHERE department_id IN (SELECT department_id
                                FROM departments
                                WHERE parent_id IS NULL);

-- 3) job_history 테이블에 있는 employee_id, job_id와 같은 건을 사원 테이블에서 조회
SELECT employee_id, emp_name, job_id
    FROM employees
    WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
                                    FROM job_history);

-- UPDATE, DELETE 문에서도 서브쿼리 사용 가능
/*
UPDATE employees
    SET salary = (SELECT AVG(salary)
                    FROM employees );
DELETE employees
     WHERE salary >= ( SELECT AVG(salary)
                         FROM employees );
*/

-- 연관성 있는 서브 쿼리 : 메인 테이블과 조인 조건이 걸려 있는 서브 쿼리
-- 부서 테이블의 부서번호와 job_history 테이블의 부서번호가 같은 건 조회
SELECT a.department_id, a.department_name
    FROM departments a
    WHERE EXISTS (SELECT 1
                    FROM job_history b
                    WHERE a.department_id = b.department_id);

-- job_history 테이블을 조회하면서 다른 테이블의 사원명과 부서명도 추출
SELECT a.employee_id
        , (SELECT b.emp_name
            FROM employees b
            WHERE a.employee_id = b.employee_id) AS emp_name
        , a.department_id
        , (SELECT b.department_name
            FROM departments b
            WHERE a.department_id = b.department_id) AS dep_name
        , (SELECT c.job_title
            FROM jobs c
            WHERE a.job_id = c.job_id) AS title_name
    FROM job_history a;
-- 각 서브 쿼리는 독립적이므로 같은 별칭을 사용해도 무방하다.

-- 평균급여보다 큰 급여의 사원들이 속한 부서를 추출
SELECT a.department_id, a.department_name
    FROM departments a
    WHERE EXISTS (SELECT 1
                    FROM employees b
                    WHERE a.department_id = b.department_id
                        AND b.salary > (SELECT AVG(salary)
                                            FROM employees));

-- 기획부 산하에 있는 부서에 속한 사원의 평균급여보다 많은 급여를 받는 사원
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
    FROM employees a
        , departments b
        , (SELECT AVG(c.salary) AS avg_salary
            FROM departments b
                , employees c
            WHERE b.parent_id = 90
                AND b.department_id = c.department_id) d
    WHERE a.department_id = b.department_id
        AND a.salary > d.avg_salary;

-- 2000년 이탈리아 평균 매출액(연평균)보다 큰 월의 평균 매출액을 구함
SELECT a.*
    FROM (SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
            FROM sales a
                , customers b
                , countries c
            WHERE a.cust_id = b.cust_id
                AND b.country_id = c.country_id
                AND a.sales_month between '200001' and '200012'
                AND c.country_name = 'Italy'
            GROUP BY a.sales_month) a
        , (SELECT ROUND(AVG(a.amount_sold)) AS year_avg
            FROM sales a
                , customers b
                , countries c
            WHERE a.cust_id = b.cust_id
                AND b.country_id = c.country_id
                AND a.sales_month between '200001' and '200012'
                AND c.country_name = 'Italy') b
    WHERE a.month_avg > b.year_avg;

-- 복잡한 쿼리 작성법
-- (1) 최종적으로 조회되는 결과 항목 정의 (메인쿼리)
-- (2) 필요한 테이블과 컬럼 파악 (메인 쿼리)
-- (3) 작은 단위로 분할해서 쿼리 작성 (서브 쿼리)
-- (4) 분할한 단위의 쿼리를 합쳐서 최종 결과 산출

-- 연도별 이탈리아 매출 데이터에서 매출 실적이 가장 많은 사원의 목록과 매출액 구하는 쿼리
-- 출력항목 : 연도, 최대 매출 사원, 최대 매출액
-- 테이블 : contries(이탈리아), customers(고객), sales(매출), employees(사원정보)

-- (1) 연도, 사원별 이탈리아 매출액 구하기
SELECT SUBSTR(a.sales_month, 1, 4) as sales_year
        , a.employee_id
        , SUM(a.amount_sold) as amount_sold
    FROM sales a
        , customers b
        , countries c
    WHERE a.cust_id = b.cust_id
        AND b.country_id = c.country_id
        AND c.country_name = 'Italy'
    GROUP BY SUBSTR(a.sales_month, 1, 4)
            , a.employee_id;

-- (2) 연도별 최대 매출액 구하기
SELECT sales_year
        , MAX(amount_sold) AS max_sold
    FROM (SELECT SUBSTR(a.sales_month, 1, 4) as sales_year
                    , a.employee_id
                    , SUM(a.amount_sold) as amount_sold
                FROM sales a
                    , customers b
                    , countries c
                WHERE a.cust_id = b.cust_id
                    AND b.country_id = c.country_id
                    AND c.country_name = 'Italy'
                GROUP BY SUBSTR(a.sales_month, 1, 4)
                        , a.employee_id) k
    GROUP BY sales_year
    ORDER BY sales_year;

-- (3) 최대매출액, 최소매출액을 기록한 사원을 찾기
SELECT emp.sales_year
        , emp.employee_id
        , emp2.emp_name
        , emp.amount_sold
    FROM (SELECT SUBSTR(a.sales_month, 1, 4) as sales_year
                , a.employee_id
                , SUM(a.amount_sold) as amount_sold
            FROM sales a
                , customers b
                , countries c
            WHERE a.cust_id = b.cust_id
                AND b.country_id = c.country_id
                AND c.country_name = 'Italy'
            GROUP BY SUBSTR(a.sales_month, 1, 4)
                    , a.employee_id) emp
        , (SELECT sales_year
                , MAX(amount_sold) AS max_sold
            FROM (SELECT SUBSTR(a.sales_month, 1, 4) as sales_year
                        , a.employee_id
                        , SUM(a.amount_sold) as amount_sold
                    FROM sales a
                        , customers b
                        , countries c
                    WHERE a.cust_id = b.cust_id
                        AND b.country_id = c.country_id
                        AND c.country_name = 'Italy'
                    GROUP BY SUBSTR(a.sales_month, 1, 4)
                            , a.employee_id) k
            GROUP BY sales_year) sale
        , employees emp2
    WHERE emp.sales_year = sale.sales_year
        AND emp.amount_sold = sale.max_sold
        AND emp.employee_id = emp2.employee_id
    ORDER BY sales_year;
    

---- Self-Check ----
-- 1. 101번 사원에 대해 아래의 결과를 산출하는 쿼리를 작성해 보자. 
/*
---------------------------------------------------------------------------------------
사번   사원명   job명칭 job시작일자  job종료일자   job수행부서명
---------------------------------------------------------------------------------------
*/

SELECT a.employee_id 사번
        , a.emp_name 사원명
        , b.job_title job명칭
        , c.start_date job시작일자
        , c.end_date job종료일자
        , d.department_name
    FROM employees a
        , jobs b
        , job_history c
        , departments d
    WHERE a.employee_id = c.employee_id
        AND b.job_id = c.job_id
        AND c.department_id = d.department_id
        AND a.employee_id = 101;


-- 2. 아래의 쿼리를 수행하면 오류가 발생한다. 오류의 원인은 무엇인가?
/*
select a.employee_id, a.emp_name, b.job_id, b.department_id 
  from employees a,
       job_history b
 where a.employee_id      = b.employee_id(+)
   and a.department_id(+) = b.department_id;
*/
-- (+) 연산자를 활용한 외부 조인의 경우 한쪽 방향으로만 가능한데,
-- 이때 (+) 연산자는 데이터가 없는 테이블의 컬럼에만 붙여야 하기 때문에
-- 마지막 줄을 and a.department_id = b.department_id(+)로 수정해야 한다.


-- 3. 외부조인시 (+)연산자를 같이 사용할 수 없는데,
--    IN절에 사용하는 값이 1개인 경우는 사용 가능하다. 그 이유는 무엇일까?
-- IN절에 사용하는 값이 1개인 경우는 등호를 사용하는 것과 같은 의미이므로 사용 가능하다.


-- 4. 다음의 쿼리를 ANSI 문법으로 변경해 보자.
/*
SELECT a.department_id, a.department_name
  FROM departments a, employees b
 WHERE a.department_id = b.department_id
   AND b.salary > 3000
ORDER BY a.department_name;
*/
SELECT a.department_id, a.department_name
    FROM departments a
    INNER JOIN employees b
        On (a.department_id = b.department_id
            AND b.salary > 3000)
    ORDER BY a.department_name;


-- 5. 다음은 연관성 있는 서브쿼리이다. 이를 연관성 없는 서브쿼리로 변환해 보자. 
/*
SELECT a.department_id, a.department_name
 FROM departments a
WHERE EXISTS ( SELECT 1 
                 FROM job_history b
                WHERE a.department_id = b.department_id );
*/
SELECT a.department_id, a.department_name
 FROM departments a
WHERE a.department_id IN (SELECT b.department_id
                                FROM job_history b);


-- 6. 연도별 이태리 최대매출액과 사원을 작성하는 쿼리를 학습했다.
--    이를 기준으로 최대 매출액, 최소매출액, 해당 사원을 조회하는 쿼리를 작성해 보자.
SELECT emp.sales_year
        , emp.employee_id
        , emp2.emp_name
        , emp.amount_sold
    FROM (SELECT SUBSTR(a.sales_month, 1, 4) as sales_year
                , a.employee_id
                , SUM(a.amount_sold) as amount_sold
            FROM sales a
                , customers b
                , countries c
            WHERE a.cust_id = b.cust_id
                AND b.country_id = c.country_id
                AND c.country_name = 'Italy'
            GROUP BY SUBSTR(a.sales_month, 1, 4)
                    , a.employee_id) emp
        , (SELECT sales_year
                , MAX(amount_sold) AS max_sold
                , MIN(amount_sold) AS min_sold
            FROM (SELECT SUBSTR(a.sales_month, 1, 4) as sales_year
                        , a.employee_id
                        , SUM(a.amount_sold) as amount_sold
                    FROM sales a
                        , customers b
                        , countries c
                    WHERE a.cust_id = b.cust_id
                        AND b.country_id = c.country_id
                        AND c.country_name = 'Italy'
                    GROUP BY SUBSTR(a.sales_month, 1, 4)
                            , a.employee_id) k
            GROUP BY sales_year) sale
        , employees emp2
    WHERE emp.sales_year = sale.sales_year
        AND (emp.amount_sold = sale.max_sold
        OR emp.amount_sold = sale.min_sold)
        AND emp.employee_id = emp2.employee_id
    ORDER BY sales_year;
