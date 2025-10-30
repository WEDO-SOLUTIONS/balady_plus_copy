import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/map/map_screen_params.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/vd_map_view.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show MapBloc, MapState, GetGISDataEvent, GISParams;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';

class VDMapScreen extends StatefulWidget {
  final bool showSearchPaddingScreen;
  final bool showSearch;
  final bool closeIcon;

  VDMapScreen({
    this.showSearch = false,
    this.closeIcon = false,
    this.showSearchPaddingScreen = false,
  });

  @override
  _VDMapScreen createState() => _VDMapScreen();
}

class _VDMapScreen extends State<VDMapScreen> {
  @override
  void initState() {
    super.initState();
    //MM   Helpers.sendEventToAnalytics(AppEvents.VD_Open_Map);

    CommonFunctions.sendUXCamEvent(UXCamEvents.mapServiceSnapAndSend);
  }

  @override
  Widget build(BuildContext context) {
    MapScreenParams? params =
        ModalRoute.of(context)!.settings.arguments as MapScreenParams;

    return Scaffold(
        backgroundColor: AppColor.white4,
        appBar: null,
        body: BlocProvider(
          create: (context) => MapBloc(getGisData: sl(), params: params),
          child: BlocConsumer<MapBloc, MapState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state.status == BlocStatus.failure)
                CommonFunctions.showError(state.errorMessage ?? "");
            },
            builder: (context, state) {
              return Stack(
                children: [
                  VDMapView(
                    showRadius: true,
                    showSearchPaddingScreen: true,
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
                            top: MediaQuery.of(context).padding.top + 5,
                            start: 12),
                        child: Image.asset(
                          widget.closeIcon
                              ? Constants.imgPath + 'exit@3x.png' //MM
                              : Constants.imgPath + 'exitBack@3x.png',
                          height: 38,
                          width: 38,
                        ),
                      ),
                    ),
                  ),
                  // loading
                  if (state.status == BlocStatus.loading)
                    const CustomCircularLoadingWidget()
                ],
              );
            },
          ),
        ));
  }
}
