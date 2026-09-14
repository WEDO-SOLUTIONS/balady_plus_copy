import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/analytics_events.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_features/rating_feature/models/rating_request.dart';
import '../../../_shared_features/rating_feature/widgets/submit_rating_widget.dart';
import '../../data/entities/success_screen_args.dart';
import '../buttons/elevated_button_widgets.dart';
import '../dialogs/bottom_sheet_dialogs.dart';
import '../widgets/buttons/custom_buttons_widgets.dart';
import '../widgets/custom_spaces_widgets.dart';
import '../widgets/texts/custom_text_widget.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SuccessScreenArgs successScreenArgs = ModalRoute.of(context)!.settings.arguments as SuccessScreenArgs;
      sendSuccessEvent(successScreenArgs.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    SuccessScreenArgs successScreenArgs = ModalRoute.of(context)!.settings.arguments as SuccessScreenArgs;

    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(ImagePath.successPageBackground), fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).padding.top + 10, start: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(IconPath.qrWhiteCloseIcon, height: 20.0, width: 20.0, color: Colors.black),
              ),
            ),
            SuccessBody(successScreenArgs: successScreenArgs),
            SuccessButtons(
              fromHomePage: successScreenArgs.fromHomePage ?? false,
              pageType: successScreenArgs.type,
              isFawry: successScreenArgs.isFawry ?? false,
              requestId: successScreenArgs.idNumber,
            ),
          ],
        ),
      ),
    );
  }

  void sendSuccessEvent(PAGE_TYPE type) {
    switch (type) {
      case PAGE_TYPE.emtethal:
        CommonFunctions.sendEventToAnalytics(AppEvents.createComplianceSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceComplianceCertificate);
        break;
      case PAGE_TYPE.deleteEmtethal:
        break;
      case PAGE_TYPE.appointmentScreen:
        CommonFunctions.sendEventToAnalytics(AppEvents.makeAppointmentSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceAppointmentBooking);

        break;

      case PAGE_TYPE.updateAppointment:
        break;
      case PAGE_TYPE.cancelAppointment:
        CommonFunctions.sendEventToAnalytics(AppEvents.cancelAppointmentSuccess);

        break;

      case PAGE_TYPE.confirmAppointment:
        CommonFunctions.sendEventToAnalytics(AppEvents.confirmAppointmentSuccess);

        break;

      case PAGE_TYPE.daem:
        CommonFunctions.sendEventToAnalytics(AppEvents.DaemSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceDaem);
        break;

      case PAGE_TYPE.dc:
        CommonFunctions.sendEventToAnalytics(AppEvents.damagedCarsReportSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceReportWriteOffVehicle);
        break;

      case PAGE_TYPE.vhr:
        CommonFunctions.sendEventToAnalytics(AppEvents.vhrRequestSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceRetrieveImpoundedVehicle);

        break;

      case PAGE_TYPE.deleteRequestScreen:
        CommonFunctions.sendEventToAnalytics(AppEvents.IssuHealthCertDeleteSuccess);

        break;

      case PAGE_TYPE.facilityIncidentScreen:
        CommonFunctions.sendEventToAnalytics(AppEvents.snapAndSendSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceSnapAndSend);

        break;

      case PAGE_TYPE.incidentsScreen:
        CommonFunctions.sendEventToAnalytics(AppEvents.snapAndSendSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceSnapAndSend);

        break;

      case PAGE_TYPE.inquiry:
        CommonFunctions.sendEventToAnalytics(AppEvents.generalInqSuccess);

        break;

      case PAGE_TYPE.msr:
        CommonFunctions.sendEventToAnalytics(AppEvents.municipalRequestSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceMunicipalServiceRequest);

        break;
      case PAGE_TYPE.newVD:
        CommonFunctions.sendEventToAnalytics(AppEvents.snapAndSendSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceSnapAndSend);

        break;

      case PAGE_TYPE.objction:
        CommonFunctions.sendEventToAnalytics(AppEvents.objectableSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceAppealRequest);

        break;
      case PAGE_TYPE.qrDetailsScreen:
        CommonFunctions.sendEventToAnalytics(AppEvents.snapAndSendSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceSnapAndSend);

        break;

      case PAGE_TYPE.qrDialog:
        CommonFunctions.sendEventToAnalytics(AppEvents.snapAndSendSuccess);
        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.finishServiceSnapAndSend);

        break;

      case PAGE_TYPE.ratingScreen:
        break;

      case PAGE_TYPE.licenseScreen:
        break;

      case PAGE_TYPE.coObserver:
        break;

      case PAGE_TYPE.contactUs:
        break;

      case PAGE_TYPE.visitScreen:
        break;

      case PAGE_TYPE.renewCommercial:
      case PAGE_TYPE.ekramCemetry:
      case PAGE_TYPE.other:
        break;
    }
  }
}

