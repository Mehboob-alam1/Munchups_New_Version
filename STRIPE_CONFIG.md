# Configurazione Stripe - Chiavi API

## Chiavi API Stripe

### Frontend (Flutter App)
- **Publishable Key**: `pk_test_Qv6FioIn5wfwiVyeQ059x3TQ`
  - ✅ Già configurata in `lib/main.dart`
  - ✅ Usata per inizializzare Stripe nel frontend
  - ✅ Sicura da esporre nel codice client

### Backend (Server PHP)
- **Secret Key**: `sk_test_N950jTKYw562aEty72yLlaEZ`
  - ⚠️ **NON deve essere esposta nel frontend**
  - ⚠️ **Deve essere usata SOLO sul server backend**
  - Usata per creare account Stripe Connect e gestire pagamenti

## Pacchetto Flutter

Versione installata: `flutter_stripe: ^12.1.1`

### Installazione
```bash
flutter pub get
```

## Configurazione Frontend

### 1. Inizializzazione in `main.dart`
```dart
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inizializza Stripe con la publishable key
  Stripe.publishableKey = 'pk_test_Qv6FioIn5wfwiVyeQ059x3TQ';
  await Stripe.instance.applySettings();
  
  runApp(MyApp());
}
```

### 2. Funzionalità Disponibili

#### Pagamenti con Carta
- ✅ Implementato in `lib/Screens/Buyer/Card Payment/card_payment_form.dart`
- Crea PaymentMethod e invia token al backend

#### Stripe Connect (Account Connection)
- ⚠️ Richiede endpoint backend: `connect_stripe_account.php`
- L'endpoint deve essere creato sul server
- Vedi `STRIPE_BACKEND_SETUP.md` per i dettagli

## Configurazione Backend

### Endpoint Richiesto
```
https://munchups.com/webservice/connect_stripe_account.php
```

### Parametri Richiesti (POST)
- `user_id`: ID dell'utente
- `user_type`: 'chef' o 'grocer'
- `email`: Email dell'utente

### Risposta Attesa (JSON)
```json
{
  "success": "true",
  "account_id": "acct_xxxxx",
  "account_link_url": "https://connect.stripe.com/setup/s/xxxxx"
}
```

### Implementazione PHP
Vedi `STRIPE_BACKEND_SETUP.md` per l'implementazione completa.

## Test delle Chiavi

### Verifica Publishable Key (Frontend)
La chiave è già configurata e funzionante se:
- ✅ L'app si avvia senza errori
- ✅ Non ci sono errori di inizializzazione Stripe nei log
- ✅ I pagamenti con carta funzionano

### Verifica Secret Key (Backend)
La chiave funziona se:
- ✅ L'endpoint backend può creare account Stripe Connect
- ✅ L'endpoint può generare Account Links
- ✅ Le risposte JSON sono valide

## Troubleshooting

### Errore: "Server endpoint not found"
**Causa**: L'endpoint `connect_stripe_account.php` non esiste sul server.

**Soluzione**:
1. Crea l'endpoint sul server backend
2. Configura la Secret Key nel backend
3. Implementa la logica per creare account Stripe Connect
4. Vedi `STRIPE_BACKEND_SETUP.md` per i dettagli

### Errore: "Stripe not initialized"
**Causa**: La publishable key non è configurata correttamente.

**Soluzione**:
1. Verifica che `Stripe.publishableKey` sia impostata in `main.dart`
2. Verifica che `flutter_stripe: ^12.1.1` sia installato
3. Esegui `flutter pub get`
4. Riavvia l'app

### Errore: "Invalid API Key"
**Causa**: La chiave API non è valida o è scaduta.

**Soluzione**:
1. Verifica le chiavi nel dashboard Stripe
2. Assicurati di usare le chiavi di test (con prefisso `pk_test_` e `sk_test_`)
3. Per produzione, usa chiavi live (con prefisso `pk_live_` e `sk_live_`)

## Note Importanti

1. **Sicurezza**:
   - ⚠️ La Secret Key NON deve mai essere nel codice frontend
   - ⚠️ La Secret Key deve essere solo sul server backend
   - ✅ La Publishable Key può essere nel codice frontend

2. **Ambiente**:
   - Le chiavi attuali sono chiavi di **test**
   - Per produzione, usa chiavi **live** dal dashboard Stripe

3. **Versione Package**:
   - Versione corrente: `flutter_stripe: ^12.1.1`
   - Compatibile con Flutter SDK >=3.0.2

## Riferimenti

- [Documentazione flutter_stripe](https://pub.dev/packages/flutter_stripe)
- [Stripe Connect Documentation](https://stripe.com/docs/connect)
- [Stripe API Keys](https://stripe.com/docs/keys)

