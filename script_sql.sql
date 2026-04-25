CREATE DATABASE IF NOT EXISTS controle_financeiro
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE controle_financeiro;

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE conta (
    id_conta INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nome_conta VARCHAR(100) NOT NULL,
    tipo_conta ENUM('corrente','poupanca','carteira') NOT NULL,
    saldo_inicial DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nome_categoria VARCHAR(100) NOT NULL,
    tipo ENUM('receita','despesa') NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE transacao (
    id_transacao INT AUTO_INCREMENT PRIMARY KEY,
    id_conta INT NOT NULL,
    id_categoria INT NOT NULL,
    descricao VARCHAR(255),
    valor DECIMAL(10,2) NOT NULL,
    data_transacao DATE NOT NULL,
    tipo ENUM('receita','despesa') NOT NULL,
    FOREIGN KEY (id_conta) REFERENCES conta(id_conta) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) ON DELETE RESTRICT
);

CREATE TABLE orcamento (
    id_orcamento INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_categoria INT NOT NULL,
    valor_limite DECIMAL(10,2) NOT NULL,
    mes_referencia DATE NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) ON DELETE CASCADE,
    UNIQUE KEY uk_orcamento (id_usuario, id_categoria, mes_referencia)
);

-- Dados de exemplo
INSERT INTO usuario (nome, email, senha) VALUES ('Joao Silva', 'joao@email.com', 'hash_senha_123');

INSERT INTO conta (id_usuario, nome_conta, tipo_conta, saldo_inicial) VALUES
(1, 'Conta Corrente Banco X', 'corrente', 5000.00),
(1, 'Poupanca', 'poupanca', 10000.00);

INSERT INTO categoria (id_usuario, nome_categoria, tipo) VALUES
(1, 'Salario', 'receita'),
(1, 'Alimentacao', 'despesa'),
(1, 'Transporte', 'despesa'),
(1, 'Lazer', 'despesa');

INSERT INTO transacao (id_conta, id_categoria, descricao, valor, data_transacao, tipo) VALUES
(1, 1, 'Salario mensal', 5000.00, '2025-04-05', 'receita'),
(1, 2, 'Supermercado', 450.00, '2025-04-10', 'despesa'),
(1, 3, 'Gasolina', 200.00, '2025-04-12', 'despesa'),
(1, 4, 'Cinema', 80.00, '2025-04-13', 'despesa');

INSERT INTO orcamento (id_usuario, id_categoria, valor_limite, mes_referencia) VALUES
(1, 2, 600.00, '2025-04-01'),
(1, 3, 300.00, '2025-04-01'),
(1, 4, 200.00, '2025-04-01');
