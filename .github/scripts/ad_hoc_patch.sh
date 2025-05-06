momrahBundle='momra.balady.ios'
urbiBundle='ae.urbi.balady'

momrahVehicleBundle='momra.balady.ios.movingViolation'
urbiVehicleBundle='ae.urbi.balady.movingViolations'

momrahTeam='9VKA788PDD'
urbiTeam='A34FT8KT4H'

codeSignAutomatic='CODE_SIGN_STYLE = Automatic;'
codeSignManual='CODE_SIGN_STYLE = Manual;'

codeSignIdentityDevelopment='CODE_SIGN_IDENTITY = "Apple Development";'
codeSignIdentityDistribution='CODE_SIGN_IDENTITY = "iPhone Distribution";'

provisionProfileAeSpecifier='AE_PROVISIONING_PROFILE_SPECIFIER'
provisionProfileSpecifier='PROVISIONING_PROFILE_SPECIFIER'

appDisplayNameProd='$(APP_DISPLAY_NAME)';
appDisplayNameDev='Balady Dev';

sed -i '' "s/$momrahVehicleBundle/$urbiVehicleBundle/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$momrahBundle/$urbiBundle/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$momrahTeam/$urbiTeam/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$codeSignAutomatic/$codeSignManual/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$codeSignIdentityDevelopment/$codeSignIdentityDistribution/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$provisionProfileAeSpecifier/$provisionProfileSpecifier/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$appDisplayNameProd/$appDisplayNameDev/" ios/Runner/Info.plist
git apply mapness/scripts/ios-appgroups.patch || echo 'could not apply ios appgroups patch'
