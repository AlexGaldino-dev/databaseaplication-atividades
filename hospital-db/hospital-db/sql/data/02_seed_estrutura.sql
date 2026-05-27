-- ============================================================
--  HOSPITAL — SEED: ESTRUTURA HOSPITALAR
--  Departamentos, médicos, funcionários, quartos
--  Executar após 01_schema.sql
-- ============================================================

USE hospital;

INSERT INTO departamento (nome, localizacao, telefone) VALUES
  ('Cardiologia',   'Bloco A – 2º andar', '(81) 3000-0001'),
  ('Ortopedia',     'Bloco B – 1º andar', '(81) 3000-0002'),
  ('Pediatria',     'Bloco C – 3º andar', '(81) 3000-0003'),
  ('UTI Adulto',    'Bloco D – Térreo',   '(81) 3000-0004'),
  ('Emergência',    'Bloco E – Térreo',   '(81) 3000-0005'),
  ('Radiografia',   'Bloco F – Térreo',   '(81) 3000-0006');

INSERT INTO medico (nome, crm, especialidade, telefone, id_departamento) VALUES
  ('Dr. Rafael Souza',    'CRM-SP 123456', 'Cardiologia',   '(81) 98000-0011', 1),
  ('Dra. Ana Pereira',    'CRM-SP 234567', 'Ortopedia',     '(81) 98000-0022', 2),
  ('Dr. Carlos Lima',     'CRM-SP 345678', 'Pediatria',     '(81) 98000-0033', 3),
  ('Dra. Fernanda Matos',  'CRM-SP 456789', 'Clínica Geral',              '(81) 98000-0044', 5),
  ('Dr. Marcelo Viana',    'CRM-PE 567890', 'Cirurgião',                  '(81) 98000-0055', 5),
  ('Dra. Patrícia Rego',   'CRM-PE 678901', 'Cirurgião',                  '(81) 98000-0066', 5),
  ('Dr. Sérgio Almeida',   'CRM-PE 789012', 'Oftalmologista',              '(81) 98000-0077', 1),
  ('Dra. Renata Borges',   'CRM-PE 890123', 'Oftalmologista',              '(81) 98000-0088', 1),
  ('Dr. Túlio Macedo',     'CRM-PE 901234', 'Dermatologista',             '(81) 98000-0099', 2),
  ('Dra. Camila Estrela',  'CRM-PE 012345', 'Dermatologista',             '(81) 98000-0100', 2),
  ('Dr. Augusto Neves',    'CRM-PE 112345', 'Otorrinolaringologista',     '(81) 98000-0111', 3),
  ('Dra. Lívia Sampaio',   'CRM-PE 212345', 'Clínica Geral',              '(81) 98000-0122', 5),
  ('Dr. Fábio Coelho',     'CRM-PE 312345', 'Clínica Geral',              '(81) 98000-0133', 5);

INSERT INTO funcionario (nome, cargo, cpf, data_admissao, salario, id_departamento) VALUES
  ('Maria Oliveira',       'Enfermeira',         '11122233344', '2020-03-01', 4500.00, 1),
  ('João Santos',          'Técnico de Lab.',    '22233344455', '2019-07-15', 3800.00, 2),
  ('Luisa Costa',          'Recepcionista',      '33344455566', '2021-01-10', 2500.00, 5),
  ('Roberta Farias',       'Enfermeira',         '44400011122', '2021-06-15', 4500.00, 1),
  ('Diego Mendonça',       'Enfermeiro',         '55500022233', '2022-02-20', 4500.00, 4),
  ('Aline Cavalcanti',     'Enfermeira',         '66600033344', '2019-11-10', 4500.00, 4),
  ('Paulo Henrique Melo',  'Enfermeiro',         '77700044455', '2023-03-05', 4500.00, 5),
  ('Tatiane Rezende',      'Enfermeira',         '88800055566', '2020-08-18', 4500.00, 3),
  ('Cláudio Barros',      'Técnico de Lab.',    '99900066677', '2021-04-12', 3800.00, 2),
  ('Fátima Nogueira',     'Técnica de Lab.',    '10010077788', '2018-09-25', 3800.00, 6),
  ('André Silveira',      'Técnico de Lab.',    '10020088899', '2022-07-30', 3800.00, 2),
  ('Juliana Teixeira',     'Técnica de Lab.',    '10030099900', '2017-12-01', 3800.00, 6);

INSERT INTO quarto (numero, tipo, status, id_departamento) VALUES
  ('A101', 'apartamento', 'disponivel', 1),
  ('B201', 'enfermaria',  'disponivel', 2),
  ('D001', 'UTI',         'ocupado',    4),
  ('E001', 'emergencia',  'ocupado',    5),
  ('C301', 'cirurgia',    'disponivel', 3),
  ('D002', 'UTI',         'ocupado',    4),
  ('D003', 'UTI',         'ocupado',    4),
  ('D004', 'UTI',         'ocupado',    4),
  ('D005', 'UTI',         'ocupado',    4),
  ('D006', 'UTI',         'ocupado',    4),
  ('D007', 'UTI',         'ocupado',    4),
  ('D008', 'UTI',         'ocupado',    4),
  ('D009', 'UTI',         'ocupado',    4),
  ('D010', 'UTI',         'ocupado',    4),
  ('D011', 'UTI',         'ocupado',    4),
  ('B202', 'enfermaria',  'disponivel', 2),
  ('B203', 'enfermaria',  'disponivel', 3),
  ('A102', 'apartamento', 'disponivel', 1),
  ('A103', 'apartamento', 'disponivel', 2);

