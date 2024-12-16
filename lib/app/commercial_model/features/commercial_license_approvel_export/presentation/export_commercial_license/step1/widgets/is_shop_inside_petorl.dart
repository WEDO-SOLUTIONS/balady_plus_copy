import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import '../bloc/step1_shop_data_cubit.dart';
import 'yes_no_radio_group_widget.dart';

class IsShopInsidePetroStationWidget extends StatelessWidget {
  const IsShopInsidePetroStationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Step1ShopDataCubit, Step1ShopDataState>(
      builder: (context, state) {
        return YesNoRadioGroupWidget(
            groupName: "is_license_inside_petrol_station".tr(),
            currentValue: state.insidePetrolStation,
            onChanged: (value) {
              if (value != null)
                context.read<Step1ShopDataCubit>().updateInsidePetrol(value);
            });
        // return Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     CustomTextWidget(
        //       trans("is_license_inside_petrol_station"),
        //       fontColor: AppColor.blackModern700Light,
        //       fontSize: 16.0,
        //       textAlign: TextAlign.start,
        //       fontWeight: AppFontWeight.bold,
        //     ),
        //     const CustomVerticalSpace(height: GeneralKey.smallPadding),
        //     Expanded(
        //       child: Row(
        //         children: [
        //           Expanded(
        //             child: CustomRadioButtonEnd<bool>(
        //               title: trans("yes"),
        //               value: true,
        //               currentSelected: state.insidePetrolStation == true,
        //               onChange: (bool item) {
        //                 context
        //                     .read<CrStep4ShopDataCubit>()
        //                     .updateInsidePetrol(true);
        //               },
        //               endRadio: false,
        //               unSelectedBackgroundColor: Colors.transparent,
        //               textSize: 16,
        //             ),
        //           ),
        //           const CustomVerticalSpace(height: 10),
        //           Expanded(
        //             child: CustomRadioButtonEnd<bool>(
        //               title: trans("no"),
        //               value: true,
        //               currentSelected: state.insidePetrolStation == false,
        //               onChange: (bool item) {
        //                 context
        //                     .read<CrStep4ShopDataCubit>()
        //                     .updateInsidePetrol(false);
        //               },
        //               endRadio: false,
        //               unSelectedBackgroundColor: Colors.transparent,
        //               textSize: 16,
        //             ),
        //           ),
        //         ],
        //       ),
        //     )
        //   ],
        // );
      },
    );
  }
}
