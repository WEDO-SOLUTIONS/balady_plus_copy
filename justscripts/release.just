ios-release: apply-patches prebuild ios_setup && unapply-patches
    #!/usr/bin/env bash
    momrahBundle='momra.balady.ios'
    urbiBundle='ae.urbi.balady'

    momrahTeam='9VKA788PDD'
    urbiTeam='A34FT8KT4H'

    appDisplayNameProd='$(APP_DISPLAY_NAME)';
    appDisplayNameDev='Balady Dev';

    set -euxo pipefail
    sed -i '' "s/$momrahBundle/$urbiBundle/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$momrahTeam/$urbiTeam/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$appDisplayNameProd/$appDisplayNameDev/" ios/Runner/Info.plist
    git apply mapness/scripts/sdkkey.patch || print_style '' 'red' 'could not apply sdk key patch'
    git apply mapness/scripts/icon.patch || print_style '' 'red' 'could not apply ios icon patch'
    fvm flutter build ipa --target lib/main_dev.dart --flavor dev
    sed -i '' "s/$urbiBundle/$momrahBundle/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$urbiTeam/$momrahTeam/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$appDisplayNameDev/$appDisplayNameProd/" ios/Runner/Info.plist
    git apply -R mapness/scripts/sdkkey.patch || print_style '' 'red' 'could not unapply sdk key patch'
    git apply -R mapness/scripts/icon.patch || print_style '' 'red' 'could not unapply ios icon patch'
    open build/ios/archive/Runner.xcarchive

ios-ad-hoc version: apply-patches prebuild ios_setup && unapply-patches
    #!/usr/bin/env bash
    # One day fuckin flutter will not ignore export options....
    momrahBundle='momra.balady.ios'
    urbiBundle='ae.urbi.balady'

    momrahTeam='9VKA788PDD'
    urbiTeam='A34FT8KT4H'

    codeSignAutomatic='CODE_SIGN_STYLE = Automatic;'
    codeSignManual='CODE_SIGN_STYLE = Manual;'

    codeSignIdentityDevelopment='CODE_SIGN_IDENTITY = "Apple Development";'
    codeSignIdentityDistribution='CODE_SIGN_IDENTITY = "iPhone Distribution";'

    provisionProfileNone='PROVISIONING_PROFILE_SPECIFIER = "";'
    provisionProfileAdHoc='PROVISIONING_PROFILE_SPECIFIER = "Balady Ad Hoc";'

    appDisplayNameProd='$(APP_DISPLAY_NAME)';
    appDisplayNameDev='Balady Dev';

    set -euxo pipefail
    sed -i '' "s/$momrahBundle/$urbiBundle/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$momrahTeam/$urbiTeam/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignAutomatic/$codeSignManual/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignIdentityDevelopment/$codeSignIdentityDistribution/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$provisionProfileNone/$provisionProfileAdHoc/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$appDisplayNameProd/$appDisplayNameDev/" ios/Runner/Info.plist
    git apply mapness/scripts/sdkkey.patch || print_style '' 'red' 'could not apply sdk key patch'
    git apply mapness/scripts/icon.patch || print_style '' 'red' 'could not apply ios icon patch'
    fvm flutter build ipa --release --export-options-plist ios/ad_hoc_options.plist --target lib/main_dev.dart --flavor dev
    sed -i '' "s/$urbiBundle/$momrahBundle/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$urbiTeam/$momrahTeam/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignManual/$codeSignAutomatic/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignIdentityDistribution/$codeSignIdentityDevelopment/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$provisionProfileAdHoc/$provisionProfileNone/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$appDisplayNameDev/$appDisplayNameProd/" ios/Runner/Info.plist
    git apply -R mapness/scripts/sdkkey.patch || print_style '' 'red' 'could not unapply sdk key patch'
    git apply -R mapness/scripts/icon.patch || print_style '' 'red' 'could not unapply ios icon patch'
    curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImEuc3RyaXpobmV2QHVyYmkuYWUifQ.DgmqmgZ-DeQfBt0R36s7nftEkk-XnFr6VVi2syD-jTE" -X PUT -F file=@build/ios/ipa/balady_plus.ipa https://baladyapp-builds.urbi.ae/builds/{{ version }}

ios-debug-prepare: 
    #!/usr/bin/env bash
    # One day fuckin flutter will not ignore export options....
    momrahBundle='momra.balady.ios'
    urbiBundle='ae.urbi.balady'

    momrahTeam='9VKA788PDD'
    urbiTeam='A34FT8KT4H'

    codeSignAutomatic='CODE_SIGN_STYLE = Automatic;'
    codeSignManual='CODE_SIGN_STYLE = Manual;'

    codeSignIdentityDevelopment='CODE_SIGN_IDENTITY = "Apple Development";'
    codeSignIdentityDistribution='CODE_SIGN_IDENTITY = "iPhone Distribution";'

    provisionProfileNone='PROVISIONING_PROFILE_SPECIFIER = "";'
    provisionProfileAdHoc='PROVISIONING_PROFILE_SPECIFIER = "Balady Ad Hoc";'

    appDisplayNameProd='$(APP_DISPLAY_NAME)';
    appDisplayNameDev='Balady Dev';

    set -euxo pipefail
    sed -i '' "s/$momrahBundle/$urbiBundle/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$momrahTeam/$urbiTeam/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignAutomatic/$codeSignManual/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignIdentityDevelopment/$codeSignIdentityDistribution/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$provisionProfileNone/$provisionProfileAdHoc/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$appDisplayNameProd/$appDisplayNameDev/" ios/Runner/Info.plist
    git apply mapness/scripts/sdkkey.patch || print_style '' 'red' 'could not apply sdk key patch'
    git apply mapness/scripts/icon.patch || print_style '' 'red' 'could not apply ios icon patch'

