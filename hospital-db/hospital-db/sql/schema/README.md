# sql/schema

Contém o script principal do banco de dados.

## hospital_db.sql

Script completo com **CREATE DATABASE**, **CREATE TABLE** e todos os **dados de exemplo**.

### O que é criado

| Etapa | Descrição |
|---|---|
| `CREATE DATABASE` | Cria o banco `hospital` com charset `utf8mb4` |
| 15× `CREATE TABLE` | Todas as tabelas com PKs, FKs, ENUMs e constraints |
| `INSERT` | Dados de exemplo para todas as tabelas |

### Ordem de criação das tabelas

A ordem respeita as dependências de chaves estrangeiras:

```
1.  departamento
2.  medico
3.  funcionario
4.  endereco_paciente
5.  paciente
6.  quarto
7.  consulta
8.  internacao
9.  prescricao
10. medicamento
11. prescricao_medicamento
12. exame
13. cirurgia
14. pagamento
15. obituario
```

### Execução

```bash
mysql -u root -p < sql/schema/hospital_db.sql
# ou dentro do MySQL:
source sql/schema/hospital_db.sql
```
