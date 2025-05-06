KC="$HOME/Library/Keychains/build.keychain"
KC_PASS='build-pass'
KEY="$RUNNER_TEMP/balady.p12"
CERT="$RUNNER_TEMP/balady.cer"
PROFILE="$RUNNER_TEMP/balady.mobileprovision"
PROFILE_MOVING_VIOLATIONS="$RUNNER_TEMP/balady_moving_violations.mobileprovision"
PROFILE_INSIDER_NOTIFICATION_CONTENT="$RUNNER_TEMP/balady_insider_notification_content.mobileprovision"
PROFILE_INSIDER_NOTIFICATION_SERVICE="$RUNNER_TEMP/balady_insider_notification_service.mobileprovision"
APPSTORE_KEY="$RUNNER_TEMP/appstore.p8"
APPLE_CERTS=(
    "AppleWWDRCAG2.cer"
    "AppleWWDRCAG3.cer"
    "AppleWWDRCAG4.cer"
    "AppleWWDRCAG5.cer"
    "AppleWWDRCAG6.cer"
    "AppleWWDRCAG7.cer"
    "AppleWWDRCAG8.cer"
    "DeveloperIDG2CA.cer"
)

# Presetup
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles/
echo "$FILE_BALADY_CER" | base64 --decode > $CERT
echo "$FILE_BALADY_P12" | base64 --decode > $KEY
echo "$FILE_APPSTORE_KEY" | base64 --decode > $APPSTORE_KEY

# Download profile
gem install jwt --user-install
curl -H "Authorization: Bearer $(ruby .github/scripts/generate_token.rb $APPSTORE_KEY)" "https://api.appstoreconnect.apple.com/v1/profiles/7FX5AZ9RG8" | jq -r '.data.attributes.profileContent' | base64 --decode > $PROFILE
curl -H "Authorization: Bearer $(ruby .github/scripts/generate_token.rb $APPSTORE_KEY)" "https://api.appstoreconnect.apple.com/v1/profiles/4K3LCF76YR" | jq -r '.data.attributes.profileContent' | base64 --decode > $PROFILE_MOVING_VIOLATIONS
curl -H "Authorization: Bearer $(ruby .github/scripts/generate_token.rb $APPSTORE_KEY)" "https://api.appstoreconnect.apple.com/v1/profiles/UTF7RA5PYY" | jq -r '.data.attributes.profileContent' | base64 --decode > $PROFILE_INSIDER_NOTIFICATION_CONTENT
curl -H "Authorization: Bearer $(ruby .github/scripts/generate_token.rb $APPSTORE_KEY)" "https://api.appstoreconnect.apple.com/v1/profiles/6NG6VWY32Z" | jq -r '.data.attributes.profileContent' | base64 --decode > $PROFILE_INSIDER_NOTIFICATION_SERVICE

# Setup keychain
security create-keychain -p $KC_PASS $KC
security list-keychains -d user -s $KC

curl https://developer.apple.com/certificationauthority/AppleWWDRCA.cer -o $RUNNER_TEMP/AppleWWDRCA.cer
security import $RUNNER_TEMP/AppleWWDRCA.cer -k $KC -t cert -A -P '' -T /usr/bin/codesign -T /usr/bin/security -T /usr/bin/productbuild


for APPLE_CERT in ${APPLE_CERTS[@]}; do
    curl https://www.apple.com/certificateauthority/$APPLE_CERT -o $RUNNER_TEMP/$APPLE_CERT
    security import $RUNNER_TEMP/$APPLE_CERT -k $KC -t cert -A -P '' -T /usr/bin/codesign -T /usr/bin/security -T /usr/bin/productbuild
done

security import $KEY -k $KC -t priv -A -P 'balady' -T /usr/bin/codesign -T /usr/bin/security -T /usr/bin/productbuild
security import $CERT -k $KC -t cert -A -P '' -T /usr/bin/codesign -T /usr/bin/security -T /usr/bin/productbuild

security default-keychain -d user -s $KC
security set-keychain-settings $KC
security set-key-partition-list -S apple-tool:,apple: -k $KC_PASS $KC
security unlock-keychain -p $KC_PASS $KC

# Install main profile
security cms -D -i $PROFILE -k $KC > $RUNNER_TEMP/provision.plist
UUID=`/usr/libexec/PlistBuddy -c 'print UUID' $RUNNER_TEMP/provision.plist`

cp $PROFILE ~/Library/MobileDevice/Provisioning\ Profiles/$UUID.mobileprovision

# Install moving violations profile
security cms -D -i $PROFILE_MOVING_VIOLATIONS -k $KC > $RUNNER_TEMP/provision.plist
UUID=`/usr/libexec/PlistBuddy -c 'print UUID' $RUNNER_TEMP/provision.plist`

cp $PROFILE_MOVING_VIOLATIONS ~/Library/MobileDevice/Provisioning\ Profiles/$UUID.mobileprovision

# Install insider service profile
security cms -D -i $PROFILE_INSIDER_NOTIFICATION_SERVICE -k $KC > $RUNNER_TEMP/provision.plist
UUID=`/usr/libexec/PlistBuddy -c 'print UUID' $RUNNER_TEMP/provision.plist`

cp $PROFILE_INSIDER_NOTIFICATION_SERVICE ~/Library/MobileDevice/Provisioning\ Profiles/$UUID.mobileprovision

# Install insider content profile
security cms -D -i $PROFILE_INSIDER_NOTIFICATION_CONTENT -k $KC > $RUNNER_TEMP/provision.plist
UUID=`/usr/libexec/PlistBuddy -c 'print UUID' $RUNNER_TEMP/provision.plist`

cp $PROFILE_INSIDER_NOTIFICATION_CONTENT ~/Library/MobileDevice/Provisioning\ Profiles/$UUID.mobileprovision

security find-identity -p codesigning
