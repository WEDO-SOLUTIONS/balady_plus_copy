require "adsedare"
require "adsedare_mattermost"

$adsedare = Adsedare

KC="#{Dir.home}/Library/Keychains/build.keychain"
KC_PASS='build-pass'

provider = AdsedareMattermost::Provider.new(
  lambda do |messages|
    apple_message = messages.find { |message| message.include?("Apple") && message.include?(ENV["APPLE_DEVELOPER_PHONE"]) }

    if apple_message.nil?
      return nil
    end

    code = apple_message.match(/Your Apple Account Code is: (\d{6})/).captures[0]
    return code
  end
)
Starship::set_provider(provider)


$adsedare.renew_profiles("ios/Runner.xcodeproj", "773CV7UR97")
$adsedare.patch_project("ios/Runner.xcodeproj")
$adsedare.install_profiles("ios/Runner.xcodeproj")
$adsedare.create_keychain(KC, KC_PASS)
$adsedare.make_export_options("ios/Runner.xcodeproj", "ios/ad_hoc_options.plist")
