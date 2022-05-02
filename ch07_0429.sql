-- 분석함수 : RANK, DENSE_RANK, LAG, LEAD
-- 형식 : 함수() OVER (PARTITION BY 컬럼명 ORDER BY 컬럼명)

---- WINDOW 절 ----
-- ROWS: 로우 단위로 window 절을 지정한다.
-- RANGE: 로우가 아닌 논리적인 범위로 window 절을 지정한다.
-- BETWEEN ~ AND: window 절의 시작과 끝 지점을 명시한다. BETWEEN을 명시하지 않고 두 번째 옵션만 지정하면이 지점이 시작 지점이 되고 끝 지점은 현재 로우가 된다.
-- UNBOUNDED PRECEDING: 파티션으로 구분된 첫 번째 로우가 시작 지점이 된다.
-- UNBOUNDED FOLLOWING: 파티션으로 구분된 마지막 로우가 끝 지점이 된다.
-- CURRENT ROW: 시작 및 끝 지점이 현재 로우가 된다.
-- value_expr PRECEDING: 끝 지점일 경우, 시작 지점은 value_expr PRECEDING
-- value_expr FOLLOWING: 시작 지점일 경우, 끝 지점은 value_expr FOLLOWING

SELECT department_id
        , emp_name
        , hire_date
        , salary
        , SUM(salary) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS all_sal
        , SUM(salary) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_current_sal
        , SUM(salary) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS current_end_sal
    FROM employees
    WHERE department_id IN (30, 90);
-- all_sal : 가장 입사가 빠른 사원부터 가장 최근에 입사한 사원까지 사원별 급여의 누적 합계
-- first_current_sal : 가장 입사가 빠른 사원부터 현재 로우까지 사원별 급여의 누적 합계
-- current_end_sal : 현재 로우부터 가장 최근에 입사한 사원까지 사원별 급여의 누적 합계


SELECT department_id, emp_name, hire_date, salary
        , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS all_sal
        , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                            RANGE 365 PRECEDING) AS range_sal1
        , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                            RANGE BETWEEN 365 PRECEDING AND CURRENT ROW) AS range_sal2
    FROM employees
    WHERE department_id = 30;
-- range_sal1 : 각 로우의 입사일 기준으로 1년 이하에 속하는 입사일을 가진 로우부터 현재 로우까지
-- range_sal2 : range_sal1과 같은 결과


---- WINDOW 함수 ----
-- 분석 함수 중 WINDOW 절과 함께 사용할 수 있는 함수

-- FIRST_VALUE : 가장 첫번째 값 반환
SELECT department_id
        , emp_name
        , hire_date
        , salary
        , FIRST_VALUE(salary) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS all_sal
        , FIRST_VALUE(salary) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_current_sal
        , FIRST_VALUE(salary) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS current_end_sal
    FROM employees
    WHERE department_id IN (30, 90);

-- LAST_VALUE : 가장 마지막 값 반환
SELECT department_id
        , emp_name
        , hire_date
        , salary
        , LAST_VALUE(salary) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS all_sal
        , LAST_VALUE(salary) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_current_sal
        , LAST_VALUE(salary) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS current_end_sal
    FROM employees
    WHERE department_id IN (30, 90);

