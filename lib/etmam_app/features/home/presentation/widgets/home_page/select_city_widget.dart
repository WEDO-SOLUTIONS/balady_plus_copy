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
        CustomIconButtonWidget,
        CustomTextButtonWithIconWidget,
        CustomTextWidget,
        CustomNetworkImageWidget,
        CustomSvgIconWidget,
        showDialogWidget;

class SelectCityWidget extends StatefulWidget {
  const SelectCityWidget({Key? key}) : super(key: key);

  @override
  State<SelectCityWidget> createState() => _SelectCityWidgetState();
}

class _SelectCityWidgetState extends State<SelectCityWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(
                child: Row(
                  children: [
                    CityIconWidget(
                      imagePath: CommonProperties.cityItem?.imageUrl ?? "",
                    ),
                    CityNameWidget(
                      cityName: CommonProperties.cityItem?.name ?? "",
                      onChanged: (CityItem? item) {
                        sl<CityBloc>().add(SelectCityEvent(item: item));
                        context.read<HomeBloc>().add(ChangeCityEvent());
                      },
                    ),
                  ],
                ),
              ),
              //    const NotificationIconWidget()
            ]));
      },
    );
  }
}

class CityIconWidget extends StatelessWidget {
  final String imagePath;

  const CityIconWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      margin: const EdgeInsetsDirectional.only(end: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.hunterGreen),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Colors.transparent,
      ),
      child: Center(
          child: SizedBox(
        height: 28,
        width: 28,
        child: CustomNetworkImageWidget(
          imagePath,
          imageHeight: 28,
          imageWidth: 28,
          imageFit: BoxFit.fill,
          placeHolderWidget: CustomSvgIconWidget(
            IconPath.otpLogo,
            iconSize: 28,
            iconFit: BoxFit.fill,
          ),
        ),
      )),
    );
  }
}

class CityNameWidget extends StatelessWidget {
  final String cityName;
  final Function onChanged;

  const CityNameWidget(
      {Key? key, required this.cityName, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            trans("view_services"),
            fontSize: 12,
            fontColor: AppColor.bottomNavigationShadow,
          ),
          CustomTextButtonWithIconWidget(
            mainAxisAlignment: MainAxisAlignment.start,
            btnText: cityName,
            btnTextSize: 14,
            btnTextColor: AppColorsTheme.primary700,
            btnTextWeight: AppFontWeight.w600,
            textOverflow: TextOverflow.ellipsis,
            maxLines: 1,
            withFlexible: true,
            mainAxisSize: MainAxisSize.min,
            icon: Container(
              margin: const EdgeInsets.only(top: 5),
              child: CustomSvgIconWidget(
                IconPath.arrowDown,
                iconSize: 24,
                iconColor: AppColorsTheme.primary700,
              ),
            ),
            btnPressed: () {
              showDialogWidget(context,
                  headerText: trans('change_city_dialog_header'),
                  haveBottomLine: false,
                  isFullHeight: true,
                  dialogBody: ChangeCityDialog(
                    onSelect: onChanged,
                  ));
            },
          ),
        ],
      ),
    );
  }
}

class NotificationIconWidget extends StatelessWidget {
  const NotificationIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIconButtonWidget(
      padding: EdgeInsets.zero,
      icon: const CustomSvgIconWidget(
        IconPath.notification,
        iconSize: 24,
      ),
      btnPressed: () {},
    );
  }
}
