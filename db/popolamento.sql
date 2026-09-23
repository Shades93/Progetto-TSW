INSERT INTO categoria (nome_categoria, descrizione) VALUES
('Tè Verde', 'Tè non fermentati ricchi di antiossidanti'),
('Tè Nero', 'Tè completamente ossidati dal sapore deciso'),
('Matcha', 'Il matcha è ricco di vitamine, minerali, polifenoli ed è il tè con la maggior percentuale di antiossidanti!');


INSERT INTO utente (nome, cognome, email, password, telefono, is_admin) VALUES
('Admin', 'Admin', 'admin@admin.it', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2', '0823987457', TRUE);

INSERT INTO indirizzo (user_id, via, numero, citta, cap) VALUES
(1, 'Via Giovanni Paolo II', '132', 'Fisciano', '84084');

INSERT INTO te (id_categoria, nome_te, descrizione, prezzo, iva, quantita_disponibile, peso, provenienza, immagine) VALUES
(1, 'Sencha Giapponese', 'Pregiato tè verde coltivato a Shizuoka, note vegetali fresche.<br><br><strong>🍵 Preparazione:</strong> 75°C • 2-3 min • 2g in 200ml', 9.50, 22.00, 45, 100, 'Giappone', '1_1.jpg'),
(3, 'Matcha Cerimoniale', 'Polvere finissima di tè verde d\'ombra di prima scelta.<br><br><strong>🥣 Preparazione:</strong> 80°C • Sbattere con frusta chasen fino a creare schiuma', 22.00, 22.00, 15, 70, 'Giappone', '2_1.jpg'),
(2, 'Earl Grey Imperiale', 'Tè nero aromatizzato con olio essenziale di bergamotto calabrese.<br><br><strong>🫖 Preparazione:</strong> 95°C • 4-5 min • 2.5g in 200ml', 7.80, 22.00, 40, 100, 'India / Italia', '3_1.jpg'),
(1, 'Gyokuro', 'Il Gyokuro è uno dei tè verdi giapponesi più pregiati, noto per un sapore e una lavorazione unica che lo rende diverso da qualsiasi altro tè.<br><br><strong>☕ Preparazione:</strong><br>• Dose: 10g<br>• Acqua: 60ml<br>• Temperatura: 42°C<br>• Tempo: 2 minuti<br><br>Riscalda la teiera, aggiungi il Gyokuro e versa lentamente l\'acqua alla temperatura corretta. Attendi due minuti, quindi versa il liquido dorato in una tazza calda, senza lasciare liquidi nella teiera. Riposiziona il coperchio leggermente inclinato per permettere alle foglie di raffreddarsi in modo naturale.', 12.00, 22.00, 50, 100, 'Giappone', '4_1.jpg');

