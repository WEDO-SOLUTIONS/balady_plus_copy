import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../home_exports.dart' show HomeSection, ServiceArgs, ServiceCard;

class NewServices extends StatefulWidget {
  const NewServices({super.key});

  @override
  State<NewServices> createState() => _NewServicesState();
}

class _NewServicesState extends State<NewServices> {
  final List<ServiceArgs> services = [];

  @override
  void initState() {
    super.initState();
    _getServices();
  }

  Future<void> _getServices() async {
    final String data = await DefaultAssetBundle.of(context)
        .loadString("assets/services/important_services.json");
    final List<dynamic> servicesData = await json.decode(data);
    for (var element in servicesData) {
      services.add(ServiceArgs.fromMap(element));
    }
    services.removeAt(0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: "newServices".tr(),
      isNew: true,
      child: Column(
        children: List.generate(services.length, (index) {
          return ServiceCard(
            args: services[index],
            fullWidth: true,
          );
        }),
      ),
    );
  }
}