ios-debug-revert:
    #!/usr/bin/env bash
    # One day fuckin flutter will not ignore export options....
    momrahBundle='momra.balady.ios'
    urbiBundle='ae.urbi.balady'

    momrahTeam='9VKA788PDD'
    urbiTeam='A34FT8KT4H'

    codeSignAutomatic='CODE_SIGN_STYLE = Automatic;'
    codeSignManual='CODE_SIGN_STYLE = Manual;'

    codeSignIdentityDevelopment='CODE_SIGN_IDENTITY = "Apple Development";'
    codeSignIdentityDistribution='CODE_SIGN_IDENTITY = "iPhone Distribution";'

    provisionProfileNone='PROVISIONING_PROFILE_SPECIFIER = "";'
    provisionProfileAdHoc='PROVISIONING_PROFILE_SPECIFIER = "Balady Ad Hoc";'

    appDisplayNameProd='$(APP_DISPLAY_NAME)';
    appDisplayNameDev='Balady Dev';
    
    sed -i '' "s/$urbiBundle/$momrahBundle/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$urbiTeam/$momrahTeam/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignManual/$codeSignAutomatic/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$codeSignIdentityDistribution/$codeSignIdentityDevelopment/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$provisionProfileAdHoc/$provisionProfileNone/" ios/Runner.xcodeproj/project.pbxproj
    sed -i '' "s/$appDisplayNameDev/$appDisplayNameProd/" ios/Runner/Info.plist
    git apply -R mapness/scripts/sdkkey.patch || print_style '' 'red' 'could not unapply sdk key patch'
    git apply -R mapness/scripts/icon.patch || print_style '' 'red' 'could not unapply ios icon patch'    

apk-release version: apply-patches prebuild (_apk-urbi_pre-prod version) (apk-momrah-prod version) (apk-momrah-stage version) unapply-patches open_built

_apk-urbi_pre-prod version:
    print_style '' 'yellow' 'build urbi pre'
    rm -rf android/app/build
    VENDOR_CONFIG="urbi-pre-prod"
    fvm flutter build apk --flavor pre --target lib/main_urbi_pre.dart {{ dart_define }}
    mv build/app/outputs/flutter-apk/app-pre-release.apk build/app/outputs/flutter-apk/urbi-pre-{{ version }}.apk
    print_style '' 'cyan' 'urbi pre ready!'

apk-momrah-prod version:
    print_style '' 'yellow' 'build momrah prod'
    rm -rf android/app/build
    VENDOR_CONFIG="momrah-prod"
    fvm flutter build apk --flavor prod --target lib/main_prod.dart {{ dart_define }}
    mv build/app/outputs/flutter-apk/app-prod-release.apk build/app/outputs/flutter-apk/momrah-prod-{{ version }}.apk
    print_style '' 'cyan' 'momrah prod ready!'

_apk-momrah-pre version:
    print_style '' 'yellow' 'build momrah pre'
    rm -rf android/app/build
    VENDOR_CONFIG="momrah-prod"
    fvm flutter build apk --flavor pre --target lib/main_pre.dart {{ dart_define }}
    mv build/app/outputs/flutter-apk/app-pre-release.apk build/app/outputs/flutter-apk/momrah-prod-{{ version }}.apk
    print_style '' 'cyan' 'momrah pre ready!'

apk-momrah-stage version:
    print_style '' 'yellow' 'build momrah stage'
    rm -rf android/app/build
    VENDOR_CONFIG="momrah-stage"
    fvm flutter build apk --flavor stg --target lib/main_stg.dart {{ dart_define }}
    mv build/app/outputs/flutter-apk/app-stg-release.apk build/app/outputs/flutter-apk/momrah-stage-{{ version }}.apk
    print_style '' 'cyan' 'momrah stage ready!'

    print_style '' 'green' 'done, you may open build with:'
    print_style 'bold' 'yellow' 'just open_built'

_apk-momrah-stage-debug version:
    print_style '' 'yellow' 'build momrah stage debug'
    rm -rf android/app/build
    VENDOR_CONFIG="momrah-stage"
    fvm flutter build apk --flavor stg --target lib/main_stg.dart --debug {{ dart_define }}
    mv build/app/outputs/flutter-apk/app-stg-debug.apk build/app/outputs/flutter-apk/momrah-stage-debug-{{ version }}.apk
    print_style '' 'cyan' 'momrah stage debug ready!'
