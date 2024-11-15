import 'package:google_fonts/google_fonts.dart';
import 'package:smart_advisor/app/features/map/presentation/pages/area_page.dart';

import '../../domain/entities/gis_data_request.dart';
import '/app/core/services/services_exports.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/map/presentation/bloc/map_bloc.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import '/app/features/shared_features/widgets/custom_button.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({super.key});

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Container(
          height: 260,
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row with Close Button and Title
              Text(
                'الموقع على الخريطة',
                textAlign: TextAlign.right,
                style: AppStyle.calloutBoldStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                'حرك الخريطة لاختيار مكان',
                textAlign: TextAlign.right,
                style: AppStyle.footNoteMediumStyle
                    .copyWith(color: AppColor.textTertiaryColor),
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Custom Radio button
                    SvgPicture.asset(
                      "packages/smart_advisor/smart_advisor_assets/icons/svg/green_icon.svg",
                      colorFilter:
                          ColorFilter.mode(AppColor.primary, BlendMode.srcIn),
                    ),
                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child: Text(
                        state.gisDataResponse?.getFullAddress() ?? "",
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        style: AppStyle.textRegularStyle.copyWith(
                            color: AppColor.textPrimaryColor, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Button

              CustomButton(
                onPress: () {
                  NavigationService.navigatorKey.currentState!
                      .pop((state.gisDataResponse, state.gisDataRequest));
                  // context.read<MapBloc>().add(const ValidatePointEvent(
                  //     lat: 24.715224858134164, lon: 46.67520498856902));

                  /* showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      backgroundColor: const Color(0xff000000),
                      context: context,
                      builder: ((c) {
                        return AreaPage(
                          params: context.read<MapBloc>().args.copyWith(
                              gisData: state.gisDataResponse,
                              gisRequest: state.gisDataRequest),
                        );
                      }));*/
                },
                text: "confirm_location".tr(),
                btnHeight: 45,
                btnColor: AppColor.primary, // AppColor.statusAccentColor,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
