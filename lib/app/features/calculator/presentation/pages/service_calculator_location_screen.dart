import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/pages/map_view.dart';
import '../../../transaction_inquiry/presentation/core/models/selected_location.dart';
import '../../core/calculator_location_view_model.dart';

class ServiceCalculatorLocationScreen extends StatefulWidget {
  const ServiceCalculatorLocationScreen({Key? key}) : super(key: key);

  @override
  _ServiceCalculatorLocationScreenState createState() =>
      _ServiceCalculatorLocationScreenState();
}

class _ServiceCalculatorLocationScreenState
    extends State<ServiceCalculatorLocationScreen> {
  final model = locator<CalculatorLocationViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permission.location.request();
    //MM   Helpers.sendEventToAnalytics(AppEvents.Calculator_MiniApp);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CalculatorLocationViewModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          return Scaffold(
            body: Stack(
              children: [
                //map view
                MapView(
                  selectedLocation: model.selectedLocation,
                  onLocationChanged: onLocationConfirmed,
                  showRadius: false,
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
                          top: MediaQuery.of(context).padding.top + 5,
                          start: 12),
                      child: Image.asset(
                        Constants.imgPath + 'exit@3x.png',
                        height: 38,
                        width: 38,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void onLocationConfirmed(SelectedLocation location) {
    if (location.selectedLocation != null) {
      model.selectedLocation = location;
      model.getMapGISInfo(
          mapLocaton: location.selectedLocation!, select: false);
    }
  }
}
