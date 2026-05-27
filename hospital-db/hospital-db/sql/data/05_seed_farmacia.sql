-- ============================================================
--  HOSPITAL — SEED: FARMÁCIA E PRESCRIÇÕES
--  Medicamentos (20), prescrições (29), itens (39)
--  Executar após 04_seed_atendimentos.sql
-- ============================================================

USE hospital;

INSERT INTO medicamento (nome, principio_ativo, fabricante, preco) VALUES
  ('Aspirina 100mg',        'Ácido acetilsalicílico',   'Bayer',      2.50),
  ('Dipirona 500mg',        'Metamizol sódico',          'EMS',        1.80),
  ('Amoxicilina 500mg',     'Amoxicilina triidratada',   'Medley',     8.90),
  ('Ibuprofeno 400mg',      'Ibuprofeno',                'Pfizer',     4.20),
  ('Omeprazol 20mg',        'Omeprazol',                 'EMS',        3.10),
  ('Losartana 50mg',        'Losartana potássica',        'Eurofarma',  2.80),
  ('Metformina 850mg',      'Metformina',                'Medley',     1.50),
  ('Morfina 10mg/ml',       'Sulfato de morfina',         'Cristália', 18.00),
  ('Midazolam 5mg/ml',      'Midazolam',                 'Cristália', 22.00),
  ('Adrenalina 1mg/ml',     'Epinefrina',                'Hipolabor', 12.00),
  ('Sulfadiazina de prata', 'Sulfadiazina de prata',     'Rioquímica', 35.00),
  ('Atropina 0,5mg',        'Atropina',                  'Hypofarma', 14.00),
  ('Pralidoxima 1g',        'Pralidoxima',               'Cristália', 95.00),
  ('Antiofídico Bothrops',  'Soro antibotrópico',        'Butantan',  220.00),
  ('Noradrenalina 2mg/ml',  'Norepinefrina',             'Hipolabor', 28.00),
  ('Enoxaparina 40mg',      'Enoxaparina sódica',        'Sanofi',    42.00),
  ('Fluconazol 150mg',      'Fluconazol',                'EMS',        5.60),
  ('Ciprofloxacino 500mg',  'Ciprofloxacino',            'Medley',     4.30),
  ('Levotiroxina 50mcg',    'Levotiroxina sódica',       'Merck',      8.70),
  ('Bromazepam 3mg',        'Bromazepam',                'Roche',      6.20);

INSERT INTO prescricao_medicamento (id_prescricao, id_medicamento, dosagem, frequencia_horas) VALUES
  -- Originais
  (1,  1,  '100 mg',    24),
  (1,  2,  '500 mg',     8),
  (2,  4,  '400 mg',     8),
  -- Graves
  (3,  8,  '2 mg/h IV',  1),
  (3,  9,  '0,05 mg/kg', 6),
  (4,  11, '1% 50g',    12),
  (4,  15, '4 mcg/kg/min', 1),
  (5,  12, '2 mg IV',    4),
  (5,  13, '1g IV',      6),
  (6,  8,  '4 mg/h IV',  1),
  (6,  10, '1mg/kg',    24),
  (7,  11, '1% 50g',    12),
  (7,  15, '8 mcg/kg/min', 1),
  (8,  9,  '0,1 mg/kg',  6),
  (8,  10, '1mg/kg',    24),
  (9,  16, '2mg/h IV',   1),
  (10, 11, '1% 50g',    12),
  (10, 15, '6 mcg/kg/min', 1),
  (11, 14, '10 ampolas IV', 6),
  (12, 15, '8 mcg/kg/min', 1),
  (12, 16, '2mg/h IV',   1),
  -- Regulares novos
  (13, 2,  '500 mg',     8),
  (13, 4,  '400 mg',     8),
  (14, 5,  '20 mg',     24),
  (14, 2,  '500 mg',     8),
  (15, 2,  '500 mg',     8),
  (16, 4,  '400 mg',     8),
  (17, 6,  '50 mg',     24),
  (18, 4,  '400 mg',     8),
  (19, 4,  '400 mg',     8),
  (20, 19, '50 mcg',    24),
  (21, 20, '3 mg',      24),
  (22, 7,  '850 mg',    12),
  (23, 18, '500 mg',    12),
  (24, 3,  '500 mg',     8),
  (25, 18, '500 mg',    12),
  (26, 6,  '50 mg',     24),
  (27, 16, '40 mg SC',  24),
  (28, 18, '500 mg',    12);

