-- ==========================================================
-- DATI INIZIALI DI TEST (MOCK DATA)
-- ==========================================================

-- Categorie
INSERT INTO categoria (nome_categoria, descrizione) VALUES
('Tè Verde', 'Tè non fermentati ricchi di antiossidanti'),
('Tè Nero', 'Tè completamente ossidati dal sapore deciso'),
('Matcha', 'Il matcha è ricco di vitamine, minerali, polifenoli ed è il tè con la maggior percentuale di antiossidanti!');

-- Utenti di prova
-- Password per entrambi: "Password123!"
-- Hash SHA-512 generato:
-- c8837b23ff8aaa8a2dde915473ce099131ff73f512f6da269a5386600241dd707475c742c3886f4a217aa7be29393a54d5d90956b629fd61dfb689a744cb89bb
INSERT INTO utente (nome, cognome, email, password, telefono, is_admin) VALUES
('Admin', 'Shop', 'admin@teatime.it', 'c8837b23ff8aaa8a2dde915473ce099131ff73f512f6da269a5386600241dd707475c742c3886f4a217aa7be29393a54d5d90956b629fd61dfb689a744cb89bb', '0891234567', TRUE),
('Mario', 'Rossi', 'mario.rossi@email.it', 'c8837b23ff8aaa8a2dde915473ce099131ff73f512f6da269a5386600241dd707475c742c3886f4a217aa7be29393a54d5d90956b629fd61dfb689a744cb89bb', '3401234567', FALSE);

-- Indirizzo
INSERT INTO indirizzo (user_id, via, numero, citta, cap) VALUES
(2, 'Via Giovanni Paolo II', '132', 'Fisciano', '84084');

-- Prodotti
INSERT INTO te (id_categoria, nome_te, descrizione, prezzo, iva, quantita_disponibile, peso, provenienza, immagine) VALUES
(1, 'Sencha Giapponese', 'Pregiato tè verde coltivato a Shizuoka, note vegetali fresche.<br><br><strong>🍵 Preparazione:</strong> 75°C • 2-3 min • 2g in 200ml', 9.50, 22.00, 25, 100, 'Giappone', '1_1.jpg'),
(3, 'Matcha Cerimoniale', 'Polvere finissima di tè verde d\'ombra di prima scelta.<br><br><strong>🥣 Preparazione:</strong> 80°C • Sbattere con frusta chasen fino a creare schiuma', 22.00, 22.00, 15, 30, 'Giappone', '2_1.jpg'),
(2, 'Earl Grey Imperiale', 'Tè nero aromatizzato con olio essenziale di bergamotto calabrese.<br><br><strong>🫖 Preparazione:</strong> 95°C • 4-5 min • 2.5g in 200ml', 7.80, 22.00, 40, 100, 'India / Italia', '3_1.jpg'),
(1, 'Gyokuro', 'Il Gyokuro è uno dei tè verdi giapponesi più pregiati, noto per un sapore e una lavorazione unica che lo rende diverso da qualsiasi altro tè.<br><br><strong>☕ Preparazione:</strong><br>• Dose: 10g<br>• Acqua: 60ml<br>• Temperatura: 42°C<br>• Tempo: 2 minuti<br><br>Riscalda la teiera, aggiungi il Gyokuro e versa lentamente l\'acqua alla temperatura corretta. Attendi due minuti, quindi versa il liquido dorato in una tazza calda, senza lasciare liquidi nella teiera. Riposiziona il coperchio leggermente inclinato per permettere alle foglie di raffreddarsi in modo naturale.', 12.00, 22.00, 10, 100, 'Giappone', '4_1.jpg');

