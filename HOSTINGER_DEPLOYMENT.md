# Guida Deploy su Hostinger - Stripe Connect Endpoint

## 📍 Dove Caricare il File

### ❌ NON nel Database
Il file PHP **NON va nel database**. Va nel **filesystem del server web**.

### ✅ Posizione Corretta

Il file deve essere caricato qui:
```
https://munchups.com/webservice/connect_stripe_account.php
```

**Percorso sul server Hostinger:**
```
/public_html/webservice/connect_stripe_account.php
```
oppure
```
/domains/munchups.com/public_html/webservice/connect_stripe_account.php
```

## 🚀 Passi per Deploy su Hostinger

### Passo 1: Accedi a Hostinger

1. Vai su [hpanel.hostinger.com](https://hpanel.hostinger.com)
2. Accedi al tuo account
3. Seleziona il dominio `munchups.com`

### Passo 2: Apri File Manager

1. Clicca su **"File Manager"** nel pannello
2. Naviga alla cartella: `public_html`
3. Apri la cartella `webservice` (se non esiste, creala)

### Passo 3: Carica il File PHP

**Opzione A: Upload tramite File Manager**
1. Nella cartella `webservice`, clicca su **"Upload"**
2. Seleziona il file `connect_stripe_account.php` dal tuo computer
3. Aspetta che il caricamento finisca

**Opzione B: Upload tramite FTP**
1. Usa un client FTP (FileZilla, Cyberduck, etc.)
2. Connettiti al server Hostinger con:
   - **Host**: `ftp.munchups.com` o l'IP del server
   - **Username**: Il tuo username Hostinger
   - **Password**: La tua password FTP
   - **Port**: 21 (FTP) o 22 (SFTP)
3. Naviga a `/public_html/webservice/`
4. Trascina il file `connect_stripe_account.php` nella cartella

**Opzione C: Upload tramite SSH (se disponibile)**
```bash
# Connettiti via SSH
ssh username@munchups.com

# Naviga alla cartella
cd public_html/webservice/

# Carica il file (usa scp da locale)
# Da terminale locale:
scp connect_stripe_account.php username@munchups.com:/public_html/webservice/
```

### Passo 4: Installa Stripe PHP SDK

**Opzione A: Via Composer (CONSIGLIATO)**

1. **Accedi via SSH** (se disponibile su Hostinger):
   ```bash
   ssh username@munchups.com
   cd public_html/webservice/
   ```

2. **Installa Composer** (se non è già installato):
   ```bash
   curl -sS https://getcomposer.org/installer | php
   ```

3. **Installa Stripe PHP SDK**:
   ```bash
   php composer.phar require stripe/stripe-php
   ```
   oppure se Composer è globale:
   ```bash
   composer require stripe/stripe-php
   ```

**Opzione B: Download Manuale**

Se non hai accesso SSH/Composer:

1. Scarica Stripe PHP SDK da: https://github.com/stripe/stripe-php
2. Estrai il file ZIP
3. Carica la cartella `stripe-php` in `/public_html/webservice/vendor/`
4. Modifica `connect_stripe_account.php`:
   ```php
   // Invece di:
   require_once __DIR__ . '/vendor/autoload.php';
   
   // Usa:
   require_once __DIR__ . '/vendor/stripe-php/init.php';
   ```

### Passo 5: Configura il Database

1. **Aggiungi colonna al database**:
   ```sql
   ALTER TABLE users 
   ADD COLUMN stripe_account_id VARCHAR(255) NULL;
   ```

2. **Oppure modifica la tabella esistente** tramite phpMyAdmin:
   - Vai su phpMyAdmin in Hostinger
   - Seleziona il database
   - Vai alla tabella `users`
   - Aggiungi colonna `stripe_account_id` (VARCHAR 255)

### Passo 6: Modifica il File PHP

Apri `connect_stripe_account.php` e modifica:

1. **URL di Return/Refresh** (righe ~100-101):
   ```php
   'refresh_url' => 'https://munchups.com/app/refresh', // Cambia con il tuo URL
   'return_url' => 'https://munchups.com/app/return',   // Cambia con il tuo URL
   ```

2. **Paese** (riga ~85):
   ```php
   'country' => 'US', // Cambia con: 'IT', 'GB', 'CA', etc.
   ```

3. **Implementa le funzioni database** (vedi commenti nel file)

### Passo 7: Testa l'Endpoint

**Test tramite Browser:**
```
https://munchups.com/webservice/connect_stripe_account.php
```
Dovresti vedere un errore JSON (normale, perché serve POST).

**Test tramite cURL:**
```bash
curl -X POST https://munchups.com/webservice/connect_stripe_account.php \
  -d "user_id=123&user_type=chef&email=test@example.com"
```

**Test dall'App Flutter:**
1. Apri l'app
2. Vai su "Manage Account"
3. Clicca "Connect Stripe Account"
4. Dovrebbe funzionare! ✅

## 📁 Struttura File sul Server

```
public_html/
├── webservice/
│   ├── connect_stripe_account.php  ← IL TUO FILE QUI
│   ├── vendor/
│   │   └── stripe/
│   │       └── stripe-php/         ← Stripe SDK (via Composer)
│   ├── login.php
│   ├── register.php
│   └── ... (altri file PHP esistenti)
└── ...
```

## ⚙️ Configurazioni Hostinger

### Verifica PHP Version
1. Vai su **File Manager** → **Select PHP Version**
2. Assicurati che sia **PHP 7.4 o superiore** (consigliato PHP 8.0+)
3. Stripe PHP SDK richiede PHP 7.4+

### Permessi File
Il file deve avere permessi **644**:
```bash
chmod 644 connect_stripe_account.php
```

### Verifica Errori
1. Abilita error logging in Hostinger
2. Controlla i log in: `public_html/error_log` o tramite hPanel

## 🔒 Sicurezza

### ✅ Cosa Fare:
- ✅ Mantieni la Secret Key nel file PHP (sul server)
- ✅ Usa HTTPS (Hostinger lo fa automaticamente)
- ✅ Valida tutti gli input
- ✅ Usa prepared statements per il database

### ❌ Cosa NON Fare:
- ❌ NON esporre la Secret Key nel frontend
- ❌ NON committare il file PHP con la Secret Key su Git pubblico
- ❌ NON permettere accesso diretto al file senza autenticazione

## 🐛 Troubleshooting

### Errore: "Class 'Stripe\Stripe' not found"
**Soluzione**: Installa Stripe PHP SDK via Composer

### Errore: "500 Internal Server Error"
**Soluzione**: 
1. Controlla i log errori in Hostinger
2. Verifica che PHP sia 7.4+
3. Verifica i permessi del file

### Errore: "Composer not found"
**Soluzione**: 
1. Installa Composer manualmente
2. Oppure usa download manuale di Stripe SDK

### Errore: "Database connection failed"
**Soluzione**: 
1. Verifica le credenziali database in Hostinger
2. Implementa le funzioni database helper nel file PHP

## 📞 Supporto

Se hai problemi:
1. Controlla i log errori in Hostinger hPanel
2. Verifica che il file sia nella posizione corretta
3. Testa l'endpoint con cURL o Postman
4. Contatta supporto Hostinger se necessario

## ✅ Checklist Finale

- [ ] File caricato in `/public_html/webservice/connect_stripe_account.php`
- [ ] Stripe PHP SDK installato (via Composer o manuale)
- [ ] Database configurato (colonna `stripe_account_id` aggiunta)
- [ ] URL return/refresh modificati nel file PHP
- [ ] Paese configurato correttamente
- [ ] PHP version 7.4+ verificata
- [ ] File testato con cURL
- [ ] App Flutter testata

## 🎉 Fatto!

Una volta completato, l'endpoint sarà disponibile a:
```
https://munchups.com/webservice/connect_stripe_account.php
```

E l'app Flutter funzionerà correttamente! ✅

