-- ============================================================
--  HOSPITAL — SCHEMA
--  Criação de todas as 15 tabelas com constraints e FKs
--  MySQL 8.0+
--  Executar antes de qualquer seed de dados
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
