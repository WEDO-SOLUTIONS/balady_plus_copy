import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/pages/map_view.dart';
import '../../../../transaction_inquiry/presentation/core/models/selected_location.dart';
import '../../blocs/driver_add_trip/add_trip_bloc.dart';



class LocationSelectorScreen extends StatefulWidget {
 final Function (double? lat,double? lng,String? address,bool isCurrentStation)callback;
 final bool isCurrentStation;
  const LocationSelectorScreen({Key? key,required this.callback,required this.isCurrentStation}) : super(key: key);


  @override
  _LocationSelectorScreenState createState() =>
      _LocationSelectorScreenState();
}

class _LocationSelectorScreenState
    extends State<LocationSelectorScreen> {
 // final model = locator<CalculatorLocationViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permission.location.request();
    //MM   Helpers.sendEventToAnalytics(AppEvents.Calculator_MiniApp);
  }

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      body: Stack(
        children: [
          //map view
          MapView(
            selectedLocation: SelectedLocation(),
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
  }

  void onLocationConfirmed(SelectedLocation location) {
    if (location.selectedLocation != null) {


      widget.callback(location.selectedLocation?.latitude,location.selectedLocation?.longitude,location.selectedLocationAddress,widget.isCurrentStation);
      Navigator.pop(context);


      // var x =  context.read<AddTripBloc>();
      //.add(EditTripPathData(item:widget.model));

      // model.selectedLocation = location;
      // model.getMapGISInfo(
      //     mapLocaton: location.selectedLocation!, select: false);
    }
  }
}
