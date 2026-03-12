CREATE DATABASE agendabd;
USE agendabd;

CREATE TABLE contato (
  ID_cont INT PRIMARY KEY AUTO_INCREMENT,
  NOME VARCHAR(100) NOT NULL,
  SOBRENOME VARCHAR(100),
  DATA_NASCIMENTO DATE
);

CREATE TABLE telefone (
  ID_tel INT PRIMARY KEY AUTO_INCREMENT,
  NUMERO VARCHAR(20) NOT NULL,
  TIPO VARCHAR(20) NOT NULL,
  ID_cont INT,
  FOREIGN KEY (ID_cont) REFERENCES contato(ID_cont)
);

CREATE TABLE email (
  ID_ema INT PRIMARY KEY AUTO_INCREMENT,
  ENDERECO VARCHAR(100) NOT NULL,
  TIPO VARCHAR(20) NOT NULL,
  ID_cont INT,
  FOREIGN KEY (ID_cont) REFERENCES contato(ID_cont)
);

INSERT INTO contato (NOME, SOBRENOME, DATA_NASCIMENTO) VALUES
('Ana','Silva','1995-03-12'),
('Bruno','Oliveira','1990-07-21'),
('Carlos','Souza','1988-11-05'),
('Daniela','Costa','1992-01-30'),
('Eduardo','Pereira','1998-09-14'),
('Fernanda','Rodrigues','1994-04-18'),
('Gabriel','Almeida','1996-12-02'),
('Helena','Nascimento','1991-06-25'),
('Igor','Lima','1989-08-09'),
('Juliana','Araújo','1993-10-11'),
('Kleber','Fernandes','1990-05-07'),
('Larissa','Carvalho','1997-02-16'),
('Marcelo','Gomes','1987-03-28'),
('Natália','Martins','1995-11-19'),
('Otávio','Rocha','1992-07-03'),
('Patrícia','Barbosa','1996-09-22'),
('Rafael','Ribeiro','1994-12-15'),
('Sabrina','Freitas','1991-04-01'),
('Thiago','Batista','1988-06-17'),
('Vanessa','Teixeira','1993-08-29'),
('William','Correia','1990-10-13'),
('Yasmin','Monteiro','1998-01-05'),
('Zeca','Moraes','1986-02-20'),
('Aline','Duarte','1997-05-31'),
('Beto','Cavalcanti','1992-09-09'),
('Caio','Peixoto','1994-03-14'),
('Debora','Farias','1991-07-27'),
('Elisa','Queiroz','1996-11-30'),
('Felipe','Sales','1989-12-12'),
('Gustavo','Pinto','1993-01-19'),
('Hugo','Torres','1995-04-23'),
('Isabela','Vasconcelos','1997-06-08'),
('João','Andrade','1990-09-15'),
('Karina','Meireles','1992-02-11'),
('Leandro','Bezerra','1988-05-20'),
('Mariana','Aguiar','1996-08-01'),
('Nicolas','Lacerda','1994-10-06'),
('Olivia','Borges','1993-12-18'),
('Paulo','Campos','1991-01-29'),
('Renata','Rezende','1995-03-09'),
('Sergio','Braga','1987-07-07'),
('Tatiane','Ferraz','1998-04-16'),
('Ubiratan','Vieira','1989-09-24'),
('Valeria','Guimarães','1990-11-02'),
('Wagner','Pacheco','1992-06-14'),
('Xavier','Tavares','1986-08-30'),
('Yuri','Bittencourt','1994-02-03'),
('Zilda','Prado','1997-12-27'),
('André','Paiva','1993-05-12'),
('Bianca','Nogueira','1996-07-19');

