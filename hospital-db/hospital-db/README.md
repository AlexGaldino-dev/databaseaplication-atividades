# 🏥 Hospital DB

Banco de dados relacional de um hospital de médio porte, desenvolvido em **MySQL 8.0**.
Modelado seguindo as **três primeiras formas normais (1FN, 2FN e 3FN)**.

---

## 📊 Visão Geral

| Item | Valor |
|---|---|
| SGBD | MySQL 8.0+ |
| Total de tabelas | 15 |
| Total de relacionamentos (FK) | 24 |
| Pacientes cadastrados | 63 |
| Médicos | 13 |
| Funcionários | 12 |
| Departamentos | 6 |
| Consultas | 63 |
| Internações (10 ainda ativas) | 16 |
| Cirurgias | 10 |
| Exames | 37 |
| Medicamentos | 20 |
| Pagamentos | 63 |
| Óbitos registrados | 7 |

---

## 🗂️ Estrutura do Repositório

```
hospital-db/
│
├── sql/
│   ├── schema/
│   │   └── 01_schema.sql                   # CREATE TABLE de todas as 15 tabelas
│   │
│   ├── data/
│   │   ├── 02_seed_estrutura.sql           # Departamentos, médicos, funcionários, quartos
│   │   ├── 03_seed_pacientes.sql           # Endereços e 63 pacientes
│   │   ├── 04_seed_atendimentos.sql        # Consultas, internações, cirurgias, exames
│   │   ├── 05_seed_farmacia.sql            # Medicamentos, prescrições e itens
│   │   └── 06_seed_financeiro_obitos.sql   # Pagamentos e 7 óbitos
│   │
│   └── queries/
│       ├── 07_consultas_where_join.sql          # SELECT + WHERE e todos os tipos de JOIN
│       └── 08_atendimentos_por_medico.sql        # Atendimentos por médico (intervalos de 3 dias)
│
├── diagrams/
│   └── hospital_erd.drawio            # ERD completo — abrir no draw.io
│
├── docs/
│   └── descricao_banco_hospital.docx  # Descrição técnica completa
│
├── .gitignore
└── README.md
```

---

## ▶️ Como Executar

Execute os arquivos na **ordem numérica** — cada seed depende do anterior:

```bash
mysql -u root -p < sql/schema/01_schema.sql
mysql -u root -p < sql/data/02_seed_estrutura.sql
mysql -u root -p < sql/data/03_seed_pacientes.sql
mysql -u root -p < sql/data/04_seed_atendimentos.sql
mysql -u root -p < sql/data/05_seed_farmacia.sql
mysql -u root -p < sql/data/06_seed_financeiro_obitos.sql
```

Ou dentro do cliente MySQL:

```sql
SOURCE sql/schema/01_schema.sql;
SOURCE sql/data/02_seed_estrutura.sql;
SOURCE sql/data/03_seed_pacientes.sql;
SOURCE sql/data/04_seed_atendimentos.sql;
SOURCE sql/data/05_seed_farmacia.sql;
SOURCE sql/data/06_seed_financeiro_obitos.sql;
```

---

## 🗃️ Tabelas

### Estrutura Hospitalar
| Tabela | Descrição |
|---|---|
| `departamento` | 6 setores: Cardiologia, Ortopedia, Pediatria, UTI Adulto, Emergência, Radiografia |
| `quarto` | 19 quartos — apartamento, enfermaria, UTI, cirurgia, emergência |

### Pessoas
| Tabela | Descrição |
|---|---|
| `endereco_paciente` | Endereços atômicos (1FN) — rua, número, bairro, cidade, UF |
| `paciente` | 63 pacientes com peso, idade, altura e tipo sanguíneo |
| `medico` | 13 médicos — 8 especialidades diferentes |
| `funcionario` | 12 funcionários — Enfermeiros, Técnicos de Lab., Recepcionista |

### Atendimento Clínico
| Tabela | Descrição |
|---|---|
| `consulta` | 63 consultas — 10 graves com `motivo = NULL` (emergências) |
| `internacao` | 16 internações — 10 com `data_saida = NULL` (ainda internados) |
| `cirurgia` | 10 procedimentos cirúrgicos com status e duração |
| `exame` | 37 exames — alguns com `data_resultado = NULL` (pendentes) |

### Farmácia
| Tabela | Descrição |
|---|---|
| `medicamento` | 20 medicamentos incluindo protocolos de UTI |
| `prescricao` | 29 prescrições vinculadas a consultas |
| `prescricao_medicamento` | Tabela associativa N:N com dosagem e frequência |

### Financeiro e Óbitos
| Tabela | Descrição |
|---|---|
| `pagamento` | 63 pagamentos — 48 pagos, 18 pendentes (casos graves em UTI) |
| `obituario` | 7 óbitos com causa, dias internado (GENERATED) e despesas |

---

## 🔗 Relacionamentos

24 relacionamentos com notação crow's foot:

- **1:N (19)** — padrão dominante
- **1:1 (4)** — paciente ↔ obituário, internação ↔ obituário, consulta ↔ pagamento, pagamento ↔ obituário
- **N:N (1)** — prescrição ↔ medicamento via `prescricao_medicamento`

---

## 📌 Destaques Técnicos

- **Coluna gerada**: `obituario.dias_internado` via `GENERATED ALWAYS AS DATEDIFF(...) STORED`
- **ENUM**: tipo sanguíneo, status de quarto, tipo de cirurgia, método de pagamento
- **Chave composta**: `prescricao_medicamento(id_prescricao, id_medicamento)`
- **NULL semântico**: `data_saida = NULL` → ainda internado; `motivo = NULL` → entrada de emergência; `data_resultado = NULL` → exame pendente
- **Regras FK**: `ON DELETE RESTRICT`, `SET NULL` e `CASCADE` conforme a criticidade do vínculo

---

## 📁 Diagrama ERD

Abrir `diagrams/hospital_erd.drawio` em [draw.io](https://app.diagrams.net):
**File → Open from → Device**

---

## 📄 Documentação

`docs/descricao_banco_hospital.docx` — descrição técnica completa com todas as tabelas, campos, cardinalidades e decisões de modelagem.
