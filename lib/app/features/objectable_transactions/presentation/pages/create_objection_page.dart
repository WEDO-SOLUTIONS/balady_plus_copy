import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../domain/entities/create_objection_page_params.dart';
import '../create_objection_bloc/create_objection_bloc.dart';
import '../widgets/create_objection_page/objection_request_app_bar.dart';

class CreateObjectionPage extends StatefulWidget {
  const CreateObjectionPage({
    super.key,
  });

  @override
  State<CreateObjectionPage> createState() => _CreateObjectionPageState();
}

class _CreateObjectionPageState extends State<CreateObjectionPage> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceAppealRequest);
  }

  @override
  Widget build(BuildContext context) {
    CreateObjectionPageParams params =
        ModalRoute.of(context)!.settings.arguments as CreateObjectionPageParams;

    return BlocProvider(
      create: (context) => CreateObjectionBloc(
        details: params.details,
        item: params.item,
      ),
      child: BlocConsumer<CreateObjectionBloc, CreateObjectionState>(
          listener: (context, state) {
        if (state.status == BlocStatus.failure) {
          CommonFunctions.showError(state.errorMessage ?? "");
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: ObjectionRequestAppBar(
                currentStep: state.currentPageValue + 1,
                backOnPress: () => context
                    .read<CreateObjectionBloc>()
                    .add(GoToPreviousPageEvent()),
              ),
              body: Stack(
                children: [
                  PageView.builder(
                      itemCount:
                          context.read<CreateObjectionBloc>().pagesList.length,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      controller:
                          context.read<CreateObjectionBloc>().controller,
                      itemBuilder: (context, position) {
                        return AnimatedContainer(
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 300),
                          child: context
                              .read<CreateObjectionBloc>()
                              .pagesList[position],
                        );
                      }),
                  if (state.status == BlocStatus.loading)
                    CustomCircularLoadingWidget(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
