import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_compass.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_header.dart';

class KiblahPage extends ConsumerWidget {
  const KiblahPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Material(
        color: Colors.black.withOpacity(0.6),
        child: const SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    KiblahHeader(),
                    Spacer(),
                  ],
                ),
              ),
              Center(
                child: KiblahCompass(),
              ),
            ],
          ),
        ),
      );
}