class SuccessBody extends StatelessWidget {
  final SuccessScreenArgs? successScreenArgs;

  const SuccessBody({super.key, this.successScreenArgs});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(ImagePath.successPageIcon, height: 137, width: 239),
              const CustomVerticalSpace(height: 26),
              CustomTextWidget(
                getTitle(),
                fontSize: 22,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.black,
                textAlign: TextAlign.center,
                maxLines: 10,
              ),
              const CustomVerticalSpace(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomTextWidget(
                  getDesc(),
                  fontSize: 16,
                  fontWeight: AppFontWeight.medium,
                  fontColor: AppColor.black500,
                  height: 1.6,
                  maxLines: 20,
                  textAlign: TextAlign.center,
                ),
              ),

              const CustomVerticalSpace(height: 20),
              //MM
              if (successScreenArgs?.msg != null && successScreenArgs!.msg!.isNotEmpty)
                CustomHtmlTextWidget(successScreenArgs!.msg!),

              // const CustomVerticalSpace(
              //   height: 48,
              // ),
              successScreenArgs?.idNumber != null && successScreenArgs?.type == PAGE_TYPE.ekramCemetry
                  ? CustomElevatedButtonWidget(
                      btnColor: Colors.transparent,
                      textStyle: AppStyle.elevatedButtonStyle.copyWith(
                        color: AppColor.blueSkyLight800,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                      btnHeight: 56,
                      text: "service_evaluation".tr(),
                      onPressed: () {
                        BottomSheetDialog.showSheet(
                          context,
                          child: SubmitRatingSheet(
                            title: 'service_evaluation'.tr(),
                            ratingRequest: RatingRequest(requestId: int.parse(successScreenArgs!.idNumber!)),
                          ),
                          isFullHeight: false,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.6,
                        );
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  String getTitle() {
    switch (successScreenArgs?.type) {
      case PAGE_TYPE.facilityIncidentScreen:
      case PAGE_TYPE.inquiry:
      case PAGE_TYPE.incidentsScreen:
      case PAGE_TYPE.msr:
      case PAGE_TYPE.qrDetailsScreen:
      case PAGE_TYPE.qrDialog:
      case PAGE_TYPE.visitScreen:
        return ('lbl_thank_you2').tr();
      case PAGE_TYPE.ratingScreen:
      case PAGE_TYPE.licenseScreen:
      case PAGE_TYPE.contactUs:
      case PAGE_TYPE.deleteRequestScreen:
      case PAGE_TYPE.appointmentScreen:
      case PAGE_TYPE.cancelAppointment:
      case PAGE_TYPE.confirmAppointment:
      case PAGE_TYPE.coObserver:
      case PAGE_TYPE.daem:
      case PAGE_TYPE.newVD:
      case PAGE_TYPE.dc:
      case PAGE_TYPE.vhr:
      case PAGE_TYPE.objction:
      case PAGE_TYPE.emtethal:
      case PAGE_TYPE.deleteEmtethal:
      case PAGE_TYPE.renewCommercial:
      case PAGE_TYPE.ekramCemetry:
      case PAGE_TYPE.updateAppointment:
        return "vd_request_submit".tr();
      default:
        return ('lbl_thank_you').tr();
    }
  }

  String getDesc() {
    switch (successScreenArgs?.type) {
      case PAGE_TYPE.licenseScreen:
        return ('order_thanks_desc').tr().replaceAll("-", successScreenArgs?.idNumber ?? "");

      case PAGE_TYPE.ratingScreen:
        return ('lbl_evaluation_thanks_desc').tr();
      case PAGE_TYPE.facilityIncidentScreen:
      case PAGE_TYPE.incidentsScreen:
      case PAGE_TYPE.qrDetailsScreen:
      //MM
      /*case PAGE_TYPE.qrDialog:
        {
          if ((successScreenArgs?.reportType != CustomerVoiceType.Snap_Rega) &&
              (successScreenArgs?.municipilaty == "006" ||
                  successScreenArgs?.municipilaty == "004"))
            return Helpers.translatingWord(
                    'incident_success_msg_eastern_riyadh')
                .replaceAll("-", successScreenArgs?.idNumber ?? "");
          else
            return Helpers.translatingWord('inc_order_thanks_desc')
                .replaceAll("-", successScreenArgs?.idNumber ?? "");
        }*/

      case PAGE_TYPE.msr:
        return ('req_order_thanks_desc').tr().replaceAll("-", successScreenArgs?.idNumber ?? "");

      case PAGE_TYPE.visitScreen:
        return successScreenArgs?.thanksMessage ?? "";

      case PAGE_TYPE.appointmentScreen:
        return ("bookNewAppointmentSuccessfullyApplicationRecievedWord").tr().replaceAll(
          "{}",
          successScreenArgs?.idNumber ?? "",
        );
      case PAGE_TYPE.cancelAppointment:
        return ("cancel_appointment_success").tr();
      case PAGE_TYPE.confirmAppointment:
        return ("confirm_appointment_success").tr();
      case PAGE_TYPE.deleteRequestScreen:
        return ("health_request_deleted").tr();
      case PAGE_TYPE.inquiry:
        return ('inq_order_thanks_desc').tr().replaceAll("-", successScreenArgs?.idNumber ?? "");
      case PAGE_TYPE.contactUs:
        return ('lbl_we_recived_your_msg').tr();
      case PAGE_TYPE.coObserver:
        return ('success_register_co_desc').tr().replaceAll("-", successScreenArgs?.idNumber ?? "--");
      case PAGE_TYPE.daem:
        return ('daem_success_desc').tr().replaceAll("-", successScreenArgs?.idNumber ?? "--");

      case PAGE_TYPE.objction:
        return ('objection_success_message').tr().replaceAll("-", successScreenArgs?.idNumber ?? "--");

      case PAGE_TYPE.deleteEmtethal:
        return ("delete_compliance_request_message").tr().replaceAll("_", successScreenArgs?.idNumber ?? "--");

      case PAGE_TYPE.newVD:
      case PAGE_TYPE.dc:
      case PAGE_TYPE.vhr:
      case PAGE_TYPE.emtethal:
      case PAGE_TYPE.renewCommercial:
      case PAGE_TYPE.ekramCemetry:
      case PAGE_TYPE.updateAppointment:
        return successScreenArgs?.thanksMessage ?? "";

      case PAGE_TYPE.other:
        return successScreenArgs?.thanksMessage ?? "";

      default:
        return "";
    }
  }
}

class SuccessButtons extends StatelessWidget {
  final PAGE_TYPE pageType;
  bool fromHomePage;
  bool isFawry;
  String? requestId;

  SuccessButtons({super.key, required this.pageType, this.isFawry = false, this.fromHomePage = false, this.requestId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (pageType == PAGE_TYPE.emtethal && isFawry == true)
              ElevatedButtonWidget.primaryCustomBorder(
                onPressed: () {
                  onPressWhiteButton(context, requestId: requestId);
                },
                text: getWhiteBtnText(),
              ),
            const CustomVerticalSpace(height: 16),
            CustomElevatedButtonWidget(
              onPressed: () {
                onPressGreenButton(context);
              },
              btnColor: AppColor.primary900Light,
              text: getGreenBtnText(),
              btnHeight: 56,
            ),
          ],
        ),
      ),
    );
  }

