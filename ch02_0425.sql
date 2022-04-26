-- sql Developer ���̵� VS Code, PyCharm, Eclipse ��� ���� ����
-- ���̺� ����
CREATE TABLE ex2_1 (
    COLUMN1 CHAR(10)
    , COLUMN2 VARCHAR2(10)
    , COLUMN3 NVARCHAR2(10)
    , COLUMN4 NUMBER
);

-- ���� ������ Ÿ��
INSERT INTO ex2_1 (COLUMN1, COLUMN2) VALUES ('abc', 'abc');
SELECT
    COLUMN1
    , LENGTH(COLUMN1) as len1
    , COLUMN2
    , LENGTH(COLUMN2) as len2
FROM ex2_1;

--
CREATE TABLE ex2_2(
    COLUMN1 VARCHAR2(3)
    , COLUMN2 VARCHAR2(3 byte)
    , COLUMN3 VARCHAR2(3 char)
);

INSERT INTO ex2_2 VALUES('abc', 'abc', 'abc');
SELECT
    COLUMN1
    , LENGTH(COLUMN1) AS len1
    , COLUMN2
    , LENGTH(COLUMN2) AS len2
    , COLUMN3
    , LENGTH(COLUMN3) AS len3
FROM ex2_2;

--
INSERT INTO ex2_2 VALUES('ȫ�浿', 'ȫ�浿', 'ȫ�浿');
INSERT INTO ex2_2 (COLUMN3) VALUES('ȫ�浿');

SELECT
    COLUMN3
    , LENGTH(COLUMN3) AS len3
    , LENGTHB(COLUMN3) AS bytelen
FROM ex2_2;

-- ���� ������ Ÿ��
CREATE TABLE ex2_3(
    COL_INT INTEGER
    , COL_DEC DECIMAL
    , COL_NUM NUMBER
);

SELECT column_id, column_name, data_type, data_length
    FROM user_tab_cols
    WHERE table_name = 'EX2_3'
    ORDER BY column_id;

--
CREATE TABLE ex2_4 (
    COL_FLOT1 FLOAT(32)
    , COL_FLOT2 FLOAT
);

INSERT INTO ex2_4 (col_flot1, col_flot2) VALUES(1234567891234, 1234567891234);
SELECT * FROM ex2_4;

-- ��¥ ������ Ÿ��
CREATE TABLE ex2_5 (
    COL_DATE DATE
    , COL_TIMESTAMP TIMESTAMP
);

INSERT INTO ex2_5 VALUES (SYSDATE, SYSTIMESTAMP);
SELECT * FROM ex2_5;

-- LOB ������ Ÿ��
-- Large OBject; ��뷮 �����͸� ������ �� �ִ� Ÿ��(������ �����Ϳ� Ȱ��)