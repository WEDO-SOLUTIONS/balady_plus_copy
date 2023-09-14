import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    hide DropDownItem;
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';
import 'package:balady_plus/etmam_app/features/submit_request/presentation/widgets/order_info/order_title_and_desc_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/enums/dynamic_forms.dart';

class FormViewWidget extends StatefulWidget {
  const FormViewWidget({super.key});

  @override
  State<FormViewWidget> createState() => _FormViewWidgetState();
}

class _FormViewWidgetState extends State<FormViewWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                    itemCount: state.formData?.items?.length ?? 0,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      if (state.formData?.items?[index].getComponentType() ==
                          DynamicFormComponentType.hidden) return SizedBox();

                      return EtmamCustomReadOnlyTextWidget(
                        label: state.formData?.items?[index].fieldLabel ?? "",
                        text: state.formData?.items?[index].field?.getValue() ??
                            "",
                      );
                    }),
              ),
            ),
            if (state.formStatus.isSubmissionLoading) CustomLoadingWidget(),
            if (state.formStatus.isSubmissionFailure)
              ReloadWidget(
                onTab: () {
                  context.read<OrderDetailsBloc>().add(GetFormViewEvent());
                },
              )
          ],
        );
      },
    );
  }
}
