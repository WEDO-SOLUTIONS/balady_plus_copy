import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomElevatedButtonWidget,
        CustomLoadingWidget,
        CustomPrimaryButton,
        CustomTextFieldWidget,
        CustomTextWidget,
        CustomVerticalSpace;
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show CancelBloc, CancelOrderParams, CancelState, CencelOrderEvent;
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_orders/my_orders_bloc.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppFontWeight,
        BlocStatus,
        BorderType,
        CommonFunctions,
        trans;

class CancelOrderDialog extends StatefulWidget {
  final CancelOrderParams params;
  final MyOrdersBloc? myOrdersBloc;
  final Function? refresh;

  const CancelOrderDialog(
      {Key? key, required this.params, this.myOrdersBloc, this.refresh})
      : super(key: key);

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.CancelOrder);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CancelBloc(
          cancelOrder: sl(),
          myOrdersBloc: widget.myOrdersBloc,
          refresh: widget.refresh),
      child: BlocConsumer<CancelBloc, CancelState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    trans('cancel_order_desc'),
                    textAlign: TextAlign.start,
                    fontSize: 16,
                    fontWeight: AppFontWeight.medium,
                    fontColor: AppColor.black400,
                  ),
                  const CustomVerticalSpace(height: 48),
                  CancelOrderPurposeWidget(
                    onChanged: (text) {
                      widget.params.purpose = text.trim();
                    },
                  ),
                  const CustomVerticalSpace(height: 24),
                  Spacer(),
                  CustomElevatedButtonWidget(
                    btnText: trans("do_cancel_order"),
                    btnTextSize: 16,
                    btnHeight: 56,
                    btnRadius: 2,
                    btnTextColor: AppColor.error,
                    btnColor: AppColor.white,
                    btnBorderColor: AppColor.error,
                    btnPressed: () {
                      if (widget.params.purpose?.isNotEmpty ?? false) {
                        context
                            .read<CancelBloc>()
                            .add(CencelOrderEvent(params: widget.params));
                      } else {
                        CommonFunctions.showError(
                            trans('cancel_order_purpose_error'));
                      }
                    },
                  ),
                  const CustomVerticalSpace(height: 16),
                  CustomPrimaryButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      btnText: trans('do_not_cancel')),
                  const CustomVerticalSpace(height: 5),
                ],
              ),
              if (state.status == BlocStatus.loading)
                const CustomLoadingWidget()
            ],
          );
        },
      ),
    );
  }
}

class CancelOrderPurposeWidget extends StatefulWidget {
  final Function(String text)? onChanged;

  const CancelOrderPurposeWidget({Key? key, required this.onChanged})
      : super(key: key);

  @override
  State<CancelOrderPurposeWidget> createState() => _CancelOrderPurposeWidget();
}

class _CancelOrderPurposeWidget extends State<CancelOrderPurposeWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CancelBloc, CancelState>(
      builder: (context, state) {
        return CustomTextFieldWidget(
          label: trans('cancel_order_purpose'),
          hintText: trans('cancel_order_purpose_hint'),
          controller: _controller,
          maxLines: 4,
          contentVerticalPadding: 10,
          spacerSize: 0,
          onChanged: (String text) {
            widget.onChanged!(text);
          },
          validator: (text) {
            if (text?.isEmpty ?? false) {
              return trans('cancel_order_purpose_error');
            }
          },
        );
      },
    );
  }
}
