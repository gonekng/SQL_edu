---- 숫자 함수 ----
-- ABS(n)
SELECT ABS(10), ABS(10.132), ABS(-10), ABS(-10.123)
    FROM DUAL;

-- CEIL(n) / FLOOR(n)
SELECT CEIL(10.123), CEIL(10.532), CEIL(11.002)
    FROM DUAL;

SELECT FLOOR(10.123), FLOOR(10.532), FLOOR(11.002)
    FROM DUAL;

-- ROUND(n,i)
SELECT ROUND(10.123), ROUND(10.532), ROUND(11.002)
    FROM DUAL;

SELECT ROUND(10.163, 1), ROUND(10.163, 2), ROUND(10.163, 3)
    FROM DUAL;

SELECT ROUND(0,3), ROUND(136.53, -1), ROUND(136.53, -2)
    FROM DUAL;

-- TRUNC(n,i)
SELECT TRUNC(115.155), TRUNC(115.155, 1), TRUNC(115.155, 2), TRUNC(115.155, -2)
    FROM DUAL;

-- POWER(n2, n1)
SELECT POWER(3,2), POWER(3,3), POWER(3,3.0001)
    FROM DUAL;

SELECT POWER(-3, 3.0001)
    FROM DUAL;
-- ORA-01428: '-3' 인수가 범위를 벗어났습니다
-- 01428. 00000 -  "argument '%s' is out of range"

-- SQRT(n)
SELECT SQRT(2), SQRT(5)
    FROM DUAL;

-- MOD(n2,n1) : n2 - n1 * FLOOR(n2/n1)
SELECT MOD(19,4), MOD(19.123, 4.2)
    FROM DUAL;

-- REMAINDER(n2,n1) : n2 - n1 * ROUND(n2/n1)
SELECT REMAINDER(19,4), REMAINDER(19.123, 4.2)
    FROM DUAL;
    
-- EXP(n) / LN(n) / LOG(n2,n1)
SELECT EXP(2), LN(2.713), LOG(10,100)
    FROM DUAL;


---- 문자 함수 ----
-- CONCAT(char1, char2) : '||' 연산자처럼 두 문자를 연결
SELECT CONCAT('I Have', ' A Dream')
       , 'I Have' || ' A Dream'
    FROM DUAL;

-- SUBSTR(char, pos, len) : 문자 개수 단위로 자른다.
-- 문자 인덱스가 1부터 시작함
SELECT SUBSTR('ABDCDEFG', 1, 4), SUBSTR('ABCDEFG', -1, 4)
    FROM DUAL;

-- SUBSTRB(char, pos, len) : 문자열의 바이트 수만큼 자른다.
-- 한글은 한 글자에 2~3바이트(인코딩에 따라 다를 수 있음)
SELECT SUBSTRB('ABDCDEFG', 1, 4), SUBSTRB('가나다라마바사', 1, 6)
    FROM DUAL;

-- LTRIM(char, set) / RTRIM(char, set)
SELECT LTRIM('ABCDEFGABC', 'ABC')
       , LTRIM('가나다라', '가')
       , RTRIM('ABCDEFGABC', 'ABC')
       , RTRIM('가나다라', '라')
    FROM DUAL;

SELECT LTRIM('가나다라', '나')
       , RTRIM('가나다라', '나')
    FROM DUAL;

-- LPAD(expr1, n, expr2) / RPAD(expr1 ,n, expr2)
-- exp2(생략시 공백 한 문자)를 n자리만큼 왼쪽/오른쪽으로 채워 expr1을 반환
-- 매개변수 n은 expr1과 expr2가 합쳐져 반환되는 총 자릿수를 의미
CREATE TABLE ex4_1 (
    phone_num VARCHAR2(30)
);

INSERT INTO ex4_1 VALUES ('111-1111');
INSERT INTO ex4_1 VALUES ('111-2222');
INSERT INTO ex4_1 VALUES ('111-3333');

SELECT * FROM ex4_1;

