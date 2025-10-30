import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/presentation/widgets/etmam_cities_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EtmamSelectCityPage extends StatefulWidget {
  const EtmamSelectCityPage({super.key});

  @override
  State<EtmamSelectCityPage> createState() => _EtmamSelectCityPageState();
}

class _EtmamSelectCityPageState extends State<EtmamSelectCityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: trans('choose_your_city'),
        withBackImg: false,
        withCloseImg: true,
      ),
      body: Container(
        child: EtmamCitiesContainerWidget(),
      ),
    );
  }
}
