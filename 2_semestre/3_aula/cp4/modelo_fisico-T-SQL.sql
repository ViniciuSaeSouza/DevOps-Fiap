/*
    Laura de Oliveira Cintra - RM558843
    Maria Eduarda Alves da Paixao - RM558832
    Vinicius Saes de Souza - RM554456
*/

CREATE TABLE tbl_pais (
    id_pais INT IDENTITY(1,1),
    nome_pais VARCHAR(50) NOT NULL,
    CONSTRAINT pk_pais PRIMARY KEY (id_pais),
    CONSTRAINT unq_nome_pais UNIQUE (nome_pais)
);

CREATE TABLE tbl_estado (
    id_estado INT IDENTITY(1,1),
    nome_estado VARCHAR(50) NOT NULL,
    id_pais INT NOT NULL,
    CONSTRAINT pk_estado PRIMARY KEY (id_estado),
    CONSTRAINT unq_nome_estado UNIQUE (nome_estado),
    CONSTRAINT fk_estado_pais FOREIGN KEY (id_pais) REFERENCES tbl_pais(id_pais)
);

CREATE TABLE tbl_cidade (
    id_cidade INT IDENTITY(1,1),
    nome_cidade VARCHAR(50) NOT NULL,
    id_estado INT NOT NULL,
    CONSTRAINT pk_cidade PRIMARY KEY (id_cidade),
    CONSTRAINT unq_nome_cidade UNIQUE (nome_cidade),
    CONSTRAINT fk_cidade_estado FOREIGN KEY (id_estado) REFERENCES tbl_estado(id_estado)
);

CREATE TABLE tbl_usuario (
    id_usuario INT IDENTITY(1,1),
    nome VARCHAR(80) NOT NULL,
    email VARCHAR(255) NOT NULL, 
    senha VARCHAR(200) NOT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT unq_email_usuario UNIQUE (email) 
);

CREATE TABLE tbl_unidade (
    id_unidade INT IDENTITY(1,1),
    nome VARCHAR(80) NOT NULL,
    capacidade_total_litros INT NOT NULL, 
    data_cadastro DATETIME DEFAULT GETDATE(),
    id_usuario INT NOT NULL,
    CONSTRAINT pk_unidade PRIMARY KEY (id_unidade),
    CONSTRAINT fk_unidade_usuario FOREIGN KEY (id_usuario) REFERENCES tbl_usuario(id_usuario)
);


CREATE TABLE tbl_endereco (
    id_endereco INT IDENTITY(1,1),
    logradouro VARCHAR(50) NOT NULL,
    numero INT NOT NULL,
    complemento VARCHAR(50),
    cep VARCHAR(8) NOT NULL,
    id_cidade INT NOT NULL,
    id_unidade INT NOT NULL,
    CONSTRAINT pk_endereco PRIMARY KEY (id_endereco),
    CONSTRAINT fk_endereco_cidade FOREIGN KEY (id_cidade) REFERENCES tbl_cidade(id_cidade),
    CONSTRAINT fk_endereco_unidade FOREIGN KEY (id_unidade) REFERENCES tbl_unidade(id_unidade)
);

CREATE TABLE tbl_reservatorio (
    id_reservatorio INT IDENTITY(1,1),
    nome VARCHAR(80) NOT NULL,
    capacidade_total_litros INT NOT NULL,
    data_instalacao DATETIME DEFAULT GETDATE(),
    id_unidade INT NOT NULL,
    CONSTRAINT pk_reservatorio PRIMARY KEY (id_reservatorio),
    CONSTRAINT fk_reservatorio_unidade FOREIGN KEY (id_unidade) REFERENCES tbl_unidade(id_unidade)
);

CREATE TABLE tbl_status_reservatorio (
    id_status_reservatorio INT IDENTITY(1,1),
    status VARCHAR(40) NOT NULL,
    CONSTRAINT pk_status_reservatorio PRIMARY KEY (id_status_reservatorio)
);

