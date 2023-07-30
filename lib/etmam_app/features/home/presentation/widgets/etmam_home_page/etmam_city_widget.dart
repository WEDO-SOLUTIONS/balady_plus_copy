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
    show CustomSvgIconWidget, CustomTextButtonWithIconWidget, showDialogWidget;

class EtmamCityWidget extends StatelessWidget {
  const EtmamCityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return EtmamCityNameWidget(
          cityName: CommonProperties.cityItem?.name ?? "",
          onChanged: (CityItem? item) {
            sl<CityBloc>().add(SelectCityEvent(item: item));
            context.read<HomeBloc>().add(ChangeCityEvent());
          },
        );
      },
    );
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
    return CustomTextButtonWithIconWidget(
      mainAxisAlignment: MainAxisAlignment.start,
      btnText: cityName,
      btnTextSize: 18,
      btnTextColor: AppColor.white,
      btnTextWeight: AppFontWeight.w600,
      textOverflow: TextOverflow.ellipsis,
      maxLines: 1,
      withFlexible: true,
      mainAxisSize: MainAxisSize.min,
      icon: Container(
        margin: const EdgeInsets.only(top: 5),
        child: CustomSvgIconWidget(
          IconPath.arrowDownWhite,
          iconSize: 18,
        ),
      ),
      btnPressed: () {
        showDialogWidget(context,
            headerText: trans('change_city_dialog_header'),
            haveBottomLine: true,
            isFullHeight: true,
            dialogBody: ChangeCityDialog(
              onSelect: onChanged,
            ));
      },
    );
  }
}
