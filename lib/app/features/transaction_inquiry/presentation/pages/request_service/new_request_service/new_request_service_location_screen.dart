import 'package:flutter/material.dart';

import '../../../../../../core/base/base_view.dart';
import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/constants.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../_shared_feature_/presentation/pages/map_view.dart';
import '../../../../data/general_inquiry_data.dart';
import '../../../core/models/selected_location.dart';
import '../../../core/view_models/msr/new_msr_map_view_model.dart';
import '../../../core/view_models/msr/new_msr_view_model.dart';

class NewRequestLocationScreen extends StatefulWidget {
  const NewRequestLocationScreen({
    Key? key,
  }) : super(key: key);

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

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startServiceMunicipalServiceRequest);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.MunicipalServiceRequest_Open_Map_Step_Event);
  }

  @override
  Widget build(BuildContext context) {
    CustomerVoiceReportTypeModel reportType = ModalRoute.of(context)!
        .settings
        .arguments as CustomerVoiceReportTypeModel;

    return BaseView<NewMSRMapViewModel>(onModelReady: (model) {
      model.type = reportType;
    }, builder: (context, model, child) {
      return Scaffold(
        body: Stack(
          children: [
            //map view
            // if (gmsAvailable)
            MapView(
              selectedLocation: model.selectedLocation,
              onLocationChanged: onLocationConfirmed,
              showRadius: true,
              showSearch: true,
              showSearchPaddingScreen: true,
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsetsDirectional.only(
                      top: MediaQuery.of(context).padding.top + 5, start: 12),
                  child: Image.asset(
                    Constants.imgPath + 'exit@3x.png',
                    height: 38,
                    width: 38,
                  ),
                ),
              ),
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
}
