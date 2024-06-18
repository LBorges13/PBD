AP13

-- 1.4.1 Exibe o número de estudantes maiores de idade.
 
 CREATE OR REPLACE PROCEDURE sp_qt_maior_idade(
     OUT Age INT
     )
 LANGUAGE plpgsql
 AS $$
 BEGIN
     SELECT COUNT (cod_id)
     INTO age
     FROM tb_alunos;
 
 END;
 $$
 
 DO $$
 DECLARE
     Age INT;
 BEGIN
     CALL sp_qt_maior_idade(Age);
     RAISE NOTICE 'A quantidade de maior de idade é de %', Age;
 END;
 $$
 
 CREATE TABLE tb_alunos(
  cod_id SERIAL PRIMARY KEY,
  Age INT,
  Gender INT,
  Salary INT,
  Prep_exam INT,
  Notes INT,
  Grade INT
 );
 
 SELECT * FROM tb_alunos;


 --1.4.2 Exibe o percentual de estudantes de cada sexo.
 
 CREATE OR REPLACE PROCEDURE sp_perc_por_genero(
     OUT Masculino NUMERIC ( 10, 2 ),
     OUT Feminino NUMERIC( 10, 2)
     )
 LANGUAGE plpgsql
 AS $$
 
 BEGIN
     SELECT COUNT (*)
     INTO Masculino
     FROM tb_alunos
     WHERE gender = 2;
 
     SELECT COUNT (*)
     INTO Feminino
     FROM tb_alunos
     WHERE gender = 1;
     Feminino := (Feminino /(Feminino + Masculino))* 100;
     Masculino :=(Masculino /(Feminino + Masculino))* 100;
 END;
 $$
 
 DO $$
 DECLARE
     Masculino NUMERIC( 10, 2);
     Feminino NUMERIC( 10, 2);
 BEGIN
     CALL sp_perc_por_genero(Feminino, Masculino);
     RAISE NOTICE 'O percentual de Masculino é % e Feminino é %', Masculino, Feminino ;
 END;
 $$


-- Recebe um sexo como parâmetro em modo IN e utiliza oito parâmetros em modo OUT 
-- para dizer qual o percentual de cada nota (variável grade) obtida por estudantes daquele
-- sexo.

CREATE OR REPLACE PROCEDURE sp_nota_genero(
    IN Genero INT,
    OUT Fail NUMERIC (10, 2),
    OUT DD NUMERIC (10, 2),
    OUT DC NUMERIC (10, 2),
    OUT CC NUMERIC (10, 2),
    OUT CB NUMERIC (10, 2),
    OUT BB NUMERIC (10, 2),
    OUT BA NUMERIC (10, 2),
    OUT AA NUMERIC (10, 2)
    )
LANGUAGE plpgsql
AS $$
 
BEGIN
    SELECT COUNT (*)
    INTO Fail
    FROM tb_alunos
    WHERE notes = 0 AND gender = Genero;
 
    SELECT COUNT (*)
    INTO DD
    FROM tb_alunos
    WHERE notes = 1 AND gender = Genero;
 
        SELECT COUNT (*)
    INTO DC
    FROM tb_alunos
    WHERE notes = 2 AND gender = Genero;
 
    SELECT COUNT (*)
    INTO CC
    FROM tb_alunos
    WHERE notes = 3 AND gender = Genero;
 
        SELECT COUNT (*)
    INTO CB
    FROM tb_alunos
    WHERE notes = 4 AND gender = Genero;
 
    SELECT COUNT (*)
    INTO BB
    FROM tb_alunos
    WHERE notes = 5 AND gender = Genero;
 
        SELECT COUNT (*)
    INTO BA
    FROM tb_alunos
    WHERE notes = 6 AND gender = Genero;
 
    SELECT COUNT (*)
    INTO AA
    FROM tb_alunos
    WHERE notes = 7 AND gender = Genero;
 
    Fail := (Fail /(Fail + DD + DC + CC + CB + BB + BA + AA))* 100;
    DD := (DD /(Fail + DD + DC + CC + CB + BB + BA + AA))* 100;
    DC := (DC /(Fail + DD + DC + CC + CB + BB + BA + AA))* 100;
    CC := (CC /(Fail + DD + DC + CC + CB + BB + BA + AA))* 100;
    CB := (CB /(Fail + DD + DC + CC + CB + BB + BA + AA))* 100;
    BB := (BB /(Fail + DD + DC + CC + CB + BB + BA + AA))* 100;
    BA := (BA /(Fail + DD + DC + CC + CB + BB + BA + AA))* 100;
    AA := (AA /(Fail + DD + DC + CC + CB + BB + BA + AA))* 100;
END;
$$
 
DO $$
DECLARE
    Fail NUMERIC (10, 2);
    DD NUMERIC (10, 2);
    DC NUMERIC (10, 2);
    CC NUMERIC (10, 2);
    CB NUMERIC (10, 2);
    BB NUMERIC (10, 2);
    BA NUMERIC (10, 2);
    AA NUMERIC (10, 2);
