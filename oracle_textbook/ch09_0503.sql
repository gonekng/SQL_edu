-- 초기 설정
SET SERVEROUTPUT ON
SET TIMING ON

---- PL/SQL 제어문 ----
-- IF문
DECLARE
    vn_num1 NUMBER := 1;
    vn_num2 NUMBER := 2;
BEGIN
    IF vn_num1 >= vn_num2 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num1 || '이 큰 수');
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_num2 || '이 큰 수');
    END IF;
END;

-- ELSE IF문
DECLARE
    vn_salary NUMBER := 0;
    vn_department_id NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE(10,120),-1);
    SELECT salary INTO vn_salary
        FROM employees
        WHERE department_id = vn_department_id
            AND ROWNUM=1;
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    IF vn_salary BETWEEN 1 AND 3000 THEN
        DBMS_OUTPUT.PUT_LINE('낮음');
    ELSIF vn_salary BETWEEN 3001 AND 6000 THEN
        DBMS_OUTPUT.PUT_LINE('중간');
    ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.PUT_LINE('높음');
    ELSE
        DBMS_OUTPUT.PUT_LINE('최상위');
    END IF;
END;

-- 중첩 IF문
DECLARE
    vn_salary NUMBER := 0;
    vn_department_id NUMBER := 0;
    vn_commission NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE(10,120), -1);
    SELECT salary, commission_pct
        INTO vn_salary, vn_commission
    FROM employees
    WHERE department_id = vn_department_id
        AND ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    IF vn_commission > 0 THEN
        IF vn_commission > 0.15 THEN
            DBMS_OUTPUT.PUT_LINE(vn_salary * vn_commission);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_salary);
    END IF;
END;

-- CASE문
DECLARE
    vn_salary NUMBER := 0;
    vn_department_id NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE(10,120),-1);
    
    SELECT salary INTO vn_salary
        FROM employees
        WHERE department_id = vn_department_id
            AND ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    CASE WHEN vn_salary BETWEEN 1 AND 3000 THEN
            DBMS_OUTPUT.PUT_LINE('낮음');
        WHEN vn_salary BETWEEN 3001 AND 6000 THEN
            DBMS_OUTPUT.PUT_LINE('중간');
        WHEN vn_salary BETWEEN 6001 AND 10000 THEN
            DBMS_OUTPUT.PUT_LINE('높음');
        ELSE
            DBMS_OUTPUT.PUT_LINE('최상위');
    END CASE;
END;

-- LOOP문
DECLARE
    vn_base_num NUMBER :=3;
    vn_cnt NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || vn_cnt || '=' || vn_base_num * vn_cnt);
        vn_cnt := vn_cnt + 1;
        
        EXIT WHEN vn_cnt > 9;
    END LOOP;
END;

-- WHILE 문
DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt NUMBER := 1;
BEGIN
    WHILE vn_cnt <= 9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || vn_cnt || '=' || vn_base_num * vn_cnt);
        vn_cnt := vn_cnt + 1;
    END LOOP;
END;

DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt NUMBER := 1;
BEGIN
    WHILE vn_cnt <= 9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || vn_cnt || '=' || vn_base_num * vn_cnt);
        EXIT WHEN vn_cnt = 5;
        vn_cnt := vn_cnt + 1;
    END LOOP;
END;

-- FOR문
DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '=' || vn_base_num * i);
    END LOOP;
END;

DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    FOR i IN REVERSE 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '=' || vn_base_num * i);
    END LOOP;
END;

-- CONTINUE문
DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    FOR i IN 1..9
    LOOP
        CONTINUE WHEN i=5;
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '=' || vn_base_num * i);
    END LOOP;
END;

-- GOTO문
DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    <<third>> -- 첫번째 for문의 라벨
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '=' || vn_base_num * i);
        IF i = 3 THEN
            GOTO fourth;
        END IF;
    END LOOP;
    
    <<fourth>> -- 두번째 for문의 라벨
    vn_base_num := 4;
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '=' || vn_base_num * i);
    END LOOP;
END;
-- 개발 현장에서는 GOTO문을 잘 사용하지 않음 (로직의 일관성이 훼손될 수 있음)


---- PL/SQL의 사용자 정의 함수
-- 1
CREATE OR REPLACE FUNCTION my_mod (num1 NUMBER, num2 NUMBER)
    RETURN NUMBER
