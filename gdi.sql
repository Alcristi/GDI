CREATE TABLE DIREITOS (
    id NUMBER PRIMARY KEY,
    validade DATE
);

CREATE TABLE PROJETO (
    id NUMBER PRIMARY KEY,
    titulo VARCHAR2(50),
    orcamento NUMBER(12,2),
    estudio VARCHAR2(50),
    idDireitos NUMBER NOT NULL,

    CONSTRAINT fk_projeto_direitos
        FOREIGN KEY (idDireitos)
        REFERENCES Direitos(id),

    CONSTRAINT uq_projeto_direitos UNIQUE (idDireitos)
);

CREATE TABLE PROFISSIONAL (
    id NUMBER PRIMARY KEY,
    nome VARCHAR2(50)
);

CREATE TABLE ATOR (
    idProfissional NUMBER PRIMARY KEY,
    tipo VARCHAR2(50),

    CONSTRAINT fk_ator_prof
        FOREIGN KEY (idProfissional)
        REFERENCES Profissional(id)
);

CREATE TABLE ROTEIRISTA (
    idProfissional NUMBER PRIMARY KEY,
    especialidade VARCHAR2(50),

    CONSTRAINT fk_roteirista_prof
        FOREIGN KEY (idProfissional)
        REFERENCES Profissional(id)
);

CREATE TABLE DIRECAO (
    idProfissional NUMBER PRIMARY KEY,
    cargo VARCHAR2(50),

    CONSTRAINT fk_direcao_prof
        FOREIGN KEY (idProfissional)
        REFERENCES Profissional(id)
);


CREATE TABLE ROTEIRO (
    id_roteirista NUMBER,
    data_criacao DATE,
    conteudo VARCHAR2(50),

    CONSTRAINT pk_roteiro PRIMARY KEY (id_roteirista, data_criacao),

    CONSTRAINT fk_roteiro_roteirista
        FOREIGN KEY (id_roteirista)
        REFERENCES Roteirista(idProfissional)
);

CREATE TABLE ROTEIROFINAL (
    id_roteiro_final NUMBER PRIMARY KEY,
    titulo VARCHAR2(200) NOT NULL,
    descricao VARCHAR2(1000),
    id_projeto NUMBER NOT NULL,
    id_roteirista NUMBER NOT NULL, 
    data_criacao DATE NOT NULL,

    CONSTRAINT fk_rf_projeto
        FOREIGN KEY (id_projeto)
        REFERENCES Projeto(id),

    CONSTRAINT uq_rf_roteirista_data UNIQUE (id_roteirista, data_criacao)
);


CREATE TABLE Revisa (
    IDProfissional NUMBER NOT NULL,
    IDRevisor NUMBER NOT NULL,
    IdRoteiroFinal NUMBER NOT NULL,
    data_revisao DATE DEFAULT SYSDATE, 
    
    CONSTRAINT PK_Revisa PRIMARY KEY (IDProfissional, IDRevisor, IdRoteiroFinal),

    CONSTRAINT FK_Revisa_Roteirista 
        FOREIGN KEY (IDProfissional) 
        REFERENCES Roteirista (IDProfissional),

    CONSTRAINT FK_Revisa_Direcao 
        FOREIGN KEY (IDRevisor) 
        REFERENCES Direcao (idProfissional), -- Corrigido para apontar para a PK de Direcao

    CONSTRAINT FK_Revisa_RoteiroFinal
        FOREIGN KEY (IdRoteiroFinal)
        REFERENCES RoteiroFinal (id_roteiro_final)
);

CREATE TABLE CENA (
    id NUMBER PRIMARY KEY,
    duracao NUMBER,
    idProjeto NUMBER NOT NULL,

    CONSTRAINT fk_cena_projeto
        FOREIGN KEY (idProjeto)
        REFERENCES Projeto(id)
);

CREATE TABLE TRABALHA (
    idProfissional NUMBER,
    idCena NUMBER,

    CONSTRAINT pk_trabalha PRIMARY KEY (idProfissional, idCena),

    CONSTRAINT fk_trabalha_prof
        FOREIGN KEY (idProfissional)
        REFERENCES Profissional(id),

    CONSTRAINT fk_trabalha_cena
        FOREIGN KEY (idCena)
        REFERENCES Cena(id)
);

CREATE TABLE FORNECEDOR (
    cnpj VARCHAR2(18) PRIMARY KEY,
    nome VARCHAR2(50),
    end_rua VARCHAR2(150),
    end_cidade VARCHAR2(100),
    end_numero VARCHAR2(20)
);

