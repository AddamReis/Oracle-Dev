
Cursores Explícitos Vs Implícitos

Por um longo tempo, tem havido debates sobre os méritos relativos de cursores implícitos e explícitos. 
A resposta curta é que os cursores implícitos são mais rápidos e resultar em um código muito mais pura forma 
que há muito poucos casos em que é necessário recorrer a cursores explícitos.


CREATE OR REPLACE PROCEDURE cursor_comparison AS
  l_loops  NUMBER := 1000000;
  l_dummy  dual.dummy%TYPE;
  l_start  NUMBER;

  CURSOR c_dual IS
    SELECT dummy
    FROM dual;

BEGIN
  -- Time explicit cursor.
  l_start := DBMS_UTILITY.get_time;

  FOR i IN 1 .. l_loops LOOP --10000
    OPEN  c_dual;
    FETCH c_dual
    INTO  l_dummy;
    CLOSE c_dual;
  END LOOP;

  DBMS_OUTPUT.put_line('Explicit: ' || 
                       (DBMS_UTILITY.get_time - l_start));

  -- Time implicit cursor.
  l_start := DBMS_UTILITY.get_time;
  FOR i IN 1 .. l_loops LOOP -- 10000
    SELECT dummy
    INTO   l_dummy
    FROM   dual;
  END LOOP;
  DBMS_OUTPUT.put_line('Implicit: ' || 
                       (DBMS_UTILITY.get_time - l_start));
END cursor_comparison;

execute cursor_comparison


CREATE OR REPLACE PROCEDURE cursor_comparison AS
  l_loops  NUMBER := 1000000;
  l_dummy  dual.dummy%TYPE;
  l_start  NUMBER;
BEGIN
-- Time implicit cursor.
  l_start := DBMS_UTILITY.get_time;
  FOR i IN 1 .. l_loops LOOP -- 10000
    SELECT dummy
    INTO   l_dummy
    FROM   dual;
  END LOOP;
  DBMS_OUTPUT.put_line('Implicit: ' || 
                       (DBMS_UTILITY.get_time - l_start));END cursor_comparisonend;
END;
                       