IS
    vn_remainder NUMBER := 0;
    vn_quotient NUMBER := 0;
BEGIN
    vn_quotient := FLOOR(num1 / num2);
    vn_remainder := num1 - (num2 * vn_quotient);
    
    RETURN vn_remainder;
END;

SELECT my_mod(14, 3) reminder
    FROM DUAL;

-- 2
CREATE OR REPLACE FUNCTION fn_get_country_name (p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
    vn_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO vn_count
        FROM countries
        WHERE country_id = p_country_id;
        
    IF vn_count = 0 THEN
        vs_country_name := '해당국가 없음';
    ELSE
        SELECT country_name INTO vs_country_name
            FROM countries
            WHERE country_id = p_country_id;
    END IF;
    
    RETURN vs_country_name;
END;

SELECT fn_get_country_name (52777) COUN1, fn_get_country_name(10000) COUN2
    FROM DUAL;

-- 3
CREATE OR REPLACE FUNCTION fn_get_user
    RETURN VARCHAR2
IS
    vs_user_name VARCHAR2(80);
BEGIN
    SELECT USER INTO vs_user_name
        FROM DUAL;
    RETURN vs_user_name;
END;

SELECT fn_get_user(), fn_get_user
    FROM DUAL;
-- 매개변수가 없는 경우에는 함수 이름 다음에 '()'를 생략해도 됨


---- 프로시저 ----
-- 특정한 로직을 처리하기만 하고 결과 값을 반환하지는 않는 서브 프로그램

-- 1
CREATE OR REPLACE PROCEDURE my_new_job_proc
( p_job_id IN JOBS.JOB_ID%TYPE
 , p_job_title IN JOBS.JOB_TITLE%TYPE
 , p_min_sal IN JOBS.MIN_SALARY%TYPE
 , p_max_sal IN JOBS.MAX_SALARY%TYPE )
IS
    vn_cnt NUMBER := 0;
BEGIN
    -- 동일한 job_id가 있는지 체크
    SELECT COUNT(*) INTO vn_cnt
        FROM JOBS
        WHERE job_id = p_job_id;
        
    -- 없으면 INSERT
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS (job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
    -- 있으면 UPDATE
    ELSE
        UPDATE JOBS
            SET job_title = p_job_title
                , min_salary = p_min_sal
                , max_salary = p_max_sal
                , update_date = SYSDATE
            WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;

EXEC my_new_job_proc('SM_JOB1', 'Sample JOB1', 1000, 5000);
EXEC my_new_job_proc('SM_JOB1', 'Sample JOB1', 2000, 6000);

SELECT * FROM jobs
    WHERE job_id = 'SM_JOB1';


-- 매개변수가 많은 경우 혼동하지 않도록 매개변수와 입력값을 매핑하여 실행할 수 있음
EXECUTE my_new_job_proc(p_job_id => 'SM_JOB2', p_job_title => 'Sample JOB2', p_min_sal => 2000, p_max_sal => 7000);

SELECT * FROM JOBS
    WHERE job_id = 'SM_JOB2';


-- 매개변수 디폴트 값 설정
CREATE OR REPLACE PROCEDURE my_new_job_proc
( p_job_id IN JOBS.JOB_ID%TYPE
 , p_job_title IN JOBS.JOB_TITLE%TYPE
 , p_min_sal IN JOBS.MIN_SALARY%TYPE := 10 -- 기본값 설정
 , p_max_sal IN JOBS.MAX_SALARY%TYPE := 100 )
IS
    vn_cnt NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO vn_cnt
        FROM JOBS
        WHERE job_id = p_job_id;
        
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS (job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
    ELSE
        UPDATE JOBS
            SET job_title = p_job_title
                , min_salary = p_min_sal
                , max_salary = p_max_sal
                , update_date = SYSDATE
            WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;

EXEC my_new_job_proc('SM_JOB1', 'Sample JOB1');
SELECT * FROM JOBS WHERE job_id = 'SM_JOB1';


-- OUT 매개변수
CREATE OR REPLACE PROCEDURE my_new_job_proc
( p_job_id IN JOBS.JOB_ID%TYPE
 , p_job_title IN JOBS.JOB_TITLE%TYPE
 , p_min_sal IN JOBS.MIN_SALARY%TYPE := 10 -- 기본값 설정
 , p_max_sal IN JOBS.MAX_SALARY%TYPE := 100
 , p_upd_date OUT JOBS.UPDATE_DATE%TYPE)
IS
    vn_cnt NUMBER := 0;
    vn_cur_date JOBS.UPDATE_DATE%TYPE := SYSDATE;
BEGIN
    SELECT COUNT(*) INTO vn_cnt
        FROM JOBS
        WHERE job_id = p_job_id;
        
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS (job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal, vn_cur_date, vn_cur_date);
    ELSE
        UPDATE JOBS
            SET job_title = p_job_title
                , min_salary = p_min_sal
                , max_salary = p_max_sal
                , update_date = vn_cur_date
            WHERE job_id = p_job_id;
    END IF;
    
    -- OUT 매개변수에 일자 할당
    p_upd_date := vn_cur_date;
    
    COMMIT;
END;

DECLARE
    vd_cur_date JOBS.UPDATE_DATE%TYPE;
BEGIN
    my_new_job_proc('SM_JOB1', 'Sample JOB1', 2000, 6000, vd_cur_date);
    DBMS_OUTPUT.PUT_LINE(vd_cur_date);
END;
-- 익명 블록에서 프로시저를 실행할 때는 EXEC를 붙이지 않고 호출

-- IN OUT 매개변수
CREATE OR REPLACE PROCEDURE my_parameter_test_proc
( p_var1 VARCHAR2
 , p_var2 OUT VARCHAR2
 , p_var3 IN OUT VARCHAR2 )
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('p_var1 value = ' || p_var1);
    DBMS_OUTPUT.PUT_LINE('p_var2 value = ' || p_var2);
    DBMS_OUTPUT.PUT_LINE('p_var3 value = ' || p_var3);
    
    p_var2 := 'B2';
    p_var3 := 'C2';
END;

DECLARE
    v_var1 VARCHAR2(10) := 'A';
    v_var2 VARCHAR2(10) := 'B';
    v_var3 VARCHAR2(10) := 'C';
BEGIN
    my_parameter_test_proc (v_var1, v_var2, v_var3);
    
    DBMS_OUTPUT.PUT_LINE('v_var2 value = ' || v_var2);
    DBMS_OUTPUT.PUT_LINE('v_var3 value = ' || v_var3);
END;

-- IN 매개변수는 참조만 가능하며 값을 할당할 수 없음
-- OUT 매개변수에 값을 전달할 수는 있으나 의미 없음
-- OUT, IN OUT 매개변수에는 디폴트 값을 설정할 수 없음
-- IN 매개변수에는 변수나 상수, 각 데이터 유형에 따른 값을 전달할 수 있지만,
-- OUT, IN OUT 매개변수에 전달할 때는 반드시 변수 형태로 값을 전달해야 함

-- RETURN문
CREATE OR REPLACE PROCEDURE my_new_job_proc
( p_job_id IN JOBS.JOB_ID%TYPE
 , p_job_title IN JOBS.JOB_TITLE%TYPE
 , p_min_sal IN JOBS.MIN_SALARY%TYPE := 10 -- 기본값 설정
 , p_max_sal IN JOBS.MAX_SALARY%TYPE := 100)
IS
    vn_cnt NUMBER := 0;
    vn_cur_date JOBS.UPDATE_DATE%TYPE := SYSDATE;
BEGIN
    -- 1000보다 작으면 메시지 출력 후 빠져 나간다.
    IF p_min_sal < 1000 THEN
        DBMS_OUTPUT.PUT_LINE('최소 급여값은 1000 이상이어야 합니다');
        RETURN;
    END IF;
    
    SELECT COUNT(*) INTO vn_cnt
        FROM JOBS
        WHERE job_id = p_job_id;
        
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS (job_id, job_title, min_salary, max_salary, create_date, update_date)
            VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal, vn_cur_date, vn_cur_date);
    ELSE
        UPDATE JOBS
            SET job_title = p_job_title
                , min_salary = p_min_sal
                , max_salary = p_max_sal
                , update_date = vn_cur_date
            WHERE job_id = p_job_id;
    END IF;    
    COMMIT;
END;

EXEC my_new_job_proc('SM_JOB1', 'Sample JOB1', 999, 6000);