import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    hide DropDownItem;

import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/request_details/request_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/enums/dynamic_forms.dart';
import '../../../../submit_request/presentation/widgets/order_info/order_title_and_desc_widget.dart';

class FormViewWidget extends StatefulWidget {
  const FormViewWidget({super.key});

  @override
  State<FormViewWidget> createState() => _FormViewWidgetState();
}

class _FormViewWidgetState extends State<FormViewWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*  CustomVerticalSpace(height: 16),
                    CustomTextWidget(widget.form.serviceName ?? "",
                        fontColor: AppColor.black,
                        fontSize: 22,
                        fontWeight: AppFontWeight.bold),
                    CustomVerticalSpace(height: 16),*/
                    ListView.builder(
                        itemCount: state.formData?.items?.length ?? 0,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          if (state.formData?.items?[index]
                                  .getComponentType() ==
                              DynamicFormComponentType.hidden)
                            return SizedBox();

                          return EtmamCustomReadOnlyTextWidget(
                            label:
                                state.formData?.items?[index].fieldLabel ?? "",
                            text: state.formData?.items?[index].field
                                    ?.getValue() ??
                                "",
                          );
                        }),
                    CustomVerticalSpace(height: 80),
                  ],
                ),
              ),
            ),
            if (state.formStatus.isSubmissionLoading) CustomLoadingWidget(),
            if (state.formStatus.isSubmissionFailure)
              ReloadWidget(
                onTab: () {
                  context.read<RequestDetailsBloc>().add(GetFormViewEvent());
                },
              )
          ],
        );
      },
    );
  }
}
