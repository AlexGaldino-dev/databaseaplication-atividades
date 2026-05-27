-- ============================================================
--  CONSULTAS SQL — BANCO DE DADOS HOSPITAL
--  Inclui: SELECT + WHERE  |  INNER JOIN  |  LEFT JOIN
--          RIGHT JOIN  |  CROSS JOIN  |  FULL JOIN (simulado)
-- ============================================================

USE hospital;

-- ============================================================
--  BLOCO 1 — SELECT com WHERE
-- ============================================================

-- ------------------------------------------------------------
-- 1.1  Pacientes que já receberam alta
--      (data_saida IS NOT NULL na tabela internacao)
-- ------------------------------------------------------------
SELECT
    p.id_paciente,
    p.nome,
    p.tipo_sanguineo,
    i.data_entrada,
    i.data_saida,
    DATEDIFF(i.data_saida, i.data_entrada) AS dias_internado
FROM internacao i
JOIN paciente p ON p.id_paciente = i.id_paciente
WHERE i.data_saida IS NOT NULL
ORDER BY i.data_saida DESC;

-- ------------------------------------------------------------
-- 1.2  Pacientes que ainda estão internados
--      (data_saida IS NULL na tabela internacao)
-- ------------------------------------------------------------
SELECT
    p.id_paciente,
    p.nome,
    p.tipo_sanguineo,
    i.data_entrada,
    DATEDIFF(NOW(), i.data_entrada)         AS dias_internado_ate_hoje,
    q.numero                                AS quarto,
    q.tipo                                  AS tipo_quarto,
    i.motivo
FROM internacao i
JOIN paciente p ON p.id_paciente = i.id_paciente
JOIN quarto   q ON q.id_quarto   = i.id_quarto
WHERE i.data_saida IS NULL
ORDER BY i.data_entrada ASC;

-- ------------------------------------------------------------
-- 1.3  Pacientes com tipo sanguíneo O-
-- ------------------------------------------------------------
SELECT
    p.id_paciente,
    p.nome,
    p.data_nascimento,
    p.idade,
    p.peso,
    p.altura,
    p.telefone,
    p.tipo_sanguineo
FROM paciente p
WHERE p.tipo_sanguineo = 'O-'
ORDER BY p.nome ASC;

-- ------------------------------------------------------------
-- 1.4  BÔNUS: contagens rápidas com COUNT + WHERE
-- ------------------------------------------------------------
SELECT 'Com alta'      AS situacao, COUNT(*) AS total
  FROM internacao WHERE data_saida IS NOT NULL
UNION ALL
SELECT 'Ainda internado', COUNT(*)
  FROM internacao WHERE data_saida IS NULL
UNION ALL
SELECT 'Tipo sanguíneo O-', COUNT(*)
  FROM paciente WHERE tipo_sanguineo = 'O-';


-- ============================================================
--  BLOCO 2 — INNER JOIN
--  Retorna apenas registros com correspondência em AMBAS as tabelas
-- ============================================================

-- 2.1  Pacientes e suas consultas (só quem tem consulta registrada)
SELECT
    p.nome                          AS paciente,
    p.tipo_sanguineo,
    c.data_hora,
    c.motivo,
    c.diagnostico,
    m.nome                          AS medico,
    m.especialidade
FROM paciente p
INNER JOIN consulta c ON c.id_paciente = p.id_paciente
INNER JOIN medico   m ON m.id_medico   = c.id_medico
ORDER BY c.data_hora DESC
LIMIT 20;

-- 2.2  Prescrições com seus medicamentos e dosagens
SELECT
    p.nome                          AS paciente,
    pr.data                         AS data_prescricao,
    me.nome                         AS medicamento,
    me.principio_ativo,
    pm.dosagem,
    pm.frequencia_horas             AS intervalo_horas
FROM prescricao pr
INNER JOIN consulta              c  ON c.id_consulta    = pr.id_consulta
INNER JOIN paciente              p  ON p.id_paciente    = c.id_paciente
INNER JOIN prescricao_medicamento pm ON pm.id_prescricao = pr.id_prescricao
INNER JOIN medicamento           me ON me.id_medicamento = pm.id_medicamento
ORDER BY pr.data DESC;

