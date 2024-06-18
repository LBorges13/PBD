Ap21

-- 1.1
CREATE OR REPLACE FUNCTION fn_consultar_saldo(
    codigo_cliente_param INT,
    codigo_conta_param INT
)
RETURNS DECIMAL AS $$
DECLARE
    saldo DECIMAL;
BEGIN
    SELECT saldo INTO saldo
    FROM contas
    WHERE codigo_cliente = codigo_cliente_param
      AND codigo_conta = codigo_conta_param;
    
    RETURN saldo;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'Conta ou cliente não encontrado';
END;
$$ LANGUAGE plpgsql;

--1.2

CREATE OR REPLACE FUNCTION fn_transferir(
    codigo_cliente_remetente INT,
    codigo_conta_remetente INT,
    codigo_cliente_destinatario INT,
    codigo_conta_destinatario INT,
    valor_transferencia DECIMAL
)
RETURNS BOOLEAN AS $$
DECLARE
    saldo_remetente DECIMAL;
    saldo_destinatario DECIMAL;
BEGIN
    -- Verifica saldo do remetente
    SELECT saldo INTO saldo_remetente
    FROM contas
    WHERE codigo_cliente = codigo_cliente_remetente
      AND codigo_conta = codigo_conta_remetente;
    
    IF saldo_remetente < valor_transferencia THEN
        RETURN FALSE;
    END IF;

    -- Verifica saldo do destinatário (não necessário para validar transferência)
    SELECT saldo INTO saldo_destinatario
    FROM contas
    WHERE codigo_cliente = codigo_cliente_destinatario
      AND codigo_conta = codigo_conta_destinatario;
    
    -- Atualiza saldos
    UPDATE contas
    SET saldo = saldo - valor_transferencia
    WHERE codigo_cliente = codigo_cliente_remetente
      AND codigo_conta = codigo_conta_remetente;

    UPDATE contas
    SET saldo = saldo + valor_transferencia
    WHERE codigo_cliente = codigo_cliente_destinatario
      AND codigo_conta = codigo_conta_destinatario;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

--1.3

DO $$
DECLARE
    saldo DECIMAL;
BEGIN
    saldo := fn_consultar_saldo(1, 101);
    RAISE NOTICE 'Saldo da conta 101 do cliente 1: %', saldo;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Erro: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;


DO $$
DECLARE
    transferencia_sucesso BOOLEAN;
BEGIN
    transferencia_sucesso := fn_transferir(1, 101, 2, 202, 100.00);
    IF transferencia_sucesso THEN
        RAISE NOTICE 'Transferência realizada com sucesso.';
    ELSE
        RAISE NOTICE 'Transferência falhou.';
    END IF;
    
    -- Verifica saldo após transferência
    RAISE NOTICE 'Saldo após transferência:';
    RAISE NOTICE 'Saldo da conta 101 do cliente 1: %', fn_consultar_saldo(1, 101);
    RAISE NOTICE 'Saldo da conta 202 do cliente 2: %', fn_consultar_saldo(2, 202);
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Erro: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
