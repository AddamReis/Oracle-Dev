Parametros de Performance PLSQL_OPTIMIZE_LEVEL

O par�metro foi introduzido no Oracle 10g para decidir o n�vel de otimiza��o aplic�veis para uma unidade de programa 
durante a compila��o.

Antes de o Oracle Database 10g, o compilador PL / SQL traduzido seu texto de origem para o c�digo do sistema sem aplicar
muitas mudan�as para melhorar o desempenho. Agora, PL / SQL usa um otimizador que pode reorganizar o c�digo para um 
melhor desempenho.

O otimizador � ativado por padr�o. Em casos raros, se a sobrecarga do otimizador faz compila��o de aplica��es muito 
grandes muito lento, voc� pode diminuir a otimiza��o definindo o par�metro compila��o PLSQL_OPTIMIZE_LEVEL = 1 
em vez de seu valor padr�o 2. Em casos ainda mais raros, PL / SQL pode levantar uma exce��o mais cedo do que o esperado 
ou n�o em todos. Definir PLSQL_OPTIMIZE_LEVEL = 1 impede que o c�digo seja reorganizado.

Ele � definido pelo DBA, sess�o e n�vel de objeto. Ele pode ser consultado em vista USER_PLSQL_OBJECT_SETTINGS para um 
determinado objeto

select * from USER_PLSQL_OBJECT_SETTINGS

Antes do lan�amento 11g, o par�metro poderia acomodar apenas tr�s valores v�lidos, ou seja, 0, 1 e 2. 
Oracle 11g introduziu um n�vel de otimiza��o adicional 3. Por padr�o, o valor do par�metro � 2. 

Com PLSQL_OPTIMIZE_LEVEL = 3, o compilador PL / SQL busca oportunidades para inline subprogramas, al�m daqueles que voc�
especificar.

Se um subprograma particular � inline, desempenho quase sempre melhora. No entanto, porque os inlines compilador 
subprogramas no in�cio do processo de optimiza��o, � poss�vel para o subprograma inline para impedir optimiza��es mais 
tarde, mais poderosos.

Se subprograma inlining diminui o desempenho de um determinado programa PL / SQL, use o PL / SQL profiler hier�rquica 
para identificar subprogramas para o qual voc� deseja desativar inlining. Para desativar inlining para um subprograma, 
utilize o pragma INLINE, descrito no INLINE Pragma.

select * from v$parameter
show parameter plsql_optimize_level

ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 1

Caso 1: PLSQL_OPTIMIZE_LEVEL = 0
Esse n�vel representa nenhuma Optimization. O compilador s� mant�m a ordem de avalia��o de c�digo e 
executa-lo sem qualquer esfor�o de optimiza��o de c�digo.

ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 0;
DECLARE
  L_START_TIME NUMBER;
  L_END_TIME NUMBER;
  A NUMBER; B NUMBER; C NUMBER;
BEGIN
  L_START_TIME := DBMS_UTILITY.GET_TIME();
  FOR I IN 1..10000000
  LOOP
    A := 1;
    B := 1;
    C := A+1;
  END LOOP;
  L_END_TIME := DBMS_UTILITY.GET_TIME();
  DBMS_OUTPUT.PUT_LINE('Execution time:'||TO_CHAR(L_END_TIME ||'�'|| L_START_TIME));
END;
-- 3.675


Caso 2: PLSQL_OPTIMIZE_LEVEL = 1
Este n�vel representa o n�vel eliminative Optimization Elementary e "mantendo a mesma ordem de c�digo. O compilador 
otimiza o c�digo, eliminando o c�digo da l�gica irrelevante.

ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 1;
DECLARE
  L_START_TIME NUMBER;
  L_END_TIME NUMBER;
  A NUMBER; B NUMBER; C NUMBER;
BEGIN
  L_START_TIME := DBMS_UTILITY.GET_TIME();
  FOR I IN 1..10000000
  LOOP
    A := 1;
    B := 1;
    C := A+1;
  END LOOP;
  L_END_TIME := DBMS_UTILITY.GET_TIME();
  DBMS_OUTPUT.PUT_LINE('Execution time:'||TO_CHAR(L_END_TIME ||'�'|| L_START_TIME));
END;
-- 1,089

Caso 3: PLSQL_OPTIMIZE_LEVEL = 2
Este � o n�vel padr�o de optimiza��o, onde o compilador inteligente faz a refatora��es e utiliza t�cnicas de optimiza��o 
avan�adas para modificar a estrutura do c�digo, a fim de alcan�ar o melhor.

ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 2;
DECLARE
  L_START_TIME NUMBER;
  L_END_TIME NUMBER;
  A NUMBER; B NUMBER; C NUMBER;
BEGIN
  L_START_TIME := DBMS_UTILITY.GET_TIME();
  FOR I IN 1..10000000
  LOOP
    A := 1;
    B := 1;
    C := A+1;
  END LOOP;
  L_END_TIME := DBMS_UTILITY.GET_TIME();
  DBMS_OUTPUT.PUT_LINE('Execution time:'||TO_CHAR(L_END_TIME ||'�'|| L_START_TIME));
END;

--0,001

Caso 4: PLSQL_OPTIMIZE_LEVEL = 3
Este � o n�vel de otimiza��o mais recente introduzida no Oracle 11g. � uma esp�cie de "for�ada" n�vel de otimiza��o, 
que os termos da Oracle como otimiza��o de 'High Priority'. O otimizador de c�digo faz a refatora��o de c�digo e 
automaticamente inlines todas as chamadas do programa na unidade de programa

inline processo

ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 3;
DECLARE
  L_START_TIME NUMBER;
  L_END_TIME NUMBER;
  A NUMBER; B NUMBER; C NUMBER;
BEGIN
  L_START_TIME := DBMS_UTILITY.GET_TIME();
  FOR I IN 1..10000000
  LOOP
    A := 1;
    B := 1;
    C := A+1;
  END LOOP;
  L_END_TIME := DBMS_UTILITY.GET_TIME();
  DBMS_OUTPUT.PUT_LINE('Execution time:'||TO_CHAR(L_END_TIME ||'�'|| L_START_TIME));
END;

0,01

create procedure hr.plsqlparametro
is
begin
  DBMS_OUTPUT.PUT_LINE('procedure para teste plsql parameter');
end;

ALTER PROCEDURE hr.plsqlparametro COMPILE PLSQL_OPTIMIZE_LEVEL = 3;

referencias :
http://docs.oracle.com/cd/E11882_01/appdev.112/e25519/tuning.htm#LNPLS012
https://docs.oracle.com/cd/B28359_01/appdev.111/b28370/tuning.htm#LNPLS012