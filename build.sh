cd urbi_map
cd dgis_map_platform_interface
mkdir lib/src/pigeons/
mkdir ../dgis_map/android/src/main/kotlin/com/dgis/map/map_api
flutter pub get
flutter pub run pigeon --input pigeons/messages.dart
cd ../..
cd  urbi_map/dgis_map
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
brew install just
brew tap localazy/tools
brew cleanup localazy
brew install localazy
brew tap leoafarias/fvm
brew install fvm
fvm install 3.44.5
cd ../..
cd  mapness
flutter pub run build_runner build --delete-conflicting-outputs
just prebuild