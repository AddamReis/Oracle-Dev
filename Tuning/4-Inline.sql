Habilitando o intraunit inlining

Oracle 11g tomou otimização do compilador mais, em especial, com o conceito de subprograma inline. Com subprograma inline, 
a Oracle irá substituir uma chamada para uma sub-rotina (como uma função) com o próprio código de rotina durante a 
compilação. Uma das vantagens deste é que podemos continuar a escrever código bem estruturado, modular, 
sem quaisquer penalidades de desempenho. Para os programas PL / SQL intensivos em SQL, os ganhos do inline 
pode ser menores, mas para o código processual, inline pode fornecer alguns benefícios maiores de otimização

O benefício de inline também é maior quando utilizado com compilação nativa do que quando usado com compilação interpretado. 

NATIVO
ALTER SESSION SET PLSQL_CODE_TYPE = NATIVE;

Exemplo :

set serveroutput on 
DECLARE
       n1 PLS_INTEGER := 0;
       FUNCTION f (p IN PLS_INTEGER) RETURN PLS_INTEGER IS
       BEGIN
          RETURN DBMS_RANDOM.VALUE(1,1000);
       END f;
BEGIN
      FOR i IN 1 .. 1000000 LOOP
         PRAGMA INLINE(f,'NO');
         n1 := n1 + f(i);
      END LOOP;
END;   
 
   
DECLARE
       n1 PLS_INTEGER := 0;
       FUNCTION f (p IN PLS_INTEGER) RETURN PLS_INTEGER IS
       BEGIN
          RETURN DBMS_RANDOM.VALUE(1,1000);
       END f;
BEGIN
      FOR i IN 1 .. 1000000 LOOP
         PRAGMA INLINE(f,'YES');
         n1 := n1 + f(i);
      END LOOP;
END;   

http://www.oracle-developer.net/display.php?id=502























Result Cache

Um novo recurso do Oracle 11g, o cache de resultado, é uma ferramenta poderosa que pode ser usado para armazenar os 
resultados da consulta e função na memória. A informação é armazenada em cache em uma área dedicada dentro da piscina 
comum, onde ele pode ser compartilhado por outros programas PL / SQL que estão realizando cálculos semelhantes. 
Se os dados armazenados neste cache de mudanças, os valores que estão em cache se tornar inválido. Este recurso é 
útil para bancos de dados com as declarações que precisam acessar um grande número de linhas e retornar apenas alguns 
deles

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
ALTER SESSION SET plsql_code_type = 'INTERPRETED';
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

-- Trace PLSQL

Permite analisar o desempenho da execução de blocos PL/SQL anônimos ou nomeados;

grant execute on DBMS_TRACE to hr;

É necessário criar (1 única vez) logado como SYS, as tabelas que guardam as informações de trace, executando o script
?/rdbms/admin/tracetab.sql;

-- criando procedure SP_TESTE no schema do usuario HR
CREATE OR REPLACE PROCEDURE HR.SP_TESTE (p_loop NUMBER) IS
  v_count number;
BEGIN   
  for i in 1..p_loop
  loop
    SELECT  COUNT(1) INTO V_COUNT
    FROM    HR.EMPLOYEES WHERE EMPLOYEE_ID = i;
  end loop;
END; 

-- executar procedure 3X com nivel de trace diferente em cada execucao
DECLARE
  l_result  NUMBER;
BEGIN
  -- monitorar chamadas pl/sql
  DBMS_TRACE.set_plsql_trace (DBMS_TRACE.trace_all_calls);
  hr.SP_TESTE(500);
  DBMS_TRACE.clear_plsql_trace;
  
  -- monitorar sql
  DBMS_TRACE.set_plsql_trace (DBMS_TRACE.trace_all_sql);
  hr.SP_TESTE(500);
  DBMS_TRACE.clear_plsql_trace;

  -- monitorar chamadas por linha
  DBMS_TRACE.set_plsql_trace (DBMS_TRACE.trace_all_lines);
  hr.SP_TESTE(500);
  DBMS_TRACE.clear_plsql_trace;  
END;
/

-- buscar o runid e o usuário
select runid, run_owner
from sys.plsql_trace_runs;

     RUNID RUN_OWNER                     
---------- -------------------------------
         1 HR
         
         
select event_seq, substr(event_comment,1,30) event_comment,
 event_unit, event_line, substr(b.text, 1, 40) script
 from sys.plsql_trace_events a
 left join (select *
 from all_source
 where name in ('TRACE_EXAMPLE2')
 and owner = upper('SCOTT')) b on (a.event_unit_owner = b.owner
 and a.event_unit = b.name
 and a.event_line = b.line)
 where runid = 20
 order by event_seq; 
 
 select  * from sys.plsql_trace_events
 
 
Restrições
You cannot use PL/SQL tracing in a shared server environment.


