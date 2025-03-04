import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/presentation/pages/etmam_select_city_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CityServicesEtmamMainPage extends StatelessWidget {
  const CityServicesEtmamMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<CityBloc>(),
      child: BlocBuilder<CityBloc, CityState>(
        builder: (context, state) {
          return CommonProperties.cityItem != null
              ? const EtmamHomePage(isMunicipalService: false)
              : const EtmamSelectCityPage();
        },
      ),
    );
  }
}
