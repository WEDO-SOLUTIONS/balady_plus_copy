import 'package:flutter/material.dart';

import '../../../_shared_feature_/shared_feature_exports.dart'
    show DefaultAppBarWidget;
import '../../services_exports.dart'
    show
        ServiceCardDescription,
        ServiceCardsList,
        ServiceEntity,
        ServiceWarningWidget;

class ServiceCardsPage extends StatelessWidget {
  final ServiceEntity service;

  const ServiceCardsPage({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: service.title,
        bottom: ServiceCardsList(
          cards: service.cards,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 16),
                ServiceCardDescription(
                  card: service.cards.first,
                ),
              ],
            ),
          ),
          if (service.warning != null)
            ServiceWarningWidget(
              warning: service.warning!,
            ),
        ],
      ),
    );
  }
}
