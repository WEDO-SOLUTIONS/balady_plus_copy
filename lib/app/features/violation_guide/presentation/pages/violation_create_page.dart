import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_bloc.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_event.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_state.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/violation_address_select_page.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/details_app_bar.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_create_widgets/violation_create_list_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants/ux_cam_events.dart';
import 'map/bloc/map_bloc.dart';

class ViolationCreatePage extends StatefulWidget {
  const ViolationCreatePage({super.key});

  @override
  State<ViolationCreatePage> createState() => _ViolationCreatePageState();
}

class _ViolationCreatePageState extends State<ViolationCreatePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceViolationsGuide);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.PViolationGuide_Open_Select_Type_Step_Event);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MapBloc(),
        ),
        BlocProvider(
          create: (context) => ViolationBloc()
            ..add(const GetEstablishmentSizeEvent())
            ..add(const GetViolatorsEvents()),
        ),
      ],
      child: BlocConsumer<ViolationBloc, ViolationState>(
        listener: (context, state) {
          if (state.ViolatorsStatus == BlocStatus.failure ||
              state.classificationStatus == BlocStatus.failure ||
              state.status == BlocStatus.failure)
            CommonFunctions.showError(state.errorMessage ?? "");
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.scaffoldBackground,
            appBar: FormAppBar(
              currentStep: state.currentStep,
              pageLength: 2,
              backOnPress: () {
                Navigator.of(context).pop();
              },
              onClose: () {
                Navigator.of(context).pop();
              },
            ),
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: PageView(
                      controller: context.read<ViolationBloc>().pageController,
                      children: [
                        const ViolationCreateListWidget(),
                        const ViolationAddressSelectPage(),
                      ]),
                ),
                if (state.ViolatorsStatus == BlocStatus.loading ||
                    state.establishmentStatus == BlocStatus.loading ||
                    state.status == BlocStatus.loading)
                  CustomCircularLoadingWidget()
              ],
            ),
          );
        },
      ),
    );
  }
}