  String getGreenBtnText() {
    switch (pageType) {
      case PAGE_TYPE.ratingScreen:
      case PAGE_TYPE.facilityIncidentScreen:
      case PAGE_TYPE.inquiry:
      case PAGE_TYPE.contactUs:
      case PAGE_TYPE.incidentsScreen:
      case PAGE_TYPE.newVD:
      case PAGE_TYPE.dc:
      case PAGE_TYPE.vhr:
      case PAGE_TYPE.msr:
      case PAGE_TYPE.qrDetailsScreen:
      case PAGE_TYPE.qrDialog:
      case PAGE_TYPE.appointmentScreen:
      case PAGE_TYPE.cancelAppointment:
      case PAGE_TYPE.confirmAppointment:
      case PAGE_TYPE.visitScreen:
      case PAGE_TYPE.daem:
      case PAGE_TYPE.objction:
      case PAGE_TYPE.licenseScreen:
      case PAGE_TYPE.deleteRequestScreen:
      case PAGE_TYPE.emtethal:
      case PAGE_TYPE.deleteEmtethal:
      case PAGE_TYPE.renewCommercial:
      case PAGE_TYPE.ekramCemetry:
      case PAGE_TYPE.updateAppointment:
        return ('go_to_home').tr();
      //   return Helpers.translatingWord('go_back_to_customer_voice_page');
      // case PAGE_TYPE.licenseScreen:
      // case PAGE_TYPE.deleteRequestScreen:
      //return Helpers.translatingWord('lbl_evaluate_service');
      // return ('go_to_license_management_screen').tr();
      case PAGE_TYPE.coObserver:
        return ('go_to_balady_academy').tr();

      case PAGE_TYPE.other:
        return ('close').tr();
      default:
        return "";
    }
  }

