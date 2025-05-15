AD_HOC_PRIVATE_KEY="$RUNNER_TEMP/balady.p12"
AD_HOC_CERTIFICATE="$RUNNER_TEMP/balady.cer"

echo "$FILE_BALADY_CER" | base64 --decode > $AD_HOC_CERTIFICATE
echo "$FILE_BALADY_P12" | base64 --decode > $AD_HOC_PRIVATE_KEY

momrahBundle='momra.balady.ios'
urbiBundle='ae.urbi.balady'

appDisplayNameProd='$(APP_DISPLAY_NAME)';
appDisplayNameDev='Balady Dev';

sed -i '' "s/$momrahBundle/$urbiBundle/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$appDisplayNameProd/$appDisplayNameDev/" ios/Runner/Info.plist
git apply mapness/scripts/ios-appgroups.patch || echo 'could not apply ios appgroups patch'

gem install adsedare --user-install

export APPSTORE_CONNECT_KEY_ID="L2HCMP3RY2"                              
export APPSTORE_CONNECT_ISSUER_ID="b57adbf8-49b8-445a-8929-3958379ff509"
export APPSTORE_CONNECT_KEY=$(echo "$FILE_APPSTORE_KEY" | base64 --decode)

export AD_HOC_PRIVATE_KEY="$RUNNER_TEMP/balady.p12"
export AD_HOC_CERTIFICATE="$RUNNER_TEMP/balady.cer"
export AD_HOC_KEY_PASSWORD="balady"

ruby .github/scripts/adsedare.rb
