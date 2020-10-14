Candidatos a Otimiza��o


1 - C�digo antigo que n�o tirar proveito dos novos recursos da linguagem PL/SQL.

    Features for Oracle 11gR2
    
    :: DBMS_PARALLEL_EXECUTE Package
    :: FORCE Option in CREATE TYPE Statement
    :: Crossedition Triggers
    :: ALTER TYPE Statement Restrictions for Editioned ADTs
    :: RESET option for ALTER TYPE Statement
    :: Automatic Detection of Data Sources of Result-Cached Function
    :: Result Caches in Oracle RAC Environment Are No Longer Private
    
    Features for Oracle 11gR1
    
    :: Enhancements to Regular Expression SQL Functions
    :: SIMPLE_INTEGER, SIMPLE_FLOAT, and SIMPLE_DOUBLE Data Types
    :: CONTINUE Statement
    :: Sequences in PL/SQL Expressions
    :: Dynamic SQL Enhancements
    :: Named and Mixed Notation in PL/SQL Subprogram Invocations
    :: PL/SQL Function Result Cache
    :: Compound DML Triggers
    :: More Control Over Triggers
    :: Automatic Subprogram Inlining
    :: PL/Scope
    :: PL/SQL Hierarchical Profiler
    :: PL/SQL Native Compiler Generates Native Code Directly


2 - DBMS_SQL package Old Dynamic Statement

    Se voc� sabe em tempo de compila��o o n�mero e tipos de dados das vari�veis de entrada e sa�da de uma instru��o SQL 
    din�mica, ent�o voc� pode reescrever a declara��o em SQL din�mica nativa, que � executado visivelmente mais r�pido 
    do que o c�digo equivalente que usa o pacote DBMS_SQL (especialmente quando se pode ser otimizado pelo compilador)

3 - Tune Sql 
   
    :: Melhoria em c�gigos SQL 
    :: Usar indices apropriados
    :: Hints
    :: DBMS_STATS - coleta de estatisticas em objetos
    :: Analisar plano de execu��o
    :: Trace e o TKProf
    :: Bulk SQL e Bulk Binding
    :: DBMS_SQLTUNE
    :: DBMS_TRACE
    :: DBMS_PROFILE

4 - Tune Functions Invocatiosn Querys

    :: Curso de Tuning de PLSQL
    :: Analisar uma melhor codifica��o e chamada para fun��es em querys
    
        explain plan for
        SELECT DISTINCT(SQRT(department_id)) col_alias
        FROM hr.employees
        ORDER BY col_alias;
        select * from table (dbms_xplan.display);
        
        explain plan for
        SELECT SQRT(department_id) col_alias
        FROM (SELECT DISTINCT department_id FROM hr.employees)
        ORDER BY col_alias;
        select * from table (dbms_xplan.display);
    
    ::Passagem de parametros IN OUT
      Utiliza��o do HINT NOCOPY - Evita que vari�veis sejam criadas dentro de blocos para passagem de parametros
    
5 - Tune Loops
    
    :: Reescrever e analisar a necessidade de LOOPS dentro de seu c�digo, tentar diminuir o m�ximo.

6 - Tune Computatios-Intensive PLSQL Code and Minimizing CPU Overhead

    :: Analisar a possibilidade de troca por vari�veis PLS_INTEGER - BINARY_FLOAT - BINARY_DOUBLE
    :: Minimizar convers�es implicitas de dados.  x = 1   x = to_char('1');
    :: Declare the variable with the %TYPE attribute, described in "%TYPE Attribute".
    :: Usar fun��es de caracter REGEXP_LIKE - express�es regulares
    :: IF boolean_variable OR (number > 10) OR boolean_function(parameter) THEN ..
    :: Bulk SQL minimizes the performance overhead of the communication between PL/SQL and SQL.
    :: Inline
   
7 - Compiling PLSQL Units for Native Execution 
    :: Capitulo 16 Curso PLSQL
    :: ALTER SESSION SET PLSQL_CODE_TYPE = NATIVE; -- interpreted




referencias :
http://docs.oracle.com/cd/E11882_01/appdev.112/e25519/tuning.htm#LNPLS012
https://docs.oracle.com/cd/B28359_01/appdev.111/b28370/tuning.htm#LNPLS012






