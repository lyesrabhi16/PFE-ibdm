## Before the first build

Two git-ignored files are needed. With the demo running, one command creates both:

```bash
demo/configure-frontend.sh            # run from the repository root; API address -> localhost:8443 (Android emulator: 10.0.2.2:8443)
```

- `lib/config/api.config.dart` is copied from `api.config.dart.example` and given the API address.
- `assets/certificates/myCA.pem` is the certificate authority that issued the server's TLS certificate (the demo creates it and serves it at `/ca`). Only the Android app loads it, to trust the server; web and desktop builds do not need it. For your own deployment, put your CA there (see `backend/ibdm_api/certs/create_certificates.readme.md`).

The script checks that the server really presents a certificate issued by the CA it just downloaded.

The project is locked to Flutter 3.29 (Dart 3.7). `nix develop .#app` from the repository root provides exactly that.

```bash
flutter pub get
flutter build web
```

## Setup Android
1. add a copy of the myCA.pem certificate authority to `assets/certificates`.

## Running the app in debug
1. you can use the vscode debug tool with F5
2. you can use the command 
```bash
flutter run
```
3. if android takes too long to start do this then try again: 
```bash
pnpm run dev:build:android
```

## Building the app
```bash
flutter build linux # for linux
flutter build windows # for windows
flutter build web # for web
flutter build ipa # for ios
flutter build apk # for android
```

