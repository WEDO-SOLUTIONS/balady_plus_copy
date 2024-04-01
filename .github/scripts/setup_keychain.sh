KC="$HOME/Library/Keychains/build.keychain"
KC_PASS='build-pass'
KEY="$RUNNER_TEMP/balady.p12"
CERT="$RUNNER_TEMP/balady.cer"
PROFILE="$RUNNER_TEMP/balady.mobileprovision"
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
echo "$FILE_BALADY_MOBILEPROVISION" | base64 --decode > $PROFILE

# Setup keychain
security create-keychain -p $KC_PASS $KC
security list-keychains -d user -s $KC

curl https://developer.apple.com/certificationauthority/AppleWWDRCA.cer -o $RUNNER_TEMP/AppleWWDRCA.cer
security import $RUNNER_TEMP/AppleWWDRCA.cer -k $KC -t cert -A -P '' -T /usr/bin/codesign -T /usr/bin/security -T /usr/bin/productbuild

# curl https://www.apple.com/appleca/AppleIncRootCertificate.cer -o $RUNNER_TEMP/AppleIncRootCertificate.cer
# security import $RUNNER_TEMP/AppleIncRootCertificate.cer -k $KC -t cert -A -P ''

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

# Install profile
security cms -D -i $PROFILE -k $KC > $RUNNER_TEMP/provision.plist
UUID=`/usr/libexec/PlistBuddy -c 'print UUID' $RUNNER_TEMP/provision.plist`

cp $PROFILE ~/Library/MobileDevice/Provisioning\ Profiles/$UUID.mobileprovision

security find-identity -p codesigning