SELECT LPAD(phone_num, 12, '(02)')
    FROM ex4_1;

SELECT RPAD(phone_num, 12, '(02)')
    FROM ex4_1;

-- REPLACE(char, search_str, replace_str)
SELECT LTRIM(' ABC DEF ')
       , RTRIM(' ABC DEF ')
       , REPLACE(' ABC DEF ', ' ', '')
    FROM DUAL;

-- TRANSLATE(expr, from_str, to_str)
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') AS rep
       , TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') AS trn
    FROM DUAL;

---- 날짜 함수 ----
-- SYSDATE, SYSTIMESTAMP
SELECT SYSDATE, SYSTIMESTAMP
    FROM DUAL;

-- ADD_MONTHS(date, integer)
SELECT ADD_MONTHS(SYSDATE, 1), ADD_MONTHS(SYSDATE, -1)
    FROM DUAL;

-- MONTHS_BETWEEN(date1, date2)
SELECT MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE, 1)) MON1
       , MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 1), SYSDATE) MON2
    FROM DUAL;

-- LAST_DAY(date)
SELECT LAST_DAY(SYSDATE)
    FROM DUAL;

-- ROUND(date, format), TRUNC(date, format)
SELECT SYSDATE, ROUND(SYSDATE, 'month'), TRUNC(SYSDATE, 'month')
    FROM DUAL;

-- NEXT_DAY(date, char)
SELECT NEXT_DAY(SYSDATE, '금요일')
    FROM DUAL;


---- 변환 함수 ----
-- 묵시적 형변환 : 자동으로 형변환되는 것
-- 명시적 형변환 : 변환함수를 통해 형변환을 직접 처리하는 것
-- TO_CHAR(number or date, format)
SELECT TO_CHAR(123456789, '999,999,999')
    FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
    FROM DUAL;

-- TO_NUMBER(expr, format)
SELECT TO_NUMBER('123456')
    FROM DUAL;

-- TO_DATE(char, format), TO_TIMESTAMP(char, format)
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

SELECT TO_DATE('20140101', 'YYYY-MM-DD')
    FROM DUAL;

SELECT TO_DATE('20220427 13:44:30', 'YYYY-MM-DD HH24:MI:SS')
    FROM DUAL;


---- NULL 관련 함수 ----
-- NVL(expr1, expr2) : expr1이 null일 때 expr2 반환
SELECT NVL(manager_id, employee_id)
    FROM employees
    WHERE manager_id IS NULL;

-- NVL2(exp1, exp2, expr3) : expr1이 null이 아니면 expr2, null이면 expr3 반환
SELECT employee_id
     , salary
     , NVL2(commission_pct, salary + (salary * commission_pct), salary)
        as salary2
    FROM employees;
-- commission_pct가 null이면 salary를, null이 아니면 새로 계산한 값을 반환

-- COALESCE(expr1, expr2, ...)
SELECT employee_id
        , salary
        , commission_pct
        , COALESCE(salary * commission_pct, salary) AS salary2
    FROM employees;
-- salary * commision_pct가 null이 아니면 반환, null이면 salary를 반환

-- LNNVL(조건식) : 조건식이 FALSE나 UNKNOWN이면 TRUE를, TURE이면 FALSE를 반환
SELECT COUNT(*)
    FROM employees
    WHERE commission_pct < 0.2;
-- 일반 조건문으로는 null값이 반영 안됨

SELECT COUNT(*)
    FROM employees
    WHERE NVL(commission_pct, 0) < 0.2;
-- null값을 0으로 처리하여 조건문에 반영

SELECT COUNT(*)
    FROM employees
    WHERE LNNVL(commission_pct >= 0.2);
-- LNNVL 함수를 적용

-- NULLIF(expr1, expr2) : exp1과 exp2가 같으면 null을, 다르면 expr1을 반환
SELECT employee_id
        , TO_CHAR(start_date, 'YYYY') start_year
        , TO_CHAR(end_date, 'YYYY') end_year
        , NULLIF(TO_CHAR(end_date, 'YYYY'), TO_CHAR(start_date, 'YYYY')) nullif_year
    FROM job_history;

