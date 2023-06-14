import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../home_exports.dart' show HomeSection, ServiceArgs, ServiceCard;

class ImportantServices extends StatefulWidget {
  const ImportantServices({super.key});

  @override
  State<ImportantServices> createState() => _ImportantServicesState();
}

class _ImportantServicesState extends State<ImportantServices> {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: "importantServices".tr(),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: services.length,
          itemBuilder: (context, index) {
            return ServiceCard(
              args: services[index],
            );
          },
        ),
      ),
    );
  }
}
