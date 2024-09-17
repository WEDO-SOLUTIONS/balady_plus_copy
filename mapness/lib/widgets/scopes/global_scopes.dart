import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_timer_indicator.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';

class GlobalScopes extends ConsumerWidget {
  const GlobalScopes({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Init global providers
    ref
      ..watch(etaGeoSubscriberProvider.select((_) => null))
      ..watch(websocketTypeProvider.select((_) => null))
      ..watch(etaTimerIndicatorProvider.select((_) => null))
      ..watch(shareEtaProvider.select((_) => null))
      ..watch(etaServiceProvider.select((_) => null));

    return child;
  }
}
