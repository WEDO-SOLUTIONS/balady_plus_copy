import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';


import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/pages/map_view.dart';
import '../../../transaction_inquiry/presentation/core/models/selected_location.dart';

class MapScreen extends StatefulWidget {
  final bool showSearchPaddingScreen;
  final bool showSearch;
  final bool closeIcon;
  final Function onLocationChanged;
  final SelectedLocation currentLocation;

  const MapScreen(
      {Key? key,
      this.showSearch = false,
      this.closeIcon = false,
      this.showSearchPaddingScreen = false,
      required this.onLocationChanged,
      required this.currentLocation})
      : super(key: key);

  @override
  _MapScreen createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  //final model = locator<NewIncdietViewModel>();
  SelectedLocation selectedLocation = SelectedLocation(
      userLocation: const LatLng(latitude: 26.271596, longitude:50.201437),
      selectedLocationAddress: 'dammam',
      selectedLocation: const LatLng(latitude:26.271596, longitude:50.201437));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white4,
        appBar: null,
        body: Stack(
          children: [
            //map view
            //  if (gmsAvailable)
            MapView(
              selectedLocation: widget.currentLocation,
              onLocationChanged: widget.onLocationChanged,
              showSearch: widget.showSearch,
              showSearchPaddingScreen: widget.showSearchPaddingScreen,
              showRadius: false,
            ),
            // exit button
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
                    widget.closeIcon
                        ? Constants.imgPath + 'exit@3x.png'
                        : Constants.imgPath + 'exitBack@3x.png',
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
        ));
  }
}
