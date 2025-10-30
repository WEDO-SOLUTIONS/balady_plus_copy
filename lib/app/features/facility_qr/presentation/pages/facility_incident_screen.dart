/*import 'package:balady_plus/app/features/facility_qr/facility_qr_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class FacilityIncidentScreen extends StatefulWidget {
  const FacilityIncidentScreen({Key? key}) : super(key: key);

  @override
  _FacilityIncidentScreenState createState() => _FacilityIncidentScreenState();
}

class _FacilityIncidentScreenState extends State<FacilityIncidentScreen> {
  final entityViewModel = locator<FacilityQRDetailsViewModel>();

  // final ScrollController _scrollController = ScrollController();
  final dataModel = locator<NewIncdietViewModel>();

  @override
  void dispose() {
    super.dispose();
    dataModel.resetAll();
  }

  @override
  void initState() {
    super.initState();

    // //  model.getGpsLocation(latLng)
    //  model.getGpsLocation(model.selectedLocation.selectedLocation);

    //setStoredGuestInfo();
    // guestTextFields();
    // sendEventToAnalytics("qr_create_incident_clicked");

    //MM  Helpers.sendEventToAnalytics(AppEvents.QR_Report);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewIncidentDetailsViewModel>(
        create: (context) => NewIncidentDetailsViewModel(),
        builder: (context, child) {
          NewIncidentDetailsViewModel model =
              Provider.of<NewIncidentDetailsViewModel>(context, listen: true);
          return GestureDetector(
              onTap: () {
                model.hideKeyboard();
              },
              child: Scaffold(
                appBar: CustomAppBar(
                  title: ('homeLatestUpdatesGoToReportDetailsWord').tr(),
                  withCloseImg: true,
                ),
                body: Stack(
                  children: [
                    IncidentBody(
                      withLocationSection: false,
                      showAttachments: true,
                    ),
                    // submit button
                    IncidentSubmitButton(
                      isButtonDisabled: !model.isFormValid,
                      btnText: Helpers.translatingWord("lbl_order_submit"),
                      onPress: () {
                        model.hideKeyboard();
                        // if (model.lastKnownAddress == true) {
                        //   model.showError(trans("fill_address_field"));
                        //   _scrollToUp();
                        //   return;
                        // }
                        // if (model.isGeust) {
                        //   bool isMobileValid = model.submitIncidentForGuest();
                        //   if (!isMobileValid) _scrollToUp();
                        // } else {
                        //   model.submitIncident();
                        // }
                        model.submit();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void guestTextFields() {
    // try {
    //   if (model.isGeust) {
    //     _guestFirstName.text = model.geustFirstName;
    //     _guestLastName.text = model.geustLastName;
    //   }
    //
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (_descriptionController != null &&
    //         _descriptionController.text.isNotEmpty)
    //       _describtionFormKey.currentState.validate();
    //   });
    // } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  }

  void setStoredGuestInfo() {
    //model.geustFirstName = sharedPrefs.getGuestFirstName();
    // model.geustLastName = sharedPrefs.getGuestLastName();
    // model.geustMobile = sharedPrefs.getGuestMobile();
  }
}
*/
