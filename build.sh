#!/bin/bash
set -euo pipefail


printlnln(){
echo
echo $@
echo
}
urbi_dir=$(pwd)
cd urbi_map/dgis_map_platform_interface/

echo "----- build pigeons -----"
echo '...'
# fvm flutter pub run pigeon --input pigeons/messages.dart
./pigeon.sh
echo "----- pigeons ready -----"

printlnln "----- codegen  -----"

cd $urbi_dir/mapness && fvm dart run build_runner build --delete-conflicting-outputs 

printlnln "----- codegen ready -----"


cd $urbi_dir

printlnln "----- build flutter -----"
fvm flutter build apk --target lib/main_dev.dart
printlnln "----- flutter ready -----"

printlnln "apk is here: build/app/outputs/flutter-apk"
