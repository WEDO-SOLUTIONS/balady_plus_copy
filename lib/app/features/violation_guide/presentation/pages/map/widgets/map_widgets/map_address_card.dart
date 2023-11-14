import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class MapAddressCard extends StatefulWidget {
  final String? address;
  final Function submitLocation;
  final bool isValidLocation;

  const MapAddressCard({
    Key? key,
    this.address,
    required this.submitLocation,
    required this.isValidLocation,
  }) : super(key: key);

  @override
  _MapAddressCard createState() => _MapAddressCard();
}

class _MapAddressCard extends State<MapAddressCard> {
  bool isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    isButtonDisabled = (widget.address != null && widget.isValidLocation);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CustomTextWidget(
                    ('address').tr(),
                    fontColor: AppColor.primary900Light,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 15,
                    textAlign: TextAlign.start,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      IconPath.vdMapMarkerIcon,
                      height: 18.0,
                      width: 18.0,
                    ),
                    const CustomHorizontalSpace(
                      width: 5,
                    ),
                    Expanded(
                        child: CustomTextWidget(
                      widget.address != null
                          ? widget.address!
                          : ('choose_location').tr(),
                      fontColor: AppColor.black500,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 14,
                      textOverflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: EnhancedCustomElevatedButtonWidget(
                  btnTextColor:
                      !isButtonDisabled ? AppColor.black400 : AppColor.white,
                  btnColor: !isButtonDisabled
                      ? AppColor.black200
                      : AppColor.primary900Light,
                  btnPressed:
                      !isButtonDisabled ? null : () => widget.submitLocation(),
                  btnText: ("lbl_confirm_incident_address").tr(),
                  btnTextSize: 15,
                  btnTextWeight: AppFontWeight.regular,
                  btnHeight: 50,
                  btnRadius: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
