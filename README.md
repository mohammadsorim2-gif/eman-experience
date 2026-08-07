# Eman Experience ERP

Production ERP for an instant beverage manufacturing plant.

## Stack

- Flutter
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Hosting
- GitHub Actions

## Core modules

- Dashboard and Factory Hub
- Products and recipes
- Raw materials and inventory
- Production orders and batches
- Quality control
- Shipping
- Reports
- Users, roles and audit trail

## Firebase

The active Firebase project is `eman-experience`.

Web builds receive Firebase configuration through GitHub Actions secrets. Do not commit service-account JSON files or private credentials to this repository.

## Deployment

Production deployment is handled only by `.github/workflows/firebase-hosting-deploy.yml`.

Every push to `main` builds Flutter Web and deploys the result to Firebase Hosting. The workflow can also be started manually from GitHub Actions.

Production URL:

`https://eman-experience.web.app`

## Local development

```bash
flutter pub get
flutter analyze
flutter run -d chrome
```

For web builds, provide the required Firebase values with `--dart-define` or an equivalent secure environment configuration.