INSERT INTO telefone (NUMERO, TIPO, ID_cont) VALUES
('81999990001','Celular',1),
('81999990002','Celular',2),
('8133330003','Residencial',3),
('8133330004','Comercial',4),
('81988880005','Celular',5),
('81988880006','Celular',6),
('81332220007','Residencial',7),
('81332220008','Comercial',8),
('81977770009','Celular',9),
('81977770010','Celular',10),
('81331110011','Residencial',11),
('81331110012','Comercial',12),
('81966660013','Celular',13),
('81966660014','Celular',14),
('81330000015','Residencial',15),
('81330000016','Comercial',16),
('81955550017','Celular',17),
('81955550018','Celular',18),
('81334440019','Residencial',19),
('81334440020','Comercial',20),
('81944440021','Celular',21),
('81944440022','Celular',22),
('81335550023','Residencial',23),
('81335550024','Comercial',24),
('81933330025','Celular',25),
('81933330026','Celular',26),
('81336660027','Residencial',27),
('81336660028','Comercial',28),
('81922220029','Celular',29),
('81922220030','Celular',30),
('81337770031','Residencial',31),
('81337770032','Comercial',32),
('81911110033','Celular',33),
('81911110034','Celular',34),
('81338880035','Residencial',35),
('81338880036','Comercial',36),
('81900000037','Celular',37),
('81900000038','Celular',38),
('81339990039','Residencial',39),
('81339990040','Comercial',40),
('81888880041','Celular',41),
('81888880042','Celular',42),
('81330010043','Residencial',43),
('81330010044','Comercial',44),
('81877770045','Celular',45),
('81877770046','Celular',46),
('81330020047','Residencial',47),
('81330020048','Comercial',48),
('81866660049','Celular',49),
('81866660050','Celular',50);

INSERT INTO email (ENDERECO, TIPO, ID_cont) VALUES
('ana.silva@email.com','Pessoal',1),
('bruno.oliveira@email.com','Pessoal',2),
('carlos.souza@email.com','Trabalho',3),
('daniela.costa@email.com','Pessoal',4),
('eduardo.pereira@email.com','Trabalho',5),
('fernanda.rodrigues@email.com','Pessoal',6),
('gabriel.almeida@email.com','Trabalho',7),
('helena.nascimento@email.com','Pessoal',8),
('igor.lima@email.com','Trabalho',9),
('juliana.araujo@email.com','Pessoal',10),
('kleber.fernandes@email.com','Trabalho',11),
('larissa.carvalho@email.com','Pessoal',12),
('marcelo.gomes@email.com','Trabalho',13),
('natalia.martins@email.com','Pessoal',14),
('otavio.rocha@email.com','Trabalho',15),
('patricia.barbosa@email.com','Pessoal',16),
('rafael.ribeiro@email.com','Trabalho',17),
('sabrina.freitas@email.com','Pessoal',18),
('thiago.batista@email.com','Trabalho',19),
('vanessa.teixeira@email.com','Pessoal',20),
('william.correia@email.com','Trabalho',21),
('yasmin.monteiro@email.com','Pessoal',22),
('zeca.moraes@email.com','Trabalho',23),
('aline.duarte@email.com','Pessoal',24),
('beto.cavalcanti@email.com','Trabalho',25),
('caio.peixoto@email.com','Pessoal',26),
('debora.farias@email.com','Trabalho',27),
('elisa.queiroz@email.com','Pessoal',28),
('felipe.sales@email.com','Trabalho',29),
('gustavo.pinto@email.com','Pessoal',30),
('hugo.torres@email.com','Trabalho',31);


SELECT COUNT(*) AS total_emails FROM email;

SELECT c.ID_cont, c.NOME, c.SOBRENOME, t.NUMERO
FROM contato c
INNER JOIN telefone t ON c.ID_cont = t.ID_cont;

SELECT c.ID_cont, c.NOME, c.SOBRENOME, t.NUMERO
FROM contato c
LEFT JOIN telefone t ON c.ID_cont = t.ID_cont;

SELECT c.ID_cont, c.NOME, c.SOBRENOME, t.NUMERO
FROM contato c
RIGHT JOIN telefone t ON c.ID_cont = t.ID_cont;

SELECT c.ID_cont, c.NOME, c.SOBRENOME, t.NUMERO
FROM contato c
CROSS JOIN telefone t;

CREATE FUNCTION fn_valor (a DECIMAL(10,2), b INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
RETURN a * b;

SELECT fn_valor(2.5,4) AS RESULTADO;

CREATE TABLE salario (
  Id INT PRIMARY KEY AUTO_INCREMENT,
  salario DECIMAL(10,2)
);

INSERT INTO salario (salario) VALUES (100), (200), (300);

SELECT salario, fn_valor(salario,4) AS NOVO_SALARIO
FROM salario WHERE Id = 3;

CREATE PROCEDURE verSalario (varValor INT)
SELECT CONCAT('Os salários são: ', salario) AS Novo_Salario
FROM salario
WHERE Id = varValor;

CALL verSalario(2);

CREATE INDEX idx_nome ON contato(NOME);

SHOW INDEX FROM contato;

/* Resumidamente, alterei a ordem de alguns comandos para que o banco de dados funcionasse normalmente,
além de concertar os joins e a função que estava sendo criada. Removi as linhas de comentário só pra não ficar muito redundante.
*/