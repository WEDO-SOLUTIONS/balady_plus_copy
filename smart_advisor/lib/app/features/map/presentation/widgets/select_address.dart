import 'package:google_fonts/google_fonts.dart';
import 'package:smart_advisor/app/features/map/presentation/pages/area_page.dart';

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
          padding:
              const EdgeInsets.only(top: 8, bottom: 16, right: 16, left: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColor.textPrimaryColor.withOpacity(.10),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                      )),
                ),
              ),
              // Top Row with Close Button and Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button (without background)

                  const Expanded(
                    child: Text('الموقع علي الخريطة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'SomarSans')),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<MapBloc>().add(const ClearGISDataEvent());
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColor.textPrimaryColor.withOpacity(0.70),
                      ),
                    ),
                  ),
                ],
              ),
              // Subtitle
              const Text(
                'حرك الخريطة لاختيار مكان',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'SomarSans', //AppConfig.appFontType2,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Align content to the right
                  children: [
                    // Text for the location

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
                        style: const TextStyle(
                            fontSize: 16, fontFamily: 'SomarSans'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Radio Button for Location

              const SizedBox(height: 20),
              // Confirm Button

              CustomButton(
                onPress: () {
                  //   context.read<MapBloc>().add(const ValidatePointEvent(
                  //      lat: 24.715224858134164, lon: 46.67520498856902));

                  showModalBottomSheet(
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
                      }));
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
