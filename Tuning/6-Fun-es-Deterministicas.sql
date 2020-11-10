Função Deterministica

A função é considerado determinístico se ela sempre retorna o mesmo resultado para um valor de entrada específico. 
A documentação da Oracle afirma que a definição de funções de tabela em pipeline como determinista usando a cláusula 
DETERMINISTIC permite Oracle para amortecer suas fileiras, evitando assim várias execuções. Mas não consigo encontrar 
nenhuma evidência para apoiar esta reivindicação.


CREATE OR REPLACE PACKAGE hr.deterministic_api AS
  TYPE t_out_row IS RECORD (
    id  NUMBER
  ); 
  TYPE t_out_tab IS TABLE OF t_out_row; 
  FUNCTION no_deterministic
    RETURN t_out_tab PIPELINED;   
  FUNCTION deterministic
    RETURN t_out_tab PIPELINED DETERMINISTIC;
END deterministic_api;


CREATE OR REPLACE PACKAGE BODY hr.deterministic_api AS
  FUNCTION no_deterministic
    RETURN t_out_tab PIPELINED
  IS
    l_row  t_out_row;
  BEGIN
    FOR i IN 1 .. 10000 LOOP
      l_row.id := i;
      PIPE ROW (l_row);
    END LOOP;
    RETURN;
  END no_deterministic;   

  FUNCTION deterministic
    RETURN t_out_tab PIPELINED DETERMINISTIC
  IS
    l_row  t_out_row;
  BEGIN
    FOR i IN 1 .. 10000 LOOP
      l_row.id := i;
      PIPE ROW (l_row);
    END LOOP;
    RETURN;
  END deterministic;
END deterministic_api;

SET SERVEROUTPUT ON
DECLARE
  l_start  NUMBER;
  l_count  NUMBER;
BEGIN
  l_start := DBMS_UTILITY.get_time;
  FOR i IN 1 .. 7000 LOOP
    SELECT COUNT(*)
    INTO   l_count
    FROM   TABLE(hr.deterministic_api.deterministic);
  END LOOP; 
  DBMS_OUTPUT.put_line('Deterministic   : ' || (DBMS_UTILITY.get_time - l_start));


  l_start := DBMS_UTILITY.get_time; 
  FOR i IN 1 .. 7000 LOOP
    SELECT COUNT(*)
    INTO   l_count
    FROM   TABLE(hr.deterministic_api.no_deterministic);
  END LOOP; 
  DBMS_OUTPUT.put_line('No Deterministic: ' || (DBMS_UTILITY.get_time - l_start));
END;

