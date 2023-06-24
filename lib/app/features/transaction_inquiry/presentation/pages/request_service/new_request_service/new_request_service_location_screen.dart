/*import 'package:balady_new_app/app/core/core_exports.dart'
    show
        BigAppBarWithStepsWidget,
        Helpers,
        MapView,
        CustomerVoiceType,
        locator,
        BaseView;
import 'package:balady_new_app/app/features/customer_voice/customer_voice_exports.dart'
    show
        NewMSRMapViewModel,
        CustomerVoiceReportTypeModel,
        SelectedLocation,
        NewMSRViewModel;
import 'package:flutter/material.dart';

class NewRequestLocationScreen extends StatefulWidget {
  CustomerVoiceReportTypeModel reportType;

  NewRequestLocationScreen({Key? key, required this.reportType})
      : super(key: key);

  @override
  _NewRequestLocationScreen createState() => _NewRequestLocationScreen();
}

class _NewRequestLocationScreen extends State<NewRequestLocationScreen> {
  final model = locator<NewMSRMapViewModel>();

  @override
  void dispose() {
    super.dispose();
    model.reset();
  }

  @override
  void initState() {
    super.initState();
    model.type = widget.reportType;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<NewMSRMapViewModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          return Scaffold(
            appBar: BigAppBarWithStepsWidget(
              title: Helpers.translatingWord('order_location'),
              nextStep: Helpers.translatingWord(
                  'customerVoiceLatestRequestsSectionGoToDetailsButtonWord'),
              stepNumber: 1,
              totalSteps: 2,
              withCloseImg: true,
            ),
            body: Stack(
              children: [
                //map view
                // if (gmsAvailable)
                MapView(
                  selectedLocation: model.selectedLocation,
                  onLocationChanged: onLocationConfirmed,
                  showRadius: true,
                  incidentType: CustomerVoiceType.REQ,
                  showSearch: true,
                  showSearchPaddingScreen: false,
                ),
                // loading
                // if (model.isLoading)
                //const CustomCircularLoadingWidget()
              ],
            ),
          );
        });
  }

  void onLocationConfirmed(SelectedLocation location) {
    if (location.selectedLocation != null) {
      model.selectedLocation = location;
      locator<NewMSRViewModel>()
          .getMapGISInfo(mapLocaton: location.selectedLocation!, select: false);
    }
  }
}*/
