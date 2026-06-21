default:
    just --list

# define shell envs

export PATH := env_var('PATH') + ":" + absolute_path('mapness/scripts/common_functions')
export GIT_BRANCH := `git rev-parse --abbrev-ref HEAD`
export GIT_COMMIT := replace_regex(`git rev-parse HEAD`, '([a-zA-Z0-9]{8}).*', '$1') + ' ' + `git --no-pager show -s --format='%s'`
export VENDOR_CONFIG := env_var_or_default('VENDOR_CONFIG', 'unknown')
dart_define := "--dart-define=GIT_BRANCH=\"" + GIT_BRANCH + "\" --dart-define=GIT_COMMIT=\"" + GIT_COMMIT + "\" --dart-define=VENDOR_CONFIG=$VENDOR_CONFIG"

# everything regarding release
import 'justscripts/release.just'

# local overrides feel free to add any there
import? 'justscripts/local.just'

# style helpers
import 'justscripts/styles.just'
import 'justscripts/styles_prepare.just'

# prebuild: pubget locale_gen build_pigeon download-sdk codegen
prebuild: locale_gen pubget build_pigeon codegen

pubrefresh: clean pubget

pubget:
    #!/bin/bash
    set -euo pipefail
    fvm flutter pub get
    cd mapness
    fvm flutter pub get
    cd ..

clean:
    #!/bin/bash
    set -euo pipefail
    fvm flutter clean
    cd mapness
    fvm flutter clean

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
    fvm dart run build_runner build --delete-conflicting-outputs --force-jit || true
    print_style '' 'yellow' '< code generated'

codegen_dir path:
    #!/bin/bash
    set -euo pipefail
    print_style '' 'yellow' '> generate code for: {{path}}'
    cd mapness
    fvm dart run build_runner build --build-filter="{{path}}" --delete-conflicting-outputs --force-jit || true
    print_style '' 'yellow' '< code generated: {{path}}'

codegen-watch:
    #!/bin/bash
    set -euo pipefail
    cd mapness
    fvm dart run build_runner watch --delete-conflicting-outputs --force-jit || true

open_built:
    print_style '' 'yellow' 'Open built folder with:'
    print_style 'bold' 'cyan' 'just open_built'
    open build/app/outputs/flutter-apk

build_pigeon:
    #!/bin/bash
    set -euo pipefail

    cd urbi_map/dgis_map
    fvm flutter pub get
    fvm dart run build_runner build --delete-conflicting-outputs || true

    cd ../dgis_map_platform_interface/
    fvm flutter pub get
    fvm dart run build_runner build --delete-conflicting-outputs || true

    print_style '' 'yellow' '> build pigeons...'
    mkdir -p mkdir lib/src/pigeons/ ../dgis_map/android/src/main/kotlin/com/dgis/map/map_api/
    fvm dart pub run pigeon --input pigeons/messages.dart
    print_style '' 'yellow' '< pigeons ready'

build_apk_qa:
    #!/bin/bash
    set -euo pipefail
    print_style '' 'yellow' '> build apk...'
    fvm flutter build apk --flavor stg --target lib/main_stg.dart --release  {{ dart_define }}
    print_style '' 'yellow' '< build ready'

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
    print_style '' 'yellow' 'remove splash screen to speed up development'
    git apply mapness/scripts/disable-splash-screen.patch || print_style '' 'red' 'could not remove splash screen appearance'

apply-patches-ios:
    #!/usr/bin/env bash
    set -euo pipefail

    # print_style '' 'yellow' 'add abi filter'
    # git apply .github/workflows/abi_filter.patch || print_style '' 'red' 'could not apply abi filter patch' #NOT USED ON IOS
    print_style '' 'yellow' 'remove app version force update'
    git apply mapness/scripts/disable-force-update.patch || print_style '' 'red' 'could not remove app version force update'
    print_style '' 'yellow' 'remove splash screen to speed up development'
    git apply mapness/scripts/disable-splash-screen.patch || print_style '' 'red' 'could not remove splash screen appearance'

unapply-patches:
    #!/usr/bin/env bash
    set -euo pipefail

    print_style '' 'yellow' 'restore app version force update'
    git apply -R mapness/scripts/disable-force-update.patch || print_style '' 'red' 'could not restore app version force update'
    print_style '' 'yellow' 'remove abi filter'
    git apply -R .github/workflows/abi_filter.patch || print_style '' 'red' 'could not unapply abi filter patch'
        print_style '' 'yellow' 'restore splash screen'
    git apply -R mapness/scripts/disable-splash-screen.patch || print_style '' 'red' 'could not restore splash screen'

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
        rm -f ${HOME}/.cocoapods/repos/cocoapods/.git/index.lock
        pod repo update || true
        pod update
        pod install
        echo
        print_style '' 'yellow' '< pod install fixed!'
    fi

dev-env-setup:
    ./mapness/scripts/dev-env-setup.sh

download-sdk:
    #!/usr/bin/env bash
    latestSDK='10.2.2'
    if [[ $(< .sdk-version) == $latestSDK ]]; then
        print_style '' 'green' 'SDK already up-to date'
        exit
    fi

    print_style '' 'yellow' 'Downloading new SDK release'
    curl -u "balady-developers:4Itn0|w3" -O https://artifactory.2gis.dev/vendor-ios-release/$latestSDK/Release/DGisFullSDK.zip
    rm -rf urbi_map/dgis_map/ios/_DELETE_ME_/DGis.xcframework
    unzip DGisFullSDK.zip -d urbi_map/dgis_map/ios/_DELETE_ME_
    rm DGisFullSDK.zip
    curl -u "balady-developers:4Itn0|w3" -O https://artifactory.2gis.dev/vendor-maven-release/ru/dgis/sdk/sdk-full/$latestSDK/sdk-full-$latestSDK.aar
    mkdir -p urbi_map/dgis_map/android/_delete_me_
    mv sdk-full-$latestSDK.aar urbi_map/dgis_map/android/_delete_me_/sdk-full-latest.aar
    print_style '' 'green' 'SDK version saved to .sdk-version'
    echo $latestSDK > .sdk-version

codegen_cached:
    #!/bin/bash
    set -euo pipefail
    print_style '' 'yellow' '> generate code...'
    cd mapness
    fvm dart run cached_build_runner build || true
    print_style '' 'yellow' '< code generated'

bump_version:
major:
    ./bump_version.sh major
minor:
    ./bump_version.sh minor
patch:
    ./bump_version.sh patch
candidate:
    ./bump_version.sh candidate