---- 기타 함수 ----
-- DECODE(expr1, search1, result1, search2, result2, ... , default)
-- : expr이 search1과 같으면 result1을, search2와 같으면 result2를, 없으면 default를 반환
SELECT * FROM sales;

SELECT prod_id
        , channel_id
        , DECODE(channel_id, 3, 'Direct',
                             9, 'Direct',
                             5, 'Indirect',
                             4, 'Indirect',
                                'Others') decodes
    FROM sales
    WHERE prod_id = 125;

---- Self-Check ----
-- 1.
-- 사원테이블(employees)에는 phone_number라는 컬럼에
-- 사원의 전화번호가 ###.###.#### 형태로 저장되어 있다.
-- 여기서 처음 3자리 대신 (02)를 붙여 전화번호를 출력하도록 쿼리를 작성해 보자.
SELECT phone_number, LPAD(SUBSTR(phone_number, 5), 12, '(02)')
    FROM employees;

-- 2.
-- 현재일자 기준으로 사원테이블의 입사일자(hire_date)를 참조해서
-- 근속년수가 10년 이상인 사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해보자. 
-- (근속년수가 많은 사원 순서대로 결과를 나오도록 하자)
/*
--------------------------------------
사원번호  사원명  입사일자 근속년수
--------------------------------------
*/
SELECT employee_id 사원번호
        , emp_name 사원명
        , hire_date 입사일자
        , ROUND((sysdate - hire_date)/365) 근속년수
    FROM employees
    WHERE ROUND((sysdate - hire_date)/365) >= 10
    ORDER BY 3;

-- 3.
-- 고객 테이블(CUSTOMERS)에는 고객 전화번호(cust_main_phone_number) 컬럼이 있다.
-- 이 컬럼 값은 ###-###-#### 형태인데, '-' 대신 '/'로 바꿔 출력하는 쿼리를 작성해 보자.
SELECT cust_name, REPLACE(cust_main_phone_number, '-', '/') new_number
    FROM customers;

-- 4.
-- 고객 테이블(CUSTOMERS)의 고객 전화번호(cust_main_phone_number) 컬럼을
-- 다른 문자로 대체(일종의 암호화)하도록 쿼리를 작성해 보자.
SELECT cust_name, TRANSLATE(cust_main_phone_number, '0123456789', 'abcdefghij') new_number
    FROM customers;

-- 5.
-- 고객 테이블(CUSTOMERS)에는 고객의 출생년도(cust_year_of_birth) 컬럼이 있다.
-- 현재일 기준으로 이 컬럼을 활용해 30대, 40대, 50대를 구분해 출력하고,
-- 나머지 연령대는 '기타'로 출력하는 쿼리를 작성해보자. 
SELECT cust_name
        , cust_year_of_birth
        , DECODE(TRUNC((TO_CHAR(SYSDATE,'YYYY') - cust_year_of_birth)/10),
                     3, '30대',
                     4, '40대',
                     5, '50대',
                        '기타') generation
    FROM customers;
  

-- 6.
-- 5번 문제에서 30~50대 까지만 표시했던 것을 전 연령대를 표시하도록 쿼리를 작성하는데, 
-- 이번에는 DECODE 대신 CASE 표현식을 사용해보자. 
SELECT cust_name
        , cust_year_of_birth
        , CASE TRUNC((TO_CHAR(SYSDATE,'YYYY') - cust_year_of_birth)/10)
            WHEN 1 THEN '10대'  
            WHEN 2 THEN '20대'  
            WHEN 3 THEN '30대'  
            WHEN 4 THEN '40대'  
            WHEN 5 THEN '50대' 
            WHEN 6 THEN '60대'  
            WHEN 7 THEN '70대'  
            ELSE '기타' 
            END AS generation
    FROM customers;