  void onPressGreenButton(BuildContext context) {
    switch (pageType) {
      case PAGE_TYPE.ratingScreen:
      case PAGE_TYPE.facilityIncidentScreen:
      case PAGE_TYPE.inquiry:
      case PAGE_TYPE.contactUs:
      case PAGE_TYPE.incidentsScreen:
      case PAGE_TYPE.newVD:
      case PAGE_TYPE.dc:
      case PAGE_TYPE.vhr:
      case PAGE_TYPE.msr:
      case PAGE_TYPE.qrDetailsScreen:
      case PAGE_TYPE.qrDialog:
      case PAGE_TYPE.appointmentScreen:
      case PAGE_TYPE.cancelAppointment:
      case PAGE_TYPE.confirmAppointment:
      case PAGE_TYPE.visitScreen:
      case PAGE_TYPE.daem:
      case PAGE_TYPE.objction:
      case PAGE_TYPE.emtethal:
      case PAGE_TYPE.deleteEmtethal:
      case PAGE_TYPE.licenseScreen:
      case PAGE_TYPE.deleteRequestScreen:
      case PAGE_TYPE.renewCommercial:
      case PAGE_TYPE.ekramCemetry:
      case PAGE_TYPE.updateAppointment:
        {
          Helpers.backNavigationToHomeScreen();
        }
        break;

        /* {
          Helpers.backNavigationToSpecificScreen2(
              navigationKey: RoutesNames.customerVoiceRoute);
        }*/
        // break;
        /* case PAGE_TYPE.licenseScreen:
      case PAGE_TYPE.deleteRequestScreen:
        {
          // "license_screen_evaluation".log();
          Navigator.of(context).pop();
        }*/
        break;
        //MM
        /*case PAGE_TYPE.coObserver:
        {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                COWebViewScreen(RemoteConfig.baladyAcademyURL),
          ));
        }*/
        break;

      case PAGE_TYPE.other:
        {
          Navigator.of(context).pop();
        }
        break;
      default:
        {
          //MM   Helpers.backNavigationToHomeScreen();
        }
        break;
    }
  }

