import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../home_page/presentation/widgets/home_tag.dart';

class UsersEkramTransportationDetailsPage extends StatefulWidget {
  const UsersEkramTransportationDetailsPage({Key? key}) : super(key: key);

  @override
  State<UsersEkramTransportationDetailsPage> createState() =>
      _UsersEkramTransportationDetailsPageState();
}

class _UsersEkramTransportationDetailsPageState
    extends State<UsersEkramTransportationDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.detailsServiceBodyTransportation);
  }

  @override
  Widget build(BuildContext context) {
    DeceasedRequestDetails params =
        ModalRoute.of(context)!.settings.arguments as DeceasedRequestDetails;

    return BlocProvider(
      create: (context) => RequestDetailsBloc(
          getTrips: sl(),
          details: params,
          getDeceasedDriverRequestDetails: sl(),
          getTripsLocation: sl(),
          isDriver: false),
      child: BlocListener<RequestDetailsBloc, RequestDetailsState>(
          listener: (context, state) {
            print("state $state");
            if (state.status == BlocStatus.failure) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          },
          child: Scaffold(
            backgroundColor: AppColor.white2,
            appBar: DetailsHeader(
              titleWidget: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    "request".tr(),
                    fontSize: 20,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.blackModern700Light,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  CustomTextWidget(
                    "#${params.requestId}",
                    fontSize: 14,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: AppFontWeight.medium,
                    fontColor: AppColor.blackModern700Light,
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              IconPath.calendarIcon,
                              width: 24,
                              height: 24,
                            ),
                            CustomHorizontalSpace(width: 8),
                            CustomTextWidget(
                              params.requestDate ?? "",
                              fontColor: AppColor.blackModern500Light,
                              fontSize: 12,
                              fontWeight: AppFontWeight.bold,
                            )
                          ],
                        ),
                        HomeTag(
                          title: params.requestStatus ?? "",
                          backgroundColor: AppColor.secondary100Light,
                        )
                      ],
                    ),
                    Constants.verticalSpaceSmall,
                    // TransferInfo
                    // DriversInfo
                    //  DriversInfoWidget(),
                    // ApplicantInfo
                    ApplicantInfoWidget(),
                    // DeceasedInfo
                    DeceasedInfoWidget(),
                    // BurialInfo
                    //  BurialInfoWidget(),
                    Constants.verticalSpaceSmall,
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
