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

