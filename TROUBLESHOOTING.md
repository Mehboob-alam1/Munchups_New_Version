# 🔧 Troubleshooting - connect_stripe_account.php

## ❌ Problema: Endpoint non funziona

### 1. Verifica che il file esista

**Controlla nel browser:**
```
https://munchups.com/webservice/connect_stripe_account.php
```

**Risposta attesa:**
- Se vedi JSON con `"Method not allowed"` → ✅ File esiste, ma serve POST
- Se vedi 404 → ❌ File non nella posizione corretta
- Se vedi errore PHP → ⚠️ Problema nel file PHP

### 2. Verifica Stripe PHP SDK

**Errore comune:** `Class 'Stripe\Stripe' not found`

**Soluzione A - Via Composer:**
```bash
cd /public_html/webservice/
composer require stripe/stripe-php
```

**Soluzione B - Download Manuale:**
1. Scarica: https://github.com/stripe/stripe-php/archive/refs/heads/master.zip
2. Estrai e carica in: `/public_html/webservice/vendor/stripe-php/`
3. Il file aggiornato ora supporta entrambi i metodi

### 3. Test con cURL

**Test GET (dovrebbe dare errore "Method not allowed"):**
```bash
curl https://munchups.com/webservice/connect_stripe_account.php
```

**Test POST (dovrebbe funzionare):**
```bash
curl -X POST https://munchups.com/webservice/connect_stripe_account.php \
  -d "user_id=123&user_type=chef&email=test@example.com" \
  -H "Content-Type: application/x-www-form-urlencoded"
```

**Risposta attesa:**
```json
{
  "success": "true",
  "account_id": "acct_xxxxx",
  "account_link_url": "https://connect.stripe.com/setup/s/xxxxx"
}
```

### 4. Controlla i Log Errori

**In Hostinger:**
1. Vai su hPanel → File Manager
2. Controlla: `public_html/error_log`
3. Cerca errori relativi a Stripe

**Errori comuni:**

#### "Class 'Stripe\Stripe' not found"
→ Stripe PHP SDK non installato

#### "Call to undefined function json_encode()"
→ Estensione JSON PHP non abilitata (raro)

#### "500 Internal Server Error"
→ Controlla i log per dettagli

### 5. Verifica Permessi File

Il file deve avere permessi **644**:
```bash
chmod 644 connect_stripe_account.php
```

### 6. Verifica PHP Version

Stripe PHP SDK richiede **PHP 7.4+**

In Hostinger:
1. Vai su hPanel → Select PHP Version
2. Assicurati che sia PHP 7.4 o superiore

### 7. Test Step-by-Step

**Step 1: Test file base**
```bash
curl https://munchups.com/webservice/connect_stripe_account.php
```
Dovrebbe restituire: `{"success":"false","msg":"Method not allowed..."}`

**Step 2: Test con parametri**
```bash
curl -X POST https://munchups.com/webservice/connect_stripe_account.php \
  -d "user_id=123&email=test@example.com"
```

**Step 3: Verifica risposta**
- Se vedi JSON con `success: true` → ✅ Funziona!
- Se vedi errore → Controlla il messaggio di errore

### 8. Errori Specifici

#### "Stripe PHP SDK not found"
**Causa:** SDK non installato

**Soluzione:**
```bash
cd /public_html/webservice/
composer require stripe/stripe-php
```

#### "Authentication failed"
**Causa:** Secret Key sbagliata o non valida

**Soluzione:**
- Verifica che la Secret Key nel file PHP sia: `sk_test_N950jTKYw562aEty72yLlaEZ`
- Verifica che sia una chiave di test valida

#### "Invalid country code"
**Causa:** Paese non supportato

**Soluzione:**
- Modifica `$country` nel file PHP
- Usa codici validi: 'US', 'GB', 'CA', 'IT', etc.

### 9. Debug Mode

Per vedere errori dettagliati, modifica temporaneamente il file PHP:
```php
ini_set('display_errors', 1); // Mostra errori
```

**⚠️ IMPORTANTE:** Rimuovi questa riga dopo il debug per sicurezza!

### 10. Checklist Finale

- [ ] File caricato in `/public_html/webservice/connect_stripe_account.php`
- [ ] Stripe PHP SDK installato
- [ ] PHP version 7.4+
- [ ] Permessi file corretti (644)
- [ ] Secret Key corretta nel file
- [ ] Test cURL funziona
- [ ] Nessun errore nei log

## 📞 Se Niente Funziona

1. Controlla i log errori in Hostinger
2. Testa con cURL per vedere la risposta esatta
3. Verifica che altri endpoint PHP funzionino (es. login.php)
4. Contatta supporto Hostinger se necessario

## ✅ File Aggiornato

Ho aggiornato `connect_stripe_account.php` con:
- ✅ Migliore gestione errori
- ✅ Supporto per Stripe SDK via Composer o manuale
- ✅ Messaggi di errore più chiari
- ✅ Logging degli errori

Ricarica il file sul server e riprova!

