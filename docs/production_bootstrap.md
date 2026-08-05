# Eman Experience ERP — Production Bootstrap

## 1. Enable Firebase services

Enable Email/Password Authentication, Cloud Firestore, Firebase Storage, and Hosting in the Firebase project.

## 2. Deploy security configuration

```bash
firebase deploy --only firestore:rules,firestore:indexes,storage
```

## 3. Create the first owner

1. Open the ERP and create an account with the owner's email.
2. In Firebase Console, open Firestore and locate `users/{uid}`.
3. Update the document once with:

```json
{
  "role": "owner",
  "department": "management",
  "active": true
}
```

After the first owner is active, all subsequent access requests can be approved from **Users & Roles** inside the ERP. Do not grant `owner` or `admin` roles to ordinary employees.

## 4. Recommended production roles

- `owner`: unrestricted business owner access.
- `admin`: system and user administration.
- `general_manager`: cross-factory operational management.
- `production_manager`: production orders, recipes, and batches.
- `warehouse_manager`: raw materials, stock movements, and loading.
- `quality_manager`: quality inspections and batch release.
- `shipping_manager`: shipment scheduling and dispatch.
- `viewer`: read-only access after activation.

## 5. Build and deploy Flutter Web

```bash
flutter clean
flutter pub get
flutter analyze
flutter build web --release \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_PROJECT_ID=... \
  --dart-define=FIREBASE_AUTH_DOMAIN=... \
  --dart-define=FIREBASE_STORAGE_BUCKET=...
firebase deploy --only hosting
```

## 6. Security operations

- Review the Audit Log weekly.
- Deactivate employees immediately when access is no longer required.
- Keep Firebase project owners limited to trusted technical administrators.
- Use separate Firebase projects for development and production.
- Test Firestore and Storage rules with the Firebase Emulator Suite before major releases.
