---- 기본 집계 함수 ----
-- COUNT(expr) -> null값은 제외
SELECT COUNT(*)
    FROM employees;

SELECT COUNT(employee_id)
    FROM employees;

SELECT COUNT(department_id)
    FROM employees;

-- DISTINCT : 유일값 조회
SELECT COUNT(DISTINCT department_id)
    FROM employees;

SELECT DISTINCT department_id
    FROM employees
    ORDER BY 1;

-- SUM(expr)
SELECT SUM(salary)
    FROM employees;

SELECT SUM(salary), SUM(DISTINCT salary)
    FROM employees;

-- AVG(expr)
SELECT AVG(salary), AVG(DISTINCT salary)
    FROM employees;

-- MIN(expr), MAX(expr)
SELECT MIN(salary), MAX(salary)
    FROM employees;

-- VARIANCE(expr), STDDEV(expr)
SELECT VARIANCE(salary), STDDEV(salary)
    FROM employees;

---- GROUP BY 절과 HAVING 절
SELECT department_id, SUM(salary)
    FROM employees
    GROUP BY department_id
    ORDER BY department_id;

SELECT * FROM kor_loan_status;

-- 2013년 월별 지역별 가계대출 총 잔액
SELECT period, region, SUM(loan_jan_amt) tot1_jan
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, region
    ORDER BY period, region;

-- 2013년 11월 가계대출 총 잔액
SELECT period, region, SUM(loan_jan_amt) tot1_jan
    FROM kor_loan_status
    WHERE period = '201311'
    GROUP BY region
    ORDER BY region;
-- ORA-00979: GROUP BY 표현식이 아닙니다.
-- 00979. 00000 -  "not a GROUP BY expression"

-- 그룹 쿼리를 사용하면 SELECT 리스트에 있는 컬럼명이나 표현식 중 집계 함수를 제외하고는
-- 모두 GROUP BY 절에 명시해야 한다. -> period 컬럼을 GROUP BY 절에 포함시켜야 한다.
-- HAVING 절 : GROUP BY의 결과를 대상으로 다시 필터를 적용하는 역할

-- 
SELECT period, region, SUM(loan_jan_amt) tot1_jan
    FROM kor_loan_status
    WHERE period = '201311'
    GROUP BY period, region
    HAVING SUM(loan_jan_amt) > 100000
    ORDER BY region;

---- ROLLUP / CUBE
-- ROLLUP(expr1, expr2, ...) : 소그룹 간의 합계를 계산함
SELECT period
        , gubun
        , SUM(loan_jan_amt) tot1_nam
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, gubun
    ORDER BY period;

SELECT period
        , gubun
        , SUM(loan_jan_amt) tot1_nam
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(period, gubun);
-- period&gubun별 총합 -> period별 총합 -> 전체 총합

SELECT period
        , gubun
        , SUM(loan_jan_amt) tot1_nam
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, ROLLUP(gubun);
-- period&gubun별 총합 -> period별 총합

SELECT period
        , gubun
        , SUM(loan_jan_amt) tot1_nam
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(period) , gubun;
-- gubun&period별 총합 -> gubun별 총합

-- CUBE(expr1, expr2, ...)
SELECT period
        , gubun
        , SUM(loan_jan_amt) tot1_nam
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY CUBE(period, gubun);
-- 전체 총합 -> gubun별 총합 -> period별 총합 -> period&gubun별 총합

SELECT period
        , gubun
        , SUM(loan_jan_amt) tot1_nam
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, CUBE(gubun);
-- period별 총합 -> period&gubun별 총합

-- GROUPING SETS : 특정 항목에 대한 소계를 계산하는 함수
SELECT period
        , gubun
        , SUM(loan_jan_amt) tot1_nam
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY GROUPING SETS(period, gubun);
-- gubun별 총합, period별 총합

---- 집합 함수 ----
CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));
       
INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

COMMIT;

-- UNION (중복 제외)
SELECT goods
    FROM exp_goods_asia
    WHERE country='한국'
UNION
SELECT goods
    FROM exp_goods_asia
    WHERE country='일본';

-- UNION ALL (중복 포함)
SELECT goods
    FROM exp_goods_asia
    WHERE country='한국'
UNION ALL
SELECT goods
    FROM exp_goods_asia
    WHERE country='일본';

-- INTERSECT
SELECT goods
    FROM exp_goods_asia
    WHERE country='한국'
INTERSECT
SELECT goods
    FROM exp_goods_asia
    WHERE country='일본';

-- MINUS
SELECT goods
    FROM exp_goods_asia
    WHERE country='한국'
MINUS
SELECT goods
    FROM exp_goods_asia
    WHERE country='일본';

SELECT goods
    FROM exp_goods_asia
    WHERE country='일본'
MINUS
SELECT goods
    FROM exp_goods_asia
    WHERE country='한국';

-- 집합 연산의 제한사항
-- 1) SELECT 리스트의 개수와 데이터 타입이 일치해야 함
SELECT goods
    FROM exp_goods_asia
    WHERE country='한국'
