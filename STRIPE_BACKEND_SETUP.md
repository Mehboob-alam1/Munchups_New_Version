# Configurazione Backend Stripe Connect

## Problema Attuale
L'endpoint `connect_stripe_account.php` non esiste sul server backend, causando l'errore "Server endpoint not found".

## Soluzione

### 1. Chiavi API Stripe
Le seguenti chiavi API devono essere configurate:

- **Publishable Key**: `pk_test_Qv6FioIn5wfwiVyeQ059x3TQ`
  - ✅ Già configurata nel frontend (`lib/main.dart`)
  - ✅ Usata per inizializzare Stripe nel Flutter app
  - ✅ Sicura da esporre nel codice client

- **Secret Key**: `sk_test_N950jTKYw562aEty72yLlaEZ`
  - ⚠️ **DEVE essere usata SOLO sul backend**
  - ⚠️ **NON deve mai essere esposta nel frontend**
  - ⚠️ **NON deve essere nel codice Flutter**
  - Usata per creare account Stripe Connect e gestire pagamenti

⚠️ **IMPORTANTE**: La Secret Key (`sk_test_...`) è estremamente sensibile. Se esposta, può essere usata per accedere al tuo account Stripe. Deve essere usata SOLO sul server backend PHP.

### 2. Endpoint Backend Richiesto

Devi creare il file `connect_stripe_account.php` sul server in:
```
https://munchups.com/webservice/connect_stripe_account.php
```

### 3. Funzionalità dell'Endpoint

L'endpoint deve:

1. **Ricevere i parametri**:
   - `user_id` (string)
   - `user_type` (string: 'chef' o 'grocer')
   - `email` (string)

2. **Usare la Stripe Secret Key** per:
   - Creare o recuperare un account Stripe Connect per l'utente
   - Generare un Account Link per l'onboarding
   - Salvare l'account ID nel database

3. **Restituire una risposta JSON**:
```json
{
  "success": "true",
  "account_id": "acct_xxxxx",
  "account_link_url": "https://connect.stripe.com/setup/s/xxxxx"
}
```

### 4. Esempio di Implementazione PHP

```php
<?php
require_once 'vendor/autoload.php'; // Stripe PHP SDK

// ⚠️ IMPORTANTE: Questa chiave deve essere nel backend, mai nel frontend!
// Configurazione Stripe Secret Key
$stripe_secret_key = 'sk_test_N950jTKYw562aEty72yLlaEZ';
\Stripe\Stripe::setApiKey($stripe_secret_key);

header('Content-Type: application/json');

// Ricevi i parametri
$user_id = $_POST['user_id'] ?? '';
$user_type = $_POST['user_type'] ?? 'chef';
$email = $_POST['email'] ?? '';

if (empty($user_id) || empty($email)) {
    echo json_encode([
        'success' => 'false',
        'msg' => 'Missing required parameters'
    ]);
    exit;
}

try {
    // Verifica se l'utente ha già un account Stripe
    // (controlla nel database)
    
    // Se non esiste, crea un nuovo account Stripe Connect
    $account = \Stripe\Account::create([
        'type' => 'express',
        'country' => 'US', // o il paese appropriato
        'email' => $email,
        'capabilities' => [
            'card_payments' => ['requested' => true],
            'transfers' => ['requested' => true],
        ],
    ]);
    
    // Salva l'account_id nel database associato all'user_id
    
    // Crea il link di onboarding
    $accountLink = \Stripe\AccountLink::create([
        'account' => $account->id,
        'refresh_url' => 'https://munchups.com/refresh',
        'return_url' => 'https://munchups.com/return',
        'type' => 'account_onboarding',
    ]);
    
    echo json_encode([
        'success' => 'true',
        'account_id' => $account->id,
        'account_link_url' => $accountLink->url
    ]);
    
} catch (\Stripe\Exception\ApiErrorException $e) {
    echo json_encode([
        'success' => 'false',
        'msg' => 'Stripe error: ' . $e->getMessage()
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => 'false',
        'msg' => 'Server error: ' . $e->getMessage()
    ]);
}
?>
```

### 5. Verifica

Dopo aver creato l'endpoint, verifica che:
1. L'endpoint risponda correttamente alle richieste POST
2. La Secret Key Stripe sia configurata correttamente
3. Il database salvi correttamente l'account_id associato all'user_id
4. I link di onboarding funzionino correttamente

### 6. Note di Sicurezza

- ✅ La Secret Key deve essere nel backend, mai nel frontend
- ✅ Usa HTTPS per tutte le comunicazioni
- ✅ Valida tutti gli input
- ✅ Gestisci gli errori in modo sicuro
- ✅ Logga le operazioni per il debugging

## Testing

Puoi testare l'endpoint con:
```bash
curl -X POST https://munchups.com/webservice/connect_stripe_account.php \
  -d "user_id=123&user_type=chef&email=test@example.com"
```

Dovresti ricevere una risposta JSON con `success: true` e l'`account_link_url`.

