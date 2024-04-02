import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/kiblah/providers/fake_compass.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_compass.dart';
import 'package:mapness/pages/kiblah/ui/widgets/kaaba_icon.dart';

class FakeKaabIcon extends ConsumerWidget {
  const FakeKaabIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fakeUserBearing = ref.watch(fakeCompassProvider);

    return Align(
      alignment: Alignment(
        cos(KiblahCompass.rad(0 - fakeUserBearing)),
        sin(KiblahCompass.rad(0 - fakeUserBearing)),
      ),
      child: const KaabaIcon(
        isCorrect: false,
      ),
    );
  }
}
