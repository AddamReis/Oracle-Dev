Tamanho de Variaveis VARCHAR(4000);


CREATE OR REPLACE FUNCTION get_used_memory RETURN NUMBER AS
  l_used_memory  NUMBER;
BEGIN
  SELECT ms.value
  INTO   l_used_memory
  FROM   v$mystat ms,
         v$statname sn
  WHERE  ms.statistic# = sn.statistic#
  AND    sn.name = 'session pga memory';
  RETURN l_used_memory;
END get_used_memory;


SET SERVEROUTPUT ON
-- VARCHAR(1)
DECLARE
  l_recursion_level  NUMBER := 10000;
  l_start            NUMBER;
  PROCEDURE varchar2_1 (p_varchar  IN  VARCHAR2,
                        p_number   IN  NUMBER) AS
    l_varchar  VARCHAR2(1) := p_varchar;
  BEGIN
    IF p_number < l_recursion_level THEN
      varchar2_1 (l_varchar, p_number + 1);
    END IF;
  END varchar2_1;
BEGIN
  l_start := get_used_memory;
  varchar2_1('1', 0);
  DBMS_OUTPUT.put_line('VARCHAR2_1     : ' || (get_used_memory - l_start));
END; --0,16

-- VARCHAR2(1999)
DECLARE
  l_recursion_level  NUMBER := 10000;
  l_start            NUMBER;
  PROCEDURE varchar2_1999 (p_varchar  IN  VARCHAR2,
                        p_number   IN  NUMBER) AS
    l_varchar  VARCHAR2(1999) := p_varchar;
  BEGIN
    IF p_number < l_recursion_level THEN
      varchar2_1999 (l_varchar, p_number + 1);
    END IF;
  END varchar2_1999;
BEGIN
  l_start := get_used_memory;
  varchar2_1999('1', 0);
  DBMS_OUTPUT.put_line('VARCHAR2_1999  : ' || (get_used_memory - l_start));
END;

-- VARCHAR2(2000)
DECLARE
  l_recursion_level  NUMBER := 10000;
  l_start            NUMBER;

  PROCEDURE varchar2_2000 (p_varchar  IN  VARCHAR2,
                        p_number   IN  NUMBER) AS
    l_varchar  VARCHAR2(2000) := p_varchar;
  BEGIN
    IF p_number < l_recursion_level THEN
      varchar2_2000 (l_varchar, p_number + 1);
    END IF;
  END varchar2_2000;
BEGIN
  l_start := get_used_memory;
  varchar2_2000('1', 0);
  DBMS_OUTPUT.put_line('VARCHAR2_2000  : ' || (get_used_memory - l_start));
END;

-- VARCHAR2(4000)
DECLARE
  l_recursion_level  NUMBER := 10000;
  l_start            NUMBER;

  PROCEDURE varchar2_4000 (p_varchar  IN  VARCHAR2,
                        p_number   IN  NUMBER) AS
    l_varchar  VARCHAR2(4000) := p_varchar;
  BEGIN
    IF p_number < l_recursion_level THEN
      varchar2_4000 (l_varchar, p_number + 1);
    END IF;
  END varchar2_4000;
BEGIN
  l_start := get_used_memory;

  varchar2_4000('1', 0);

  DBMS_OUTPUT.put_line('VARCHAR2_4000  : ' || (get_used_memory - l_start));
END;

-- VARCHAR2(4001)
DECLARE
  l_recursion_level  NUMBER := 10000;
  l_start            NUMBER;

  PROCEDURE varchar2_4001 (p_varchar  IN  VARCHAR2,
                        p_number   IN  NUMBER) AS
    l_varchar  VARCHAR2(4001) := p_varchar;
  BEGIN
    IF p_number < l_recursion_level THEN
      varchar2_4001 (l_varchar, p_number + 1);
    END IF;
  END varchar2_4001;
BEGIN
  l_start := get_used_memory;
  varchar2_4001('1', 0);
  DBMS_OUTPUT.put_line('VARCHAR2_4001  : ' || (get_used_memory - l_start));
END;

--VARCHAR2(32767)
DECLARE
  l_recursion_level  NUMBER := 10000;
  l_start            NUMBER;

  PROCEDURE varchar2_32767 (p_varchar  IN  VARCHAR2,
                       p_number   IN  NUMBER) AS
    l_varchar  VARCHAR2(32767) := p_varchar;
  BEGIN
    IF p_number < l_recursion_level THEN
      varchar2_32767 (l_varchar, p_number + 1);
    END IF;
  END varchar2_32767;
BEGIN
  l_start := get_used_memory;
  varchar2_32767('1', 0);
  DBMS_OUTPUT.put_line('VARCHAR2_32767 : ' || (get_used_memory - l_start));
END;


DROP FUNCTION get_used_memory;
Fun��o para retornar a quantidade de mem�ria PGA sendo utilizada pela sess�o, que � utilizada para 
c�lculo de mem�ria atribu�da para cada teste.

A defini��o byte 4001 requer um pouco menos de mem�ria do que a defini��o 1 byte
Se o tamanho vari�vel � reduzido para 4000 bytes, � necess�ria mais mem�ria. 
Isto implica que o n�vel de otimiza��o �, na verdade, 4001 bytes em Oracle 10g, n�o 2000, 
como afirma o documento.

No momento da reda��o deste scritp, a quest�o foi levantada como um bug (erro no. 4330467), com o suporte da Oracle, 
e a documenta��o do Oracle 10g Release 2 foi alterado para refletir este novo limite para a otimiza��o de VARCHAR2. 
Assim, maior � verdadeiramente melhor para vari�veis VARCHAR2.