-- NTH_VALUE : 주어진 그룹의 N번째 로우 값 반환
SELECT department_id
        , emp_name
        , hire_date
        , salary
        , NTH_VALUE(salary, 2) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS all_sal
        , NTH_VALUE(salary, 2) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_current_sal
        , NTH_VALUE(salary, 2) OVER (PARTITION BY department_id
                            ORDER BY hire_date
                            ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS current_end_sal
    FROM employees
    WHERE department_id IN (30, 90);


---- 계층형 쿼리(Hierarchical Query) ----
-- 2차원 테이블에 저장된 데이터를 계층형 구조로 결과를 반환하는 쿼리
-- START WITH : 계층형 구조에서 최상위 계층의 로우를 식별하는 조건을 명시
-- CONNECT BY : 계층형 구조가 어떤 식으로 연결되는지를 기술하는 부분
-- PRIOR : 계층형 쿼리에서만 사용하는 연산자 (직전의, 이전의)
-- LEVEL : 계층형 쿼리에서만 사용하는 컬럼 (계층형 구조의 레벨 값 반환)

SELECT department_id
        , LPAD(' ', 3*(LEVEL-1)) || department_name AS depart
        , LEVEL
    FROM departments
    START WITH parent_id IS NULL
    CONNECT by PRIOR department_id = parent_id;
-- parent_id가 null인 가장 상위 부서에서 시작
-- LPAD 함수를 사용하여 LEVEL 값에 따라 들여쓰기한 효과를 줄 수 있다.

SELECT a.employee_id
        , LPAD(' ', 3*(LEVEL-1)) || a.emp_name AS EMP_NAME
        , LEVEL
        , b.department_name
    FROM employees a
        , departments b
    WHERE a.department_id = b.department_id
    START WITH a.manager_id IS NULL
    CONNECT BY PRIOR a.employee_id = a.manager_id;

SELECT a.employee_id
        , LPAD(' ', 3*(LEVEL-1)) || a.emp_name AS EMP_NAME
        , LEVEL
        , b.department_name
        , a.department_id
    FROM employees a
        , departments b
    WHERE a.department_id = b.department_id
        AND a.department_id = 30
    START WITH a.manager_id IS NULL
    CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id;
-- WHERE 절에 조건을 명시
-- 부모-자식 관계를 모두 풀어헤치고 모든 로우에 대해 개별적으로 검색하므로 최상위 로우가 제외됨

SELECT a.employee_id
        , LPAD(' ', 3*(LEVEL-1)) || a.emp_name AS EMP_NAME
        , LEVEL
        , b.department_name
        , a.department_id
    FROM employees a
        , departments b
    WHERE a.department_id = b.department_id
    START WITH a.manager_id IS NULL
    CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id
        AND a.department_id = 30;
-- CONNECT BY 절에 조건 명시
-- 부모-자식 관계를 식별하여 조건에 맞는 자식 로우를 찾으므로 최상위 로우까지 조회됨

SELECT a.employee_id
        , LPAD(' ', 3*(LEVEL-1)) || a.emp_name AS EMP_NAME
        , LEVEL
        , b.department_name
    FROM employees a
        , departments b
    WHERE a.department_id = b.department_id
    START WITH a.manager_id IS NULL
    CONNECT BY PRIOR a.manager_id = a.employee_id;
-- CONNECT BY PRIOR 자식컬럼 = 부모컬럼 : 부모에서 자식으로 트리 구성(TOP-DOWN) -> 일반적
-- CONNECT BY PRIOR 부모컬럼 = 자식컬럼 : 자식에서 부모으로 트리 구성(BOTTOL-UP)
-- CONNECT BY NOCYCLE PRIOR : 무한루프 방지


-- 계층형 쿼리 정렬
SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL
    FROM departments
    START WITH parent_id IS NULL
    CONNECT BY PRIOR department_id  = parent_id
    ORDER BY department_name;
-- 계층형 쿼리에서는 구조별로 자동 정렬되는데, ORDER BY를 사용하면 구조가 깨져버린다.

SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL
    FROM departments
    START WITH parent_id IS NULL
    CONNECT BY PRIOR department_id  = parent_id
    ORDER SIBLINGS BY department_name;
-- ORDER SIBLINGS BY는 계층형 구조도 보존하면서 레벨이 같은 형제 로우 간에 정렬을 수행한다.


---- WITH 절 ----
-- WITH으로 시작하고 별칭을 앞에 명시하는 점을 제외하면 기본 형태는 일반 서브 쿼리와 같음
-- 별도의 쿼리에서 일시적으로 재사용이 가능하나, 저장이 되는 것은 아니며 함께 실행해야 함
WITH temp AS (
    SELECT employee_id, emp_name, job_id, salary
        FROM employees
)
SELECT job_id, SUM(salary)
    FROM temp
    GROUP by job_id;


-- WITH 절 활용 예시    
SELECT b2.*
    FROM (
            SELECT period
                    , region
                    , sum(loan_jan_amt) jan_amt
                FROM kor_loan_status 
                GROUP BY period, region
         ) b2
        , (
            SELECT b.period
                    , MAX(b.jan_amt) max_jan_amt
                FROM (
                        SELECT period
                                , region
                                , sum(loan_jan_amt) jan_amt
                            FROM kor_loan_status 
                            GROUP BY period, region
                     ) b
                    , (
                        SELECT MAX(PERIOD) max_month
                            FROM kor_loan_status
                            GROUP BY SUBSTR(PERIOD, 1, 4)
                      ) a
            WHERE b.period = a.max_month
            GROUP BY b.period
          ) c
    WHERE b2.period = c.period
        AND b2.jan_amt = c.max_jan_amt
    ORDER BY 1;

-- WITH 동일 구문 반복 사용 시
WITH b2 AS (
                SELECT period, region, sum(loan_jan_amt) jan_amt
                    FROM kor_loan_status 
                    GROUP BY period, region
           )
     , c AS (
                SELECT b.period, MAX(b.jan_amt) max_jan_amt
                    FROM (
                            SELECT period, region, sum(loan_jan_amt) jan_amt
                                FROM kor_loan_status 
                                GROUP BY period, region
                         ) b
                        , (
                            SELECT MAX(PERIOD) max_month
                                FROM kor_loan_status
                                GROUP BY SUBSTR(PERIOD, 1, 4)
                          ) a
                    WHERE b.period = a.max_month
                    GROUP BY b.period
            ) -- AS SELECT 
SELECT b2.*
    FROM b2, c
    WHERE b2.period = c.period
        AND b2.jan_amt = c.max_jan_amt
    ORDER BY 1;


---- Self-Check ----
-- 1.
-- 계층형 쿼리 응용편에서 LISTAGG 함수를 사용해 다음과 같이 로우를 컬럼으로 분리했었다. 
/*
  SELECT department_id,
         LISTAGG(emp_name, ',') WITHIN GROUP (ORDER BY emp_name) as empnames
    FROM employees
   WHERE department_id IS NOT NULL
   GROUP BY department_id;
*/
--  LISTAGG 함수 대신 계층형 쿼리, 분석함수를 사용해서 위 쿼리와 동일한 결과를 산출하는 쿼리를 작성해 보자. 

SELECT department_id
        , SYS_CONNECT_BY_PATH(emp_name, ',') empnames
    FROM (
            SELECT emp_name
                    , department_id
                    , COUNT(*) OVER (PARTITION BY department_id) cnt
                    , ROW_NUMBER() OVER (PARTITION BY department_id
                                         ORDER BY emp_name) rowseq
                FROM employees
                WHERE department_id IS NOT NULL
         )
    WHERE rowseq = cnt
    START WITH rowseq = 1
    CONNECT BY PRIOR rowseq + 1 = rowseq
        AND PRIOR department_id = department_id;
    
    
-- 2.
-- 아래의 쿼리는 사원테이블에서 JOB_ID가 'SH_CLERK'인 사원을 조회하는 쿼리이다. 
/* 
SELECT employee_id, emp_name, hire_date
FROM employees
WHERE job_id = 'SH_CLERK'
ORDER By hire_date; 

EMPLOYEE_ID EMP_NAME             HIRE_DATE         
----------- -------------------- -------------------
        184 Nandita Sarchand     2004/01/27 00:00:00 
        192 Sarah Bell           2004/02/04 00:00:00 
        185 Alexis Bull          2005/02/20 00:00:00 
        193 Britney Everett      2005/03/03 00:00:00 
        188 Kelly Chung          2005/06/14 00:00:00
....        
....
        199 Douglas Grant        2008/01/13 00:00:00
        183 Girard Geoni         2008/02/03 00:00:00
*/
-- 사원테이블에서 퇴사일자(retire_date)는 모두 비어있는데,
-- 위 결과에서 사원번호가 184인 사원의 퇴사일자는 다음으로 입사일자가 빠른 192번 사원의 입사일자라고 가정해서
-- 다음과 같은 형태로 결과를 추출해낼 수 있도록 쿼리를 작성해 보자. (입사일자가 가장 최근인 183번 사원의 퇴사일자는 NULL이다)
/*
EMPLOYEE_ID EMP_NAME             HIRE_DATE             RETIRE_DATE
----------- -------------------- -------------------  ---------------------------
        184 Nandita Sarchand     2004/01/27 00:00:00  2004/02/04 00:00:00
        192 Sarah Bell           2004/02/04 00:00:00  2005/02/20 00:00:00
        185 Alexis Bull          2005/02/20 00:00:00  2005/03/03 00:00:00
        193 Britney Everett      2005/03/03 00:00:00  2005/06/14 00:00:00
        188 Kelly Chung          2005/06/14 00:00:00  2005/08/13 00:00:00
....        
....
        199 Douglas Grant        2008/01/13 00:00:00  2008/02/03 00:00:00
        183 Girard Geoni         2008/02/03 00:00:00
*/

SELECT employee_id
        , emp_name
        , hire_date
        , LEAD(hire_date) OVER (PARTITION BY job_id ORDER BY hire_date) AS retire_date
    FROM employees
    WHERE job_id = 'SH_CLERK'
    ORDER BY hire_date;


-- 3.
-- sales 테이블에는 판매데이터, customers 테이블에는 고객정보가 있다.
-- 2001년 12월 판매데이터 중 현재일자를 기준으로 고객의 나이를 계산해서
-- 다음과 같이 연령대별 매출금액을 보여주는 쿼리를 작성해 보자.
/*
-------------------------   
연령대    매출금액
-------------------------
10대      xxxxxx
20대      ....
30대      .... 
40대      ....
-------------------------   
*/

WITH age_amt AS (
                    SELECT TRUNC((TO_CHAR(SYSDATE, 'yyyy') - b.cust_year_of_birth), -1) AS age_seg
                            , SUM(a.amount_sold) AS amount
                        FROM sales a
                            , customers b
                        WHERE a.sales_month = '200112'
                            AND a.cust_id = b.cust_id
                        GROUP BY TRUNC((TO_CHAR(SYSDATE, 'yyyy') - b.cust_year_of_birth), -1)
                )
SELECT * FROM age_amt
    ORDER BY age_seg;

 
-- 4.
-- 3번 문제를 이용해 월별로 판매금액이 가장 하위에 속하는 대륙 목록을 뽑아보자.
-- 대륙목록은 countries 테이블의 country_region에 있으며,
-- country_id 컬럼으로 customers 테이블과 조인을 해서 구한다.
/*
---------------------------------   
매출월    지역(대륙)  매출금액 
---------------------------------
199801    Oceania      xxxxxx
199803    Oceania      xxxxxx
...
---------------------------------
*/
WITH basis AS (
                SELECT a.sales_month
                        , c.country_region
                        , SUM(a.amount_sold) as amt
                    FROM sales a
                        , customers b
                        , countries c
                    WHERE a.cust_id = b.cust_id
                        AND b.country_id = c.country_id
                    GROUP BY a.sales_month, c.country_region
              )
       , month_amt AS (
                        SELECT sales_month AS "매출월"
                                , country_region AS "지역(대륙)"
                                , amt AS "매출금액"
                                , RANK() OVER (PARTITION BY sales_month ORDER BY amt) AS ranks
                            FROM basis
                      )
SELECT "매출월", "지역(대륙)", "매출금액"
    FROM month_amt
    WHERE ranks = 1;


-- 5.
-- 5장 연습문제 5번의 정답 결과를 이용해 다음과 같이 지역별, 대출종류별, 월별 대출잔액과 지역별 파티션을 만들어 대출종류별 대출잔액의 %를 구하는 쿼리를 작성해보자. 
/*
------------------------------------------------------------------------------------------------
지역    대출종류        201111         201112    201210    201211   201212   203110    201311
------------------------------------------------------------------------------------------------
서울    기타대출       73996.9( 36% )
서울    주택담보대출   130105.9( 64% ) 
부산
...
...
-------------------------------------------------------------------------------------------------
*/
WITH basis AS (
                SELECT region
                        , gubun
                        , SUM(amt1) AS amt1
                        , SUM(amt2) AS amt2
                        , SUM(amt3) AS amt3
                        , SUM(amt4) AS amt4
                        , SUM(amt5) AS amt5
                        , SUM(amt6) AS amt6
                        , SUM(amt7) AS amt7
                    FROM (
                            SELECT region
                                    , gubun
                                    , CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END amt1
                                    , CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END amt2
                                    , CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END amt3
                                    , CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END amt4
                                    , CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END amt5
                                    , CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END amt6
                                    , CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END amt7
                                FROM kor_loan_status
                         )
                    GROUP BY region, gubun
              )
SELECT region AS "지역"
        , gubun AS "대출종류"
        , amt1 || '(' || ROUND(RATIO_TO_REPORT(amt1) OVER (PARTITION BY region), 3) *100 || '%)' AS "201111"
        , amt2 || '(' || ROUND(RATIO_TO_REPORT(amt2) OVER (PARTITION BY region), 3) *100 || '%)' AS "201112"
        , amt3 || '(' || ROUND(RATIO_TO_REPORT(amt3) OVER (PARTITION BY region), 3) *100 || '%)' AS "201210"
        , amt4 || '(' || ROUND(RATIO_TO_REPORT(amt4) OVER (PARTITION BY region), 3) *100 || '%)' AS "201211"
        , amt5 || '(' || ROUND(RATIO_TO_REPORT(amt5) OVER (PARTITION BY region), 3) *100 || '%)' AS "201212"
        , amt6 || '(' || ROUND(RATIO_TO_REPORT(amt6) OVER (PARTITION BY region), 3) *100 || '%)' AS "201311"
        , amt7 || '(' || ROUND(RATIO_TO_REPORT(amt7) OVER (PARTITION BY region), 3) *100 || '%)' AS "201311"
    FROM basis
    ORDER BY region;

