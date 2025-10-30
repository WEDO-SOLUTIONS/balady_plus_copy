import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, IconPath, trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/city/city_item.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomSvgIconWidget,
        CustomTextButtonWithIconWidget,
        CustomTextWidget,
        showDialogWidget;
import '../../../../etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';

class EtmamCityWidget extends StatelessWidget {
  const EtmamCityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityBloc, CityState>(builder: (context, cityState) {
      return BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return EtmamCityNameWidget(
            cityName: cityState.status == BlocStatus.success
                ? CommonProperties.cityItem?.name ?? ""
                : "",
            onChanged: (CityItem? item) {
              sl<CityBloc>().add(SelectCityEvent(item: item));
              context.read<HomeBloc>().add(ChangeCityEvent());
            },
          );
        },
      );
    });
  }
}

class EtmamCityNameWidget extends StatelessWidget {
  final String cityName;
  final Function onChanged;

  const EtmamCityNameWidget(
      {Key? key, required this.cityName, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialogWidget(context,
            headerText: trans('change_city_dialog_header'),
            haveBottomLine: true,
            isFullHeight: true,
            dialogBody: ChangeCityDialog(
              onSelect: onChanged,
            ));

        sl<CityBloc>().add(GetCitiesEvent());
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColor.primary900,
              width: 1,
            ),
            color: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomTextWidget(
              cityName,
              fontSize: 14,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.black50,
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: AppColor.black50,
            )
          ]),
        ),
      ),
    );
  }
}
