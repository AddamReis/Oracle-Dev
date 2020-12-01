9 - NOCOPY

A dica NOCOPY informa o compilador PL / SQL para passar OUT e IN OUT parâmetros por referência, ao invés de por valor.

Um parâmetro de subprograma pode ser passado  entre duas maneiras - por referência ou por valor. Quando uma 
parâmetro é passado por referência , um ponteiro para o parametro real é passado para o parametro formal correspondente. 
Por outro lado, quando um parâmetro é passado por valor  ele é copiado do parâmetro real para o parâmetro formal. 
Passar por referência é geralmente mais rápido, pois evita cópia. Por padrão, a PL/SQL passará parâmetros IN por 
referência e parâmetros OUT e IN OUT por valor. Isso é feito para preservar a semântica de exceção e de tal modo que 
as restrições sobre os parâmetros reais possam ser verificados. Antes do Oracle8i , não havia nenhuma maneira de 
modificar esse comportamento.


CREATE OR REPLACE PROCEDURE NoCopyTest (
 p_InParameter IN NUMBER, -- passado por referencia por default
 p_OutParameter OUT  NOCOPY  VARCHAR2, -- out é passado por valor por default mas utilizando o hint nocopy força a passar por referencia
 p_InOutParameter IN OUT  NOCOPY CHAR) -- out é passado por valor por default mas utilizando o hint nocopy força a passar por referencia
 IS BEGIN 
    NULL; 
 END NoCopyTes;
 
NOCOPY não é aplicado para o parâmetro IN pois os parâmetros IN sempre serão passados
por referência


declare
  type my_type is table of varchar2(32767) index by binary_integer;
  my_array my_type;
  st number;
  rt number;

  procedure in_out(m1 in out my_type) -- passagem é por valor
  is
  begin
    dbms_output.put_line(my_array(1));
  end in_out;
  
  procedure in_out_nocopy(m1  in out nocopy my_type) -- agora a passagem é por referencia
  is
  begin
    dbms_output.put_line(my_array(1));
  end in_out_nocopy;

  begin
  for i in 1..999999 loop
    my_array(i) := '123456789012345678901234567890123456789012345678901234567890abcd';
  end loop;
    st := dbms_utility.get_time;
    in_out(my_array);
    rt := (dbms_utility.get_time - st)/100;
    dbms_output.put_line('Time needed for in out is: ' || rt || ' 100''ths of second!');
   
    st := dbms_utility.get_time;
    in_out_nocopy(my_array);
    rt := (dbms_utility.get_time - st)/100;
    dbms_output.put_line('Time needed for in out nocopy is: ' || rt || ' 100''ths of second!');
  end;

Restrições de NOCOPY
 
Como NOCOPY é uma dica que o compilador não é obrigado a seguir, em alguns casos, ele será ignorado e o parametro sera 
passado como valor. NOCOPY sera ignorado nas seguintes situações:

 
- O parametro real é membro de uma tabela index-by. Exceto se o parametro real for uma tabela inteira.
- O parametro real esta escrito por uma precisao, escala ou NOT NULL.
- Os parametros formais e reais sao registros; e eles foram declarados implicitamente com uma variavel de controle de 
  loop ou utilizando %ROWTYPE, e as restrições diferem nos campos correspondentes.
- Passar o parâmetro real requer uma conversão implícita para os tipos de dados.
- O subprograma é envolvido em uma chamada de procedimento remoto (RPC). Uma RPC é uma chamada de procedure realizada 
  de um link do banco de dados para um servidor remoto. Pelo fato de os parametros deverem ser transferidos na rede, nao é
  possivel passa-los por referencia.

Então, quando você deve usar NOCOPY?

Use NOCOPY quando ambas as condições forem verdadeiras:

:: Os parametros usarem grandes estruturas de dados, causando problemas de desempenho na passagem de parâmetros
:: Os programa de chamada pode ignorar os valores dos parâmetros retornados pelo subprograma se o subprograma sai com o erro.

