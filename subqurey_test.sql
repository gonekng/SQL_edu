-- SQL 서브쿼리 연습문제
-- 문제 1. 2015년 평균 기대수명보다 높은 모든 정보를 조회하세요.
-- 테이블명 : populations
                                   
SELECT *
    FROM populations
    WHERE year = 2015
        AND life_expectancy > (SELECT AVG(life_expectancy) as AVG
                                FROM populations
                                where year = 2015
                                GROUP BY year);

-- 문제 2. subquery_countries 테이블에 있는 capital과 
-- 매칭되는 cities 테이블의 정보를 조회하세요. 
-- 조회할 컬럼명은 name, country_code, urbanarea_pop

SELECT a.name, a.country_code, a.urbanarea_pop
    FROM cities a
    WHERE a.name IN (SELECT b.capital
                        FROM subquery_countries b)
    ORDER BY a.urbanarea_pop desc;

-- 문제 3. 
-- 조건 1. economies 테이블에서 country code, inflation rate, unemployment rate를 조회한다.
-- 조건 2. inflation rate 오름차순으로 정렬한다.
-- 조건 3. subquery_countries 테이블내 gov_form 컬럼에서 Constitutional Monarchy 또는 `Republic`이 들어간 국가는 제외한다.

SELECT a.code, a.inflation_rate, a.unemployment_rate
    FROM economies a
    WHERE a.year = 2015 
        AND a.code NOT IN (SELECT b.code
                            FROM subquery_countries b
                            WHERE b.gov_form = 'Constitutional Monarchy'
                                OR b.gov_form LIKE '%Republic%')
    ORDER BY a.inflation_rate ASC;

-- 문제 4. 2015년 각 대륙별 inflation_rate가 가장 심한 국가와 inflation_rate를 구하세요. 
-- 힌트 1. 아래 쿼리 실행
SELECT country_name, continent, inflation_rate
  FROM subquery_countries 
  	INNER JOIN economies
    USING (code)
WHERE year = 2015;
-- 각 대륙별 inflation_rate가 가장 높은 나라를 추출하는 코드를 작성한다. 

With basis AS (
            SELECT country_name, continent, inflation_rate
                FROM subquery_countries 
                    INNER JOIN economies
                    USING (code)
                WHERE year = 2015
            )
    , max_inf AS (
            SELECT continent, MAX(inflation_rate) as inflation_rate
                FROM basis
                GROUP BY continent
            )
SELECT a.country_name, b.continent, b.inflation_rate
    FROM basis a, max_inf b
    WHERE a.inflation_rate = b.inflation_rate;

-- SQL 윈도우 함수 연습문제
-- 문제 1. 각 행에 숫자를 1, 2, 3, ..., 형태로 추가한다. (row_n 으로 표시)
-- row_n 기준으로 오름차순으로 출력
-- 테이블명에 alias를 적용한다. 

With sub_table AS (
                SELECT ROWNUM-95 AS ROW_N
                    , YEAR, CITY, SPORT, DISCIPLINE, ATHLETE
                    FROM summer_medals
                )
SELECT * 
    FROM sub_table
    WHERE ROW_N > 0;

-- 문제 2. 올림픽 년도를 오름차순 순번대로 작성을 한다. 
-- 힌트 : 서브쿼리와 윈도우 함수를 이용한다. 

SELECT year, ROW_NUMBER() OVER (ORDER BY year) as ROW_N
    FROM (SELECT year FROM summer_medals GROUP BY year);

-- 문제 3. 
-- (1) WITH 절 사용하여 각 운동선수들이 획득한 메달 갯수를 내림차순으로 정렬하도록 합니다. 
-- (2) (1) 쿼리를 활용하여 그리고 선수들의 랭킹을 추가한다. 
-- 상위 5개만 추출 : OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
-- WITH AS (1번 쿼리)
-- 2번 쿼리

With basis AS (
            SELECT ATHLETE, COUNT(*) AS MEDALS
                FROM summer_medals
                GROUP BY ATHLETE
                ORDER BY COUNT(*) desc
            )
SELECT MEDALS, ATHLETE, ROWNUM
    FROM basis
    OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- 문제 4
-- 다음쿼리를 실행한다. 
-- 남자 69KG 역도 경기에서 매년 금메달리스트 조회하도록 합니다. 
SELECT
    Year,
    Country AS champion
  FROM summer_medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold';
    
-- 기존 쿼리에서 매년 전년도 챔피언도 같이 조회하도록 합니다.
-- LAG & WITH 절 사용

WITH basis AS (
            SELECT Year, Country AS champion
                FROM summer_medals
                WHERE Discipline = 'Weightlifting'
                    AND Event = '69KG'
                    AND Gender = 'Men'
                    AND Medal = 'Gold'
            )
SELECT year, champion, LAG(champion, 1) OVER(order by champion) AS LAST_CHAMPION
    FROM basis;