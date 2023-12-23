prebuild: pubget build_pigeon codegen
  
pubget:
  #!/bin/bash
  set -euo pipefail
  fvm flutter pub get
  cd mapness
  fvm flutter pub get

delete_codegen:
  fd -HI -tf '\.(g|freezed)\.dart' -X rm

locale_gen:
  #!/bin/bash
  set -euo pipefail

  localazy download
  cd mapness
  fvm flutter gen-l10n # --arb-dir=lib/src/l10n/ --template-arb-file=intl_ru.arb --output-localization-file=generated/ --output-class=AppLocalization --output-dir=lib/src/l10n/generated/app_localizations --no-synthetic-package


codegen:
  #!/bin/bash
  set -euo pipefail
  cd mapness
  fvm dart run build_runner build --delete-conflicting-outputs || true

codegen-watch:
  #!/bin/bash
  set -euo pipefail
  cd mapness
  fvm dart run build_runner watch --delete-conflicting-outputs || true

open_built:
  open build/app/outputs/flutter-apk

build_pigeon:
  #!/bin/bash
  set -euo pipefail
  cd urbi_map/dgis_map_platform_interface/
  
  echo build pigeons
  # fvm flutter pub run pigeon --input pigeons/messages.dart
  ./pigeon.sh
  echo pigeons ready

run:
  fvm flutter run --target lib/main_dev.dart

protoc:
  #!/bin/bash
  set -euo pipefail
  cd mapness
  protoc protocol.proto --dart_out=lib/_generated/protocol


apk-release filename: locale_gen prebuild
  #!/usr/bin/env bash
  set -euo pipefail

  echo add abi filter
  git apply .github/workflows/abi_filter.patch

  echo build urbi pre
  fvm flutter build apk --target lib/main_urbi_pre.dart
  mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/urbi-pre-{{filename}}.apk

  echo build main prod
  fvm flutter build apk --target lib/main_prod.dart
  mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/momrah-prod-{{filename}}.apk

  # echo build main stage
  # fvm flutter build apk --target lib/main_stg.dart --debug
  # mv build/app/outputs/flutter-apk/app-debug.apk build/app/outputs/flutter-apk/momrah-stage-debug-{{filename}}.apk

  echo remove abi filter
  git apply -R .github/workflows/abi_filter.patch

