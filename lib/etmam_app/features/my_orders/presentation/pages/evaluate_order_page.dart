import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, CommonFunctions, trans;

import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        CategoryRatingWidget,
        ChangeRateEvent,
        CommentTextFieldWidget,
        GetRatingItemsEvent,
        RatingBloc,
        RatingPageParams,
        RatingState,
        SubmitRateEvent;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/shared/shared_feature_exports.dart';
import '../../../submit_request/presentation/widgets/order_info/order_info_card_widget.dart';

class EvaluateOrderPage extends StatefulWidget {
  const EvaluateOrderPage({Key? key}) : super(key: key);

  @override
  State<EvaluateOrderPage> createState() => _EvaluateOrderPage();
}

class _EvaluateOrderPage extends State<EvaluateOrderPage> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.EvaluateOrder);
  }

  @override
  Widget build(BuildContext context) {
    RatingPageParams args =
        ModalRoute.of(context)!.settings.arguments as RatingPageParams;

    return Scaffold(
        appBar: CustomAppBar(
          title: trans("evaluate_order"),
        ),
        body: BlocProvider(
          create: (context) =>
              RatingBloc(args: args, getRatingItems: sl(), submitRating: sl()),
          child: BlocConsumer<RatingBloc, RatingState>(
            listener: (context, state) {
              if (state.status == BlocStatus.failure) {
                CommonFunctions.showError(state.errorMessage ?? "");
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 90),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (state.args?.providerName != null) ...[
                            CustomVerticalSpace(height: 16),
                            ProviderNameAndLogoWidget(
                              name: state.args?.providerName ?? "",
                              logo: state.args?.logoUrl ?? "",
                            )
                          ],
                          CustomVerticalSpace(height: 16),
                          Container(
                            margin: EdgeInsets.all(16),
                            child: CustomTextWidget(
                              trans('evaluate_order_desc'),
                              fontSize: 16,
                              fontWeight: AppFontWeight.regular,
                              fontColor: AppColor.bottomNavigationShadow,
                            ),
                          ),
                          const CustomVerticalSpace(height: 16),
                          ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.items?.length ?? 0,
                              itemBuilder: (ctx, index) {
                                return CategoryRatingWidget(
                                  item: state.items![index],
                                  onChangeRate: (int rating) {
                                    context.read<RatingBloc>().add(
                                        ChangeRateEvent(
                                            index: index, rate: rating));
                                  },
                                );
                              }),
                          if (state.status == BlocStatus.retry)
                            ReloadWidget(onTab: () {
                              context
                                  .read<RatingBloc>()
                                  .add(GetRatingItemsEvent());
                            }),
                          CustomVerticalSpace(height: 16),
                          CommentTextFieldWidget(),
                          const CustomVerticalSpace(height: 20),
                        ],
                      ),
                    ),
                  ),
                  CustomStackFooterButtonWidget(
                    btnText: trans('send_evaluation'),
                    isBtnDisabled: !(state.isFormValid ?? false),
                    onPressed: () {
                      context.read<RatingBloc>().add(SubmitRateEvent());
                    },
                  ),
                  if (state.status == BlocStatus.loading)
                    const CustomLoadingWidget(),
                ],
              );
            },
          ),
        ));
  }
}
