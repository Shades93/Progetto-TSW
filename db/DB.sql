DROP DATABASE IF EXISTS terapia;
CREATE DATABASE terapia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE terapia;


CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(100) NOT NULL UNIQUE,
    descrizione TEXT
) ENGINE=InnoDB;


CREATE TABLE utente (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password CHAR(128) NOT NULL,
    telefono VARCHAR(20),
    is_admin BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB;


CREATE TABLE indirizzo (
    id_indirizzo INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    via VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    citta VARCHAR(100) NOT NULL,
    cap CHAR(5) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES utente(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE te (
    id_te INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome_te VARCHAR(150) NOT NULL,
    descrizione TEXT,
    prezzo DECIMAL(10, 2) NOT NULL CHECK (prezzo > 0),
    iva DECIMAL(4, 2) NOT NULL DEFAULT 22.00 CHECK (iva >= 0),
    quantita_disponibile INT NOT NULL DEFAULT 0 CHECK (quantita_disponibile >= 0),
    peso DECIMAL(6, 2), -- in grammi
    provenienza VARCHAR(100),
    immagine VARCHAR(255) DEFAULT 'default.jpg',
    attivo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
        ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE ordine (
    id_ordine INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    data DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    totale DECIMAL(10, 2) NOT NULL CHECK (totale >= 0),
    totale_iva DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (totale_iva >= 0),
    stato VARCHAR(50) NOT NULL DEFAULT 'In elaborazione',
    indirizzo_spedizione VARCHAR(255) NOT NULL,
    metodo_pagamento VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES utente(user_id)
        ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE dettaglio_ordine (
    id_ordine INT NOT NULL,
    id_te INT NOT NULL,
    quantita INT NOT NULL CHECK (quantita > 0),
    prezzo_storico DECIMAL(10, 2) NOT NULL CHECK (prezzo_storico > 0),
    iva_storica DECIMAL(4, 2) NOT NULL CHECK (iva_storica >= 0),
    PRIMARY KEY (id_ordine, id_te),
    FOREIGN KEY (id_ordine) REFERENCES ordine(id_ordine)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_te) REFERENCES te(id_te)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
