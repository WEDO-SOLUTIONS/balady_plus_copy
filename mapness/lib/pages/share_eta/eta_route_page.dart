import 'package:balady_uikit/balady_uikit.dart' show Spacing;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/ui/eta_arrival_card/eta_arrival_card.dart';

class EtaRoutePage extends ConsumerWidget {
  const EtaRoutePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(etaGeoSubscriberProvider);

    return const Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Spacer(),
          Padding(
            padding: EdgeInsets.all(Spacing.$4x),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ZoomControl(),
              ],
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: EtaArrivalCard(),
          ),
        ],
      ),
    );
  }
}
