# Changelog

Todas as mudanças relevantes neste projeto serão documentadas aqui.  
Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).

---

## [1.4.0] — 2024-07-08

### Adicionado
- Tabela `obituario` com 7 óbitos de pacientes graves
- Campo `dias_internado` gerado automaticamente via `GENERATED ALWAYS AS DATEDIFF(...) STORED`
- Consultas de verificação de óbitos: total, média de dias, despesas e agrupamento por causa
- Diagrama ERD no formato nativo do draw.io (`hospital_erd.drawio`) com 15 tabelas e 24 relacionamentos
- Descrição técnica completa em `docs/descricao_banco_hospital.docx`

### Modificado
- 3 dos 10 pacientes graves (Ana Luiza Souza, Diego Cavalcanti, Isabela Cunha) mantidos internados sem óbito
- `data_saida = NULL` confirma internação ativa dos 3 sobreviventes

---

## [1.3.0] — 2024-07-07

### Adicionado
- 9 novos médicos: Cirurgião (×2), Oftalmologista (×2), Dermatologista (×2), Otorrinolaringologista, Clínica Geral (×2)
- 9 novos funcionários distribuídos em Enfermeiro(a) e Técnico(a) de Lab.
- Consultas de atendimentos por médico em 3 intervalos de 3 dias (`atendimentos_por_medico.sql`)

---

## [1.2.0] — 2024-07-06

### Adicionado
- 60 novos pacientes (ids 4–63) com endereços em PE (Recife, Olinda, Paulista, Caruaru, Petrolina)
- 60 novos endereços na tabela `endereco_paciente`
- 10 casos graves com `motivo = NULL` e diagnósticos críticos (queimaduras, politraumatismo, envenenamento)
- 10 internações com `data_saida = NULL` (pacientes ainda internados)
- 14 novos quartos de UTI para suporte aos casos graves
- Expansão de prescrições, exames, cirurgias e pagamentos para todos os novos pacientes
- Arquivo de consultas SQL (`consultas_hospital.sql`) com SELECT/WHERE e todos os tipos de JOIN

### Modificado
- DDD de todos os telefones alterado de (11) para (81)
- Departamento `Radiografia` (Bloco F) adicionado

---

## [1.1.0] — 2024-07-01

### Adicionado
- Campos `peso`, `idade` e `altura` na tabela `paciente`
- Dados de peso/idade/altura para os 3 pacientes originais

### Modificado
- Tabela `endereco` renomeada para `endereco_paciente`
- FK em `paciente` atualizada para referenciar `endereco_paciente`

---

## [1.0.1] — 2024-06-30

### Modificado
- Campo `endereco VARCHAR(200)` removido de `paciente`
- Criada tabela `endereco_paciente` com campos atômicos: `rua`, `numero`, `bairro`, `cidade`, `uf`
- Normalização aplicada (1FN, 2FN e 3FN)

---

## [1.0.0] — 2024-06-01

### Adicionado
- Estrutura inicial com 13 tabelas:  
  `departamento`, `medico`, `funcionario`, `paciente`, `quarto`, `consulta`,  
  `internacao`, `prescricao`, `medicamento`, `prescricao_medicamento`,  
  `exame`, `cirurgia`, `pagamento`
- 3 pacientes, 4 médicos, 3 funcionários, 5 departamentos de exemplo
- Relacionamentos com `ON DELETE` e `ON UPDATE` explícitos em todas as FKs
- Tipos `ENUM` para campos de domínio controlado
