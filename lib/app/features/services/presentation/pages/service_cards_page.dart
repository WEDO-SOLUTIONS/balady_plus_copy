import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../_shared_feature_/shared_feature_exports.dart'
    show DefaultAppBarWidget, ElevatedButtonWidget;
import '../../services_exports.dart'
    show
        ServiceCardDescription,
        ServiceCardsCubit,
        ServiceCardsList,
        ServiceEntity,
        ServiceWarningWidget;

class ServiceCardsPage extends StatefulWidget {
  const ServiceCardsPage({
    super.key,
  });

  @override
  State<ServiceCardsPage> createState() => _ServiceCardsPageState();
}

class _ServiceCardsPageState extends State<ServiceCardsPage> {
  late final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    service = ModalRoute.of(context)!.settings.arguments as ServiceEntity;

    return BlocProvider(
      create: (context) => ServiceCardsCubit(service),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: service.title,
          bottom: ServiceCardsList(
            cards: service.cards,
          ),
        ),
        body: Column(
          children: [
            const Expanded(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  ServiceCardDescription(),
                ],
              ),
            ),
            if (service.warning != null)
              ServiceWarningWidget(
                warning: service.warning!,
              )
            else
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButtonWidget.startService(
                    onPressed: () {},
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