Event 
EVENT_SEQ EVENT_COMMENT EVENT_UNIT line SCRIPT 
---------- ------------------------------ --------------- ------ ---------------------------------------- 
1 PL/SQL Trace Tool started 
2 Trace flags changed 
3 Return from procedure call DBMS_TRACE 21 
4 New line executed DBMS_TRACE 66 
5 New line executed DBMS_TRACE 67 
6 Return from procedure call DBMS_TRACE 67 
7 New line executed DBMS_TRACE 72 
8 Return from procedure call DBMS_TRACE 72 
9 New line executed 5 
10 Procedure Call 5 
11 New line executed TRACE_EXAMPLE2 1 procedure trace_example2 is 
12 New line executed TRACE_EXAMPLE2 5 open a; 
13 Procedure Call TRACE_EXAMPLE2 5 open a; 
14 New line executed TRACE_EXAMPLE2 2 cursor a is select * from employee; 
15 SELECT * FROM EMPLOYEE TRACE_EXAMPLE2 2 cursor a is select * from employee; 
16 Return from procedure call TRACE_EXAMPLE2 2 cursor a is select * from employee; 
17 New line executed TRACE_EXAMPLE2 6 fetch a into a_var; 
18 SELECT * FROM EMPLOYEE TRACE_EXAMPLE2 6 fetch a into a_var; 
19 New line executed TRACE_EXAMPLE2 7 while a%found loop 
20 New line executed TRACE_EXAMPLE2 8 if a_var.first_name = 'JOHN' then 
21 New line executed TRACE_EXAMPLE2 11 fetch a into a_var; 
22 SELECT * FROM EMPLOYEE TRACE_EXAMPLE2 11 fetch a into a_var; 
23 New line executed TRACE_EXAMPLE2 7 while a%found loop 
24 New line executed TRACE_EXAMPLE2 8 if a_var.first_name = 'JOHN' then 
25 New line executed TRACE_EXAMPLE2 11 fetch a into a_var; 
26 SELECT * FROM EMPLOYEE TRACE_EXAMPLE2 11 fetch a into a_var; 
...
63 New line executed TRACE_EXAMPLE2 7 while a%found loop 
64 New line executed TRACE_EXAMPLE2 8 if a_var.first_name = 'JOHN' then 
65 New line executed TRACE_EXAMPLE2 9 display (a_var.last_name); 
66 Procedure Call TRACE_EXAMPLE2 9 display (a_var.last_name); 
67 New line executed DISPLAY 1 
68 New line executed DISPLAY 3 
69 New line executed DISPLAY 4 
70 Procedure Call DISPLAY 4 
71 New line executed DBMS_OUTPUT 99 
72 New line executed DBMS_OUTPUT 103 
73 New line executed DBMS_OUTPUT 111 
74 New line executed DBMS_OUTPUT 112 
75 New line executed DBMS_OUTPUT 121 
76 New line executed DBMS_OUTPUT 122 
77 New line executed DBMS_OUTPUT 123 
78 Procedure Call DBMS_OUTPUT 123 
79 New line executed DBMS_OUTPUT 127 
... 
96 New line executed DBMS_OUTPUT 177 
97 New line executed DBMS_OUTPUT 180 
98 Return from procedure call DBMS_OUTPUT 180 
99 New line executed DBMS_OUTPUT 125 
100 Return from procedure call DBMS_OUTPUT 125 
101 New line executed DISPLAY 5 
102 Return from procedure call DISPLAY 5 
103 New line executed TRACE_EXAMPLE2 11 fetch a into a_var; 
104 SELECT * FROM EMPLOYEE TRACE_EXAMPLE2 11 fetch a into a_var; 
105 New line executed TRACE_EXAMPLE2 7 while a%found loop 
106 New line executed TRACE_EXAMPLE2 8 if a_var.first_name = 'JOHN' then 
107 New line executed TRACE_EXAMPLE2 11 fetch a into a_var; 
108 SELECT * FROM EMPLOYEE TRACE_EXAMPLE2 11 fetch a into a_var; 
... 
137 New line executed TRACE_EXAMPLE2 7 while a%found loop 
138 New line executed TRACE_EXAMPLE2 8 if a_var.first_name = 'JOHN' then 
139 New line executed TRACE_EXAMPLE2 11 fetch a into a_var; 
140 SELECT * FROM EMPLOYEE TRACE_EXAMPLE2 11 fetch a into a_var; 
141 New line executed TRACE_EXAMPLE2 7 while a%found loop 
142 New line executed TRACE_EXAMPLE2 13 end; 
143 Return from procedure call TRACE_EXAMPLE2 13 end; 
144 New line executed 6 
145 Procedure Call 6 
146 New line executed DBMS_TRACE 76 
147 Procedure Call DBMS_TRACE 76 
148 New line executed DBMS_TRACE 60 
149 New line executed DBMS_TRACE 63 
150 Procedure Call DBMS_TRACE 63 
151 New line executed DBMS_TRACE 57 
152 Procedure Call DBMS_TRACE 57 
153 New line executed DBMS_TRACE 12 
154 Return from procedure call DBMS_TRACE 12 
155 New line executed DBMS_TRACE 57 
156 New line executed DBMS_TRACE 58 
157 Return from procedure call DBMS_TRACE 58 
158 New line executed DBMS_TRACE 60 
159 New line executed DBMS_TRACE 63 
160 New line executed DBMS_TRACE 66 
161 Procedure Call DBMS_TRACE 66 
162 New line executed DBMS_TRACE 21 
163 PL/SQL trace stopped
163 rows selected.
SQL>


-- referencias:
  -- http://www.dba-oracle.com/plsql/t_plsql_dbms_trace.htm
  -- http://docs.oracle.com/cd/E11882_01/appdev.112/e40758/d_trace.htm#ARPLS060


   
   
   
   
   
   






 






























