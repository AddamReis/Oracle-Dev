Tuning If/Case statement

-- :: EVITAR PASSAGENS POR IFs DESNECESSÁRIOS


SET SERVEROUTPUT ON
DECLARE
  v_discount NUMBER;
  qtde NUMBER;
BEGIN
  qtde := 1;
  v_discount :=
         CASE
            WHEN qtde > 10
               THEN 17
            WHEN qtde = 9
               THEN 16
            WHEN qtde = 8
               THEN 15
            WHEN qtde = 7
               THEN 14
            WHEN qtde = 6
               THEN 13
            WHEN qtde = 5
               THEN 12
            WHEN qtde = 4                
               THEN 11
            WHEN qtde = 3
               THEN 10
            WHEN qtde = 2
               THEN 8
            WHEN qtde = 1
               THEN 5
         END; 
END;         

O código está correto, mas sabemos que 90% do tempo os clientes só comprar um item. Isso significa que, na maioria das
vezes nós avaliamos 9 cláusulas desnecessárias. 

Colocar nas intruções if and case as variaveis mais prováveis em primeiro lugar para não fazer verificações
desnecessárias

Melhor para reescrever esta declaração da seguinte forma:

DECLARE
  v_discount NUMBER;
  qtde NUMBER := 1;
BEGIN
  qtde := 1;
  v_discount := CASE
            WHEN qtde = 1
               THEN 5
            WHEN qtde = 2
               THEN 8
            WHEN qtde = 3
               THEN 10
            WHEN qtde = 4
               THEN 11
            WHEN qtde = 5
               THEN 12
            WHEN qtde = 6
               THEN 13
            WHEN qtde = 7
               THEN 14
            WHEN qtde = 8
               THEN 15
            WHEN qtde = 9
               THEN 16
            WHEN qtde > 10
               THEN 17
         END; 
END;         

-- Caso 2

declare
    v_sts varchar(10);
    n_numb number;
begin
    n_numb := 4;
    if n_numb > 5 then
      v_sts := 'large';
    else
      v_sts := 'small';
    end if;
end;

declare
  v_sts varchar(10);
  n_numb number;
begin
  n_numb := 4;
  if n_numb > 5 then 
    v_sts := 'large'; 
  end if;
  if n_numb <=5 then 
    v_sts := 'small'; 
  end if;
end;  

declare
  v_sts varchar(10);
  n_numb number;
begin
  n_numb := 7;
  if n_numb > 5 then 
    v_sts := 'large'; 
    GOTO jump;
  end if;
  if n_numb <=5 then 
    v_sts := 'small'; 
  end if;
  << jump >>
  null;
end;  


-- caso 3 if vs case
SET SERVEROUTPUT ON
DECLARE
  l_day  VARCHAR2(100);
BEGIN
  l_day := TRIM(TO_CHAR(SYSDATE, 'DAY')); 
  IF l_day = 'SATURDAY' THEN
    DBMS_OUTPUT.put_line('The weekend has just started!');
  ELSIF l_day = 'SUNDAY' THEN
    DBMS_OUTPUT.put_line('The weekend is nearly over!');
  ELSE
    DBMS_OUTPUT.put_line('It''s not the weekend yet!');
  END IF;
END;


SET SERVEROUTPUT ON
DECLARE
  l_day  VARCHAR2(100);
BEGIN
  l_day := TRIM(TO_CHAR(SYSDATE, 'DAY'));  
  CASE
    WHEN l_day = 'SATURDAY' THEN
      DBMS_OUTPUT.put_line('The weekend has just started!');
    WHEN l_day = 'SUNDAY' THEN
      DBMS_OUTPUT.put_line('The weekend is nearly over!');
    ELSE
      DBMS_OUTPUT.put_line('It''s not the weekend yet!');
  END CASE;
END;

-- CASE statement is the natural replacement for large IF-THEN-ELSIF-ELSE statements. "
