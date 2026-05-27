# sql/queries

Consultas demonstrativas que exploram os dados do banco.

## consultas_hospital.sql

Consultas organizadas em 6 blocos:

| Bloco | Tipo | Descrição |
|---|---|---|
| 1 | `SELECT + WHERE` | Pacientes com alta, ainda internados, tipo sanguíneo O- e contagens via `UNION ALL` |
| 2 | `INNER JOIN` | Pacientes × consultas, prescrições × medicamentos, cirurgias, médicos × departamentos |
| 3 | `LEFT JOIN` | Todos os pacientes (com ou sem consulta), consultas sem pagamento, médicos sem cirurgia |
| 4 | `RIGHT JOIN` | Todos os pagamentos e exames, mesmo sem consulta vinculada |
| 5 | `CROSS JOIN` | Grade departamento × tipo de quarto; médico × departamento |
| 6 | `FULL JOIN` | Simulado com `LEFT JOIN UNION RIGHT JOIN` (MySQL não tem `FULL OUTER JOIN` nativo) |

## atendimentos_por_medico.sql

Consultas que retornam quantos pacientes cada médico atendeu em intervalos de 3 dias.

| Período | Datas | Perfil |
|---|---|---|
| 1 | 22–24/jun/2024 | Pico de consultas regulares |
| 2 | 01–03/jun/2024 | Início das internações graves |
| 3 | 06–08/jul/2024 | Mix de casos graves e regulares |

Inclui também uma **visão comparativa** com agregação condicional (`SUM(CASE WHEN ... THEN 1 ELSE 0 END)`) mostrando os 3 períodos em colunas lado a lado.
