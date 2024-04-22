import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/bloc/request_ownership_transfer_details_cubit.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/widgets/request_ownership_transfer_details_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/balady_features/widgets/shared/circle_icon.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../widgets/reject_request_transfer_popup.dart';

class RequestOwnershipTransferDetailsPage extends StatefulWidget {
  const RequestOwnershipTransferDetailsPage({super.key});

  @override
  State<RequestOwnershipTransferDetailsPage> createState() =>
      _RequestOwnershipTransferDetailsPageState();
}

class _RequestOwnershipTransferDetailsPageState
    extends State<RequestOwnershipTransferDetailsPage> {
  RequestOwnershipTransferDetailsCubit? bloc;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      bloc!.getCommercialLicenseDetailsById(bloc!.requestID!);
    });
    CommonFunctions.sendUXCamEvent(UXCamEvents.openLicensesDetails);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    String requestNumber = data['requestNumber'];
    bool? isReadonly = data['isReadonly'];
    return BlocProvider(
      create: (context) {
        bloc = RequestOwnershipTransferDetailsCubit(
            requestOwnershipTransferDetailsRepository: sl(),
            acceptOrRejectRequestOwnershipTransferRepository: sl());

        bloc?.requestID = requestNumber;

        return bloc!;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.scaffoldBackground,
          elevation: 0,
          shadowColor: AppColor.primary100Light,
          centerTitle: false,
          // leadingWidth: showBack == true ? null : 8,
          title: Row(
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
                width: 10,
              ),
              CustomTextWidget(
                "#$requestNumber",
                fontSize: 14,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontWeight: AppFontWeight.medium,
                fontColor: AppColor.blackModern700Light,
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColor.blackModern900Light,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [],
        ),
        body: Stack(alignment: Alignment.bottomCenter, children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: RequestOwnershipTransferDetailsBody(),
          ),
          if (isReadonly ?? false)
            Container()
          else
            BlocBuilder<RequestOwnershipTransferDetailsCubit,
                RequestOwnershipTransferDetailsState>(
              builder: (blocContext, state) {

                return state.commercialLicenceDetails != null ?
                state.commercialLicenceDetails!.statusId == 10 ||
                            state.commercialLicenceDetails!.statusId == 37 ?

                SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.horizontal(
                                        start: Radius.circular(15.0),
                                        end: Radius.circular(15.0)),
                              ),
                              margin: EdgeInsets.zero,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  state.commercialLicenceDetails?.warnings
                                              .partialHeldWarnings ==
                                          null
                                      ? const SizedBox.shrink()
                                      : Row(
                                          children: [
                                            SvgPicture.asset(
                                              IconPath.infoCircle,
                                              width: 100,
                                              height: 100,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                AppColor.darkRed,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(state
                                                    .commercialLicenceDetails
                                                    ?.warnings
                                                    .partialHeldWarnings ??
                                                '')
                                          ],
                                        ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    height: 60,
                                    width: double.infinity,
                                    child: CustomElevatedButtonWidget(
                                      btnColor: AppColor.blueSkyLight800,
                                      textStyle:
                                          AppStyle.elevatedButtonStyle.copyWith(
                                        color: AppColor.blackModern50Light,
                                        fontSize: 20,
                                      ),
                                      text:
                                          "respond_to_ownership_transfer".tr(),
                                      onPressed: () {
                                        CustomPopUpsWidgets.showBottomSheet(
                                          context,
                                          child: BlocProvider.value(
                                            value: bloc!,
                                            child: BlocBuilder<
                                                RequestOwnershipTransferDetailsCubit,
                                                RequestOwnershipTransferDetailsState>(
                                              builder: (blocContext, state) {
                                                if (state.status ==
                                                    BlocRequestStatus
                                                        .submissionUpdateLoading) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }

                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: CircleIcon(
                                                            icon: Icons.close,
                                                            circleSize: 50,
                                                            iconColor: AppColor
                                                                .primary600Light,
                                                            backgroundColor:
                                                                AppColor.geyser
                                                                    .withOpacity(
                                                                        0.4),
                                                            iconSize: 25,
                                                          ),
                                                        ),
                                                      ),
                                                      SvgPicture.asset(
                                                        IconPath
                                                            .switchProfileIcon,
                                                        width: 100,
                                                        height: 100,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                          AppColor
                                                              .blueSkyLight800,
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                      Text(
                                                        'respond_to_ownership_transfer'
                                                            .tr(),
                                                        style: const TextStyle(
                                                            fontSize: 28,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        'respond_to_ownership_transfer_warning'
                                                            .tr(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Container(
                                                        height: 55,
                                                        width: double.infinity,
                                                        child:
                                                            CustomElevatedButtonWidget(
                                                          btnRadius: 5.0,
                                                          btnColor: AppColor
                                                              .blueSkyLight800,
                                                          textStyle: AppStyle
                                                              .elevatedButtonStyle
                                                              .copyWith(
                                                            color: AppColor
                                                                .blackModern50Light,
                                                            fontSize: 20,
                                                          ),
                                                          btnHeight: 40,
                                                          text:
                                                              "accept_ownership_transfer"
                                                                  .tr(),
                                                          onPressed: () {
                                                            bloc!
                                                                .acceptCommercialRequestTransfer(
                                                                    requestNumber)
                                                                .then(
                                                                    (value) => {
                                                                          if (value ==
                                                                              "sucessfull")
                                                                            {
                                                                              Navigator.of(context).pushNamed(
                                                                                RouteName.approvalSequenceMainScreen,
                                                                                arguments: bloc,
                                                                              )
                                                                            }
                                                                          else
                                                                            {

                                                                             // state.status =  BlocRequestStatus.submissionUpdateFailure
                                                                            }
                                                                        });
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 55,
                                                        width: double.infinity,
                                                        child:
                                                            CustomElevatedButtonWidget(
                                                          btnRadius: 5.0,
                                                          btnBorderColor:
                                                              Colors.red[900],
                                                          btnColor:
                                                              Colors.white,
                                                          textStyle: AppStyle
                                                              .elevatedButtonStyle
                                                              .copyWith(
                                                            color:
                                                                Colors.red[900],
                                                            fontSize: 20,
                                                          ),
                                                          btnHeight: 40,
                                                          text:
                                                              "reject_ownership_transfer"
                                                                  .tr(),
                                                          onPressed: () {
                                                      bloc!
                                                      .rejectCommercialRequestTransfer(
                                                          requestNumber)
                                                      .then((value) =>
                                                      {


                                                        if(value == true)
                                                          {

                                                            showDialog(
                                                              context: context,
                                                              builder: (_) =>
                                                                  RejectionPopup(),)
                                                          }
                                                      });



                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          height: 600,
                                          radius: 30,
                                        );
                                        // Navigator.of(context).pushNamed(
                                        //   RouteName.approvalSequenceMainScreen,
                                        //   arguments: {},
                                        // );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                    : const SizedBox.shrink()
                    : const SizedBox.shrink();
              },
            )
        ]),
      ),
    );
  }
}


