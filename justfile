default:
    just --list

# define shell envs

export PATH := env_var('PATH') + ":" + absolute_path('mapness/scripts/common_functions')
export GIT_BRANCH := `git rev-parse --abbrev-ref HEAD`
export GIT_COMMIT := replace_regex(`git rev-parse HEAD`, '([a-zA-Z0-9]{8}).*', '$1') + ' ' + `git --no-pager show -s --format='%s'`
export VENDOR_CONFIG := env_var_or_default('VENDOR_CONFIG', 'unknown')
dart_define := "--dart-define=GIT_BRANCH=\"" + GIT_BRANCH + "\" --dart-define=GIT_COMMIT=\"" + GIT_COMMIT + "\" --dart-define=VENDOR_CONFIG=$VENDOR_CONFIG"

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

    print_style '' 'yellow' '> setup locale...'
    localazy download
    cd mapness
    mkdir -p lib/l10n
    fvm flutter gen-l10n # --arb-dir=lib/src/l10n/ --template-arb-file=intl_ru.arb --output-localization-file=generated/ --output-class=AppLocalization --output-dir=lib/src/l10n/generated/app_localizations --no-synthetic-package
    print_style '' 'yellow' '< locale ready '

codegen:
    #!/bin/bash
    set -euo pipefail
    print_style '' 'yellow' '> generate code...'
    cd mapness
    fvm dart run build_runner build --delete-conflicting-outputs || true
    print_style '' 'yellow' '< code generated'

codegen_dir path:
    #!/bin/bash
    set -euo pipefail
    print_style '' 'yellow' '> generate code for: {{path}}'
    cd mapness
    fvm dart run build_runner build --build-filter="{{path}}" --delete-conflicting-outputs || true
    print_style '' 'yellow' '< code generated: {{path}}'

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

    print_style '' 'yellow' '> build pigeons...'
    # fvm flutter pub run pigeon --input pigeons/messages.dart
    ./pigeon.sh
    print_style '' 'yellow' '< pigeons ready'

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

    print_style '' 'yellow' 'add abi filter'
    git apply .github/workflows/abi_filter.patch || print_style '' 'red' 'could not apply abi filter patch'
    print_style '' 'yellow' 'remove app version force update'
    git apply mapness/scripts/disable-force-update.patch || print_style '' 'red' 'could not remove app version force update'

unapply-patches:
    #!/usr/bin/env bash
    set -euo pipefail

    print_style '' 'yellow' 'restore app version force update'
    git apply -R mapness/scripts/disable-force-update.patch || print_style '' 'red' 'could not restore app version force update'
    print_style '' 'yellow' 'remove abi filter'
    git apply -R .github/workflows/abi_filter.patch || print_style '' 'red' 'could not unapply abi filter patch'

xcode:
    open ios/Runner.xcworkspace

ios_setup:
    #!/usr/bin/env bash
    set -euo pipefail

    cd ios
    if pod install; then
        echo
        print_style '' 'yellow' 'pod install success'
    else
        print_style '' 'yellow' '> pod install failed, trying to fix...'
        just pubget
        fvm flutter precache --ios
        rm -f Podfile.lock
        pod repo update || true
        pod update
        pod install
        echo
        print_style '' 'yellow' '< pod install fixed!'
    fi

dev-env-setup:
    ./mapness/scripts/dev-env-setup.sh

ios-release: apply-patches prebuild ios_setup && unapply-patches
    #!/usr/bin/env bash
    momrahBundle='momra.balady.ios'
    baladyBundle='xyz.amoriodi.balady'

    set -euxo pipefail
    sed -i '' "s/$momrahBundle/$baladyBundle/" ios/Runner.xcodeproj/project.pbxproj
    fvm flutter build ipa --target lib/main_stg.dart --flavor stg
    sed -i '' "s/$baladyBundle/$momrahBundle/" ios/Runner.xcodeproj/project.pbxproj
    open build/ios/archive/Runner.xcarchive

apk-release version: apply-patches prebuild && unapply-patches open_built 
    #!/usr/bin/env bash
    set -euo pipefail

    print_style '' 'yellow' 'build urbi pre'
    VENDOR_CONFIG="urbi-pre-prod"
    fvm flutter build apk --target lib/main_urbi_pre.dart {{ dart_define }}
    mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/urbi-pre-{{ version }}.apk
    print_style '' 'cyan' 'urbi pre ready!'

    print_style '' 'yellow' 'build momrah prod'
    VENDOR_CONFIG="momrah-prod"
    fvm flutter build apk --target lib/main_prod.dart {{ dart_define }}
    mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/momrah-prod-{{ version }}.apk
    print_style '' 'cyan' 'momrah prod ready!'

    print_style '' 'yellow' 'build momrah stage'
    VENDOR_CONFIG="momrah-stage"
    # fvm flutter build apk --target lib/main_stg.dart --debug {{ dart_define }}
    # mv build/app/outputs/flutter-apk/app-debug.apk build/app/outputs/flutter-apk/momrah-stage-debug-{{ version }}.apk
    fvm flutter build apk --target lib/main_stg.dart {{ dart_define }}
    mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/momrah-stage-{{ version }}.apk
    print_style '' 'cyan' 'momrah stage ready!'

    print_style '' 'green' 'done, you may open build with:'
    print_style 'bold' 'yellow' 'just open_built'
