-- ============================================================
--  TABELA: obituario
--  Registra pacientes em estado grave que vieram a óbito.
--  Apenas pacientes internados sem data_saida são elegíveis.
--  Referencia: paciente, medico, internacao, quarto, pagamento
-- ============================================================

USE hospital;

CREATE TABLE obituario (
  id_obituario        INT             NOT NULL AUTO_INCREMENT,
  id_paciente         INT             NOT NULL,
  id_medico           INT             NOT NULL  COMMENT 'Médico responsável no momento do óbito',
  id_internacao       INT             NOT NULL,
  id_quarto           INT             NOT NULL,
  id_pagamento        INT                       COMMENT 'Vínculo com despesas médicas registradas',
  causa_obito         TEXT            NOT NULL  COMMENT 'Diagnóstico/motivo que levou ao óbito',
  data_internacao     DATETIME        NOT NULL,
  data_obito          DATETIME        NOT NULL,
  dias_internado      INT GENERATED ALWAYS AS
                        (DATEDIFF(data_obito, data_internacao)) STORED
                                                COMMENT 'Calculado automaticamente',
  despesas_medicas    DECIMAL(10,2)   NOT NULL  COMMENT 'Total das despesas geradas durante a internação',
  observacoes         TEXT                      COMMENT 'Notas clínicas ou circunstâncias adicionais',
  PRIMARY KEY (id_obituario),
  CONSTRAINT fk_obit_paciente
    FOREIGN KEY (id_paciente)   REFERENCES paciente   (id_paciente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_obit_medico
    FOREIGN KEY (id_medico)     REFERENCES medico     (id_medico)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_obit_internacao
    FOREIGN KEY (id_internacao) REFERENCES internacao  (id_internacao)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_obit_quarto
    FOREIGN KEY (id_quarto)     REFERENCES quarto      (id_quarto)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_obit_pagamento
    FOREIGN KEY (id_pagamento)  REFERENCES pagamento   (id_pagamento)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- ============================================================
--  DADOS — 10 óbitos (pacientes graves sem alta)
--
--  Referências rápidas:
--   id_paciente | nome              | id_internacao | id_quarto | id_medico | id_pagamento
--   *** AINDA INTERNADOS (removidos do obituário) ***
--   4  Ana Luiza Souza      → politraumatismo — ainda em UTI, sem alta
--   7  Diego Cavalcanti     → queimaduras 45% SCQ — ainda em UTI, sem alta
--   12 Isabela Cunha        → envenenamento — ainda em UTI, sem alta
--   *** ÓBITOS CONFIRMADOS (7 registros) ***
--   18 Olivia Ramos         → intern 5,  quarto 8,  médico 2,  pagto 7
--   25 Vinícius Carvalho    → intern 6,  quarto 9,  médico 4,  pagto 8
--   31 Beatriz Moura        → intern 7,  quarto 10, médico 1,  pagto 9
--   37 Helena Vieira        → intern 8,  quarto 11, médico 2,  pagto 10
--   43 Nathalia Aragão      → intern 9,  quarto 12, médico 4,  pagto 11
--   50 Vanessa Estrada      → intern 10, quarto 13, médico 1,  pagto 12
--   56 Bianca Cavalcante    → intern 11, quarto 14, médico 2,  pagto 13
-- ============================================================

-- Nota: os 3 primeiros pacientes graves (id 4 — Ana Luiza Souza,
-- id 7 — Diego Cavalcanti, id 12 — Isabela Cunha) ainda estão
-- internados em estado crítico e NÃO constam neste obituário.
-- Suas internações permanecem com data_saida = NULL na tabela internacao.

INSERT INTO obituario
  (id_paciente, id_medico, id_internacao, id_quarto, id_pagamento,
   causa_obito, data_internacao, data_obito, despesas_medicas, observacoes)
VALUES
  (
    18, 2, 5, 8, 7,
    'Politraumatismo por atropelamento — ruptura esplênica e pneumotórax hipertensivo. Choque hemorrágico irreversível após esplenectomia de urgência.',
    '2024-06-08 08:00:00',
    '2024-06-10 23:55:00',
    6400.00,
    'Esplenectomia realizada em caráter emergencial. Persistência de sangramento em sítios múltiplos com coagulopatia por consumo. Transfusão maciça sem resposta hemodinâmica. Óbito intraoperatório.'
  ),
  (
    25, 4, 6, 9, 8,
    'Queimaduras de 3° grau em 60% do corpo — face, tronco e membros. Óbito por falência de múltiplos órgãos secundária a sepse de origem cutânea e insuficiência renal aguda.',
    '2024-06-10 15:00:00',
    '2024-06-21 06:30:00',
    9800.00,
    'SCQ de 60% com comprometimento de vias aéreas superiores. Intubação orotraqueal na admissão. Renal substituída por hemodiálise contínua a partir do 6° dia. Falência hepática instalada no 9° dia. Óbito por DMOF.'
  ),
  (
    31, 1, 7, 10, 9,
    'Intoxicação aguda por cianeto — parada cardiorrespiratória revertida na admissão, encefalopatia anóxica grave. Diagnóstico de morte encefálica confirmado.',
    '2024-06-12 04:00:00',
    '2024-06-17 11:20:00',
    8100.00,
    'PCR revertida após 18 minutos sem circulação efetiva. Encefalopatia anóxica estabelecida. Exames de morte encefálica realizados em 15 e 17/06, confirmados por dois médicos distintos. Família orientada sobre doação de órgãos.'
  ),
  (
    37, 2, 8, 11, 10,
    'Traumatismo raquimedular cervical C5-C6 por acidente de motocicleta — tetraplegia completa com comprometimento do centro respiratório. Óbito por pneumonia aspirativa e insuficiência respiratória.',
    '2024-06-14 12:30:00',
    '2024-06-25 16:45:00',
    7500.00,
    'Lesão medular completa confirmada por RM e potencial evocado. Dependência de ventilação mecânica desde a admissão. Pneumonia nosocomial por Pseudomonas aeruginosa instalada no 8° dia. Sepse pulmonar refratária. Óbito após retirada de suporte a pedido da família mediante processo ético.'
  ),
  (
    43, 4, 9, 12, 11,
    'Queimaduras de 3° grau por explosão de gás — 55% SCQ com insuficiência renal aguda instalada na admissão. Óbito por disfunção de múltiplos órgãos e choque séptico.',
    '2024-06-16 21:00:00',
    '2024-06-28 09:15:00',
    9600.00,
    'Necessidade de hemodiálise contínua desde o 2° dia. Enxerto cutâneo contraindicado pela instabilidade hemodinâmica. Três episódios de sepse com germes distintos. Evolução desfavorável apesar de suporte máximo em UTI.'
  ),
  (
    50, 1, 10, 13, 12,
    'Envenenamento por picada de serpente Bothrops — coagulopatia grave com CIVD e necrose tecidual extensa. Falência hepática e hemorrágica irreversível.',
    '2024-06-18 10:00:00',
    '2024-06-23 20:40:00',
    6900.00,
    'Soroterapia antibotrópica iniciada em menos de 1h da picada, porém envenenamento já sistêmico. CIVD com fibrinogênio indetectável. Necrose hepática maciça confirmada por biópsia. Hemorragia digestiva alta não controlável. Óbito por choque hemorrágico.'
  ),
  (
    56, 2, 11, 14, 13,
    'Politraumatismo por colisão frontal — hemotórax maciço bilateral e choque hemorrágico classe IV. Óbito por exsanguinação irreversível apesar de drenagem torácica e transfusão maciça.',
    '2024-06-20 17:30:00',
    '2024-06-21 03:10:00',
    8800.00,
    'Entrada em PCR na ambulância — revertida por paramedics. Drenagem torácica bilateral imediata com débito > 2L de sangue. Indicação cirúrgica de toracotomia de urgência. Óbito na mesa operatória por exsanguinação e parada cardíaca irreversível.'
  );

-- ============================================================
--  CONSULTA DE VERIFICAÇÃO
--  Cruza obituario com paciente, medico, quarto e pagamento
-- ============================================================
SELECT
    o.id_obituario,
    p.nome                          AS paciente,
    p.tipo_sanguineo,
    p.idade,
    m.nome                          AS medico_responsavel,
    m.especialidade,
    q.numero                        AS quarto,
    q.tipo                          AS tipo_quarto,
    o.data_internacao,
    o.data_obito,
    o.dias_internado,
    o.causa_obito,
    o.despesas_medicas,
    o.observacoes
FROM obituario o
INNER JOIN paciente p ON p.id_paciente = o.id_paciente
INNER JOIN medico   m ON m.id_medico   = o.id_medico
INNER JOIN quarto   q ON q.id_quarto   = o.id_quarto
ORDER BY o.data_obito ASC;

-- Total de óbitos e média de despesas
SELECT
    COUNT(*)                        AS total_obitos,
    AVG(dias_internado)             AS media_dias_internado,
    SUM(despesas_medicas)           AS total_despesas,
    AVG(despesas_medicas)           AS media_despesas_por_obito,
    MIN(despesas_medicas)           AS menor_despesa,
    MAX(despesas_medicas)           AS maior_despesa
FROM obituario;

-- Óbitos por médico
SELECT
    m.nome                          AS medico,
    m.especialidade,
    COUNT(o.id_obituario)           AS total_obitos,
    SUM(o.despesas_medicas)         AS total_despesas_geradas
FROM obituario o
INNER JOIN medico m ON m.id_medico = o.id_medico
GROUP BY m.id_medico, m.nome, m.especialidade
ORDER BY total_obitos DESC;

-- Óbitos por causa (agrupado por tipo)
SELECT
    CASE
        WHEN causa_obito LIKE '%acidente de trânsito%'
          OR causa_obito LIKE '%politraumatismo%'   THEN 'Trauma / Acidente de Trânsito'
        WHEN causa_obito LIKE '%queimadura%'        THEN 'Queimaduras de 3° Grau'
        WHEN causa_obito LIKE '%envenenamento%'
          OR causa_obito LIKE '%intoxicação%'
          OR causa_obito LIKE '%Bothrops%'          THEN 'Envenenamento / Intoxicação'
        WHEN causa_obito LIKE '%raquimedular%'      THEN 'Traumatismo Raquimedular'
        ELSE 'Outros'
    END                             AS categoria,
    COUNT(*)                        AS total_obitos,
    AVG(dias_internado)             AS media_dias_ate_obito,
    SUM(despesas_medicas)           AS total_despesas
FROM obituario
GROUP BY categoria
ORDER BY total_obitos DESC;
