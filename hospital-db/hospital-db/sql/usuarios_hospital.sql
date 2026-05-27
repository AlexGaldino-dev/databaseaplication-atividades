-- ============================================================
--  HOSPITAL — GERENCIAMENTO DE USUÁRIOS E PERMISSÕES
--  MySQL 8.0+
--  4 perfis com níveis crescentes de acesso
--  Executar como root ou usuário com GRANT OPTION
-- ============================================================

USE hospital;

-- ============================================================
--  USUÁRIO 1 — leitor_hospital
--  Perfil: Consulta / Relatórios
--  Pode apenas executar SELECT em todas as tabelas do banco.
--  Indicado para: analistas de dados, auditores externos,
--  sistemas de BI e dashboards de leitura.
-- ============================================================

CREATE USER IF NOT EXISTS 'leitor_hospital'@'localhost'
  IDENTIFIED BY 'Leitor@H0sp2024!';

-- Apenas leitura em todas as tabelas do banco
GRANT SELECT
  ON hospital.*
  TO 'leitor_hospital'@'localhost';

-- ============================================================
--  USUÁRIO 2 — recepcao_hospital
--  Perfil: Recepção / Cadastro de Pacientes
--  Pode inserir e atualizar dados APENAS nas tabelas
--  'paciente' e 'endereco_paciente'. Sem acesso às demais.
--  Indicado para: atendentes de recepção, sistema de
--  agendamento e pré-cadastro de pacientes.
-- ============================================================

CREATE USER IF NOT EXISTS 'recepcao_hospital'@'localhost'
  IDENTIFIED BY 'Recepcao@H0sp2024!';

-- Permissões restritas somente às duas tabelas autorizadas
GRANT SELECT, INSERT, UPDATE
  ON hospital.paciente
  TO 'recepcao_hospital'@'localhost';

GRANT SELECT, INSERT, UPDATE
  ON hospital.endereco_paciente
  TO 'recepcao_hospital'@'localhost';

-- ============================================================
--  USUÁRIO 3 — enfermagem_hospital
--  Perfil: Operacional / Enfermagem e Equipe Clínica
--  Pode inserir dados em TODAS as tabelas e adicionar
--  novos campos (ALTER TABLE ... ADD COLUMN) em qualquer
--  tabela, mas NÃO pode excluir nenhuma tabela (sem DROP).
--  Indicado para: equipe de enfermagem, técnicos, sistemas
--  clínicos que registram consultas, internações e exames.
-- ============================================================

CREATE USER IF NOT EXISTS 'enfermagem_hospital'@'localhost'
  IDENTIFIED BY 'Enfermagem@H0sp2024!';

-- Leitura e escrita em todas as tabelas (sem DROP TABLE)
GRANT SELECT, INSERT, UPDATE, CREATE, ALTER, INDEX, REFERENCES
  ON hospital.*
  TO 'enfermagem_hospital'@'localhost';

-- Nota: DELETE de linhas é concedido (remover um registro
-- errado é operação legítima). O que NÃO é concedido é
-- DROP TABLE (destruir a estrutura da tabela).
GRANT DELETE
  ON hospital.*
  TO 'enfermagem_hospital'@'localhost';

-- ============================================================
--  USUÁRIO 4 — admin_hospital
--  Perfil: Administrador do Banco
--  Possui TODOS os privilégios sobre o banco 'hospital',
--  incluindo criar/alterar/excluir tabelas e gerenciar
--  outros usuários DENTRO deste banco — mas NÃO pode
--  executar DROP DATABASE, preservando o banco inteiro.
--  Indicado para: DBA responsável pelo sistema hospitalar,
--  equipe de TI interna.
-- ============================================================

CREATE USER IF NOT EXISTS 'admin_hospital'@'localhost'
  IDENTIFIED BY 'Admin@H0sp2024!';

-- Todos os privilégios sobre o banco hospital
GRANT ALL PRIVILEGES
  ON hospital.*
  TO 'admin_hospital'@'localhost'
  WITH GRANT OPTION;

-- Revogar explicitamente a capacidade de destruir o banco.
-- Em MySQL, DROP DATABASE é coberto por DROP no nível global,
-- não por ALL PRIVILEGES no nível de database. Portanto,
-- NÃO concedemos privilégios globais a este usuário, o que
-- já o impede de executar DROP DATABASE.
-- A linha abaixo é uma garantia adicional de documentação:
REVOKE DROP
  ON hospital.*
  FROM 'admin_hospital'@'localhost';

-- Aplicar todas as permissões imediatamente
FLUSH PRIVILEGES;


-- ============================================================
--  VERIFICAÇÃO — consulta as permissões de cada usuário
-- ============================================================

SHOW GRANTS FOR 'leitor_hospital'@'localhost';
SHOW GRANTS FOR 'recepcao_hospital'@'localhost';
SHOW GRANTS FOR 'enfermagem_hospital'@'localhost';
SHOW GRANTS FOR 'admin_hospital'@'localhost';
