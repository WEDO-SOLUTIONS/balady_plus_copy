require "adsedare"

$adsedare = Adsedare

KC="#{Dir.home}/Library/Keychains/build.keychain"
KC_PASS='build-pass'

$adsedare.patch_project("ios/Runner.xcodeproj", "A34FT8KT4H")
$adsedare.install_profiles("ios/Runner.xcodeproj")
$adsedare.create_keychain(KC, KC_PASS)
$adsedare.make_export_options("ios/Runner.xcodeproj", "ios/ad_hoc_options.plist")
