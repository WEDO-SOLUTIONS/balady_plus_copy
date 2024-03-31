import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../domain/entities/create_violation_objection_page_params.dart';
import '../create_objection_bloc/create_objection_bloc.dart';
import '../widgets/create_objection_page/objection_request_app_bar.dart';

class CreateViolationObjectionPage extends StatefulWidget {
  const CreateViolationObjectionPage({super.key});

  @override
  State<CreateViolationObjectionPage> createState() =>
      _CreateObjectionPageState();
}

class _CreateObjectionPageState extends State<CreateViolationObjectionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CreateViolationObjectionPageParams params = ModalRoute.of(context)!
        .settings
        .arguments as CreateViolationObjectionPageParams;

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
                      physics: const NeverScrollableScrollPhysics(),
                      controller:
                          context.read<CreateObjectionBloc>().controller,
                      itemBuilder: (context, position) {
                        return AnimatedContainer(
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 300),
                          child: context
                              .read<CreateObjectionBloc>()
                              .pagesList[position],
                        );
                      }),
                  if (state.status == BlocStatus.loading)
                    const CustomCircularLoadingWidget(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
