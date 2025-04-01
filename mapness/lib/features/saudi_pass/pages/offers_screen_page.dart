import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_screen_notifier.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_screen_widget.dart';

@RoutePage()
class OffersScreenPage extends StatelessWidget {
  final OffersScreenNotifier offersScreenNotifier;

  const OffersScreenPage({required this.offersScreenNotifier, super.key});

  @override
  Widget build(BuildContext context) => OffersScreenWidget(offersScreenNotifier);
}