CREATE TABLE Contato (
    CNPJ VARCHAR2(18) NOT NULL,
    contato VARCHAR2(100) NOT NULL,
 
    CONSTRAINT FK_Contato_Fornecedor 
        FOREIGN KEY (CNPJ) 
        REFERENCES Fornecedor (CNPJ),
    
    CONSTRAINT PK_Contato PRIMARY KEY (CNPJ, contato)
);

CREATE TABLE EQUIPAMENTO (
    id NUMBER PRIMARY KEY,
    nome VARCHAR2(50)
);

CREATE TABLE CONTRATO (
    idCena NUMBER,
    idEquipamento NUMBER,
    cnpjFornecedor VARCHAR2(18),
    dataUso DATE,

    CONSTRAINT pk_contrato PRIMARY KEY (idEquipamento, idCena, cnpjFornecedor, dataUso),

    CONSTRAINT fk_contrato_cena
        FOREIGN KEY (idCena)
        REFERENCES Cena(id),

    CONSTRAINT fk_contrato_equip
        FOREIGN KEY (idEquipamento)
        REFERENCES Equipamento(id),

    CONSTRAINT fk_contrato_fornecedor
        FOREIGN KEY (cnpjFornecedor)
        REFERENCES Fornecedor(cnpj)
);



INSERT INTO Direitos (id, validade) VALUES (1, DATE '2026-12-31');
INSERT INTO Direitos (id, validade) VALUES (2, DATE '2027-06-30');

INSERT INTO Projeto (id, titulo, orcamento, estudio, idDireitos)
VALUES (1, 'Projeto Aurora', 500000, 'Estúdio Sol', 1);

INSERT INTO Projeto (id, titulo, orcamento, estudio, idDireitos)
VALUES (2, 'Projeto Eclipse', 300000, 'Estúdio Lua', 2);

INSERT INTO Profissional (id, nome) VALUES (1, 'Ana Costa');
INSERT INTO Profissional (id, nome) VALUES (2, 'Bruno Silva');
INSERT INTO Profissional (id, nome) VALUES (3, 'Carla Souza');
INSERT INTO Profissional (id, nome) VALUES (4, 'Daniel Rocha');
INSERT INTO Profissional (id, nome) VALUES (5, 'Eduarda Lima');

INSERT INTO ATOR (idProfissional, tipo) VALUES (1, 'Protagonista');
INSERT INTO ATOR (idProfissional, tipo) VALUES (2, 'Coadjuvante');

INSERT INTO ROTEIRISTA (idProfissional, especialidade) VALUES (3, 'Drama');
INSERT INTO ROTEIRISTA (idProfissional, especialidade) VALUES (4, 'Ação');

INSERT INTO DIRECAO (idProfissional, cargo) VALUES (5, 'Diretor Geral');

-- ATUALIZADO: Inserts de ROTEIRO sem o id_revisor (apenas 3 valores)
INSERT INTO Roteiro (id_roteirista, data_criacao, conteudo)
VALUES (3, DATE '2024-01-10', 'Primeira versão do roteiro');

INSERT INTO Roteiro (id_roteirista, data_criacao, conteudo)
VALUES (4, DATE '2024-02-15', 'Roteiro revisado para ação');

INSERT INTO RoteiroFinal (id_roteiro_final, titulo, descricao, id_projeto, id_roteirista, data_criacao)
VALUES (1, 'Roteiro Final Aurora', 'Versão final aprovada', 1, 3, DATE '2024-01-10');

INSERT INTO RoteiroFinal (id_roteiro_final, titulo, descricao, id_projeto, id_roteirista, data_criacao)
VALUES (2, 'Roteiro Final Eclipse', 'Roteiro definitivo', 2, 4, DATE '2024-02-15');

-- Inserts necessários para a tabela Revisa
INSERT INTO Revisa (IDProfissional, IDRevisor, IdRoteiroFinal, data_revisao) VALUES (3, 5, 1, DATE '2024-01-20');
INSERT INTO Revisa (IDProfissional, IDRevisor, IdRoteiroFinal, data_revisao) VALUES (4, 5, 2, DATE '2024-02-20');

INSERT INTO CENA (id, duracao, idProjeto) VALUES (1, 120, 1);
INSERT INTO CENA (id, duracao, idProjeto) VALUES (2, 90, 1);
INSERT INTO CENA (id, duracao, idProjeto) VALUES (3, 110, 2);

