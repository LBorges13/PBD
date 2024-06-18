Ap11

-- 1.1
CREATE TABLE log_operacoes (
    id SERIAL PRIMARY KEY,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nome_procedimento TEXT
);

--1.2
CREATE OR REPLACE FUNCTION exibir_total_pedidos_cliente(
    codigo_cliente_param INT
)
RETURNS VOID AS $$
BEGIN
    -- Registra a operação no log
    INSERT INTO log_operacoes (nome_procedimento)
    VALUES ('exibir_total_pedidos_cliente');

    -- Calcula o total de pedidos do cliente e exibe
    RAISE NOTICE 'Total de pedidos do cliente %: %', codigo_cliente_param, (
        SELECT COUNT(*)
        FROM pedidos
        WHERE codigo_cliente = codigo_cliente_param
    );
END;
$$ LANGUAGE plpgsql;

--1.3
CREATE OR REPLACE FUNCTION exibir_total_pedidos_cliente_out(
    codigo_cliente_param INT,
    OUT total_pedidos INT
)
RETURNS VOID AS $$
BEGIN
    -- Registra a operação no log
    INSERT INTO log_operacoes (nome_procedimento)
    VALUES ('exibir_total_pedidos_cliente_out');

    -- Calcula o total de pedidos do cliente
    SELECT COUNT(*)
    INTO total_pedidos
    FROM pedidos
    WHERE codigo_cliente = codigo_cliente_param;
END;
$$ LANGUAGE plpgsql;

--1.4
CREATE OR REPLACE FUNCTION total_pedidos_cliente_inout(
    INOUT codigo_cliente_param INT
)
RETURNS VOID AS $$
BEGIN
    -- Registra a operação no log
    INSERT INTO log_operacoes (nome_procedimento)
    VALUES ('total_pedidos_cliente_inout');

    -- Calcula o total de pedidos do cliente
    SELECT COUNT(*)
    INTO codigo_cliente_param
    FROM pedidos
    WHERE codigo_cliente = codigo_cliente_param;
END;
$$ LANGUAGE plpgsql;

--1.5

CREATE OR REPLACE FUNCTION cadastrar_clientes_variadic(
    VARIADIC nomes TEXT[],
    OUT mensagem TEXT
)
RETURNS VOID AS $$
DECLARE
    nome_cliente TEXT;
BEGIN
    -- Registra a operação no log
    INSERT INTO log_operacoes (nome_procedimento)
    VALUES ('cadastrar_clientes_variadic');

    -- Insere cada nome na tabela de clientes
    FOREACH nome_cliente IN ARRAY nomes
    LOOP
        INSERT INTO clientes (nome) VALUES (nome_cliente);
    END LOOP;

    -- Monta a mensagem de retorno
    mensagem := 'Os clientes: ' || array_to_string(nomes, ', ') || ' foram cadastrados';
END;
$$ LANGUAGE plpgsql;

--1.6

DO $$
BEGIN
    PERFORM exibir_total_pedidos_cliente(1);
END;
$$;

DO $$
DECLARE
    total INT;
BEGIN
    PERFORM exibir_total_pedidos_cliente_out(1, total);
    RAISE NOTICE 'Total de pedidos do cliente: %', total;
END;
$$;

DO $$
DECLARE
    codigo_cliente INT := 1;
BEGIN
    CALL total_pedidos_cliente_inout(codigo_cliente);
    RAISE NOTICE 'Total de pedidos do cliente: %', codigo_cliente;
END;
$$;

DO $$
DECLARE
    nomes TEXT[] := ARRAY['Pedro', 'Ana', 'João'];
    mensagem TEXT;
BEGIN
    CALL cadastrar_clientes_variadic(VARIADIC nomes, mensagem);
    RAISE NOTICE '%', mensagem;
END;
$$;


