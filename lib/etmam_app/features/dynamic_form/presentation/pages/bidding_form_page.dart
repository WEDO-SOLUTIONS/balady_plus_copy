import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_app_bar_widget.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/blocs/bidding_form/bidding_form_bloc.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/form_item_widget.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/previous_next_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/form/form_app_bar.dart';

class BiddingFormPage extends StatefulWidget {
  const BiddingFormPage({super.key});

  @override
  State<BiddingFormPage> createState() => _BiddingFormPageState();
}

class _BiddingFormPageState extends State<BiddingFormPage> {
  @override
  Widget build(BuildContext context) {
    BiddingFormParams params =
        ModalRoute.of(context)!.settings.arguments as BiddingFormParams;

    return BlocProvider(
      create: (context) => BiddingFormBloc(
          createBiddingForm: sl(),
          getFormFieldData: sl(),
          submitDynamicForm: sl(),
          validateDynamicForm: sl(),
          params: params),
      child: BlocConsumer<BiddingFormBloc, BiddingFormState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              context.read<BiddingFormBloc>().add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<BiddingFormBloc>().hideKeyboard();
              },
              child: Scaffold(
                backgroundColor: AppColor.white,
                appBar: FormAppBar(
                  // title: trans('bidding_step_app_bar'),
                  //  nextStep: trans('send_order'),
                  currentStep: state.currentPageValue + 1,
                  pageLength: state.formsCount == 0 ? 1 : state.formsCount,
                  backOnPress: () {
                    context
                        .read<BiddingFormBloc>()
                        .add(GoToPreviousPageEvent());
                  },
                  onClose: () {
                    Navigator.of(context).pop();
                  },
                  //withCloseImg: false,
                ),
                body: Stack(
                  children: [
                    PageView.builder(
                        itemCount:
                            context.read<BiddingFormBloc>().state.formsCount,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        controller: context.read<BiddingFormBloc>().controller,
                        itemBuilder: (context, position) {
                          return AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 300),
                            child: FormItemWidget(form: state.currentForm!),
                          );
                        }),
                    if (state.status == BlocStatus.loading)
                      CustomCircularLoadingWidget(),

                    /*  CustomStackFooterButtonWidget(
                      isBtnDisabled: false,
                      btnText:
                          (state.currentPageValue + 1) == (state.formsCount)
                              ? trans('send_order')
                              : trans('nextButton'),
                      onPressed: () {
                        context
                            .read<BiddingFormBloc>()
                            .add(ValidateFormEvent());
                      },
                    ),*/
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