-- 2.3  Cirurgias com paciente, médico e quarto
SELECT
    ci.tipo                         AS cirurgia,
    ci.data_hora,
    ci.duracao_min,
    ci.status,
    p.nome                          AS paciente,
    m.nome                          AS medico_responsavel,
    q.numero                        AS quarto
FROM cirurgia ci
INNER JOIN paciente p ON p.id_paciente = ci.id_paciente
INNER JOIN medico   m ON m.id_medico   = ci.id_medico
INNER JOIN quarto   q ON q.id_quarto   = ci.id_quarto
ORDER BY ci.data_hora;

-- 2.4  Médicos e seus departamentos (só médicos alocados)
SELECT
    m.nome                          AS medico,
    m.crm,
    m.especialidade,
    d.nome                          AS departamento,
    d.localizacao
FROM medico m
INNER JOIN departamento d ON d.id_departamento = m.id_departamento
ORDER BY d.nome, m.nome;


-- ============================================================
--  BLOCO 3 — LEFT JOIN
--  Retorna TODOS os registros da tabela da ESQUERDA,
--  com NULL nos campos da direita quando não há correspondência
-- ============================================================

-- 3.1  Todos os pacientes, com ou sem consulta registrada
SELECT
    p.id_paciente,
    p.nome                          AS paciente,
    p.tipo_sanguineo,
    COUNT(c.id_consulta)            AS total_consultas
FROM paciente p
LEFT JOIN consulta c ON c.id_paciente = p.id_paciente
GROUP BY p.id_paciente, p.nome, p.tipo_sanguineo
ORDER BY total_consultas DESC;

-- 3.2  Todas as consultas, com ou sem pagamento vinculado
SELECT
    c.id_consulta,
    p.nome                          AS paciente,
    c.data_hora,
    c.diagnostico,
    pg.valor,
    pg.metodo,
    pg.status                       AS status_pagamento
FROM consulta c
LEFT JOIN paciente p  ON p.id_paciente  = c.id_paciente
LEFT JOIN pagamento pg ON pg.id_consulta = c.id_consulta
ORDER BY c.data_hora DESC
LIMIT 20;

-- 3.3  Todos os médicos e suas cirurgias (incluindo quem não operou ainda)
SELECT
    m.nome                          AS medico,
    m.especialidade,
    COUNT(ci.id_cirurgia)           AS total_cirurgias
FROM medico m
LEFT JOIN cirurgia ci ON ci.id_medico = m.id_medico
GROUP BY m.id_medico, m.nome, m.especialidade
ORDER BY total_cirurgias DESC;

-- 3.4  Todos os departamentos com seus funcionários (incluindo depto sem func.)
SELECT
    d.nome                          AS departamento,
    f.nome                          AS funcionario,
    f.cargo,
    f.salario
FROM departamento d
LEFT JOIN funcionario f ON f.id_departamento = d.id_departamento
ORDER BY d.nome, f.nome;


-- ============================================================
--  BLOCO 4 — RIGHT JOIN
--  Retorna TODOS os registros da tabela da DIREITA,
--  com NULL nos campos da esquerda quando não há correspondência
-- ============================================================

-- 4.1  Todas as internações, mesmo se o quarto não tiver departamento
SELECT
    i.id_internacao,
    p.nome                          AS paciente,
    i.data_entrada,
    i.data_saida,
    i.motivo,
    q.numero                        AS quarto,
    d.nome                          AS departamento
FROM departamento d
RIGHT JOIN quarto    q ON q.id_departamento = d.id_departamento
RIGHT JOIN internacao i ON i.id_quarto      = q.id_quarto
LEFT  JOIN paciente  p ON p.id_paciente     = i.id_paciente
ORDER BY i.data_entrada;

-- 4.2  Todos os pagamentos, mesmo que a consulta não exista mais
SELECT
    pg.id_pagamento,
    pg.data,
    pg.valor,
    pg.metodo,
    pg.status,
    p.nome                          AS paciente,
    c.diagnostico
FROM consulta c
RIGHT JOIN pagamento pg ON pg.id_consulta  = c.id_consulta
LEFT  JOIN paciente  p  ON p.id_paciente   = pg.id_paciente
ORDER BY pg.data DESC
LIMIT 20;

