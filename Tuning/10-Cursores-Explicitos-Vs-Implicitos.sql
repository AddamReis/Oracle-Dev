
Cursores Expl�citos Vs Impl�citos

Por um longo tempo, tem havido debates sobre os m�ritos relativos de cursores impl�citos e expl�citos. 
A resposta curta � que os cursores impl�citos s�o mais r�pidos e resultar em um c�digo muito mais pura forma 
que h� muito poucos casos em que � necess�rio recorrer a cursores expl�citos.


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
                       