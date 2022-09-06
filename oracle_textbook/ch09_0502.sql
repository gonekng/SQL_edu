---- 조건절 ----
-- 사원 이름 입력 (KING, SCOTT)
-- 받는 급여가 고소득인지 중간소득인지 저소득인지 구분
ACCEPT p_ename prompt '사원 이름을 입력하세요 ~ '
DECLARE
    -- 변수 선언
    v_ename emp.ename%TYPE := upper('&p_ename');
    v_sal emp.sal%TYPE;
BEGIN
    SELECT sal INTO v_sal
        FROM emp
        WHERE ename = v_ename;
    DBMS_OUTPUT.PUT_LINE('급여 ' || v_sal);
    
    -- 조건식
    IF v_sal >= 3500 THEN
        DBMS_OUTPUT.PUT_LINE('고 소득자');
    ELSIF v_sal >= 2000 THEN
        DBMS_OUTPUT.PUT_LINE('중간 소득자');
    ELSE
        DBMS_OUTPUT.PUT_LINE('저 소득자');
    END IF;
END;

---- 반복문 ----
-- 구구단 만들기
DECLARE
    v_count number(10) := 0;
BEGIN
    LOOP -- 반복문 실행
        v_count := v_count +1;
        DBMS_OUTPUT.PUT_LINE('2 * ' || v_count || ' = ' || 2 * v_count);
        EXIT WHEN v_count = 9;
    END LOOP;
END;