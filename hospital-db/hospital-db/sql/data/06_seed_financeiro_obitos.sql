-- ============================================================
--  HOSPITAL — SEED: FINANCEIRO E OBITUÁRIO
--  Pagamentos (63) e 7 óbitos registrados
--  Pacientes ainda internados sem óbito:
--    id 4  — Ana Luiza Souza    (politraumatismo)
--    id 7  — Diego Cavalcanti   (queimaduras 45% SCQ)
--    id 12 — Isabela Cunha      (envenenamento)
--  Executar após 05_seed_farmacia.sql
-- ============================================================

USE hospital;

INSERT INTO pagamento (data, valor, metodo, status, id_paciente, id_consulta) VALUES
  -- Originais
  ('2024-05-10', 250.00,  'convenio',       'pago',     1,  1),
  ('2024-05-11', 180.00,  'cartao_credito', 'pago',     2,  2),
  ('2024-05-12',  80.00,  'pix',            'pendente', 3,  3),
  -- Casos graves — valores altos, maioria pendente (ainda internados)
  ('2024-06-01', 8500.00, 'convenio',       'pendente', 4,  4),
  ('2024-06-03', 9200.00, 'convenio',       'pendente', 7,  5),
  ('2024-06-05', 7800.00, 'convenio',       'pendente', 12, 6),
  ('2024-06-08', 6400.00, 'convenio',       'pendente', 18, 7),
  ('2024-06-10', 9800.00, 'convenio',       'pendente', 25, 8),
  ('2024-06-12', 8100.00, 'convenio',       'pendente', 31, 9),
  ('2024-06-14', 7500.00, 'convenio',       'pendente', 37, 10),
  ('2024-06-16', 9600.00, 'convenio',       'pendente', 43, 11),
  ('2024-06-18', 6900.00, 'convenio',       'pendente', 50, 12),
  ('2024-06-20', 8800.00, 'convenio',       'pendente', 56, 13),
  -- Regulares novos
  ('2024-06-22', 150.00,  'pix',            'pago',     5,  14),
  ('2024-06-22', 120.00,  'cartao_debito',  'pago',     6,  15),
  ('2024-06-22', 130.00,  'pix',            'pago',     8,  16),
  ('2024-06-23', 200.00,  'convenio',       'pago',     9,  17),
  ('2024-06-23', 160.00,  'cartao_credito', 'pago',    10,  18),
  ('2024-06-23', 110.00,  'pix',            'pago',    11,  19),
  ('2024-06-24', 190.00,  'convenio',       'pago',    13,  20),
  ('2024-06-24', 140.00,  'boleto',         'pago',    14,  21),
  ('2024-06-24', 100.00,  'pix',            'pago',    15,  22),
  ('2024-06-25', 130.00,  'cartao_credito', 'pago',    16,  23),
  ('2024-06-25', 170.00,  'convenio',       'pago',    17,  24),
  ('2024-06-25', 145.00,  'pix',            'pago',    19,  25),
  ('2024-06-26', 230.00,  'convenio',       'pago',    20,  26),
  ('2024-06-26', 180.00,  'cartao_debito',  'pago',    21,  27),
  ('2024-06-26', 110.00,  'pix',            'pago',    22,  28),
  ('2024-06-27', 120.00,  'boleto',         'pago',    23,  29),
  ('2024-06-27', 160.00,  'convenio',       'pago',    24,  30),
  ('2024-06-27', 150.00,  'pix',            'pago',    26,  31),
  ('2024-06-28', 130.00,  'cartao_credito', 'pago',    27,  32),
  ('2024-06-28', 140.00,  'pix',            'pago',    28,  33),
  ('2024-06-28', 175.00,  'convenio',       'pago',    29,  34),
  ('2024-06-29', 190.00,  'cartao_credito', 'pago',    30,  35),
  ('2024-06-29', 120.00,  'pix',            'pago',    32,  36),
  ('2024-06-29', 160.00,  'convenio',       'pago',    33,  37),
  ('2024-06-30', 210.00,  'convenio',       'pago',    34,  38),
  ('2024-06-30', 100.00,  'pix',            'pago',    35,  39),
  ('2024-06-30', 115.00,  'cartao_debito',  'pago',    36,  40),
  ('2024-07-01', 130.00,  'pix',            'pago',    38,  41),
  ('2024-07-01', 200.00,  'convenio',       'pago',    39,  42),
  ('2024-07-01', 220.00,  'convenio',       'pago',    40,  43),
  ('2024-07-02', 175.00,  'pix',            'pago',    41,  44),
  ('2024-07-02', 190.00,  'convenio',       'pago',    42,  45),
  ('2024-07-02', 185.00,  'cartao_credito', 'pago',    44,  46),
  ('2024-07-03', 250.00,  'convenio',       'pago',    45,  47),
  ('2024-07-03', 160.00,  'pix',            'pago',    46,  48),
  ('2024-07-03', 140.00,  'cartao_debito',  'pago',    47,  49),
  ('2024-07-04', 220.00,  'convenio',       'pago',    48,  50),
  ('2024-07-04', 150.00,  'pix',            'pago',    49,  51),
  ('2024-07-04', 270.00,  'convenio',       'pago',    51,  52),
  ('2024-07-05', 310.00,  'convenio',       'pago',    52,  53),
  ('2024-07-05', 240.00,  'convenio',       'pago',    53,  54),
  ('2024-07-05', 290.00,  'convenio',       'pago',    54,  55),
  ('2024-07-06', 200.00,  'pix',            'pago',    55,  56),
  ('2024-07-06', 180.00,  'convenio',       'pago',    57,  57),
  ('2024-07-06', 210.00,  'convenio',       'pago',    58,  58),
  ('2024-07-07', 320.00,  'convenio',       'pendente',59,  59),
  ('2024-07-07', 850.00,  'convenio',       'pendente',60,  60),
  ('2024-07-07', 900.00,  'convenio',       'pendente',61,  61),
  ('2024-07-08', 750.00,  'convenio',       'pendente',62,  62),
  ('2024-07-08', 680.00,  'convenio',       'pendente',63,  63);

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
    'Queimaduras de 3° grau em 60% do corpo — face, tronco e membros. Óbito por falência de múltiplos órgãos secundária a sepse e insuficiência renal aguda.',
    '2024-06-10 15:00:00',
    '2024-06-21 06:30:00',
    9800.00,
    'SCQ de 60% com comprometimento de vias aéreas superiores. Hemodiálise contínua a partir do 6° dia. Falência hepática instalada no 9° dia. Óbito por DMOF.'
  ),
  (
    31, 1, 7, 10, 9,
    'Intoxicação aguda por cianeto — parada cardiorrespiratória revertida na admissão, encefalopatia anóxica grave. Diagnóstico de morte encefálica confirmado.',
    '2024-06-12 04:00:00',
    '2024-06-17 11:20:00',
    8100.00,
    'PCR revertida após 18 minutos sem circulação efetiva. Encefalopatia anóxica estabelecida. Morte encefálica confirmada por dois médicos em 15 e 17/06. Família orientada sobre doação de órgãos.'
  ),
  (
    37, 2, 8, 11, 10,
    'Traumatismo raquimedular cervical C5-C6 — tetraplegia completa com comprometimento do centro respiratório. Óbito por pneumonia aspirativa e insuficiência respiratória.',
    '2024-06-14 12:30:00',
    '2024-06-25 16:45:00',
    7500.00,
    'Lesão medular completa confirmada por RM. Dependência de VM desde a admissão. Pneumonia nosocomial por Pseudomonas aeruginosa no 8° dia. Óbito após retirada de suporte a pedido da família.'
  ),
  (
    43, 4, 9, 12, 11,
    'Queimaduras de 3° grau por explosão de gás — 55% SCQ com insuficiência renal aguda. Óbito por disfunção de múltiplos órgãos e choque séptico.',
    '2024-06-16 21:00:00',
    '2024-06-28 09:15:00',
    9600.00,
    'Hemodiálise contínua desde o 2° dia. Enxerto cutâneo contraindicado por instabilidade hemodinâmica. Três episódios de sepse com germes distintos. Evolução desfavorável apesar de suporte máximo.'
  ),
  (
    50, 1, 10, 13, 12,
    'Envenenamento por picada de serpente Bothrops — coagulopatia grave com CIVD e necrose tecidual extensa. Falência hepática e hemorrágica irreversível.',
    '2024-06-18 10:00:00',
    '2024-06-23 20:40:00',
    6900.00,
    'Soroterapia iniciada em menos de 1h, porém envenenamento já sistêmico. CIVD com fibrinogênio indetectável. Necrose hepática maciça confirmada por biópsia. Óbito por choque hemorrágico.'
  ),
  (
    56, 2, 11, 14, 13,
    'Politraumatismo por colisão frontal — hemotórax maciço bilateral e choque hemorrágico classe IV. Óbito por exsanguinação irreversível.',
    '2024-06-20 17:30:00',
    '2024-06-21 03:10:00',
    8800.00,
    'Drenagem torácica bilateral com débito > 2L. Toracotomia de urgência indicada. Óbito na mesa operatória por exsanguinação e parada cardíaca irreversível.'
  );

