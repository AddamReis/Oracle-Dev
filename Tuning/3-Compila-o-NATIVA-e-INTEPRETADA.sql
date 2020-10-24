/* --------------------------------------------------------------------------------------------------------------------
                                                  PEDRO F. CARVALHO
                                              www.pedrofcarvalho.com.br
                                            contato@pedrofcarvalho.com.br
                                TREINAMENTO DE TUNING DE PL/SQL ORACLE 9i 10g 11g 12c
----------------------------------------------------------------------------------------------------------------------*/

Compilações native ou interpreted

Por padrão, cada unidade de programa PLSQL é compilada em código legível pela máquina, na forma de intermediária.  
Esse código legível pela máquina é armazenada no banco de dados e interpretado sempre que o código é executado.  
Com a compilação nativa PL/SQL o PL/SQL é transformado em codigo nativo e armazenado em bibliotecas compartilhadas.
O código nativo ´executado muito mais rapidamente do que o código interpretado, pois não precisa ser interpretado antes 
da execução.  O modo de compilação é determinado pelo valor do parâmetro PLSQL_CODE_TYPE, que tem valores de 
interpretado (padrão) ou nativas. Ganho de (5-15)% de desempenho pode ser obtido através da compilação de rotina em 
código nativo

-- ver MOS: "PLSQL Native Compilation (NCOMP) in 11g [ID 1086845.1]"

-- desabilita debug para permitir compilacao nativa
alter system set plsql_debug=false;

-- habilitando compilacao nativa no 10G
ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 3;
ALTER SESSION SET PLSQL_CODE_TYPE = NATIVE;

-- habilitando compilacao nativa no 11G
ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 3;
ALTER SESSION SET PLSQL_CODE_TYPE = NATIVE; -- interpreted

-- consultar objetos compilados em modo nativo
SELECT  owner, name, PLSQL_code_type 
FROM    dba_plsql_object_settings
--where   plsql_code_type = 'NATIVE'; 
--where   plsql_code_type = 'INTERPRETED'
where NAME LIKE 'PFC%'
ORDER BY 2;

-- verificar configuracoes de modo de compilacao
show parameter PLSQL_OPTIMIZE_LEVEL
show parameter PLSQL_CODE_TYPE

drop function HR.pfc_interpreted

ALTER SESSION SET PLSQL_CODE_TYPE = NATIVE;

CREATE OR REPLACE FUNCTION HR.pfc_native (n POSITIVE) RETURN INTEGER IS 
BEGIN 
  IF (n = 1) OR (n = 2) THEN 
    RETURN 1; 
  ELSE 
    RETURN hr.pfc_native(n - 1) + hr.pfc_native(n - 2); 
  END IF; 
END; 
/ 

-- ALTER PROCEDURE HR.fib_native COMPILE PLSQL_CODE_TYPE = NATIVE

ALTER SESSION SET plsql_code_type = 'INTERPRETED';
CREATE OR REPLACE FUNCTION HR.pfc_interpreted (n POSITIVE) RETURN INTEGER IS 
BEGIN 
  IF (n = 1) OR (n = 2) THEN 
    RETURN 1; 
  ELSE 
    RETURN hr.pfc_interpreted(n - 1) + hr.pfc_interpreted(n - 2); 
  END IF; 
END; 
/ 

-- verificar se as 2 procedures nos 2 modos foram compiladas conforme desejado
SELECT  owner, name, PLSQL_code_type 
FROM    dba_plsql_object_settings
where   OWNER = 'HR'


-- verificar tempo de execucao DAS FUNCOES
set timing on 
set serveroutput on 
DECLARE 
  x NUMBER; 
BEGIN 
  x := hr.pfc_interpreted(25); 
  dbms_output.put_line(x); 
END; 

set timing on 
set serveroutput on 
DECLARE 
  x NUMBER; 
BEGIN 
  x := hr.pfc_native(25); 
  dbms_output.put_line(x); 
END; 


referencias :
http://docs.oracle.com/cd/E11882_01/appdev.112/e25519/tuning.htm#LNPLS012
https://docs.oracle.com/cd/B28359_01/appdev.111/b28370/tuning.htm#LNPLS012





