CREATE TABLE tbl_historico_reservatorio (
    id_historico INT IDENTITY(1,1),
    nivel_litros INT NOT NULL,
    data_hora DATETIME DEFAULT GETDATE(),
    id_reservatorio INT NOT NULL,
    id_status_reservatorio INT NOT NULL,
    CONSTRAINT pk_historico_reservatorio PRIMARY KEY (id_historico),
    CONSTRAINT fk_hist_reservatorio FOREIGN KEY (id_reservatorio) REFERENCES tbl_reservatorio(id_reservatorio),
    CONSTRAINT fk_hist_status FOREIGN KEY (id_status_reservatorio) REFERENCES tbl_status_reservatorio(id_status_reservatorio)
);

-- Dispositivo (esp32) e sensores
CREATE TABLE tbl_dispositivo (
    id_dispositivo INT IDENTITY(1,1),
    data_instalacao DATETIME DEFAULT GETDATE() NOT NULL,
    CONSTRAINT pk_dispositivo PRIMARY KEY (id_dispositivo)
);

CREATE TABLE tbl_reservatorio_dispositivo (
    id_reservatorio_dispositivo INT IDENTITY(1,1),
    data_instalacao DATETIME DEFAULT GETDATE(), 
    data_remocao DATE,   
    id_dispositivo INT NOT NULL,
    id_reservatorio INT NOT NULL,
    CONSTRAINT pk_reservatorio_dispositivo PRIMARY KEY (id_reservatorio_dispositivo),
    CONSTRAINT fk_reservatorio FOREIGN KEY (id_reservatorio) REFERENCES tbl_reservatorio(id_reservatorio),
    CONSTRAINT fk_dispositivo FOREIGN KEY (id_dispositivo) REFERENCES tbl_dispositivo(id_dispositivo)
);

CREATE TABLE tbl_leitura_dispositivo (
    id_leitura INT IDENTITY(1,1),
    nivel_pct INT NOT NULL,
    turbidez_ntu INT NOT NULL,
    ph_int DECIMAL(4,2) NOT NULL,
    data_hora DATETIME DEFAULT GETDATE(),
    id_dispositivo INT NOT NULL,
    CONSTRAINT pk_leitura PRIMARY KEY (id_leitura),
    CONSTRAINT fk_leitura_dispositivo FOREIGN KEY (id_dispositivo) REFERENCES tbl_dispositivo(id_dispositivo)
);

-- Clima e alertas

CREATE TABLE tbl_clima_resumo_sem (
    id_clima_resumo INT IDENTITY(1,1),
    data_hora_resumo DATETIME DEFAULT GETDATE(),
    media_chance_chuva DECIMAL(5,2) NOT NULL,
    media_temperatura_max DECIMAL(5,2) NOT NULL,
    media_temperatura_min DECIMAL(5,2) NOT NULL,
    id_cidade INT NOT NULL,
    CONSTRAINT pk_clima_resumo PRIMARY KEY (id_clima_resumo),
    CONSTRAINT fk_clima_cidade FOREIGN KEY (id_cidade) REFERENCES tbl_cidade(id_cidade)
);

CREATE TABLE tbl_status_alerta (
    id_status_alerta INT IDENTITY(1,1),
    status VARCHAR(80) NOT NULL,
    CONSTRAINT pk_status_alerta PRIMARY KEY (id_status_alerta)
);

CREATE TABLE tbl_alerta (
    id_alerta INT IDENTITY(1,1),
    mensagem VARCHAR(200) NOT NULL,
    data_hora_envio DATETIME DEFAULT GETDATE(),
    id_reservatorio INT NOT NULL,
    id_status_alerta INT NOT NULL, 
    CONSTRAINT pk_alerta PRIMARY KEY (id_alerta),
    CONSTRAINT fk_alerta_reservatorio FOREIGN KEY (id_reservatorio) REFERENCES tbl_reservatorio(id_reservatorio),
    CONSTRAINT fk_alerta_status FOREIGN KEY (id_status_alerta) REFERENCES tbl_status_alerta(id_status_alerta)
);
