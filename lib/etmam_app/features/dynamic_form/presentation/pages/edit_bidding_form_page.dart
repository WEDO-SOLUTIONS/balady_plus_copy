import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/form/form_app_bar.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_app_bar_widget.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/edit_bidding_page_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/blocs/edit_bidding_form/edit_bidding_form_bloc.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/edit_form/edit_form_item_widget.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/form_item_widget.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/edit_form/previous_next_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';

class EditBiddingFormPage extends StatefulWidget {
  const EditBiddingFormPage({super.key});

  @override
  State<EditBiddingFormPage> createState() => _EditBiddingFormPageState();
}

class _EditBiddingFormPageState extends State<EditBiddingFormPage> {
  @override
  Widget build(BuildContext context) {
    EditBiddingPageParams params =
        ModalRoute.of(context)!.settings.arguments as EditBiddingPageParams;

    return BlocProvider(
      create: (context) => EdtiBiddingFormBloc(
          createBiddingForm: sl(),
          getFormFieldData: sl(),
          submitDynamicForm: sl(),
          validateDynamicForm: sl(),
          params: params),
      child: BlocConsumer<EdtiBiddingFormBloc, EditBiddingFormState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              context.read<EdtiBiddingFormBloc>().add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<EdtiBiddingFormBloc>().hideKeyboard();
              },
              child: Scaffold(
                backgroundColor: AppColor.white,
                appBar: FormAppBar(
                  //    title: trans('bidding_step_app_bar'),
                  //    nextStep: trans('send_order'),
                  currentStep: state.currentPageValue + 1,
                  pageLength: 1,
                  // withCloseImg: false,
                  onClose: () {
                    Navigator.pop(context);
                  },
                  backOnPress: () {
                    context
                        .read<EdtiBiddingFormBloc>()
                        .add(GoToPreviousPageEvent());
                  },
                ),
                body: Stack(
                  children: [
                    if (state.formResponses != null)
                      PageView.builder(
                          itemCount: 1,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          controller:
                              context.read<EdtiBiddingFormBloc>().controller,
                          itemBuilder: (context, position) {
                            return AnimatedContainer(
                              curve: Curves.easeIn,
                              duration: Duration(milliseconds: 300),
                              child: EditFormItemWidget(
                                  form: state.formResponses!),
                            );
                          }),
                    if (state.status == BlocStatus.loading)
                      CustomCircularLoadingWidget(),
                    PreviousNextButtons(),
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
