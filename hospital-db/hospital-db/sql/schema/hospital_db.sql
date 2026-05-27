-- ============================================================
--  BANCO DE DADOS: HOSPITAL
--  14 tabelas cobrindo pacientes, endereços, médicos, internações,
--  cirurgias, prescrições, exames e pagamentos
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE hospital;

-- ------------------------------------------------------------
-- 1. DEPARTAMENTO
-- ------------------------------------------------------------
CREATE TABLE departamento (
  id_departamento  INT            NOT NULL AUTO_INCREMENT,
  nome             VARCHAR(100)   NOT NULL,
  localizacao      VARCHAR(100),
  telefone         VARCHAR(20),
  PRIMARY KEY (id_departamento)
);

-- ------------------------------------------------------------
-- 2. MEDICO
-- ------------------------------------------------------------
CREATE TABLE medico (
  id_medico        INT            NOT NULL AUTO_INCREMENT,
  nome             VARCHAR(120)   NOT NULL,
  crm              VARCHAR(20)    NOT NULL UNIQUE,
  especialidade    VARCHAR(80)    NOT NULL,
  telefone         VARCHAR(20),
  id_departamento  INT,
  PRIMARY KEY (id_medico),
  CONSTRAINT fk_medico_depto
    FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 3. FUNCIONARIO
-- ------------------------------------------------------------
CREATE TABLE funcionario (
  id_funcionario   INT            NOT NULL AUTO_INCREMENT,
  nome             VARCHAR(120)   NOT NULL,
  cargo            VARCHAR(80)    NOT NULL,
  cpf              CHAR(11)       NOT NULL UNIQUE,
  data_admissao    DATE           NOT NULL,
  salario          DECIMAL(10,2)  NOT NULL,
  id_departamento  INT,
  PRIMARY KEY (id_funcionario),
  CONSTRAINT fk_func_depto
    FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 4. ENDERECO_PACIENTE
--    Criada antes de PACIENTE pois será referenciada por FK.
--
--    Justificativa (Formas Normais):
--    • 1FN: o campo "endereco VARCHAR(200)" original armazenava
--      múltiplos atributos concatenados numa única célula,
--      violando a atomicidade. Cada componente agora é uma
--      coluna separada e indivisível.
--    • 2FN: todos os campos descrevem exclusivamente o endereço
--      e dependem por completo de id_endereco (chave primária),
--      sem dependências parciais.
--    • 3FN: nenhum campo não-chave depende de outro campo
--      não-chave — eliminando dependências transitivas que
--      existiriam se esses dados permanecessem em PACIENTE.
-- ------------------------------------------------------------
CREATE TABLE endereco_paciente (
  id_endereco      INT            NOT NULL AUTO_INCREMENT,
  rua              VARCHAR(150)   NOT NULL,
  numero           VARCHAR(10)    NOT NULL,
  bairro           VARCHAR(100)   NOT NULL,
  cidade           VARCHAR(100)   NOT NULL,
  uf               CHAR(2)        NOT NULL COMMENT 'Sigla do estado (ex: SP, RJ)',
  PRIMARY KEY (id_endereco)
);

-- ------------------------------------------------------------
-- 5. PACIENTE  (normalizado — 1FN, 2FN e 3FN)
--    Campo "endereco VARCHAR(200)" removido e substituído por
--    id_endereco, chave estrangeira para ENDERECO_PACIENTE.
--    Campos adicionados: peso, idade, altura.
-- ------------------------------------------------------------
CREATE TABLE paciente (
  id_paciente      INT            NOT NULL AUTO_INCREMENT,
  nome             VARCHAR(120)   NOT NULL,
  data_nascimento  DATE           NOT NULL,
  cpf              CHAR(11)       NOT NULL UNIQUE,
  telefone         VARCHAR(20),
  tipo_sanguineo   ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-'),
  peso             DECIMAL(5,2)   COMMENT 'Peso em kg (ex: 72.50)',
  idade            TINYINT        UNSIGNED COMMENT 'Idade em anos',
  altura           DECIMAL(4,2)   COMMENT 'Altura em metros (ex: 1.75)',
  id_endereco      INT,
  PRIMARY KEY (id_paciente),
  CONSTRAINT fk_paciente_endereco
    FOREIGN KEY (id_endereco) REFERENCES endereco_paciente (id_endereco)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 6. QUARTO
-- ------------------------------------------------------------
CREATE TABLE quarto (
  id_quarto        INT            NOT NULL AUTO_INCREMENT,
  numero           VARCHAR(10)    NOT NULL UNIQUE,
  tipo             ENUM('enfermaria','apartamento','UTI','cirurgia','emergencia') NOT NULL,
  status           ENUM('disponivel','ocupado','manutencao') NOT NULL DEFAULT 'disponivel',
  id_departamento  INT,
  PRIMARY KEY (id_quarto),
  CONSTRAINT fk_quarto_depto
    FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 7. CONSULTA
-- ------------------------------------------------------------
CREATE TABLE consulta (
  id_consulta      INT            NOT NULL AUTO_INCREMENT,
  data_hora        DATETIME       NOT NULL,
  motivo           TEXT,
  diagnostico      TEXT,
  id_paciente      INT            NOT NULL,
  id_medico        INT            NOT NULL,
  id_quarto        INT,
  PRIMARY KEY (id_consulta),
  CONSTRAINT fk_consulta_paciente
    FOREIGN KEY (id_paciente) REFERENCES paciente (id_paciente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_consulta_medico
    FOREIGN KEY (id_medico) REFERENCES medico (id_medico)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_consulta_quarto
    FOREIGN KEY (id_quarto) REFERENCES quarto (id_quarto)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 8. INTERNACAO
-- ------------------------------------------------------------
CREATE TABLE internacao (
  id_internacao    INT            NOT NULL AUTO_INCREMENT,
  data_entrada     DATETIME       NOT NULL,
  data_saida       DATETIME,
  motivo           TEXT,
  id_paciente      INT            NOT NULL,
  id_quarto        INT            NOT NULL,
  id_medico        INT            NOT NULL,
  PRIMARY KEY (id_internacao),
  CONSTRAINT fk_intern_paciente
    FOREIGN KEY (id_paciente) REFERENCES paciente (id_paciente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_intern_quarto
    FOREIGN KEY (id_quarto) REFERENCES quarto (id_quarto)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_intern_medico
    FOREIGN KEY (id_medico) REFERENCES medico (id_medico)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 9. PRESCRICAO
-- ------------------------------------------------------------
CREATE TABLE prescricao (
  id_prescricao    INT            NOT NULL AUTO_INCREMENT,
  data             DATE           NOT NULL,
  instrucoes       TEXT,
  id_consulta      INT            NOT NULL,
  PRIMARY KEY (id_prescricao),
  CONSTRAINT fk_prescricao_consulta
    FOREIGN KEY (id_consulta) REFERENCES consulta (id_consulta)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 10. MEDICAMENTO
-- ------------------------------------------------------------
CREATE TABLE medicamento (
  id_medicamento   INT            NOT NULL AUTO_INCREMENT,
  nome             VARCHAR(120)   NOT NULL,
  principio_ativo  VARCHAR(120)   NOT NULL,
  fabricante       VARCHAR(100),
  preco            DECIMAL(10,2)  NOT NULL,
  PRIMARY KEY (id_medicamento)
);

-- ------------------------------------------------------------
-- 11. PRESCRICAO_MEDICAMENTO  (tabela associativa N:N)
-- ------------------------------------------------------------
CREATE TABLE prescricao_medicamento (
  id_prescricao    INT            NOT NULL,
  id_medicamento   INT            NOT NULL,
  dosagem          VARCHAR(50)    NOT NULL,
  frequencia_horas INT            NOT NULL COMMENT 'Intervalo em horas entre doses',
  PRIMARY KEY (id_prescricao, id_medicamento),
  CONSTRAINT fk_pm_prescricao
    FOREIGN KEY (id_prescricao) REFERENCES prescricao (id_prescricao)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pm_medicamento
    FOREIGN KEY (id_medicamento) REFERENCES medicamento (id_medicamento)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 12. EXAME
-- ------------------------------------------------------------
CREATE TABLE exame (
  id_exame          INT           NOT NULL AUTO_INCREMENT,
  tipo              VARCHAR(100)  NOT NULL,
  data_solicitacao  DATE          NOT NULL,
  data_resultado    DATE,
  resultado         TEXT,
  id_consulta       INT           NOT NULL,
  PRIMARY KEY (id_exame),
  CONSTRAINT fk_exame_consulta
    FOREIGN KEY (id_consulta) REFERENCES consulta (id_consulta)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 13. CIRURGIA
-- ------------------------------------------------------------
CREATE TABLE cirurgia (
  id_cirurgia      INT            NOT NULL AUTO_INCREMENT,
  tipo             VARCHAR(120)   NOT NULL,
  data_hora        DATETIME       NOT NULL,
  duracao_min      INT            COMMENT 'Duração estimada em minutos',
  status           ENUM('agendada','em_andamento','concluida','cancelada') NOT NULL DEFAULT 'agendada',
  id_paciente      INT            NOT NULL,
  id_medico        INT            NOT NULL,
  id_quarto        INT,
  PRIMARY KEY (id_cirurgia),
  CONSTRAINT fk_cirurgia_paciente
    FOREIGN KEY (id_paciente) REFERENCES paciente (id_paciente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cirurgia_medico
    FOREIGN KEY (id_medico) REFERENCES medico (id_medico)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cirurgia_quarto
    FOREIGN KEY (id_quarto) REFERENCES quarto (id_quarto)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 14. PAGAMENTO
-- ------------------------------------------------------------
CREATE TABLE pagamento (
  id_pagamento     INT            NOT NULL AUTO_INCREMENT,
  data             DATE           NOT NULL,
  valor            DECIMAL(10,2)  NOT NULL,
  metodo           ENUM('dinheiro','cartao_credito','cartao_debito','pix','convenio','boleto') NOT NULL,
  status           ENUM('pendente','pago','cancelado') NOT NULL DEFAULT 'pendente',
  id_paciente      INT            NOT NULL,
  id_consulta      INT,
  PRIMARY KEY (id_pagamento),
  CONSTRAINT fk_pagamento_paciente
    FOREIGN KEY (id_paciente) REFERENCES paciente (id_paciente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pagamento_consulta
    FOREIGN KEY (id_consulta) REFERENCES consulta (id_consulta)
    ON DELETE SET NULL ON UPDATE CASCADE
);


-- ============================================================
--  15. OBITUARIO
--  Registra óbitos de pacientes que estavam internados em
--  estado grave e não receberam alta (data_saida IS NULL).
-- ============================================================
CREATE TABLE obituario (
  id_obituario        INT             NOT NULL AUTO_INCREMENT,
  id_paciente         INT             NOT NULL,
  id_medico           INT             NOT NULL,
  id_internacao       INT             NOT NULL,
  id_quarto           INT             NOT NULL,
  id_pagamento        INT,
  causa_obito         TEXT            NOT NULL,
  data_internacao     DATETIME        NOT NULL,
  data_obito          DATETIME        NOT NULL,
  dias_internado      INT GENERATED ALWAYS AS
                        (DATEDIFF(data_obito, data_internacao)) STORED,
  despesas_medicas    DECIMAL(10,2)   NOT NULL,
  observacoes         TEXT,
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
--  DADOS DE EXEMPLO
-- ============================================================

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

INSERT INTO endereco_paciente (rua, numero, bairro, cidade, uf) VALUES
  ('Rua das Flores',  '10',  'Jardim Primavera', 'São Paulo',       'SP'),
  ('Av. Paulista',    '200', 'Bela Vista',        'São Paulo',       'SP'),
  ('Rua Larga',       '55',  'Centro',            'São Paulo',       'SP');

INSERT INTO paciente (nome, data_nascimento, cpf, telefone, tipo_sanguineo, peso, idade, altura, id_endereco) VALUES
  ('Pedro Alves',       '1985-04-12', '44455566677', '(81) 97000-0001', 'O+',  82.30, 39, 1.78, 1),
  ('Camila Rodrigues',  '1992-11-30', '55566677788', '(81) 97000-0002', 'A+',  61.50, 31, 1.63, 2),
  ('Marcos Ferreira',   '1970-06-22', '66677788899', '(81) 97000-0003', 'B-',  95.00, 53, 1.82, 3);

-- ------------------------------------------------------------
--  60 NOVOS ENDEREÇOS
-- ------------------------------------------------------------
INSERT INTO endereco_paciente (rua, numero, bairro, cidade, uf) VALUES
  ('Rua das Acácias',         '12',  'Boa Viagem',        'Recife',          'PE'),
  ('Av. Caxangá',             '340', 'Iputinga',          'Recife',          'PE'),
  ('Rua do Futuro',           '88',  'Poço da Panela',    'Recife',          'PE'),
  ('Rua Benfica',             '201', 'Benfica',           'Recife',          'PE'),
  ('Av. Agamenon Magalhães',  '555', 'Espinheiro',        'Recife',          'PE'),
  ('Rua Real da Torre',       '77',  'Madalena',          'Recife',          'PE'),
  ('Av. Boa Viagem',          '900', 'Boa Viagem',        'Recife',          'PE'),
  ('Rua Padre Carapuceiro',   '32',  'Boa Viagem',        'Recife',          'PE'),
  ('Rua José Osório',         '14',  'Afogados',          'Recife',          'PE'),
  ('Av. Norte',               '620', 'Água Fria',         'Recife',          'PE'),
  ('Rua Formosa',             '55',  'Casa Amarela',      'Recife',          'PE'),
  ('Rua da Paz',              '200', 'Graças',            'Recife',          'PE'),
  ('Av. Conde da Boa Vista',  '412', 'Boa Vista',         'Recife',          'PE'),
  ('Rua Frei Matias',         '9',   'Derby',             'Recife',          'PE'),
  ('Rua Henrique Dias',       '130', 'Derby',             'Recife',          'PE'),
  ('Av. Dantas Barreto',      '780', 'Santo António',     'Recife',          'PE'),
  ('Rua João de Barros',      '63',  'Boa Vista',         'Recife',          'PE'),
  ('Rua Visconde de Jequitinhonha','44','Boa Viagem',     'Recife',          'PE'),
  ('Rua Barão de Souza Leão', '120', 'Boa Viagem',        'Recife',          'PE'),
  ('Av. Engenheiro Abdias',   '505', 'Imbiribeira',       'Recife',          'PE'),
  ('Rua Marechal Deodoro',    '88',  'Centro',            'Olinda',          'PE'),
  ('Rua do Amparo',           '27',  'Amparo',            'Olinda',          'PE'),
  ('Rua Prudente de Morais',  '310', 'Boa Viagem',        'Recife',          'PE'),
  ('Rua Setúbal',             '190', 'Boa Viagem',        'Recife',          'PE'),
  ('Av. Conselheiro Aguiar',  '800', 'Boa Viagem',        'Recife',          'PE'),
  ('Rua Amaro Bezerra',       '45',  'Casa Forte',        'Recife',          'PE'),
  ('Av. 17 de Agosto',        '230', 'Casa Forte',        'Recife',          'PE'),
  ('Rua Joaquim Nabuco',      '160', 'Graças',            'Recife',          'PE'),
  ('Rua Capitão Lima',        '72',  'Prado',             'Recife',          'PE'),
  ('Rua Gervásio Pires',      '55',  'Boa Vista',         'Recife',          'PE'),
  ('Av. Rosa e Silva',        '440', 'Aflitos',           'Recife',          'PE'),
  ('Rua Dois Irmãos',         '310', 'Dois Irmãos',       'Recife',          'PE'),
  ('Rua General San Martin',  '88',  'Bongi',             'Recife',          'PE'),
  ('Rua das Ninfas',          '21',  'Santo Amaro',       'Recife',          'PE'),
  ('Rua da Aurora',           '150', 'Boa Vista',         'Recife',          'PE'),
  ('Av. Cais do Apolo',       '90',  'Recife Antigo',     'Recife',          'PE'),
  ('Rua do Bom Jesus',        '33',  'Recife Antigo',     'Recife',          'PE'),
  ('Rua da Moeda',            '11',  'Recife Antigo',     'Recife',          'PE'),
  ('Rua Floriano Peixoto',    '280', 'Santo António',     'Recife',          'PE'),
  ('Av. Mário Melo',          '65',  'Santo António',     'Recife',          'PE'),
  ('Rua Érico de Siqueira',   '38',  'Universitário',     'Caruaru',         'PE'),
  ('Av. Agamenon Magalhães',  '900', 'Maurício de Nassau', 'Caruaru',        'PE'),
  ('Rua Padre Eugênio',       '55',  'São Francisco',     'Caruaru',         'PE'),
  ('Rua Leão Dourado',        '140', 'Cohab',             'Caruaru',         'PE'),
  ('Rua do Cruzeiro',         '18',  'Petrópolis',        'Caruaru',         'PE'),
  ('Rua Cônego Domingos Velasco','70','Centro',            'Petrolina',       'PE'),
  ('Av. São Francisco',       '400', 'Jardim São Paulo',  'Petrolina',       'PE'),
  ('Rua Domingos Dias',       '99',  'Centro',            'Petrolina',       'PE'),
  ('Rua das Cajazeiras',      '55',  'José e Maria',      'Petrolina',       'PE'),
  ('Av. Cardoso de Sá',       '220', 'Bairro Novo',       'Petrolina',       'PE'),
  ('Rua Guararapes',          '77',  'Centro',            'Caruaru',         'PE'),
  ('Rua Vereador Tibúrcio',   '33',  'Novo Horizonte',    'Caruaru',         'PE'),
  ('Rua Presidente Médici',   '410', 'Peixinhos',         'Olinda',          'PE'),
  ('Rua Professor Andrade',   '200', 'Ouro Preto',        'Olinda',          'PE'),
  ('Rua Olímpio Catão',       '15',  'Águas Compridas',   'Olinda',          'PE'),
  ('Av. Liberdade',           '330', 'Jardim Liberdade',  'Paulista',        'PE'),
  ('Rua das Orquídeas',       '88',  'Maranguape I',      'Paulista',        'PE'),
  ('Rua Severino Pereira',    '44',  'Janga',             'Paulista',        'PE'),
  ('Av. Marechal Mascarenhas','600', 'Encruzilhada',      'Recife',          'PE'),
  ('Rua Henrique Timóteo',    '22',  'Tamarineira',       'Recife',          'PE');

-- ------------------------------------------------------------
--  60 NOVOS PACIENTES  (id_paciente 4–63)
-- ------------------------------------------------------------
INSERT INTO paciente (nome, data_nascimento, cpf, telefone, tipo_sanguineo, peso, idade, altura, id_endereco) VALUES
  ('Ana Luiza Souza',        '2002-03-14', '10011122200', '(81) 99100-0001', 'A+',  58.00, 22, 1.62, 4),
  ('Bruno Henrique Lima',    '1998-07-22', '10022233300', '(81) 99100-0002', 'O+',  78.50, 26, 1.80, 5),
  ('Carla Mendonça',         '1995-11-05', '10033344400', '(81) 99100-0003', 'B+',  63.00, 28, 1.65, 6),
  ('Diego Cavalcanti',       '1988-04-18', '10044455500', '(81) 99100-0004', 'AB+', 90.00, 36, 1.85, 7),
  ('Elaine Farias',          '2001-09-30', '10055566600', '(81) 99100-0005', 'O-',  55.50, 22, 1.60, 8),
  ('Fábio Nascimento',       '1990-01-12', '10066677700', '(81) 99100-0006', 'A-',  82.00, 34, 1.78, 9),
  ('Gabriela Torres',        '1997-06-25', '10077788800', '(81) 99100-0007', 'B-',  61.00, 27, 1.67, 10),
  ('Henrique Melo',          '1983-12-08', '10088899900', '(81) 99100-0008', 'O+',  95.00, 40, 1.90, 11),
  ('Isabela Cunha',          '2003-08-17', '10099900010', '(81) 99100-0009', 'A+',  57.00, 20, 1.61, 12),
  ('João Victor Barros',     '1996-02-28', '10100011100', '(81) 99100-0010', 'AB-', 74.00, 28, 1.75, 13),
  ('Karen Oliveira',         '1989-05-19', '10111122200', '(81) 99100-0011', 'O+',  68.00, 35, 1.70, 14),
  ('Leonardo Pires',         '2000-10-03', '10122233300', '(81) 99100-0012', 'B+',  80.00, 23, 1.82, 15),
  ('Mariana Andrade',        '1994-07-11', '10133344400', '(81) 99100-0013', 'A-',  59.50, 29, 1.64, 16),
  ('Nathan Correia',         '1987-03-27', '10144455500', '(81) 99100-0014', 'O-',  87.00, 37, 1.88, 17),
  ('Olivia Ramos',           '2004-01-09', '10155566600', '(81) 99100-0015', 'A+',  56.00, 20, 1.60, 18),
  ('Paulo Sérgio Freitas',   '1979-09-15', '10166677700', '(81) 99100-0016', 'B-',  99.00, 44, 1.92, 19),
  ('Quezia Monteiro',        '1993-04-22', '10177788800', '(81) 99100-0017', 'AB+', 64.00, 31, 1.66, 20),
  ('Rafael Bezerra',         '1985-11-30', '10188899900', '(81) 99100-0018', 'O+',  77.00, 38, 1.77, 21),
  ('Sabrina Leal',           '2002-06-14', '10199900010', '(81) 99100-0019', 'A-',  60.00, 22, 1.63, 22),
  ('Thiago Azevedo',         '1991-08-07', '10200011100', '(81) 99100-0020', 'B+',  85.00, 32, 1.83, 23),
  ('Ursula Cardoso',         '1998-12-20', '10211122200', '(81) 99100-0021', 'O-',  62.00, 25, 1.68, 24),
  ('Vinícius Carvalho',      '1986-03-03', '10222233300', '(81) 99100-0022', 'AB-', 91.00, 38, 1.87, 25),
  ('Wanessa Gomes',          '1999-07-16', '10233344400', '(81) 99100-0023', 'A+',  66.00, 25, 1.69, 26),
  ('Xavier Santana',         '1980-10-28', '10244455500', '(81) 99100-0024', 'O+',  93.00, 43, 1.91, 27),
  ('Yasmin Patriota',        '2001-02-05', '10255566600', '(81) 99100-0025', 'B+',  57.50, 23, 1.61, 28),
  ('Zélia Brandão',          '1976-06-18', '10266677700', '(81) 99100-0026', 'A-',  70.00, 48, 1.65, 29),
  ('Adriano Queiroz',        '1992-09-10', '10277788800', '(81) 99100-0027', 'O+',  83.00, 31, 1.80, 30),
  ('Beatriz Moura',          '2003-11-24', '10288899900', '(81) 99100-0028', 'AB+', 55.00, 20, 1.60, 31),
  ('César Figueiredo',       '1977-04-06', '10299900010', '(81) 99100-0029', 'B-',  96.00, 47, 1.89, 32),
  ('Dandara Medeiros',       '1995-08-19', '10300011100', '(81) 99100-0030', 'O-',  65.00, 28, 1.67, 33),
  ('Eduardo Tavares',        '1988-01-31', '10311122200', '(81) 99100-0031', 'A+',  79.00, 36, 1.76, 34),
  ('Fernanda Lacerda',       '2000-05-13', '10322233300', '(81) 99100-0032', 'B+',  61.50, 24, 1.63, 35),
  ('Gustavo Lopes',          '1983-09-26', '10333344400', '(81) 99100-0033', 'AB-', 88.00, 40, 1.86, 36),
  ('Helena Vieira',          '1997-03-08', '10344455500', '(81) 99100-0034', 'O+',  59.00, 27, 1.62, 37),
  ('Iago Magalhães',         '1990-07-21', '10355566600', '(81) 99100-0035', 'A-',  84.00, 34, 1.81, 38),
  ('Júlia Novaes',           '2002-12-04', '10366677700', '(81) 99100-0036', 'B-',  56.50, 21, 1.60, 39),
  ('Klaus Wanderley',        '1984-04-17', '10377788800', '(81) 99100-0037', 'O+',  97.00, 40, 1.93, 40),
  ('Larissa Campos',         '1993-08-30', '10388899900', '(81) 99100-0038', 'AB+', 63.50, 30, 1.66, 41),
  ('Mateus Rocha',           '1975-02-12', '10399900010', '(81) 99100-0039', 'O-',  100.00,49, 1.95, 42),
  ('Nathalia Aragão',        '2001-06-25', '10400011100', '(81) 99100-0040', 'A+',  58.50, 23, 1.61, 43),
  ('Otávio Mendes',          '1989-10-08', '10411122200', '(81) 99100-0041', 'B+',  81.00, 34, 1.79, 44),
  ('Priscila Esteves',       '1996-03-21', '10422233300', '(81) 99100-0042', 'A-',  67.00, 28, 1.68, 45),
  ('Rodrigo Albuquerque',    '1982-07-04', '10433344400', '(81) 99100-0043', 'O+',  92.00, 42, 1.90, 46),
  ('Sofia Diniz',            '2004-11-17', '10444455500', '(81) 99100-0044', 'AB-', 55.00, 19, 1.60, 47),
  ('Tarcísio Brito',         '1978-04-30', '10455566600', '(81) 99100-0045', 'B-',  98.00, 46, 1.94, 48),
  ('Ubiratan Guimarães',     '1991-09-12', '10466677700', '(81) 99100-0046', 'O-',  76.00, 32, 1.74, 49),
  ('Vanessa Estrada',        '1999-01-25', '10477788800', '(81) 99100-0047', 'A+',  64.00, 25, 1.65, 50),
  ('Wellington Sá',          '1985-05-08', '10488899900', '(81) 99100-0048', 'B+',  86.00, 39, 1.84, 51),
  ('Xênia Ferraz',           '2003-09-21', '10499900010', '(81) 99100-0049', 'O+',  57.00, 20, 1.62, 52),
  ('Yago Fernandes',         '1994-02-03', '10500011100', '(81) 99100-0050', 'AB+', 73.00, 30, 1.76, 53),
  ('Zilda Amorim',           '1980-06-16', '10511122200', '(81) 99100-0051', 'A-',  69.00, 44, 1.64, 54),
  ('Alexandre Pinto',        '1987-10-29', '10522233300', '(81) 99100-0052', 'O+',  89.00, 36, 1.87, 55),
  ('Bianca Cavalcante',      '2000-03-13', '10533344400', '(81) 99100-0053', 'B-',  60.00, 24, 1.63, 56),
  ('Cláudio Holanda',        '1973-07-26', '10544455500', '(81) 99100-0054', 'AB+', 94.00, 51, 1.91, 57),
  ('Denise Fonseca',         '1997-12-09', '10555566600', '(81) 99100-0055', 'O-',  62.50, 26, 1.66, 58),
  ('Emerson Leite',          '1981-04-22', '10566677700', '(81) 99100-0056', 'A+',  85.50, 43, 1.82, 59),
  ('Flávia Drummond',        '1995-09-05', '10577788800', '(81) 99100-0057', 'B+',  67.50, 28, 1.69, 60),
  ('Geraldo Meireles',       '1969-01-18', '10588899900', '(81) 99100-0058', 'O+',  91.00, 55, 1.88, 61),
  ('Heloísa Barreto',        '2002-05-01', '10599900010', '(81) 99100-0059', 'A-',  59.00, 22, 1.61, 62),
  ('Ítalo Sampaio',          '1976-08-14', '10600011100', '(81) 99100-0060', 'AB-', 97.50, 47, 1.92, 63);

-- ------------------------------------------------------------
--  NOVOS QUARTOS (para suportar os casos graves)
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
--  CONSULTAS — pacientes regulares (motivo e diagnóstico normais)
--  + 10 casos graves com motivo NULL e diagnósticos críticos
--  Os 10 casos graves: id_paciente 4,7,12,18,25,31,37,43,50,56
--  (ids relativos ao banco após os 3 originais)
-- ------------------------------------------------------------
INSERT INTO consulta (data_hora, motivo, diagnostico, id_paciente, id_medico, id_quarto) VALUES
  ('2024-05-10 09:00:00', 'Dor no peito',            'Angina estável',                    1, 1, 1),
  ('2024-05-11 14:30:00', 'Dor no joelho',            'Artrite leve',                      2, 2, 2),
  ('2024-05-12 10:00:00', 'Febre e tosse',            'Resfriado viral',                   3, 4, 4),
  -- Casos graves (motivo NULL, diagnósticos críticos)
  ('2024-06-01 02:15:00', NULL, 'Politraumatismo grave por acidente de trânsito — fratura de fêmur bilateral e TCE moderado',              4,  1, 3),
  ('2024-06-03 18:40:00', NULL, 'Queimaduras de 3° grau em 45% da superfície corporal — região torácica e membros superiores',             7,  4, 6),
  ('2024-06-05 23:55:00', NULL, 'Envenenamento por organofosforado — insuficiência respiratória aguda e colinérgico grave',                12, 1, 7),
  ('2024-06-08 07:30:00', NULL, 'Politraumatismo por atropelamento — ruptura esplênica e pneumotórax hipertensivo',                        18, 2, 8),
  ('2024-06-10 14:10:00', NULL, 'Queimaduras de 3° grau em 60% do corpo — face, tronco e membros — risco de sepse',                       25, 4, 9),
  ('2024-06-12 03:20:00', NULL, 'Intoxicação aguda por cianeto — parada cardiorrespiratória revertida, encefalopatia anóxica',             31, 1, 10),
  ('2024-06-14 11:45:00', NULL, 'Acidente de trânsito com motocicleta — traumatismo raquimedular cervical, risco de tetraplegia',          37, 2, 11),
  ('2024-06-16 20:00:00', NULL, 'Queimaduras de 3° grau por explosão de gás — 55% SCQ, insuficiência renal aguda instalada',              43, 4, 12),
  ('2024-06-18 09:35:00', NULL, 'Envenenamento por picada de serpente Bothrops — coagulopatia grave e necrose tecidual extensa',           50, 1, 13),
  ('2024-06-20 16:50:00', NULL, 'Politraumatismo por colisão frontal — hemotórax maciço bilateral e choque hemorrágico classe IV',         56, 2, 14),
  -- Pacientes regulares adicionais
  ('2024-06-22 09:00:00', 'Cefaleia persistente',     'Enxaqueca com aura',                5,  1, 1),
  ('2024-06-22 10:00:00', 'Dor abdominal',            'Gastrite aguda',                    6,  4, 4),
  ('2024-06-22 11:00:00', 'Tontura e náusea',         'Labirintite',                       8,  1, 2),
  ('2024-06-23 08:30:00', 'Dor lombar',               'Hérnia de disco L4-L5',             9,  2, 2),
  ('2024-06-23 09:30:00', 'Palpitações',              'Arritmia sinusal benigna',          10,  1, 1),
  ('2024-06-23 14:00:00', 'Tosse crônica',            'Bronquite alérgica',               11,  4, 4),
  ('2024-06-24 10:00:00', 'Dor no ombro',             'Tendinite do manguito rotador',    13,  2, 2),
  ('2024-06-24 11:00:00', 'Manchas na pele',          'Dermatite de contato',             14,  4, 4),
  ('2024-06-24 15:00:00', 'Visão turva',              'Miopia progressiva',               15,  1, 1),
  ('2024-06-25 08:00:00', 'Dor de garganta',          'Amigdalite bacteriana',            16,  4, 4),
  ('2024-06-25 09:00:00', 'Fadiga constante',         'Hipotireoidismo',                  17,  1, 1),
  ('2024-06-25 10:00:00', 'Ansiedade e insônia',      'Transtorno de ansiedade generalizada', 19, 4, 4),
  ('2024-06-26 08:30:00', 'Dor no peito ao esforço',  'Angina de esforço',               20,  1, 1),
  ('2024-06-26 09:30:00', 'Edema nos membros',        'Insuficiência venosa periférica',  21,  2, 2),
  ('2024-06-26 14:00:00', 'Queda de cabelo',          'Alopecia androgenética',           22,  4, 4),
  ('2024-06-27 08:00:00', 'Câimbras frequentes',      'Deficiência de magnésio',          23,  1, 1),
  ('2024-06-27 09:00:00', 'Diabetes descompensada',   'DM2 com hiperglicemia',            24,  4, 4),
  ('2024-06-27 10:00:00', 'Dor nos pés',              'Fascite plantar bilateral',        26,  2, 2),
  ('2024-06-28 08:30:00', 'Hemorragia nasal',         'Epistaxe hipertensiva',            27,  1, 1),
  ('2024-06-28 09:30:00', 'Infecção urinária',        'Cistite bacteriana aguda',         28,  4, 4),
  ('2024-06-28 14:00:00', 'Dor articular',            'Gota articular',                   29,  2, 2),
  ('2024-06-29 08:00:00', 'Depressão e tristeza',     'Episódio depressivo moderado',     30,  4, 4),
  ('2024-06-29 10:00:00', 'Perda de apetite',         'Gastroenterite viral',             32,  4, 4),
  ('2024-06-29 14:00:00', 'Pressão alta',             'Hipertensão arterial estágio 2',   33,  1, 1),
  ('2024-06-30 08:30:00', 'Dor no joelho direito',    'Lesão de menisco medial',          34,  2, 2),
  ('2024-06-30 09:30:00', 'Rinite alérgica',          'Rinite perene moderada',           35,  4, 4),
  ('2024-06-30 14:00:00', 'Dor de ouvido',            'Otite média aguda',                36,  4, 4),
  ('2024-07-01 08:00:00', 'Dificuldade para dormir',  'Insônia crônica primária',         38,  4, 4),
  ('2024-07-01 09:00:00', 'Fraqueza muscular',        'Miosite inflamatória',             39,  2, 2),
  ('2024-07-01 10:00:00', 'Inchaço articular',        'Artrite reumatoide ativa',         40,  2, 2),
  ('2024-07-02 08:30:00', 'Tosse com sangue',         'Bronquiectasia',                   41,  4, 4),
  ('2024-07-02 09:30:00', 'Dor abdominal direita',    'Colelitíase com colecistite',      42,  4, 4),
  ('2024-07-02 14:00:00', 'Dor no quadril',           'Coxartrose bilateral',             44,  2, 2),
  ('2024-07-03 08:00:00', 'Convulsão',                'Epilepsia focal sintomática',       45,  1, 1),
  ('2024-07-03 09:00:00', 'Dor ao urinar',            'Prostatite aguda bacteriana',      46,  4, 4),
  ('2024-07-03 10:00:00', 'Irregularidade menstrual', 'SOP — síndrome dos ovários policísticos', 47, 4, 4),
  ('2024-07-04 08:30:00', 'Palpitações e sudorese',   'Hipertireoidismo',                 48,  1, 1),
  ('2024-07-04 09:30:00', 'Dor no tornozelo',         'Entorse grau II',                  49,  2, 2),
  ('2024-07-04 14:00:00', 'Dor de cabeça intensa',    'Hipertensão intracraniana benigna',51,  1, 1),
  ('2024-07-05 08:00:00', 'Ganho de peso rápido',     'Hipercortisolismo (Cushing)',       52,  1, 1),
  ('2024-07-05 09:00:00', 'Dor nas costas alta',      'Fratura vertebral por osteoporose',53,  2, 2),
  ('2024-07-05 10:00:00', 'Falta de ar em repouso',   'Insuficiência cardíaca congestiva', 54,  1, 1),
  ('2024-07-06 08:30:00', 'Dor pélvica crônica',      'Endometriose estágio III',         55,  4, 4),
  ('2024-07-06 09:30:00', 'Visão dupla',              'Neurite óptica',                   57,  1, 1),
  ('2024-07-06 14:00:00', 'Tremores nas mãos',        'Doença de Parkinson inicial',       58,  1, 1),
  ('2024-07-07 08:00:00', 'Dor no estômago',          'Úlcera péptica sangrante',         59,  4, 4),
  ('2024-07-07 09:00:00', 'Falta de ar intensa',      'Embolia pulmonar',                 60,  1, 1),
  ('2024-07-07 10:00:00', 'Fraqueza num lado do corpo','AVC isquêmico em evolução',       61,  1, 1),
  ('2024-07-08 08:30:00', 'Dor abdominal difusa',     'Peritonite por apendicite rota',   62,  4, 4),
  ('2024-07-08 09:30:00', 'Confusão mental aguda',    'Sepse de foco urinário',           63,  4, 4);

-- ------------------------------------------------------------
--  INTERNAÇÕES
--  Casos graves (data_saida NULL = ainda internado)
--  Casos regulares com alta já definida
-- ------------------------------------------------------------
INSERT INTO internacao (data_entrada, data_saida, motivo, id_paciente, id_quarto, id_medico) VALUES
  ('2024-05-10 11:00:00', '2024-05-13 10:00:00', 'Observação cardíaca',                    1,  1,  1),
  -- Casos graves — sem data_saida (ainda internados)
  ('2024-06-01 03:00:00', NULL, 'Politraumatismo grave por acidente de trânsito',           4,  3,  1),
  ('2024-06-03 19:10:00', NULL, 'Queimaduras de 3° grau — 45% SCQ',                        7,  6,  4),
  ('2024-06-05 00:30:00', NULL, 'Envenenamento por organofosforado',                       12,  7,  1),
  ('2024-06-08 08:00:00', NULL, 'Politraumatismo por atropelamento — ruptura esplênica',   18,  8,  2),
  ('2024-06-10 15:00:00', NULL, 'Queimaduras de 3° grau — 60% SCQ',                       25,  9,  4),
  ('2024-06-12 04:00:00', NULL, 'Intoxicação por cianeto — encefalopatia anóxica',         31, 10,  1),
  ('2024-06-14 12:30:00', NULL, 'Traumatismo raquimedular cervical',                       37, 11,  2),
  ('2024-06-16 21:00:00', NULL, 'Queimaduras de 3° grau por explosão — 55% SCQ',          43, 12,  4),
  ('2024-06-18 10:00:00', NULL, 'Envenenamento por Bothrops — coagulopatia grave',         50, 13,  1),
  ('2024-06-20 17:30:00', NULL, 'Hemotórax maciço bilateral — choque hemorrágico',         56, 14,  2),
  -- Internações regulares com alta
  ('2024-06-22 12:00:00', '2024-06-25 10:00:00', 'Observação por arritmia',               10,  1,  1),
  ('2024-06-24 09:00:00', '2024-06-27 08:00:00', 'Tratamento de bronquite',               11,  2,  4),
  ('2024-06-25 14:00:00', '2024-06-28 11:00:00', 'Controle de hipertireoidismo',          48,  1,  1),
  ('2024-07-02 10:00:00', '2024-07-05 09:00:00', 'Colecistite aguda — preparo cirúrgico', 42,  2,  4),
  ('2024-07-07 09:30:00', '2024-07-10 08:00:00', 'AVC isquêmico — monitoramento',         61,  1,  1);

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

-- ------------------------------------------------------------
--  PRESCRIÇÕES
--  id_consulta referencia a ordem dos INSERTs de consulta:
--  consultas 1-3 = pacientes originais, 4-13 = casos graves,
--  14 em diante = regulares novos
-- ------------------------------------------------------------
INSERT INTO prescricao (data, instrucoes, id_consulta) VALUES
  -- Originais
  ('2024-05-10', 'Tomar com água, evitar jejum.',                                   1),
  ('2024-05-11', 'Aplicar gelo local 3x/dia.',                                      2),
  -- Casos graves (UTI — prescrições contínuas)
  ('2024-06-01', 'Analgesia contínua em bomba de infusão. Manter cabeceira a 30°.', 4),
  ('2024-06-03', 'Curativo com sulfadiazina 2x/dia. Hidratação venosa rigorosa.',   5),
  ('2024-06-05', 'Atropina + pralidoxima IV conforme protocolo de OP.',              6),
  ('2024-06-08', 'Morfina titulada. Monitorar PA e SatO2 continuamente.',           7),
  ('2024-06-10', 'Reposição volêmica agressiva. Curativo especial 3x/dia.',         8),
  ('2024-06-12', 'Hidroxicobalamina IV. Suporte ventilatório mecânico.',            9),
  ('2024-06-14', 'Imobilização cervical. Corticosteroide IV nas primeiras 8h.',    10),
  ('2024-06-16', 'Nutrição parenteral total. Antibioticoterapia profilática.',      11),
  ('2024-06-18', 'Soro antibotrópico IV. Monitorar coagulação a cada 6h.',         12),
  ('2024-06-20', 'Transfusão de hemácias. Noradrenalina em bomba de infusão.',     13),
  -- Regulares novos
  ('2024-06-22', 'Tomar com bastante água. Evitar luz intensa.',                   14),
  ('2024-06-22', 'Ingerir antes das refeições. Evitar alimentos gordurosos.',      15),
  ('2024-06-22', 'Repouso relativo. Evitar movimentos bruscos.',                   16),
  ('2024-06-23', 'Fisioterapia 3x/semana. Evitar esforço físico.',                 17),
  ('2024-06-23', 'Uso contínuo. Monitorar pressão arterial semanalmente.',         18),
  ('2024-06-23', 'Nebulização 2x/dia. Evitar exposição ao frio.',                  19),
  ('2024-06-24', 'Fisioterapia e gelo local 2x/dia.',                              20),
  ('2024-06-25', 'Tomar em jejum, 30min antes do café da manhã.',                  22),
  ('2024-06-25', 'Uso contínuo. Revisão em 30 dias.',                              23),
  ('2024-06-27', 'Monitorar glicemia em jejum 3x/semana.',                         25),
  ('2024-06-28', 'Aumentar ingestão hídrica. Repetir urina após 7 dias.',          28),
  ('2024-06-29', 'Evitar alimentos com purina. Hidratação abundante.',             29),
  ('2024-07-03', 'Tomar por 10 dias sem interromper.',                             31),
  ('2024-07-04', 'Controle laboratorial mensal. Uso contínuo.',                    32),
  ('2024-07-05', 'Dieta hipossódica. Pesar diariamente.',                          34),
  ('2024-07-07', 'Anticoagulação iniciada. Evitar quedas.',                        39),
  ('2024-07-08', 'Antibioticoterapia IV por 14 dias.',                             40);

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

INSERT INTO exame (tipo, data_solicitacao, data_resultado, resultado, id_consulta) VALUES
  -- Originais
  ('Eletrocardiograma',        '2024-05-10', '2024-05-10', 'Ritmo sinusal, sem alterações agudas.',                      1),
  ('Raio-X joelho',            '2024-05-11', '2024-05-12', 'Leve estreitamento do espaço articular.',                    2),
  -- Casos graves — exames urgentes, alguns ainda sem resultado
  ('TC de crânio e coluna',    '2024-06-01', '2024-06-01', 'TCE moderado, fratura de fêmur bilateral confirmada.',        4),
  ('Gasometria arterial',      '2024-06-01', '2024-06-01', 'Acidose respiratória compensada.',                           4),
  ('Mapeamento de queimaduras','2024-06-03', '2024-06-03', '45% SCQ — 2° e 3° graus em tórax e MMSS.',                  5),
  ('Hemograma completo',       '2024-06-03', '2024-06-03', 'Leucocitose com desvio à esquerda.',                         5),
  ('Colinesterase plasmática', '2024-06-05', '2024-06-05', 'Colinesterase < 10% do valor de referência.',                6),
  ('Gasometria arterial',      '2024-06-05', '2024-06-05', 'Hipoxemia grave — PaO2 52 mmHg.',                            6),
  ('Ultrassom abdominal',      '2024-06-08', '2024-06-08', 'Ruptura esplênica confirmada. Hemoperitônio volumoso.',       7),
  ('Raio-X de tórax',         '2024-06-08', '2024-06-08', 'Pneumotórax hipertensivo à direita.',                        7),
  ('Mapeamento de queimaduras','2024-06-10', '2024-06-10', '60% SCQ — 3° grau em face, tronco e MMII.',                  8),
  ('Proteína C-reativa',       '2024-06-10', NULL,         NULL,                                                          8),
  ('Lactato sérico',           '2024-06-12', '2024-06-12', 'Lactato 12 mmol/L — acidose lática grave.',                  9),
  ('Eletroencefalograma',      '2024-06-12', NULL,         NULL,                                                          9),
  ('RM de coluna cervical',    '2024-06-14', '2024-06-14', 'Lesão medular completa em C5-C6.',                           10),
  ('Potencial evocado',        '2024-06-14', NULL,         NULL,                                                         10),
  ('Mapeamento de queimaduras','2024-06-16', '2024-06-16', '55% SCQ — 3° grau. Creatinina 3,8 mg/dL.',                  11),
  ('Ureia e creatinina',       '2024-06-16', '2024-06-16', 'IRA instalada — creatinina 3,8, ureia 120.',                 11),
  ('Coagulograma',             '2024-06-18', '2024-06-18', 'TTPA > 120s. Fibrinogênio indetectável. CIVD confirmada.',   12),
  ('Dosagem de veneno',        '2024-06-18', NULL,         NULL,                                                         12),
  ('TC de tórax',              '2024-06-20', '2024-06-20', 'Hemotórax bilateral maciço. Desvio de mediastino.',          13),
  ('Gasometria arterial',      '2024-06-20', '2024-06-20', 'Choque hemorrágico classe IV. BE -14.',                      13),
  -- Regulares novos
  ('Ressonância magnética',    '2024-06-23', '2024-06-25', 'Protrusão discal L4-L5 com compressão radicular.',           17),
  ('Holter 24h',               '2024-06-23', '2024-06-24', 'Arritmia sinusal sem bloqueios ou pausas significativas.',   18),
  ('Radiografia de ombro',     '2024-06-24', '2024-06-24', 'Calcificação no tendão supraespinal.',                      20),
  ('TSH e T4 livre',           '2024-06-25', '2024-06-26', 'TSH 18,4 mUI/L. T4 livre 0,6 ng/dL. Hipotireoidismo.',     23),
  ('Ecocardiograma',           '2024-06-26', '2024-06-27', 'FE 38%. Dilatação de VE. ICC confirmada.',                  34),
  ('Glicemia e HbA1c',         '2024-06-27', '2024-06-27', 'Glicemia 310 mg/dL. HbA1c 11,2%. DM2 descompensado.',      25),
  ('Urocultura',               '2024-06-28', '2024-06-30', 'E. coli > 100.000 UFC/mL. Sensível à ciprofloxacino.',      28),
  ('Ácido úrico sérico',       '2024-06-28', '2024-06-28', 'Ácido úrico 9,8 mg/dL.',                                    29),
  ('EEG',                      '2024-07-03', '2024-07-04', 'Foco epileptiforme temporal esquerdo.',                     31),
  ('Ultrassom pélvico',        '2024-07-03', '2024-07-03', 'Ovários aumentados com múltiplos folículos.',                32),
  ('TSH, T3 e T4',             '2024-07-04', '2024-07-04', 'TSH suprimido. T3 e T4 elevados. Hipertireoidismo.',        32),
  ('Ressonância de joelho',    '2024-06-30', '2024-07-01', 'Lesão parcial do menisco medial. Sem ruptura total.',        18),
  ('Angio-TC pulmonar',        '2024-07-07', '2024-07-07', 'Tromboembolismo pulmonar bilateral confirmado.',             39),
  ('TC de crânio',             '2024-07-07', '2024-07-07', 'Área de hipodensidade em território da ACM esquerda.',      40),
  ('Hemocultura',              '2024-07-08', '2024-07-09', 'Klebsiella pneumoniae — sensível a carbapenêmicos.',         40);

INSERT INTO cirurgia (tipo, data_hora, duracao_min, status, id_paciente, id_medico, id_quarto) VALUES
  ('Artroscopia de joelho',            '2024-06-15 08:00:00',  90,  'agendada',   2,  2, 5),
  ('Laparotomia exploradora — esplenectomia', '2024-06-08 10:00:00', 180, 'concluida',  18, 2, 5),
  ('Drenagem de tórax bilateral',      '2024-06-20 19:00:00', 120,  'concluida',  56, 2, 5),
  ('Debridamento de queimaduras',      '2024-06-04 08:00:00', 210,  'concluida',   7, 4, 5),
  ('Debridamento e enxerto cutâneo',   '2024-06-17 07:30:00', 300,  'concluida',  43, 4, 5),
  ('Fixação cirúrgica de fêmur',       '2024-06-02 09:00:00', 150,  'concluida',   4, 2, 5),
  ('Colecistectomia laparoscópica',    '2024-07-03 07:00:00',  75,  'concluida',  42, 4, 5),
  ('Apendicectomia com lavagem',       '2024-07-08 11:00:00',  90,  'em_andamento',62, 4, 5),
  ('Diálise de urgência — acesso venoso central', '2024-06-17 14:00:00', 60, 'concluida', 43, 1, 5),
  ('Craniectomia descompressiva',      '2024-07-08 13:00:00', 240,  'agendada',   56, 1, 5);

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

-- ============================================================
--  DADOS — OBITUARIO
--  Apenas 7 óbitos confirmados.
--  Os 3 primeiros pacientes graves (id 4 — Ana Luiza Souza,
--  id 7 — Diego Cavalcanti, id 12 — Isabela Cunha) ainda estão
--  internados em UTI com data_saida = NULL na tabela internacao.
-- ============================================================
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
