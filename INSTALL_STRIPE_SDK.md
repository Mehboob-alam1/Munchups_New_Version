# 🚀 Installazione Stripe PHP SDK - GUIDA RAPIDA

## ⚠️ PROBLEMA ATTUALE
Stripe PHP SDK non è installato sul server. Questo causa l'errore 500.

## ✅ SOLUZIONE RAPIDA (5 minuti)

### Opzione 1: Download Manuale (PIÙ VELOCE)

1. **Scarica Stripe PHP SDK:**
   - Vai su: https://github.com/stripe/stripe-php/archive/refs/heads/master.zip
   - Scarica il file ZIP

2. **Estrai il file ZIP** sul tuo computer

3. **Carica sul server:**
   - Vai su Hostinger File Manager
   - Naviga a: `/public_html/webservice/`
   - Crea la cartella `vendor` se non esiste
   - Carica la cartella `stripe-php` (dall'archivio estratto) in: `/public_html/webservice/vendor/stripe-php/`

4. **Struttura finale:**
   ```
   /public_html/webservice/
   ├── connect_stripe_account.php
   └── vendor/
       └── stripe-php/
           ├── init.php
           └── ... (altri file)
   ```

5. **Testa:**
   - Apri: https://munchups.com/webservice/test_stripe_endpoint.php
   - Dovresti vedere "✅ Stripe class caricata correttamente!"

### Opzione 2: Via Composer (se hai SSH)

1. **Connettiti via SSH:**
   ```bash
   ssh username@munchups.com
   ```

2. **Vai nella cartella:**
   ```bash
   cd /public_html/webservice/
   ```

3. **Installa Composer (se non c'è):**
   ```bash
   curl -sS https://getcomposer.org/installer | php
   ```

4. **Installa Stripe SDK:**
   ```bash
   php composer.phar require stripe/stripe-php
   ```
   oppure se Composer è globale:
   ```bash
   composer require stripe/stripe-php
   ```

5. **Verifica:**
   ```bash
   ls -la vendor/stripe/
   ```
   Dovresti vedere la cartella `stripe-php`

## ✅ VERIFICA INSTALLAZIONE

### Test 1: File di Test
Apri nel browser:
```
https://munchups.com/webservice/test_stripe_endpoint.php
```

Dovresti vedere:
- ✅ Stripe class caricata correttamente!

### Test 2: Endpoint Reale
```bash
curl -X POST https://munchups.com/webservice/connect_stripe_account.php \
  -d "user_id=118&user_type=chef&email=test@example.com"
```

Dovresti ricevere:
```json
{
  "success": "true",
  "account_id": "acct_xxxxx",
  "account_link_url": "https://connect.stripe.com/setup/s/xxxxx"
}
```

## ⏱️ TEMPO STIMATO

- **Download manuale:** 3-5 minuti
- **Via Composer:** 2-3 minuti (se hai SSH)

## 🎯 DOPO L'INSTALLAZIONE

Una volta installato Stripe SDK:
1. ✅ L'errore 500 scomparirà
2. ✅ L'endpoint funzionerà correttamente
3. ✅ L'app Flutter potrà connettere account Stripe

## 📞 SE HAI PROBLEMI

1. Verifica che la cartella `vendor/stripe-php/` esista
2. Verifica che il file `vendor/stripe-php/init.php` esista
3. Controlla i permessi: la cartella deve essere leggibile (755)
4. Usa `test_stripe_endpoint.php` per diagnosticare

## ✅ CHECKLIST

- [ ] Stripe PHP SDK scaricato
- [ ] Cartella `vendor/stripe-php/` caricata sul server
- [ ] File `init.php` presente in `vendor/stripe-php/`
- [ ] Test `test_stripe_endpoint.php` mostra successo
- [ ] Endpoint funziona con cURL
- [ ] App Flutter funziona

