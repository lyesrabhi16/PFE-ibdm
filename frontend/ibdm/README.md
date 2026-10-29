## Before the first build

Two git-ignored files must exist (a fresh clone fails with "unable to find directory entry in pubspec.yaml" or "Undefined name 'ApiConfig'" otherwise):

```bash
cp lib/config/api.config.dart.example lib/config/api.config.dart   # then set the API address
# the CA certificate that signed the server's TLS certificate; any (even empty) file lets web builds bundle
touch assets/certificates/ifruit_CA.pem
```

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

