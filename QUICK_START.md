# ✅ Quick Start - Stripe Connect è Pronto!

## 🎉 File Caricato sul Server

Il file `connect_stripe_account.php` è stato caricato in:
```
https://munchups.com/webservice/connect_stripe_account.php
```

## ⚠️ IMPORTANTE: Verifica Questi Passi

### 1. ✅ Stripe PHP SDK Installato?

Il file PHP richiede Stripe SDK. Verifica:

**Opzione A - Via Composer (CONSIGLIATO):**
```bash
cd /public_html/webservice/
composer require stripe/stripe-php
```

**Opzione B - Download Manuale:**
1. Scarica: https://github.com/stripe/stripe-php/archive/refs/heads/master.zip
2. Estrai e carica in: `/public_html/webservice/vendor/stripe-php/`
3. Modifica il file PHP (riga 15):
   ```php
   require_once __DIR__ . '/vendor/stripe-php/init.php';
   ```

### 2. ✅ Configurazione File PHP

Apri `connect_stripe_account.php` e verifica:

**Riga 81 - Paese:**
```php
'country' => 'US', // Cambia se necessario (IT, GB, CA, etc.)
```

**Riga 102-103 - URL Return/Refresh:**
```php
'refresh_url' => 'https://munchups.com/app/refresh', // Modifica se necessario
'return_url' => 'https://munchups.com/app/return',   // Modifica se necessario
```

### 3. ✅ Test dell'Endpoint

Testa l'endpoint con:
```bash
curl -X POST https://munchups.com/webservice/connect_stripe_account.php \
  -d "user_id=123&user_type=chef&email=test@example.com"
```

**Risposta Attesa:**
```json
{
  "success": "true",
  "account_id": "acct_xxxxx",
  "account_link_url": "https://connect.stripe.com/setup/s/xxxxx",
  "msg": "Stripe account created successfully"
}
```

### 4. ✅ Test dall'App Flutter

1. Apri l'app Flutter
2. Vai su "Manage Account" (per Chef/Grocer)
3. Clicca "Connect Stripe Account"
4. Dovrebbe funzionare! ✅

## 🐛 Troubleshooting

### Errore: "Class 'Stripe\Stripe' not found"
**Causa**: Stripe PHP SDK non installato

**Soluzione**: 
- Installa via Composer: `composer require stripe/stripe-php`
- Oppure carica manualmente Stripe SDK

### Errore: "500 Internal Server Error"
**Causa**: Errore nel file PHP o Stripe SDK

**Soluzione**:
1. Controlla i log errori in Hostinger
2. Verifica che la Secret Key sia corretta
3. Verifica che PHP sia 7.4+

### Errore: "404 Not Found"
**Causa**: File non nella posizione corretta

**Soluzione**:
- Verifica che il file sia in: `/public_html/webservice/connect_stripe_account.php`
- Verifica i permessi del file (644)

### Errore: "Invalid JSON response"
**Causa**: Il server restituisce HTML invece di JSON

**Soluzione**:
- Verifica che Stripe SDK sia installato correttamente
- Controlla i log errori PHP

## ✅ Checklist Finale

- [ ] File `connect_stripe_account.php` caricato in `/public_html/webservice/`
- [ ] Stripe PHP SDK installato (Composer o manuale)
- [ ] Paese configurato nel file PHP
- [ ] URL return/refresh configurati
- [ ] Endpoint testato con cURL (risposta JSON valida)
- [ ] App Flutter testata (funziona!)

## 🎉 Fatto!

Se tutti i passi sono completati, l'integrazione Stripe Connect è pronta e funzionante!

Per problemi, controlla:
- `HOSTINGER_DEPLOYMENT.md` - Guida dettagliata deploy
- `STRIPE_BACKEND_SETUP.md` - Setup backend completo
- Log errori in Hostinger hPanel

