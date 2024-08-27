import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/blocs/commercial_license_cancel/commercial_license_cancel_bloc.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/request_attachments_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/screens/commercial_license_cancel_one_screen.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/screens/commercial_license_cancel_two_screen.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/mvvm/commercial_license_reason_cancel_view_model.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';

class CommercialLicenseCancelScreen extends StatefulWidget {
  const CommercialLicenseCancelScreen({Key? key}) : super(key: key);

  @override
  State<CommercialLicenseCancelScreen> createState() =>
      _CommercialLicenseCancelScreenState();
}

class _CommercialLicenseCancelScreenState
    extends State<CommercialLicenseCancelScreen> {
  PageController controller = PageController();
  int currentPageValue = 0;

  final List<Widget> pagesList = [
    CommercialLicenseCancelOneScreen(),
    const CommercialLicenseCancelTwoScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.CancelCommercialLicense_Open_Create_Details_Event);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    return WillPopScope(
      onWillPop: () async {
        if (currentPageValue < 0) {
          setState(() {
            currentPageValue == 0;
          });
          goToNewPage();
          return Future<bool>.value(false);
        } else {
          return (await showBackDialog());
        }
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return RequestAttachmentsViewModel(
                webService: sl(),
                requestId: data['requestId'],
              );
            },
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) =>
                CommercialLicenseReasonCancelViewModel(
              webService: sl(),
              licenseId: 0000,
              submitterInfo: null,
            ),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            // BlocProvider(
            //   create: (context) => CommercialLicenseCancelPagesBloc(),
            // ),
            BlocProvider(
              create: (context) => CommercialLicenseCancelBloc(
                webService: sl(),
                from: data['from'],
                crNumber: data['crNumber'],
                crType: data['crType'],
                reasonCancel: data['reasonCancel'],
                requestId: data['requestId'],
                availableCloseDate: data['availableCloseDate'],
              ),
            ),
          ],
          child: Column(
            children: [
              Expanded(
                child: BlocListener<CommercialLicenseCancelBloc,
                    CommercialLicenseCancelState>(
                  listener: (BuildContext contextCubit, state) {
                    if (state is CommercialLicenseCancelSucceededState) {
                      // setState(() {
                        currentPageValue++;
                      // });
                      goToNewPage();
                    }
                    if (state is SubmitCancelRequestSucceededState) {
                      Navigator.of(context).popAndPushNamed(
                        CommercialRouteName.submitApplicationSuccessfullyCancel,
                        arguments: (
                          data['from'],
                          state.submitResponse,
                          state.totalCost,
                        ),
                      );
                    }
                    if (state is CommercialLicenseCancelFailureState) {
                      // show
                      CommonFunctions.showError(state.errorMessage);
                    }
                  },
                  child: GestureDetector(
                    onTap: () => hideKeyboard(),
                    child: Scaffold(
                      appBar: DetailsAppBarTwo(
                        pageLength: pagesList.length,
                        currentStep: currentPageValue + 1,
                        backOnPress: () {
                          if (currentPageValue > 0) {
                            setState(() {
                              currentPageValue--;
                            });
                            goToNewPage();
                          } else {
                            showBackDialog();
                          }
                        },
                        onTapCloseAction: () => showBackDialog(),
                        requestNum: data['requestId'],
                      ),
                      body: PageView.builder(
                        itemCount: pagesList.length,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller,
                        itemBuilder: (context, position) {
                          return AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 300),
                            child: CommercialDebtsScreen(
                              transactionType: TransactionType.REQUEST,
                              transactionId: data['requestId'],
                              steps: [listCancelSteps[position]],
                              serviceId: CommercialLicenseServiceId
                                  .cancelCommercialLicense,
                              child: pagesList[position],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // const PreviousCancelButtons(isBtnDisabled: false),
            ],
          ),
        ),
      ),
    );
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void goToNewPage() {
    controller.animateToPage(
      currentPageValue,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  Future<bool> showBackDialog() async {
    return await showDialog(
      barrierColor: Colors.black.withOpacity(0.6),
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  IconPath.logoutIcon,
                ),
                const SizedBox(height: 16),
                CustomAutoSizeTextWidget(
                  'exit_order'.tr(),
                  textStyle: AppStyle.appBarTitleTextStyle,
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                CustomAutoSizeTextWidget(
                  'cancellation_license_message'.tr(),
                  textStyle: AppStyle.profileSectionTitleTextStyle,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButtonWidget.primaryCustom(
                  text: "save_exit".tr(),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButtonWidget.primaryCustomBorder(
                  text: 'back_order'.tr(),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
