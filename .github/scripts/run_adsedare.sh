AD_HOC_PRIVATE_KEY="$RUNNER_TEMP/balady.p12"
AD_HOC_CERTIFICATE="$RUNNER_TEMP/balady.cer"

echo "$FILE_BALADY_CER" | base64 --decode > $AD_HOC_CERTIFICATE
echo "$FILE_BALADY_P12" | base64 --decode > $AD_HOC_PRIVATE_KEY

momrahBundle='momra.balady.ios'
urbiBundle='ae.urbi-service.balady'

momrahTeamId='9VKA788PDD'
urbiTeamId='2L8V399M5W'

appDisplayNameProd='$(APP_DISPLAY_NAME)';
appDisplayNameDev='Balady Dev';

sed -i '' "s/$momrahBundle/$urbiBundle/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$momrahTeamId/$urbiTeamId/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$appDisplayNameProd/$appDisplayNameDev/" ios/Runner/Info.plist
git apply mapness/scripts/ios-appgroups.patch || echo 'could not apply ios appgroups patch'

export APPSTORE_CONNECT_KEY_ID="UPT425R2C6"
export APPSTORE_CONNECT_ISSUER_ID="76db13ba-00ef-4fa1-9a84-7de28e0cd342"
export APPSTORE_CONNECT_KEY=$(echo "$FILE_APPSTORE_KEY" | base64 --decode)

export APPLE_DEVELOPER_USERNAME="apple.dev01@urbi.ae"
export APPLE_DEVELOPER_PHONE="+971551659890"

export ADSEDARE_MM_HOST="https://mm.ouo-stg.com"
export ADSEDARE_MM_TEAM_NAME="urbi"
export ADSEDARE_MM_CHANNEL_NAME="sms-public"
export ADSEDARE_MM_TIMEOUT_SECONDS=15

export AD_HOC_PRIVATE_KEY="$RUNNER_TEMP/balady.p12"
export AD_HOC_CERTIFICATE="$RUNNER_TEMP/balady.cer"
export AD_HOC_KEY_PASSWORD="balady"

bundle install --gemfile .github/scripts/Gemfile
bundle exec --gemfile .github/scripts/Gemfile ruby .github/scripts/adsedare.rb