BEGIN
    CALL sp_nota_genero(2, Fail, DD, DC, CC, CB, BB, BA, AA);
    RAISE NOTICE 'O percentual de Fail para o genero escolhido é de %', Fail;
    RAISE NOTICE 'O percentual de DD para o genero escolhido é de %', DD;
    RAISE NOTICE 'O percentual de DC para o genero escolhido é de %', DC;
    RAISE NOTICE 'O percentual de CC para o genero escolhido é de %', CC;
    RAISE NOTICE 'O percentual de CB para o genero escolhido é de %', CB;
    RAISE NOTICE 'O percentual de BB para o genero escolhido é de %', BB;
    RAISE NOTICE 'O percentual de BA para o genero escolhido é de %', BA;
    RAISE NOTICE 'O percentual de AA para o genero escolhido é de %', AA;
END;
$$
 

-- 1.5.1

 CREATE OR REPLACE PROCEDURE sp_todos_renda_alta_aprovados(

    OUT resultado BOOLEAN

)

LANGUAGE plpgsql

AS $$

DECLARE

    contagem_renda_alta INT;

    contagem_renda_alta_aprovados INT;

BEGIN

    

    SELECT COUNT(*) INTO contagem_renda_alta

    FROM tb_alunos

    WHERE Salario > 410;

     Conta todos os estudantes com renda acima de 410 que foram aprovados

    SELECT COUNT(*) INTO contagem_renda_alta_aprovados

    FROM tb_alunos

    WHERE Salario > 410 AND Nota > 0;


    IF contagem_renda_alta = contagem_renda_alta_aprovados THEN

        resultado := TRUE;

    ELSE

        resultado := FALSE;

    END IF;

END;

$$;
 


DO $$

DECLARE

    resultado BOOLEAN;

BEGIN

    CALL sp_todos_renda_alta_aprovados(resultado);

    RAISE NOTICE 'Todos os estudantes com renda acima de 410 são aprovados: %', resultado;

END;

$$;


-- 1.5.2
CREATE OR REPLACE PROCEDURE sp_anotacoes_aprovados(

    OUT resultado BOOLEAN

)

LANGUAGE plpgsql

AS $$

DECLARE

    contagem_anotacoes INT;

    contagem_anotacoes_aprovados INT;

    percentual NUMERIC(5, 2);

BEGIN

   

    SELECT COUNT(*) INTO contagem_anotacoes

    FROM tb_alunos

    WHERE Anotacoes > 0;


    SELECT COUNT(*) INTO contagem_anotacoes_aprovados

    FROM tb_alunos

    WHERE Anotacoes > 0 AND Nota > 0;

     Calcula o percentual de aprovados

    IF contagem_anotacoes > 0 THEN

        percentual := (contagem_anotacoes_aprovados::NUMERIC / contagem_anotacoes::NUMERIC) * 100;

    ELSE

        percentual := 0;

    END IF;

     Verifica se pelo menos 70% dos estudantes foram aprovados

    IF percentual >= 70 THEN

        resultado := TRUE;

    ELSE

        resultado := FALSE;

    END IF;

END;

$$;
 
 Teste a procedure 1.5.2

DO $$

DECLARE

    resultado BOOLEAN;

BEGIN

    CALL sp_anotacoes_aprovados(resultado);

    RAISE NOTICE 'Pelo menos 70%% dos estudantes que fazem anotações são aprovados: %', resultado;

END;

$$;
 


-- 1.5.3

CREATE OR REPLACE PROCEDURE sp_preparacao_exame_aprovados(

    OUT percentual NUMERIC(5, 2)

)

LANGUAGE plpgsql

AS $$

DECLARE

    contagem_preparados INT;

    contagem_preparados_aprovados INT;

BEGIN

     Conta todos os estudantes que se preparam pelo menos um pouco para os midterm exams

    SELECT COUNT(*) INTO contagem_preparados

    FROM tb_alunos

    WHERE Preparacao_exame > 0;

     Conta todos os estudantes que se preparam pelo menos um pouco para os midterm exams e foram aprovados

    SELECT COUNT(*) INTO contagem_preparados_aprovados

    FROM tb_alunos

    WHERE Preparacao_exame > 0 AND Nota > 0;

     Calcula o percentual de aprovados

    IF contagem_preparados > 0 THEN

        percentual := (contagem_preparados_aprovados::NUMERIC / contagem_preparados::NUMERIC) * 100;

    ELSE

        percentual := 0;

    END IF;

END;

$$;
 
 Teste a procedure 1.5.3

DO $$

DECLARE

    percentual NUMERIC(5, 2);

BEGIN

    CALL sp_preparacao_exame_aprovados(percentual);

    RAISE NOTICE 'Percentual de alunos que se preparam e são aprovados: %', percentual;

END;

$$;
