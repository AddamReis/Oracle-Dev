Parametros de Performance PLSQL_OPTIMIZE_LEVEL

O parâmetro foi introduzido no Oracle 10g para decidir o nível de otimização aplicáveis para uma unidade de programa 
durante a compilação.

Antes de o Oracle Database 10g, o compilador PL / SQL traduzido seu texto de origem para o código do sistema sem aplicar
muitas mudanças para melhorar o desempenho. Agora, PL / SQL usa um otimizador que pode reorganizar o código para um 
melhor desempenho.

O otimizador é ativado por padrão. Em casos raros, se a sobrecarga do otimizador faz compilação de aplicações muito 
grandes muito lento, você pode diminuir a otimização definindo o parâmetro compilação PLSQL_OPTIMIZE_LEVEL = 1 
em vez de seu valor padrão 2. Em casos ainda mais raros, PL / SQL pode levantar uma exceção mais cedo do que o esperado 
ou não em todos. Definir PLSQL_OPTIMIZE_LEVEL = 1 impede que o código seja reorganizado.

Ele é definido pelo DBA, sessão e nível de objeto. Ele pode ser consultado em vista USER_PLSQL_OBJECT_SETTINGS para um 
determinado objeto

select * from USER_PLSQL_OBJECT_SETTINGS

Antes do lançamento 11g, o parâmetro poderia acomodar apenas três valores válidos, ou seja, 0, 1 e 2. 
Oracle 11g introduziu um nível de otimização adicional 3. Por padrão, o valor do parâmetro é 2. 

Com PLSQL_OPTIMIZE_LEVEL = 3, o compilador PL / SQL busca oportunidades para inline subprogramas, além daqueles que você
especificar.

Se um subprograma particular é inline, desempenho quase sempre melhora. No entanto, porque os inlines compilador 
subprogramas no início do processo de optimização, é possível para o subprograma inline para impedir optimizações mais 
tarde, mais poderosos.

Se subprograma inlining diminui o desempenho de um determinado programa PL / SQL, use o PL / SQL profiler hierárquica 
para identificar subprogramas para o qual você deseja desativar inlining. Para desativar inlining para um subprograma, 
utilize o pragma INLINE, descrito no INLINE Pragma.

select * from v$parameter
show parameter plsql_optimize_level

ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 1

Caso 1: PLSQL_OPTIMIZE_LEVEL = 0
Esse nível representa nenhuma Optimization. O compilador só mantém a ordem de avaliação de código e 
executa-lo sem qualquer esforço de optimização de código.

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
  DBMS_OUTPUT.PUT_LINE('Execution time:'||TO_CHAR(L_END_TIME ||'–'|| L_START_TIME));
END;
-- 3.675


Caso 2: PLSQL_OPTIMIZE_LEVEL = 1
Este nível representa o nível eliminative Optimization Elementary e "mantendo a mesma ordem de código. O compilador 
otimiza o código, eliminando o código da lógica irrelevante.

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
  DBMS_OUTPUT.PUT_LINE('Execution time:'||TO_CHAR(L_END_TIME ||'–'|| L_START_TIME));
END;
-- 1,089

Caso 3: PLSQL_OPTIMIZE_LEVEL = 2
Este é o nível padrão de optimização, onde o compilador inteligente faz a refatorações e utiliza técnicas de optimização 
avançadas para modificar a estrutura do código, a fim de alcançar o melhor.

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
  DBMS_OUTPUT.PUT_LINE('Execution time:'||TO_CHAR(L_END_TIME ||'–'|| L_START_TIME));
END;

--0,001

Caso 4: PLSQL_OPTIMIZE_LEVEL = 3
Este é o nível de otimização mais recente introduzida no Oracle 11g. É uma espécie de "forçada" nível de otimização, 
que os termos da Oracle como otimização de 'High Priority'. O otimizador de código faz a refatoração de código e 
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
  DBMS_OUTPUT.PUT_LINE('Execution time:'||TO_CHAR(L_END_TIME ||'–'|| L_START_TIME));
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