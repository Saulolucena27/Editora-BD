-- =============================================
-- CRIAÇÃO DO BANCO DE DADOS E TABELAS
-- =============================================

CREATE DATABASE  IF NOT EXISTS `editora` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `editora`;

-- Tabela de áreas de conhecimento
DROP TABLE IF EXISTS `areasconhecimento`;
CREATE TABLE `areasconhecimento` (
  `cod_area` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) NOT NULL,
  PRIMARY KEY (`cod_area`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de autores
DROP TABLE IF EXISTS `autores`;
CREATE TABLE `autores` (
  `cod_autor` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `biografia` text,
  `nacionalidade` varchar(50) DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  PRIMARY KEY (`cod_autor`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de clientes
DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes` (
  `cod_cliente` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `endereco` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`cod_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de departamentos
DROP TABLE IF EXISTS `departamentos`;
CREATE TABLE `departamentos` (
  `cod_departamento` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `responsavel` varchar(100) DEFAULT NULL,
  `descricao` text,
  PRIMARY KEY (`cod_departamento`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de livros
DROP TABLE IF EXISTS `livros`;
CREATE TABLE `livros` (
  `isbn` varchar(20) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `data_publicacao` date DEFAULT NULL,
  `genero` varchar(50) DEFAULT NULL,
  `num_paginas` int DEFAULT NULL,
  `descricao` text,
  `cod_area` int DEFAULT NULL,
  PRIMARY KEY (`isbn`),
  KEY `cod_area` (`cod_area`),
  KEY `idx_livros_titulo` (`titulo`),
  CONSTRAINT `livros_ibfk_1` FOREIGN KEY (`cod_area`) REFERENCES `areasconhecimento` (`cod_area`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de palavras-chave
DROP TABLE IF EXISTS `palavraschave`;
CREATE TABLE `palavraschave` (
  `cod_palavra` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) NOT NULL,
  PRIMARY KEY (`cod_palavra`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de funcionários
DROP TABLE IF EXISTS `funcionarios`;
CREATE TABLE `funcionarios` (
  `cod_funcionario` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cargo` varchar(50) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `endereco` varchar(200) DEFAULT NULL,
  `cod_departamento` int DEFAULT NULL,
  PRIMARY KEY (`cod_funcionario`),
  KEY `cod_departamento` (`cod_departamento`),
  CONSTRAINT `funcionarios_ibfk_1` FOREIGN KEY (`cod_departamento`) REFERENCES `departamentos` (`cod_departamento`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de exemplares
DROP TABLE IF EXISTS `exemplares`;
CREATE TABLE `exemplares` (
  `num_serie` varchar(50) NOT NULL,
  `isbn` varchar(20) NOT NULL,
  `estado` enum('disponível','reservado','danificado','vendido') NOT NULL DEFAULT 'disponível',
  `localizacao` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`num_serie`),
  KEY `isbn` (`isbn`),
  CONSTRAINT `exemplares_ibfk_1` FOREIGN KEY (`isbn`) REFERENCES `livros` (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de pedidos
DROP TABLE IF EXISTS `pedidos`;
CREATE TABLE `pedidos` (
  `cod_pedido` int NOT NULL AUTO_INCREMENT,
  `cod_cliente` int NOT NULL,
  `data_pedido` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pendente','processando','enviado','entregue','cancelado') NOT NULL DEFAULT 'pendente',
  `forma_pagamento` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cod_pedido`),
  KEY `cod_cliente` (`cod_cliente`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`cod_cliente`) REFERENCES `clientes` (`cod_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de itens pedido
DROP TABLE IF EXISTS `itenspedido`;
CREATE TABLE `itenspedido` (
  `cod_pedido` int NOT NULL,
  `num_serie` varchar(50) NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL,
  `quantidade` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`cod_pedido`,`num_serie`),
  KEY `num_serie` (`num_serie`),
  CONSTRAINT `itenspedido_ibfk_1` FOREIGN KEY (`cod_pedido`) REFERENCES `pedidos` (`cod_pedido`),
  CONSTRAINT `itenspedido_ibfk_2` FOREIGN KEY (`num_serie`) REFERENCES `exemplares` (`num_serie`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de livros e autores (N:M)
DROP TABLE IF EXISTS `livrosautores`;
CREATE TABLE `livrosautores` (
  `isbn` varchar(20) NOT NULL,
  `cod_autor` int NOT NULL,
  PRIMARY KEY (`isbn`,`cod_autor`),
  KEY `cod_autor` (`cod_autor`),
  CONSTRAINT `livrosautores_ibfk_1` FOREIGN KEY (`isbn`) REFERENCES `livros` (`isbn`),
  CONSTRAINT `livrosautores_ibfk_2` FOREIGN KEY (`cod_autor`) REFERENCES `autores` (`cod_autor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de livros e palavras-chave (N:M)
DROP TABLE IF EXISTS `livrospalavraschave`;
CREATE TABLE `livrospalavraschave` (
  `isbn` varchar(20) NOT NULL,  
  `cod_palavra` int NOT NULL,
  PRIMARY KEY (`isbn`,`cod_palavra`),
  KEY `cod_palavra` (`cod_palavra`),
  CONSTRAINT `livrospalavraschave_ibfk_1` FOREIGN KEY (`isbn`) REFERENCES `livros` (`isbn`),
  CONSTRAINT `livrospalavraschave_ibfk_2` FOREIGN KEY (`cod_palavra`) REFERENCES `palavraschave` (`cod_palavra`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;