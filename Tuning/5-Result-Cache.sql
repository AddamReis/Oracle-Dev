Result Cache

Um novo recurso do Oracle 11g, o cache de resultado, é uma ferramenta poderosa que pode ser usado para armazenar os 
resultados da consulta e função na memória. A informação é armazenada em cache em uma área dedicada dentro da Shared Pool
, onde ele pode ser compartilhado por outros programas PL / SQL que estão realizando cálculos semelhantes. 
Este recurso é útil para bancos de dados com as declarações que precisam acessar um grande número de linhas e retornar 
apenas alguns deles.

dbms_result_cache

--Check result cache parameters
select 
   name,
   value 
from 
   v$parameter 
where 
   name like '%result%';
   
--Query the v$result_cache_objects to check if there is any cached object 
select 
   count(*) 
from 
   v$result_cache_objects;
   
--Use the result_cache hint because manual mode is being used for this instance
select /*+ result_cache */  
   count(*) 
from 
   hr.employees 
where 
   employee_id=102;
   

---Check objects cached
select 
   o.owner "Owner",
   o.object_id "ID", 
   o.object_name "Name", 
   r.object_no "Obj Number"
from 
   dba_objects o, 
   gv$result_cache_dependency r
where 
   o.object_id = r.object_no;   
   

--Flush Retaining memory (default for both are FALSE)
begin 
dbms_result_cache.flush (
   retainmem => TRUE,
   retainsta => FALSE);
end;

-- *** RESULT CACHE NAO FUNCIONA NO ORACLE XE ***
-- nasceu no 11g
-- usado mais para calculos .. result_cache area da shared pool força a registros ficarem na memoria.
ALTER SESSION SET plsql_code_type = 'INTEPRETED';

CREATE OR REPLACE FUNCTION HR.fib_interpreted (n POSITIVE) RETURN INTEGER 
    RESULT_CACHE
IS 
BEGIN 
  IF (n = 1) OR (n = 2) THEN 
    RETURN 1; 
  ELSE 
    RETURN hr.fib_interpreted(n - 1) + hr.fib_interpreted(n - 2); 
  END IF; 
END; 

