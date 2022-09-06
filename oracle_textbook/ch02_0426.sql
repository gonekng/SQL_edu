---- 제약 조건 ----
-- NOT NULL
CREATE TABLE ex2_6 (
    COL_NULL VARCHAR2(10)
    , COL_NOT_NULL VARCHAR2(10) NOT NULL
);

INSERT INTO ex2_6 VALUES('AA', '');
INSERT INTO ex2_6 VALUES('AA', 'BB');

-- UNIQUE
CREATE TABLE ex2_7 (
    COL_UNIQUE_NULL VARCHAR2(10) UNIQUE
    , COL_UNIQUE_NNULL VARCHAR2(10) UNIQUE NOT NULL
    , COL_UNIQUE VARCHAR2(10)
    , CONSTRAINTS unique_nm1 UNIQUE(COL_UNIQUE)
);

SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
    WHERE table_name = 'EX2_7';

INSERT INTO ex2_7 VALUES('AA', 'AA', 'AA');
SELECT * FROM ex2_7

INSERT INTO ex2_7 VALUES('AA', 'AA', 'AA');
SELECT * FROM ex2_7
-- ORA-00001: 무결성 제약 조건(ORA_USER.SYS_C007455)에 위배됩니다

INSERT INTO ex2_7 VALUES('', 'BB', 'BB');
SELECT * FROM ex2_7

INSERT INTO ex2_7 VALUES('', 'CC', 'CC');
SELECT * FROM ex2_7

-- 기본키
CREATE TABLE ex2_8 (
    COL1 VARCHAR2(10) PRIMARY KEY
    , COL2 VARCHAR2(10)
);

SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
    WHERE table_name = 'EX2_8';

INSERT INTO ex2_8 VALUES('', 'AA');
SELECT * FROM ex2_8;
-- ORA-01400: NULL을 ("ORA_USER"."EX2_8"."COL1") 안에 삽입할 수 없습니다

INSERT INTO ex2_8 VALUES('AA', 'AA');
SELECT * FROM ex2_8;

INSERT INTO ex2_8 VALUES('AA', 'AA');
SELECT * FROM ex2_8;
-- ORA-00001: 무결성 제약 조건(ORA_USER.SYS_C007458)에 위배됩니다

-- CHECK
CREATE TABLE ex2_9 (
    num1 NUMBER 
     CONSTRAINTS check1 CHECK ( num1 BETWEEN 1 AND 9)
    , gender VARCHAR2(10) 
     CONSTRAINTS check2 CHECK ( gender IN ('MALE', 'FEMALE'))        
); 

SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_9';
 
INSERT INTO ex2_9 VALUES (10, 'MAN');
-- ORA-02290: 체크 제약조건(ORA_USER.CHECK2)이 위배되었습니다

INSERT INTO ex2_9 VALUES (5, 'FEMALE');

-- DEFAULT 
CREATE TABLE ex2_10 (
   Col1 VARCHAR2(10) NOT NULL
   , Col2 VARCHAR2(10) NULL
   , Create_date DATE DEFAULT SYSDATE
);
   
INSERT INTO ex2_10 (COL1, COL2) VALUES ('AA', 'AA'); 
SELECT * FROM ex2_10;


---- 테이블 삭제 ----
-- CASCADE CONSTRAINTS : 참조 무결성 제약조건도 자동 삭제
DROP TABLE ex2_10;


---- 테이블 변경 ----
CREATE TABLE ex2_10 (
   Col1 VARCHAR2(10) NOT NULL
   , Col2 VARCHAR2(10) NULL
   , Create_date DATE DEFAULT SYSDATE
);

-- 컬럼명 변경
ALTER TABLE ex2_10 RENAME COLUMN COL1 TO COL11;
DESC ex2_10;

-- 컬럼 타입 변경
ALTER TABLE ex2_10 MODIFY COL2 VARCHAR2(30);
DESC ex2_10;

-- 컬럼 추가
ALTER TABLE ex2_10 ADD COL3 NUMBER;
DESC ex2_10;

-- 컬럼 삭제
ALTER TABLE ex2_10 DROP COLUMN COL3;
DESC ex2_10;

-- 제약조건 추가
ALTER TABLE ex2_10 ADD CONSTRAINTS pk_ex2_10 PRIMARY KEY (COL11);
SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
    WHERE table_name = 'EX2_10';

-- 제약조건 삭제
ALTER TABLE ex2_10 DROP CONSTRAINTS pk_ex2_10;
SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
    WHERE table_name = 'EX2_10';


---- 테이블 복사 ----
CREATE TABLE ex2_9_1 AS
    SELECT * FROM ex2_9;

SELECT * FROM ex2_9_1;


---- 뷰 (VIEW) ----
-- 뷰 생성
SELECT a.employee_id, a.emp_name, a.department_id,
           b.department_name
      FROM employees a,
           departments b
     WHERE a.department_id = b.department_id;

CREATE OR REPLACE VIEW emp_dept_v1 AS
    SELECT a.employee_id, a.emp_name, a.department_id,
           b.department_name
      FROM employees a,
           departments b
     WHERE a.department_id = b.department_id;
     
SELECT * FROM emp_dept_v1;


---- 인덱스 ----
-- 내부 구조에 따른 분류 : B-Tree 인덱스, 비트맵 인덱스, 함수 기반 인덱스
-- 인덱스 생성
CREATE UNIQUE INDEX ex2_10_ix01
ON ex2_10 (COL11);

SELECT index_name, index_type, table_name, uniqueness
    FROM user_indexes
    WHERE table_name = 'EX2_10';
    
-- 결합 인덱스
CREATE INDEX ex2_10_ix02
    ON ex2_10 (col11, col2);

SELECT index_name, index_type, table_name, uniqueness
      FROM user_indexes
    WHERE table_name = 'EX2_10';

-- 인덱스 삭제
DROP INDEX ex2_10_ix02;


---- Self-Check ----
-- 1.
CREATE TABLE ORDERS (
    ORDER_ID NUMBER(12, 0)
    , ORDER_DATE DATE
    , ORDER_MODE VARCHAR2(8 BYTE)
    , CUSTOMER_ID NUMBER(6,0)
    , ORDER_STATUS NUMBER(2,0)
    , ORDER_TOTAL NUMBER(8,2) DEFAULT 0
    , SALES_REP_ID NUMBER(6,0)
    , PROMOTION_ID NUMBER(6,0)
    , CONSTRAINT PK_ORDER PRIMARY KEY (ORDER_ID)
    , CONSTRAINT CK_ORDER_MODE CHECK (ORDER_MODE IN ('direct','online'))
);

-- 2.
CREATE TABLE OREDER_ITEMS (
    ORDER_ID NUMBER(12,0)
    , LINE_ITEM_ID NUMBER(3,0)
    , PRODUCT_ID NUMBER(3,0)
    , UNIT_PRICE NUMBER(8,2) DEFAULT 0
    , QUANTITY NUMBER(8,0) DEFAULT 0
    , CONSTRAINT PK_ORDER_ITEMS PRIMARY KEY (ORDER_ID, LINE_ITEM_ID)
);

-- 3.
CREATE TABLE PROMOTIONS (
    PROMO_ID NUMBER(6,0)
    , PROMO_NAME VARCHAR2(20)
    , CONSTRAINT PK_PROMOTIONS PRIMARY KEY (PROMO_ID)
);

