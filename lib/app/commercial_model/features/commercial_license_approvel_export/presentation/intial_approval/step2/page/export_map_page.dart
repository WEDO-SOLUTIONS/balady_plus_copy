import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/map/map_screen_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../bloc/step2_activity_data_export_cubit.dart';
import '../widgets/map_widgets/export_map_view.dart';



class ExportMapScreen extends StatefulWidget {
  final bool showSearchPaddingScreen;
  final bool showSearch;
  final bool closeIcon;

  ExportMapScreen({
    this.showSearch = false,
    this.closeIcon = false,
    this.showSearchPaddingScreen = false,
  });

  @override
  _CRMapScreen createState() => _CRMapScreen();
}

class _CRMapScreen extends State<ExportMapScreen> {
  @override
  void initState() {
    super.initState();
    //MM   Helpers.sendEventToAnalytics(AppEvents.VD_Open_Map);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.CommercialLicense_Open_Map_Locator_Page_Event);
  }

  @override
  Widget build(BuildContext context) {
    Step2ActivityDataExportCubit bloc = ModalRoute.of(context)?.settings.arguments as Step2ActivityDataExportCubit;
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
          backgroundColor: AppColor.white4,
          appBar: null,
          body: BlocConsumer<Step2ActivityDataExportCubit, Step2ActivityDataExportState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state.status == BlocStatus.failure)
                CommonFunctions.showError(state.errorMessage ?? "");
            },
            builder: (context, state) {
              return Stack(
                children: [
                  ExportMapView(
                    showRadius: false,
                    showSearchPaddingScreen: true,
                    readOnly: false,
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
          )),
    );
  }
}