-- 4.3  Todos os exames, mesmo sem resultado ainda
SELECT
    e.tipo                          AS tipo_exame,
    e.data_solicitacao,
    e.data_resultado,
    CASE WHEN e.data_resultado IS NULL
         THEN 'Aguardando resultado'
         ELSE e.resultado
    END                             AS resultado,
    p.nome                          AS paciente
FROM consulta c
RIGHT JOIN exame    e ON e.id_consulta  = c.id_consulta
LEFT  JOIN paciente p ON p.id_paciente  = c.id_paciente
ORDER BY e.data_solicitacao DESC
LIMIT 20;


-- ============================================================
--  BLOCO 5 — CROSS JOIN
--  Produto cartesiano: combina CADA linha de A com CADA linha de B
--  Útil para gerar combinações, grades ou relatórios de cobertura
-- ============================================================

-- 5.1  Todas as combinações possíveis entre departamentos e tipos de quarto
--      (útil para auditoria de capacidade — quais tipos cada depto tem)
SELECT
    d.nome                          AS departamento,
    tipos.tipo                      AS tipo_quarto_possivel
FROM departamento d
CROSS JOIN (
    SELECT DISTINCT tipo FROM quarto
) AS tipos
ORDER BY d.nome, tipos.tipo;

-- 5.2  Grade de cobertura: cada médico × cada departamento
--      (mostra todos os cruzamentos possíveis)
SELECT
    m.nome                          AS medico,
    m.especialidade,
    d.nome                          AS departamento
FROM medico m
CROSS JOIN departamento d
ORDER BY m.nome, d.nome;


-- ============================================================
--  BLOCO 6 — FULL JOIN (simulado com LEFT + RIGHT via UNION)
--  MySQL não tem FULL OUTER JOIN nativo;
--  simula-se com UNION de LEFT JOIN e RIGHT JOIN
-- ============================================================

-- 6.1  Todos os médicos E todos os departamentos, com ou sem vínculo
SELECT
    m.nome                          AS medico,
    m.especialidade,
    d.nome                          AS departamento,
    d.localizacao
FROM medico m
LEFT JOIN departamento d ON d.id_departamento = m.id_departamento

UNION

SELECT
    m.nome,
    m.especialidade,
    d.nome,
    d.localizacao
FROM medico m
RIGHT JOIN departamento d ON d.id_departamento = m.id_departamento
ORDER BY departamento, medico;

-- 6.2  Todos os pacientes E todas as internações (com ou sem vínculo)
--      Expõe pacientes nunca internados e internações sem paciente (dados órfãos)
SELECT
    p.id_paciente,
    p.nome                          AS paciente,
    p.tipo_sanguineo,
    i.id_internacao,
    i.data_entrada,
    i.data_saida,
    CASE
        WHEN i.data_saida IS NULL AND i.id_internacao IS NOT NULL THEN 'Internado'
        WHEN i.id_internacao IS NULL                              THEN 'Nunca internado'
        ELSE 'Com alta'
    END                             AS status_internacao
FROM paciente p
LEFT JOIN internacao i ON i.id_paciente = p.id_paciente

UNION

SELECT
    p.id_paciente,
    p.nome,
    p.tipo_sanguineo,
    i.id_internacao,
    i.data_entrada,
    i.data_saida,
    CASE
        WHEN i.data_saida IS NULL AND i.id_internacao IS NOT NULL THEN 'Internado'
        WHEN i.id_internacao IS NULL                              THEN 'Nunca internado'
        ELSE 'Com alta'
    END
FROM paciente p
RIGHT JOIN internacao i ON i.id_paciente = p.id_paciente
ORDER BY status_internacao, paciente;

-- 6.3  Todos os quartos E todas as cirurgias (com ou sem uso cirúrgico)
SELECT
    q.numero                        AS quarto,
    q.tipo                          AS tipo_quarto,
    ci.tipo                         AS cirurgia,
    ci.status,
    ci.data_hora
FROM quarto q
LEFT JOIN cirurgia ci ON ci.id_quarto = q.id_quarto

UNION

SELECT
    q.numero,
    q.tipo,
    ci.tipo,
    ci.status,
    ci.data_hora
FROM quarto q
RIGHT JOIN cirurgia ci ON ci.id_quarto = q.id_quarto
ORDER BY quarto, data_hora;

