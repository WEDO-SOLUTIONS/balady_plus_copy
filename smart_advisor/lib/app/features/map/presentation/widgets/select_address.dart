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
  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
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
              // Top Row with Close Button and Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button (without background)

                  Expanded(
                    child: Text(
                      'الموقع علي الخريطة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.surfacePrimaryColor,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Align content to the right
                  children: [
                    // Text for the location

                    // Custom Radio button
                    SvgPicture.asset(
                        "packages/smart_advisor/smart_advisor_assets/icons/svg/green_icon.svg"),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        state.gisDataResponse?.getFullAddress() ?? "",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              // Subtitle
              Text(
                'حرك الخريطة لاختيار مكان',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              // Radio Button for Location

              SizedBox(height: 20),
              // Confirm Button

              CustomButton(
                onPress: () {
                  NavigationService.navigatorKey.currentState!.pushNamed(
                      RouteName.areaPage,
                      arguments: context.read<MapBloc>().args.copyWith(
                          gisData: state.gisDataResponse,
                          gisRequest: state.gisDataRequest));
                },
                text: "confirm_location".tr(),
                btnColor: AppColor.statusAccentColor,
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
