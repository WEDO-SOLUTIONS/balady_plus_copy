require "adsedare"
require "adsedare_mattermost"

include Logging

$adsedare = Adsedare

KC="#{Dir.home}/Library/Keychains/build.keychain"
KC_PASS='build-pass'

provider = AdsedareMattermost::Provider.new(
  lambda do |messages|
    logger.info "[MM] Messages received: #{messages.size}"

    apple_message = messages.find { |message| message.include?("Apple") }

    if apple_message.nil?
      logger.info "[MM] Apple message not found"
      return nil
    end

     logger.info "[MM] Apple message found: #{apple_message}"

    code = apple_message.match(/Your Apple Account Code is: (\d{6})/).captures[0]

    if code.nil?
      logger.info "[MM] Apple message found, but code NOT matched"
      return nil
    end

    logger.info "[MM] Code #{code}"

    return code
  end
)
Starship::set_provider(provider)

$adsedare.renew_profiles("ios/Runner.xcodeproj", "2L8V399M5W")
$adsedare.patch_project("ios/Runner.xcodeproj")
$adsedare.install_profiles("ios/Runner.xcodeproj")
$adsedare.create_keychain(KC, KC_PASS)
$adsedare.make_export_options("ios/Runner.xcodeproj", "ios/ad_hoc_options.plist")
