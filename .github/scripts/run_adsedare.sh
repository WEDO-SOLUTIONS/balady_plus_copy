KEY="$RUNNER_TEMP/balady.p12"
CERT="$RUNNER_TEMP/balady.cer"
APPSTORE_KEY="$RUNNER_TEMP/appstore.p8"

echo "$FILE_BALADY_CER" | base64 --decode > $CERT
echo "$FILE_BALADY_P12" | base64 --decode > $KEY
echo "$FILE_APPSTORE_KEY" | base64 --decode > $APPSTORE_KEY

momrahBundle='momra.balady.ios'
urbiBundle='ae.urbi.balady'

appDisplayNameProd='$(APP_DISPLAY_NAME)';
appDisplayNameDev='Balady Dev';

sed -i '' "s/$momrahBundle/$urbiBundle/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$appDisplayNameProd/$appDisplayNameDev/" ios/Runner/Info.plist
git apply mapness/scripts/ios-appgroups.patch || echo 'could not apply ios appgroups patch'

gem install adsedare --user-install

ruby .github/scripts/adsedare.rb
