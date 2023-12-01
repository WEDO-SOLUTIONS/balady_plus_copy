prebuild: && build_pigeon codegen
  #!/bin/bash
  set -euo pipefail
  cd mapness
  fvm flutter pub get
  

assemble:
  fvm flutter build apk --target lib/main_dev.dart

_run_command_in_projects command:
  #!/bin/bash
  set -euo pipefail

  paths=$(fd -tf -a 'pubspec\.yaml' -x echo {//})
  for p in ${paths}; do
    echo
    echo $p
    cd $p
    {{command}}
  done

codegen_all: (_run_command_in_projects "fvm dart run build_runner build --delete-conflicting-outputs || true")

pub_get_all: (_run_command_in_projects "fvm flutter pub get")

delete_codegen:
  # fd -tf '\.(g|freezed)\.dart' -X rm
  fd -HI -tf '\.(g|freezed)\.dart' -X rm

locale_gen:
  #!/bin/bash
  set -euo pipefail

  cd mapness
  fvm flutter gen-l10n # --arb-dir=lib/src/l10n/ --template-arb-file=intl_ru.arb --output-localization-file=generated/ --output-class=AppLocalization --output-dir=lib/src/l10n/generated/app_localizations --no-synthetic-package

kill_codegen_watch:
  tmux kill-session -t codegen

codegen_all_watch:
  #!/bin/bash
  set -euo pipefail

  # Define the jobs array
  paths=($(fd -tf -a 'pubspec\.yaml' -x echo {//} | sort | uniq))

  # Start a new tmux session
  tmux new-session -d -s codegen || true

  for i in ${!paths[@]}; do
    # add pane
    tmux split-window -v
    # run job
    tmux send-keys -t $i "cd ${paths[i]}; fvm dart run build_runner watch --delete-conflicting-outputs" C-m
    # Divide the window into panes
    tmux select-layout tiled
  done

  tmux attach-session -t codegen

[no-cd]
codegen:
  fvm dart run build_runner build --delete-conflicting-outputs || true

[no-cd]
codegen-watch:
  fvm dart run build_runner watch --delete-conflicting-outputs || true

build: build_pigeon && assemble
  cd ./mapness && fvm dart run build_runner build --delete-conflicting-outputs 


build_full: pub_get_all codegen_all build_pigeon build

open_built:
  open build/app/outputs/flutter-apk

build_pigeon:
  #!/bin/bash
  set -euo pipefail
  cd urbi_map/dgis_map_platform_interface/
  
  echo build pigeons
  # fvm flutter pub run pigeon --input pigeons/messages.dart
  ./pigeon.sh
  echo pigeons ready

run:
  fvm flutter run --target lib/main_dev.dart

protoc:
  #!/bin/bash
  set -euo pipefail
  cd mapness
  protoc protocol.proto --dart_out=lib/_generated/protocol
