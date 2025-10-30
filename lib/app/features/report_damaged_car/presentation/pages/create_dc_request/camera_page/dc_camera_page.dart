import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/categories/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/app_analytics_events.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../vd/domain/entities/camera/camera_page_params.dart';
import '../../../blocs/create_dc_request/camera_bloc/dc_camera_bloc.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';
import '../../../widgets/create_dc_request/camera_widgets/camera_view_widget.dart';

class DCCameraPage extends StatefulWidget {
  const DCCameraPage({super.key});

  @override
  State<DCCameraPage> createState() => _DCCameraPageState();
}

class _DCCameraPageState extends State<DCCameraPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Helpers.sendEventToAnalytics(AppEvents.VD_Open_Camera);

    CommonFunctions.sendEventToAnalytics(AppEvents.damagedCarsReport);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startServiceReportWriteOffVehicle);
  }

  @override
  Widget build(BuildContext context) {
    CameraParamsPage params = CameraParamsPage(
      selectedCategory: CategoryItem(categoryId: "CG-14"),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateDCBloc>(
          create: (BuildContext context) => CreateDCBloc(),
        ),
        BlocProvider<DCCameraBloc>(
          create: (BuildContext context) => DCCameraBloc(
            params: params,
            createDCBloc: context.read<CreateDCBloc>(),
          ),
        ),
      ],
      child: BlocConsumer<DCCameraBloc, DCCameraState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: cameraViewWidgetNew(),
          );
        },
      ),
    );
  }
}
