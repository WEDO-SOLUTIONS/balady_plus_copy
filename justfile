default: 
  just --list

green := '\033[0;32m'
cyan:='\033[0;36m'
yellow:='\033[0;33m' 
byellow :='\033[1;33m'
red :='\033[0;31m'
nc := '\033[0m'

prebuild: pubget locale_gen build_pigeon codegen
  
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

  echo -e '{{yellow}}> setup locale...{{nc}}'
  localazy download
  cd mapness
  mkdir -p lib/l10n
  fvm flutter gen-l10n # --arb-dir=lib/src/l10n/ --template-arb-file=intl_ru.arb --output-localization-file=generated/ --output-class=AppLocalization --output-dir=lib/src/l10n/generated/app_localizations --no-synthetic-package
  echo -e '{{yellow}}< locale ready {{nc}}'


codegen:
  #!/bin/bash
  set -euo pipefail
  echo -e '{{yellow}}> generate code...{{nc}}'
  cd mapness
  fvm dart run build_runner build --delete-conflicting-outputs || true
  echo -e '{{yellow}}< code generated{{nc}}'

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
  
  echo -e '{{yellow}}> build pigeons...{{nc}}'
  # fvm flutter pub run pigeon --input pigeons/messages.dart
  ./pigeon.sh
  echo -e '{{yellow}}< pigeons ready{{nc}}'

run:
  fvm flutter run --target lib/main_dev.dart

protoc:
  #!/bin/bash
  set -euo pipefail
  cd mapness
  protoc protocol.proto --dart_out=lib/_generated/protocol

apply-patches:
  #!/usr/bin/env bash
  set -euo pipefail

  echo -e '{{yellow}}add abi filter{{nc}}'
  git apply .github/workflows/abi_filter.patch || echo -e '{{red}}could not apply abi filter patch{{nc}}'
  echo -e '{{yellow}}remove app version force update{{nc}}'
  git apply mapness/scripts/disable-force-update.patch || echo -e '{{red}}could not remove app version force update{{nc}}'

unapply-patches:
  #!/usr/bin/env bash
  set -euo pipefail

  echo -e '{{yellow}}restore app version force update{{nc}}'
  git apply -R mapness/scripts/disable-force-update.patch || echo -e '{{red}}could not restore app version force update{{nc}}'
  echo -e '{{yellow}}remove abi filter{{nc}}'
  git apply -R .github/workflows/abi_filter.patch || echo -e '{{red}}could not unapply abi filter patch{{nc}}'


apk-release version: prebuild
  #!/usr/bin/env bash
  set -euo pipefail

  just apply-patches

  echo -e '{{yellow}}build urbi pre{{nc}}'
  fvm flutter build apk --target lib/main_urbi_pre.dart
  mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/urbi-pre-{{version}}.apk
  echo -e '{{cyan}}urbi pre ready!{{nc}}'

  echo -e '{{yellow}}build main prod{{nc}}'
  fvm flutter build apk --target lib/main_prod.dart
  mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/momrah-prod-{{version}}.apk
  echo -e '{{cyan}}main prod ready!{{nc}}'

  echo -e '{{yellow}}build main stage{{nc}}'
  # fvm flutter build apk --target lib/main_stg.dart --debug
  # mv build/app/outputs/flutter-apk/app-debug.apk build/app/outputs/flutter-apk/momrah-stage-debug-{{version}}.apk
  fvm flutter build apk --target lib/main_stg.dart
  mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/momrah-stage-{{version}}.apk
  echo -e '{{cyan}}main stage ready!{{nc}}'

  just unapply-patches

  echo -e '{{green}}done, you may open build with{{nc}}: {{byellow}}just open_built{{nc}}'

