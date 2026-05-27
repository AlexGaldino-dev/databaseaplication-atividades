# sql/data

Scripts de dados complementares, separados do schema principal.

## obituario.sql

Contém os **7 INSERTs** de óbitos na tabela `obituario`, mais 3 consultas de verificação:

1. **Visão completa** — JOIN com paciente, médico e quarto
2. **Estatísticas** — total de óbitos, média de dias internado, soma e média de despesas
3. **Agrupamento por causa** — óbitos categorizados por tipo (trauma, queimadura, envenenamento, TCR)

### Pré-requisito

O script `sql/schema/hospital_db.sql` deve ser executado antes, pois este script depende das tabelas e dos dados de internação já criados.

```bash
# Executar após o schema principal
source sql/data/obituario.sql
```

### Pacientes que NÃO constam no obituário

Os 3 primeiros pacientes graves estão internados em UTI com `data_saida = NULL` e **não vieram a óbito**:

| id | Nome | Diagnóstico |
|---|---|---|
| 4 | Ana Luiza Souza | Politraumatismo — TCE moderado |
| 7 | Diego Cavalcanti | Queimaduras de 3° grau — 45% SCQ |
| 12 | Isabela Cunha | Envenenamento por organofosforado |