  String getWhiteBtnText() {
    switch (pageType) {
      /* case PAGE_TYPE.incidentsScreen:
      case PAGE_TYPE.newVD:
      case PAGE_TYPE.dc:
      case PAGE_TYPE.vhr:
      case PAGE_TYPE.msr:
      case PAGE_TYPE.facilityIncidentScreen:
      case PAGE_TYPE.inquiry:
      case PAGE_TYPE.qrDetailsScreen:
      case PAGE_TYPE.qrDialog:
      case PAGE_TYPE.daem:
        return ('go_to_orders_page').tr();
      case PAGE_TYPE.licenseScreen:
        return ('go_to_license_management_screen').tr();
      case PAGE_TYPE.appointmentScreen:
      case PAGE_TYPE.cancelAppointment:
      case PAGE_TYPE.confirmAppointment:
        return ('go_to_license_appointment_screen').tr();
      case PAGE_TYPE.coObserver:
        return ('go_to_home').tr();
      case PAGE_TYPE.visitScreen:
        return ('go_to_visit_list').tr();

      case PAGE_TYPE.objction:*/
      case PAGE_TYPE.emtethal:
        return ('compliance_show_certificate').tr();

      default:
        return "";
    }
  }

  void onPressWhiteButton(BuildContext context, {String? requestId}) {
    switch (pageType) {
      case PAGE_TYPE.emtethal:
        Navigator.pushNamed(
          context,
          RouteName.complianceDetailsPage,
          arguments: {"requestNumber": requestId, "redirectUrl": ""},
        );
        break;

      /*
      case PAGE_TYPE.incidentsScreen:
      case PAGE_TYPE.newVD:
      case PAGE_TYPE.dc:
      case PAGE_TYPE.vhr:
      case PAGE_TYPE.msr:
      case PAGE_TYPE.facilityIncidentScreen:
      case PAGE_TYPE.inquiry:
      case PAGE_TYPE.visitScreen:
      case PAGE_TYPE.daem:
        //MM
        /*  if (fromHomePage) {
          NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
              RoutesNames.customerVoiceRoute,
              ModalRoute.withName(RoutesNames.bottomNavigationRoute));
        } else {
          NavigationService.goBack();
        }*/
        break;
      case PAGE_TYPE.qrDetailsScreen:
      case PAGE_TYPE.qrDialog: //MM
        /*{
          bool Function(Route<dynamic>) predicate =
              ModalRoute.withName(RoutesNames.bottomNavigationRoute);

          NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
              RoutesNames.customerVoiceRoute, predicate);
        }*/
        break;
      case PAGE_TYPE.appointmentScreen:
      case PAGE_TYPE.cancelAppointment:
      case PAGE_TYPE.confirmAppointment:
        //MM
        /*if (fromHomePage) {
          NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
              RoutesNames.appointmentsRoute,
              ModalRoute.withName(RoutesNames.bottomNavigationRoute));
        } else {
          NavigationService.goBack();
        }*/
        break;
      case PAGE_TYPE.licenseScreen:
        {
          // Helpers.backNavigationToSpecificScreen2(
          //     navigationKey: RoutesNames.ordersRoute);
        }
        break;
      case PAGE_TYPE.coObserver:
        {
          //  Helpers.backNavigationToHomeScreen();
        }
        break;

      case PAGE_TYPE.objction:
      case PAGE_TYPE.emtethal:
      case PAGE_TYPE.deleteEmtethal:
        /*{
          NavigationService.goBack();
        }*/
        break;
*/
      default:
        /*{
          Helpers.backNavigationToSpecificScreen2(
              navigationKey: RoutesNames.ordersRoute);
        }*/
        break;
    }
  }
}

class CustomHtmlTextWidget extends StatelessWidget {
  final String data;

  const CustomHtmlTextWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        border: Border.all(color: const Color(0xff6bb21f), width: 1),
        color: const Color(0xfffafef6),
      ),
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4, // adjust as needed
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 13.0, bottom: 13),
              child: SvgPicture.asset("assets/images/feedbackMessageItemIconPartiallyDetected.svg"),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Html(
                    data: data,
                    style: {
                      "body": Style(
                        fontSize: FontSize(13.0),
                        fontWeight: FontWeight.w500,
                        color: AppColor.black400,
                        lineHeight: const LineHeight(2),
                        fontFamily: Constants.appFontType,
                      ),
                    },
                    onLinkTap: (url, _, __) {
                      CommonFunctions.externalLaunch(url!);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
