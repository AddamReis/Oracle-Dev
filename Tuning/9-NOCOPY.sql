9 - NOCOPY

A dica NOCOPY informa o compilador PL / SQL para passar OUT e IN OUT par�metros por refer�ncia, ao inv�s de por valor.

Um par�metro de subprograma pode ser passado  entre duas maneiras - por refer�ncia ou por valor. Quando uma 
par�metro � passado por refer�ncia , um ponteiro para o parametro real � passado para o parametro formal correspondente. 
Por outro lado, quando um par�metro � passado por valor  ele � copiado do par�metro real para o par�metro formal. 
Passar por refer�ncia � geralmente mais r�pido, pois evita c�pia. Por padr�o, a PL/SQL passar� par�metros IN por 
refer�ncia e par�metros OUT e IN OUT por valor. Isso � feito para preservar a sem�ntica de exce��o e de tal modo que 
as restri��es sobre os par�metros reais possam ser verificados. Antes do Oracle8i , n�o havia nenhuma maneira de 
modificar esse comportamento.


CREATE OR REPLACE PROCEDURE NoCopyTest (
 p_InParameter IN NUMBER, -- passado por referencia por default
 p_OutParameter OUT  NOCOPY  VARCHAR2, -- out � passado por valor por default mas utilizando o hint nocopy for�a a passar por referencia
 p_InOutParameter IN OUT  NOCOPY CHAR) -- out � passado por valor por default mas utilizando o hint nocopy for�a a passar por referencia
 IS BEGIN 
    NULL; 
 END NoCopyTes;
 
NOCOPY n�o � aplicado para o par�metro IN pois os par�metros IN sempre ser�o passados
por refer�ncia


declare
  type my_type is table of varchar2(32767) index by binary_integer;
  my_array my_type;
  st number;
  rt number;

  procedure in_out(m1 in out my_type) -- passagem � por valor
  is
  begin
    dbms_output.put_line(my_array(1));
  end in_out;
  
  procedure in_out_nocopy(m1  in out nocopy my_type) -- agora a passagem � por referencia
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

Restri��es de NOCOPY
 
Como NOCOPY � uma dica que o compilador n�o � obrigado a seguir, em alguns casos, ele ser� ignorado e o parametro sera 
passado como valor. NOCOPY sera ignorado nas seguintes situa��es:

 
- O parametro real � membro de uma tabela index-by. Exceto se o parametro real for uma tabela inteira.
- O parametro real esta escrito por uma precisao, escala ou NOT NULL.
- Os parametros formais e reais sao registros; e eles foram declarados implicitamente com uma variavel de controle de 
  loop ou utilizando %ROWTYPE, e as restri��es diferem nos campos correspondentes.
- Passar o par�metro real requer uma convers�o impl�cita para os tipos de dados.
- O subprograma � envolvido em uma chamada de procedimento remoto (RPC). Uma RPC � uma chamada de procedure realizada 
  de um link do banco de dados para um servidor remoto. Pelo fato de os parametros deverem ser transferidos na rede, nao �
  possivel passa-los por referencia.

Ent�o, quando voc� deve usar NOCOPY?

Use NOCOPY quando ambas as condi��es forem verdadeiras:

:: Os parametros usarem grandes estruturas de dados, causando problemas de desempenho na passagem de par�metros
:: Os programa de chamada pode ignorar os valores dos par�metros retornados pelo subprograma se o subprograma sai com o erro.

