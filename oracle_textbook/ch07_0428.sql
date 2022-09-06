---- 분석 함수 (Analytic Function) ----
-- 특정 그룹별로 집계 값을 산출할 때 사용
-- 일반적으로 GROUP BY절에 의해 최종 결과를 산출하면 로우 수가 줄어든다.
-- WINDOW 함수를 사용하면 로우의 손실 없이도 그룹별 집계 값을 산출할 수 있다.

-- PARTITION BY 절 : 분석 함수로 계산될 대상 로우의 그룹(파티션)을 지정
-- ORDER BY 절 : 파티션 안에서의 순서를 지정
-- WINDOW 절 : 파티션으로 분할된 그룹에 대해 더 상세한 그룹으로 분할

-- ROW_NUMBER() : 파티션으로 분할된 그룹별로 각 로우의 순번 반환
SELECT department_id
        , emp_name
        , ROW_NUMBER() OVER(PARTITION BY department_id
                            ORDER BY department_id, emp_name) dep_rows
    FROM employees;

-- RANK(), DENSE_RANK() : 파티션별 순위 반환
SELECT department_id
        , emp_name
        , salary
        , RANK() OVER (PARTITION BY department_id
                       ORDER BY salary) dep_rank -- 순위가 같은 경우 뛰어넘고 처리
        , DENSE_RANK() OVER (PARTITION BY department_id
                             ORDER BY salary) dep_rank -- 순위가 같은 경우 이어서 처리
    FROM employees;

-- CUME_DIST() : 주어진 그룹에 대한 상대 누적 분포도 값 반환(0 초과 1 이하)
-- PERCENT_RANK() : 해당 그룹 내의 백분위 순위 반환(0 이상 1 이하)
SELECT department_id
        , emp_name
        , salary
        , RANK() OVER (PARTITION BY department_id
                            ORDER BY salary) dep_rank
        , CUME_DIST() OVER (PARTITION BY department_id
                            ORDER BY salary) dep_dist
        , PERCENT_RANK() OVER (PARTITION BY department_id
                            ORDER BY salary) dep_perc
    FROM employees;

-- NTILE(expr) : 파티션별로 expr에 명시된 값만큼 분할한 결과 반환
SELECT department_id
        , emp_name
        , salary
        , NTILE(4) OVER (PARTITION BY department_id
                            ORDER BY salary) ntiles
    FROM employees;

-- LAG(expr, offset, default_value) : 주어진 그룹과 순서에 따라 선행 로우의 값 참조
-- LEAD(expr, offset, default_value) : 주어진 그룹과 순서에 따라 후행 로우의 값 참조
-- offset은 선행/후행 로우와의 간격 수
SELECT emp_name
        , hire_date
        , salary
        , LAG(salary, 1, 0) OVER (ORDER BY hire_date) AS prev_sal
        , LEAD(salary, 1, 0) OVER (ORDER BY hire_date) AS next_sal
    FROM employees
    WHERE department_id = 30;