INSERT INTO Trabalha (idProfissional, idCena) VALUES (1, 1);
INSERT INTO Trabalha (idProfissional, idCena) VALUES (2, 1);
INSERT INTO Trabalha (idProfissional, idCena) VALUES (1, 2);
INSERT INTO Trabalha (idProfissional, idCena) VALUES (3, 3);
INSERT INTO Trabalha (idProfissional, idCena) VALUES (5, 1); 

INSERT INTO Fornecedor (cnpj, nome) VALUES ('11.111.111/0001-11', 'TechFilm');
INSERT INTO Fornecedor (cnpj, nome) VALUES ('22.222.222/0001-22', 'CineEquip');


INSERT INTO Contato (CNPJ, contato) VALUES ('11.111.111/0001-11', 'comercial@techfilm.com');
INSERT INTO Contato (CNPJ, contato) VALUES ('22.222.222/0001-22', 'vendas@cineequip.com');

INSERT INTO Equipamento (id, nome) VALUES (1, 'Câmera 4K');
INSERT INTO Equipamento (id, nome) VALUES (2, 'Iluminação LED');
INSERT INTO Equipamento (id, nome) VALUES (3, 'Microfone Direcional');

INSERT INTO Contrato (idCena, idEquipamento, cnpjFornecedor, dataUso)
VALUES (1, 1, '11.111.111/0001-11', DATE '2024-03-01');

INSERT INTO Contrato (idCena, idEquipamento, cnpjFornecedor, dataUso)
VALUES (1, 2, '11.111.111/0001-11', DATE '2024-03-01');

INSERT INTO Contrato (idCena, idEquipamento, cnpjFornecedor, dataUso)
VALUES (2, 3, '22.222.222/0001-22', DATE '2024-03-05');

INSERT INTO Contrato (idCena, idEquipamento, cnpjFornecedor, dataUso)
VALUES (3, 2, '22.222.222/0001-22', DATE '2024-03-10');


--Query

-- Junção interna
SELECT P.TITULO, P.ORCAMENTO, D.VALIDADE FROM DIREITOS D INNER JOIN PROJETO P ON (D.ID = P.IDDIREITOS);

-- Junção externa
SELECT P.NOME, C.ID FROM PROFISSIONAL P LEFT JOIN TRABALHA T ON (P.ID = T.IDPROFISSIONAL)
INNER JOIN CENA C ON (T.IDCENA = C.ID);

-- Anti Junção
SELECT E.nome
FROM EQUIPAMENTO E
WHERE NOT EXISTS (
    SELECT 1
    FROM CONTRATO C 
    WHERE C.IDEQUIPAMENTO = E.ID
);

-- Semi Junção
SELECT c.ID
FROM CENA c
WHERE EXISTS (
    SELECT 1
    FROM CONTRATO CO 
    INNER JOIN EQUIPAMENTO E ON (CO.IDEQUIPAMENTO = E.ID)
    WHERE CO.IDCENA = c.ID
    AND E.NOME = 'Microfone Direcional'
);

-- Sub consulta tabela
SELECT *
FROM FORNECEDOR
WHERE CNPJ IN (
    SELECT DISTINCT C.CNPJFORNECEDOR
    FROM CONTRATO C
    INNER JOIN EQUIPAMENTO E ON C.idEquipamento = E.id
);

-- Sub consulta linha (ajustada para um valor que existe nos inserts)
SELECT E.nome, C.idCena
FROM EQUIPAMENTO E
INNER JOIN CONTRATO C
       ON E.id = C.idEquipamento
WHERE (C.cnpjFornecedor, C.dataUso) =
      (SELECT C1.cnpjFornecedor, C1.dataUso
       FROM CONTRATO C1
       WHERE C1.cnpjFornecedor = '11.111.111/0001-11'
         AND C1.dataUso = DATE '2024-03-01');

-- Consulta com Having e Group by
SELECT E.NOME, COUNT(C.dataUso) AS dias_usados
FROM CONTRATO C INNER JOIN EQUIPAMENTO E ON (C.IDEQUIPAMENTO = E.ID)
GROUP BY E.NOME
HAVING COUNT(C.dataUso) >= 1;

-- Procedure
CREATE OR REPLACE PROCEDURE AjustarOrcamentoProjeto (
    p_id_projeto IN NUMBER,
    p_percentual IN NUMBER
) 
IS 
BEGIN
    UPDATE PROJETO
    SET orcamento = orcamento + (orcamento * p_percentual / 100)
    WHERE id = p_id_projeto;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END AjustarOrcamentoProjeto;
