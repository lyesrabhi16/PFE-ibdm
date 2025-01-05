## set up api address
1. copy and paste [`.api.config.dart.example`](./.api.config.dart.example), then rename it to `.api.config.dart`
```bash
cp .api.config.dart.example .api.config.dart
```

2. replace the ip in base_url in ApiConfig in this file [`.api.config.dart`](./.api.config.dart)
```dart
static String base_url = "https://your_pc_ip_address:8443"
```