import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/constants.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../vd/domain/entities/map/map_screen_params.dart';
import '../../../blocs/create_dc_request/map_bloc/dc_map_bloc.dart';
import '../../../widgets/create_dc_request/dc_map_view.dart';

class DCMapScreen extends StatefulWidget {
  final bool showSearchPaddingScreen;
  final bool showSearch;
  final bool closeIcon;

  const DCMapScreen({
    this.showSearch = false,
    this.closeIcon = false,
    this.showSearchPaddingScreen = false,
  });

  @override
  _DCMapScreen createState() => _DCMapScreen();
}

class _DCMapScreen extends State<DCMapScreen> {
  @override
  void initState() {
    super.initState();
    // Helpers.sendEventToAnalytics(AppEvents.VD_Open_Map);
  }

  @override
  Widget build(BuildContext context) {
    MapScreenParams? params =
        ModalRoute.of(context)!.settings.arguments as MapScreenParams;

    return Scaffold(
        backgroundColor: AppColor.white4,
        appBar: null,
        body: BlocProvider(
          create: (context) => DCMapBloc(
            params: params,
          ),
          child: BlocConsumer<DCMapBloc, DCMapState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state.status == BlocStatus.failure)
                CommonFunctions.showError(state.errorMessage ?? "");
            },
            builder: (context, state) {
              return Stack(
                children: [
                  DCMapView(
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
                              ? Constants.imgPath + 'exit@3x.png'
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
