-- ============================================================
--  CONSULTAS — PACIENTES ATENDIDOS POR MÉDICO
--  em diferentes intervalos de 3 dias
-- ============================================================

USE hospital;

-- ============================================================
--  PERÍODO 1: 22 a 24 de junho de 2024
--  (pico de consultas regulares — muitos pacientes novos)
-- ============================================================

-- 1.1  Contagem por médico no período (visão resumida)
SELECT
    m.id_medico,
    m.nome                              AS medico,
    m.especialidade,
    d.nome                              AS departamento,
    COUNT(c.id_consulta)                AS total_pacientes_atendidos,
    MIN(c.data_hora)                    AS primeiro_atendimento,
    MAX(c.data_hora)                    AS ultimo_atendimento
FROM medico m
LEFT JOIN consulta    c ON c.id_medico      = m.id_medico
                       AND c.data_hora BETWEEN '2024-06-22 00:00:00'
                                           AND '2024-06-24 23:59:59'
LEFT JOIN departamento d ON d.id_departamento = m.id_departamento
GROUP BY m.id_medico, m.nome, m.especialidade, d.nome
ORDER BY total_pacientes_atendidos DESC;

-- ------------------------------------------------------------
-- 1.2  Detalhe: quais pacientes cada médico atendeu no período
-- ------------------------------------------------------------
SELECT
    m.nome                              AS medico,
    m.especialidade,
    p.nome                              AS paciente,
    p.idade,
    p.tipo_sanguineo,
    c.data_hora,
    c.motivo,
    c.diagnostico
FROM consulta c
INNER JOIN medico   m ON m.id_medico   = c.id_medico
INNER JOIN paciente p ON p.id_paciente = c.id_paciente
WHERE c.data_hora BETWEEN '2024-06-22 00:00:00'
                      AND '2024-06-24 23:59:59'
ORDER BY m.nome, c.data_hora;


-- ============================================================
--  PERÍODO 2: 01 a 03 de junho de 2024
--  (início das internações graves — diagnósticos críticos)
-- ============================================================

-- 2.1  Contagem por médico no período
SELECT
    m.id_medico,
    m.nome                              AS medico,
    m.especialidade,
    d.nome                              AS departamento,
    COUNT(c.id_consulta)                AS total_pacientes_atendidos,
    MIN(c.data_hora)                    AS primeiro_atendimento,
    MAX(c.data_hora)                    AS ultimo_atendimento
FROM medico m
LEFT JOIN consulta    c ON c.id_medico      = m.id_medico
                       AND c.data_hora BETWEEN '2024-06-01 00:00:00'
                                           AND '2024-06-03 23:59:59'
LEFT JOIN departamento d ON d.id_departamento = m.id_departamento
GROUP BY m.id_medico, m.nome, m.especialidade, d.nome
ORDER BY total_pacientes_atendidos DESC;

-- ------------------------------------------------------------
-- 2.2  Detalhe dos atendimentos graves nesse período
-- ------------------------------------------------------------
SELECT
    m.nome                              AS medico,
    m.especialidade,
    p.nome                              AS paciente,
    p.idade,
    p.tipo_sanguineo,
    c.data_hora,
    COALESCE(c.motivo, '(entrada de emergência)') AS motivo,
    c.diagnostico
FROM consulta c
INNER JOIN medico   m ON m.id_medico   = c.id_medico
INNER JOIN paciente p ON p.id_paciente = c.id_paciente
WHERE c.data_hora BETWEEN '2024-06-01 00:00:00'
                      AND '2024-06-03 23:59:59'
ORDER BY m.nome, c.data_hora;


-- ============================================================
--  PERÍODO 3: 06 a 08 de julho de 2024
--  (últimas entradas — mix de casos graves e regulares)
-- ============================================================

-- 3.1  Contagem por médico no período
SELECT
    m.id_medico,
    m.nome                              AS medico,
    m.especialidade,
    d.nome                              AS departamento,
    COUNT(c.id_consulta)                AS total_pacientes_atendidos,
    MIN(c.data_hora)                    AS primeiro_atendimento,
    MAX(c.data_hora)                    AS ultimo_atendimento
FROM medico m
LEFT JOIN consulta    c ON c.id_medico      = m.id_medico
                       AND c.data_hora BETWEEN '2024-07-06 00:00:00'
                                           AND '2024-07-08 23:59:59'
LEFT JOIN departamento d ON d.id_departamento = m.id_departamento
GROUP BY m.id_medico, m.nome, m.especialidade, d.nome
ORDER BY total_pacientes_atendidos DESC;

-- ------------------------------------------------------------
-- 3.2  Detalhe dos atendimentos nesse período
-- ------------------------------------------------------------
SELECT
    m.nome                              AS medico,
    m.especialidade,
    p.nome                              AS paciente,
    p.idade,
    p.tipo_sanguineo,
    c.data_hora,
    COALESCE(c.motivo, '(entrada de emergência)') AS motivo,
    c.diagnostico
FROM consulta c
INNER JOIN medico   m ON m.id_medico   = c.id_medico
INNER JOIN paciente p ON p.id_paciente = c.id_paciente
WHERE c.data_hora BETWEEN '2024-07-06 00:00:00'
                      AND '2024-07-08 23:59:59'
ORDER BY m.nome, c.data_hora;


-- ============================================================
--  VISÃO COMPARATIVA — os 3 períodos lado a lado
--  Ranking de médicos pelo total acumulado nos 3 intervalos
-- ============================================================
SELECT
    m.nome                              AS medico,
    m.especialidade,
    d.nome                              AS departamento,

    SUM(CASE WHEN c.data_hora BETWEEN '2024-06-22 00:00:00'
                                  AND '2024-06-24 23:59:59'
             THEN 1 ELSE 0 END)         AS periodo_1_jun22_24,

    SUM(CASE WHEN c.data_hora BETWEEN '2024-06-01 00:00:00'
                                  AND '2024-06-03 23:59:59'
             THEN 1 ELSE 0 END)         AS periodo_2_jun01_03,

    SUM(CASE WHEN c.data_hora BETWEEN '2024-07-06 00:00:00'
                                  AND '2024-07-08 23:59:59'
             THEN 1 ELSE 0 END)         AS periodo_3_jul06_08,

    COUNT(c.id_consulta)                AS total_geral_todos_periodos
FROM medico m
LEFT JOIN consulta    c ON c.id_medico = m.id_medico
                       AND (
                               c.data_hora BETWEEN '2024-06-22 00:00:00' AND '2024-06-24 23:59:59'
                            OR c.data_hora BETWEEN '2024-06-01 00:00:00' AND '2024-06-03 23:59:59'
                            OR c.data_hora BETWEEN '2024-07-06 00:00:00' AND '2024-07-08 23:59:59'
                           )
LEFT JOIN departamento d ON d.id_departamento = m.id_departamento
GROUP BY m.id_medico, m.nome, m.especialidade, d.nome
ORDER BY total_geral_todos_periodos DESC, m.nome;