UNION
SELECT seq, goods
    FROM exp_goods_asia
    WHERE country='일본';
-- ORA-01789: 질의 블록은 부정확한 수의 결과 열을 가지고 있습니다.
-- 01789. 00000 -  "query block has incorrect number of result columns"

SELECT seq
    FROM exp_goods_asia
    WHERE country='한국'
UNION
SELECT goods
    FROM exp_goods_asia
    WHERE country='일본';
-- ORA-01790: 대응하는 식과 같은 데이터 유형이어야 합니다
-- 01790. 00000 -  "expression must have same datatype as corresponding expression"

-- 2) 집합 연산자로 SELECT문을 연결할 때 ORDER BY절은 맨 마지막에 사용해야 함
SELECT goods
    FROM exp_goods_asia
    WHERE country='한국'
    ORDER BY goods
UNION
SELECT goods
    FROM exp_goods_asia
    WHERE country='일본';
-- ORA-00933: SQL 명령어가 올바르게 종료되지 않았습니다
-- 00933. 00000 -  "SQL command not properly ended"

SELECT goods
    FROM exp_goods_asia
    WHERE country='한국'
UNION
SELECT goods
    FROM exp_goods_asia
    WHERE country='일본'
    ORDER BY goods;

-- 3) BLOB, CLOB, BFILE 타입의 컬럼에 대해서는 집합 연산자를 사용할 수 없음
-- 4) UNION, INTERSECT, MINUS 연산자는 LONG형 컬럼에 사용할 수 없음


---- Self-Check ----
-- 1. 사원테이블에서 입사년도별 사원수를 구하는 쿼리를 작성해보자. 
SELECT TO_CHAR(hire_Date, 'YYYY') as hire_year , COUNT(*)
    FROM employees
    GROUP BY TO_CHAR(hire_Date, 'YYYY')
    ORDER BY TO_CHAR(hire_Date, 'YYYY');

-- 2. kor_loan_status 테이블에서 2012년도 월별, 지역별 대출 총 잔액을 구하는 쿼리를 작성하라.
SELECT period, region, SUM(LOAN_JAN_AMT)
    FROM kor_loan_status
    WHERE period LIKE '2012%'
    GROUP BY period, region
    ORDER BY period, region;

-- 3. 아래의 쿼리는 분할 ROLLUP을 적용한 쿼리이다.
/*
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
    FROM kor_loan_status
    WHERE period LIKE '2013%' 
    GROUP BY period, ROLLUP( gubun );
 */
-- 이 쿼리를 ROLLUP을 사용하지 않고, 집합연산자를 사용해서 동일한 결과가 나오도록 쿼리를 작성해보자.
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
    FROM kor_loan_status
    WHERE period LIKE '2013%' 
    GROUP BY period, gubun
UNION
SELECT period, '', SUM(loan_jan_amt) totl_jan
    FROM kor_loan_status
    WHERE period LIKE '2013%' 
    GROUP BY period;

-- 4. 다음 쿼리를 실행해서 결과를 확인한 후, 집합 연산자를 사용해 동일한 결과를 추출하도록 쿼리를 작성해 보자. 
/*
SELECT period 
        , CASE WHEN gubun = '주택담보대출' THEN SUM(loan_jan_amt)
                ELSE 0 END 주택담보대출액
        , CASE WHEN gubun = '기타대출' THEN SUM(loan_jan_amt)
                ELSE 0 END 기타대출액
    FROM kor_loan_status
    WHERE period = '201311' 
    GROUP BY period, gubun;
*/

SELECT period, SUM(loan_jan_amt) 주택담보대출액, 0 기타대출액
    FROM kor_loan_status
    WHERE period = '201311' 
    GROUP BY period, gubun
        HAVING gubun = '주택담보대출'
UNION
SELECT period, 0 주택담보대출액 , SUM(loan_jan_amt) 기타대출액
    FROM kor_loan_status
    WHERE period = '201311' 
    GROUP BY period, gubun
        HAVING gubun = '기타대출';

-- 5. 다음과 같은 형태, 즉 지역과 각 월별 대출총잔액을 구하는 쿼리를 작성해 보자.
/*
---------------------------------------------------------------------------------------
지역   201111   201112    201210    201211   201212   203110    201311
---------------------------------------------------------------------------------------
서울   
부산
...
...
---------------------------------------------------------------------------------------
*/
SELECT region 지역
        , SUM(amt1) AS "201111"
        , SUM(amt2) AS "201112"
        , SUM(amt3) AS "201210"
        , SUM(amt4) AS "201211"
        , SUM(amt5) AS "201212"
        , SUM(amt6) AS "201310"
        , SUM(amt7) AS "201311"
    FROM (SELECT region
                , CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END amt1
                , CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END amt2
                , CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END amt3
                , CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END amt4
                , CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END amt5
                , CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END amt6
                , CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END amt7
            FROM kor_loan_status)
    GROUP BY region
    ORDER BY region;