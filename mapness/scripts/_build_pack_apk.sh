#!/usr/bin/env bash

cd ../../
fvm flutter build apk --target lib/main_urbi_pre.dart
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/urbi-pre-$1.apk
fvm flutter build apk --target lib/main_prod.dart
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/momrah-prod-$1.apk
fvm flutter build apk --target lib/main_stg.dart # --debug
mv build/app/outputs/flutter-apk/app-debug.apk build/app/outputs/flutter-apk/momrah-stage-debug-$1.apk
