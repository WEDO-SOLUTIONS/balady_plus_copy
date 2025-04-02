import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/providers/offers_screen_riverpod.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_screen_widget.dart';

@RoutePage()
class OffersScreenPage extends ConsumerWidget {
  final OffersGroup? offersGroup;

  const OffersScreenPage({this.offersGroup, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => OffersScreenWidget(
        ref.watch(offersScreenRiverpodProvider(offersGroup: offersGroup)),
      );
}
