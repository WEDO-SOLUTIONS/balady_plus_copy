import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_packages.g.dart';

@riverpod
class DgisPackages extends _$DgisPackages {
  @override
  List<PackageMessage> build() {
    final dgisController = ref.watch(dgisControllerProvider);
    dgisController.value?.listPackages().then(
          (value) => state = value.whereType<PackageMessage>().toList(),
        );

    return [];
  }

  Future<void> install(PackageMessage package) async {
    final dgisController = ref.read(dgisControllerProvider);
    await dgisController.value?.installPackage(package.id);
  }
}

@riverpod
class VoicePackages extends _$VoicePackages {
  @override
  List<VoiceMessage> build() {
    final dgisController = ref.watch(dgisControllerProvider);
    dgisController.value?.listVoices().then(
          (value) => state = value.whereType<VoiceMessage>().toList(),
        );

    return [];
  }

  Future<void> install(PackageMessage package) async {
    final dgisController = ref.read(dgisControllerProvider);
    await dgisController.value?.installVoice(package.id).then((_) => ref.invalidateSelf());
  }
}

@riverpod
class PackageProgress extends _$PackageProgress {
  @override
  int build(PackageMessage package) {
    final dgisController = ref.watch(dgisControllerProvider);
    final packageSubscription = dgisController.value?.packageProgressEvents.listen((event) {
      if (event.id == package.id) {
        state = event.progress;
      }
    });

    ref.onDispose(
      () {
        packageSubscription?.cancel();
      },
    );

    return 0;
  }
}

@riverpod
class PackageInfo extends _$PackageInfo {
  @override
  PackageInfoMessage build(PackageMessage package) {
    final dgisController = ref.watch(dgisControllerProvider);

    final packagesInfoChangedSubscription = dgisController.value?.packagesInfoChangedEvents.listen((event) {
      if (event.id == package.id) {
        state = event.packageInfo;
      }
    });
    ref.onDispose(() {
      packagesInfoChangedSubscription?.cancel();
    });

    return package.info;
  }
}
