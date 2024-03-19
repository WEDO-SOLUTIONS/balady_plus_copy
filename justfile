default:
    just --list

# define shell envs

export PATH := env_var('PATH') + ":" + absolute_path('mapness/scripts/common_functions')
export GIT_BRANCH := `git rev-parse --abbrev-ref HEAD`
export GIT_COMMIT := replace_regex(`git rev-parse HEAD`, '([a-zA-Z0-9]{8}).*', '$1') + ' ' + `git --no-pager show -s --format='%s'`
export VENDOR_CONFIG := env_var_or_default('VENDOR_CONFIG', 'unknown')
dart_define := "--dart-define=GIT_BRANCH=\"" + GIT_BRANCH + "\" --dart-define=GIT_COMMIT=\"" + GIT_COMMIT + "\" --dart-define=VENDOR_CONFIG=$VENDOR_CONFIG"

prebuild: pubget locale_gen build_pigeon download-sdk codegen

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

    cd urbi_map
    fvm flutter pub get
    fvm dart run build_runner build --delete-conflicting-outputs || true

    cd dgis_map_platform_interface/
    fvm flutter pub get
    fvm dart run build_runner build --delete-conflicting-outputs || true

    print_style '' 'yellow' '> build pigeons...'
    mkdir -p mkdir lib/src/pigeons/ ../dgis_map/android/src/main/kotlin/com/dgis/map/map_api/
    fvm dart pub run pigeon --input pigeons/messages.dart
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

ios-release: apply-patches prebuild ios_setup && unapply-patches
    #!/usr/bin/env bash
    momrahBundle='momra.balady.ios'
    baladyBundle='xyz.amoriodi.balady'

    momrahTeam='9VKA788PDD'
    baladyTeam='USDCL8J49X'

    appDisplayNameProd='$(APP_DISPLAY_NAME)';
    appDisplayNameDev='Balady Dev';

    set -euxo pipefail
    sed -i '' "s/$momrahBundle/$baladyBundle/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$momrahTeam/$baladyTeam/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$appDisplayNameProd/$appDisplayNameDev/" ios/Runner/Info.plist
    git apply mapness/scripts/sdkkey.patch || print_style '' 'red' 'could not apply sdk key patch'
    fvm flutter build ipa --target lib/main_dev.dart --flavor dev
    sed -i '' "s/$baladyBundle/$momrahBundle/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$baladyTeam/$momrahTeam/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$appDisplayNameDev/$appDisplayNameProd/" ios/Runner/Info.plist
    git apply -R mapness/scripts/sdkkey.patch || print_style '' 'red' 'could not unapply sdk key patch'
    open build/ios/archive/Runner.xcarchive

ios-ad-hoc version: apply-patches prebuild ios_setup && unapply-patches
    #!/usr/bin/env bash
    # One day fuckin' flutter will not ignore export options....
    momrahBundle='momra.balady.ios'
    baladyBundle='xyz.amoriodi.balady'

    momrahTeam='9VKA788PDD'
    baladyTeam='USDCL8J49X'

    codeSignAutomatic='CODE_SIGN_STYLE = Automatic;'
    codeSignManual='CODE_SIGN_STYLE = Manual;'

    codeSignIdentityDevelopment='CODE_SIGN_IDENTITY = "Apple Development";'
    codeSignIdentityDistribution='CODE_SIGN_IDENTITY = "iPhone Distribution";'

    provisionProfileNone='PROVISIONING_PROFILE_SPECIFIER = "";'
    provisionProfileAdHoc='PROVISIONING_PROFILE_SPECIFIER = "Balady Ad Hoc";'

    appDisplayNameProd='$(APP_DISPLAY_NAME)';
    appDisplayNameDev='Balady Dev';

    set -euxo pipefail
    sed -i '' "s/$momrahBundle/$baladyBundle/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$momrahTeam/$baladyTeam/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignAutomatic/$codeSignManual/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignIdentityDevelopment/$codeSignIdentityDistribution/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$provisionProfileNone/$provisionProfileAdHoc/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$appDisplayNameProd/$appDisplayNameDev/" ios/Runner/Info.plist
    git apply mapness/scripts/sdkkey.patch || print_style '' 'red' 'could not apply sdk key patch'
    fvm flutter build ipa --release --export-options-plist ios/ad_hoc_options.plist --target lib/main_dev.dart --flavor dev
    sed -i '' "s/$baladyBundle/$momrahBundle/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$baladyTeam/$momrahTeam/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignManual/$codeSignAutomatic/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignIdentityDistribution/$codeSignIdentityDevelopment/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$provisionProfileAdHoc/$provisionProfileNone/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$appDisplayNameDev/$appDisplayNameProd/" ios/Runner/Info.plist
    git apply -R mapness/scripts/sdkkey.patch || print_style '' 'red' 'could not unapply sdk key patch'
    curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImEuc3RyaXpobmV2QHVyYmkuYWUifQ.DgmqmgZ-DeQfBt0R36s7nftEkk-XnFr6VVi2syD-jTE" -X PUT -F file=@build/ios/ipa/balady_plus.ipa https://baladyapp-builds.urbi.ae/builds/{{ version }}

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
