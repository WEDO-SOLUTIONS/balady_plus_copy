import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/app_font_weight.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/features/services/presentation/blocs/service_details_bloc/service_details_bloc.dart';
import '../../../../../core/utils/utils_exports.dart' show AppFontWeight, trans;
import '../../../../_shared_feature_/shared/presentation/widgets/custom_expansion_widget.dart';

class ServiceFaqSection extends StatelessWidget {
  const ServiceFaqSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            (state.response.service?.faqs?.length ?? 0) > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: AppColor.white,
                      boxShadow: Constants.boxShadow,
                    ),
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemCount:
                              (state.response.service?.faqs?.length ?? 0) > 3
                                  ? 3
                                  : (state.response.service?.faqs?.length ?? 0),
                          itemBuilder: (_, index) => ExpansionItemWidget(
                            title:
                                state.response.service?.faqs?[index].question ??
                                    "",
                            subTitle:
                                state.response.service?.faqs?[index].answer ??
                                    "",
                            isExpanded: index == 0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if ((state.response.service?.faqs?.length ?? 0) > 3)
                          CustomElevatedButtonWidget(
                            btnText: trans("show_all"),
                            btnTextColor: AppColor.primary900Light,
                            btnTextSize: 12,
                            btnTextWeight: AppFontWeight.bold,
                            btnHeight: 42,
                            btnRadius: 8,
                            btnBorderWidth: 1,
                            btnColor: AppColor.white,
                            btnBorderColor: AppColor.primary900Light,
                            btnPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            btnPressed: () {
                              NavigationService.pushNamed(
                                  routeName: EtmamRoutesNames.faqPage,
                                  args: state.response.service?.faqs);
                            },
                          ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}

// class ServiceFaqSection extends StatelessWidget {
//   const ServiceFaqSection({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
//       builder: (context, state) {
//         return (state.response.service?.faqs?.length ?? 0) > 0
//             ? Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     MediaQuery.removePadding(
//                       context: context,
//                       removeTop: true,
//                       child: ListView.builder(
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount:
//                             (state.response.service?.faqs?.length ?? 0) > 3
//                                 ? 3
//                                 : (state.response.service?.faqs?.length ?? 0),
//                         shrinkWrap: true,
//                         itemBuilder: (ctx, index) {
//                           return ExpansionItemWidget(
//                             title:
//                                 state.response.service?.faqs?[index].question ??
//                                     "",
//                             subTitle:
//                                 state.response.service?.faqs?[index].answer ??
//                                     "",
//                             isExpanded: index == 0,
//                           );
//                         },
//                       ),
//                     ),
//                     ShowMoreFaq(
//                       questionCount:
//                           (state.response.service?.faqs?.length ?? 0),
//                     )
//                   ],
//                 ),
//               )
//             : Container();
//       },
//     );
//   }
// }

// class ShowMoreFaq extends StatelessWidget {
//   final int questionCount;
//
//   const ShowMoreFaq({Key? key, required this.questionCount}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     int remainingQuestion = questionCount - 3;
//     return remainingQuestion > 1
//         ? BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
//             builder: (context, state) {
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 CustomTextButtonWidget(
//                   btnTextSize: 16,
//                   btnTextWeight: AppFontWeight.bold,
//                   btnTextColor: AppColor.darkTurquoise,
//                   btnPressed: () {
//                     NavigationService.pushNamed(
//                         routeName: EtmamRoutesNames.faqPage,
//                         args: state.response.service?.faqs);
//                   },
//                   btnText: trans("show_more"),
//                 ),
//                 const CustomHorizontalSpace(width: 4),
//                 CustomTextWidget(
//                   trans("faq_more_question")
//                       .replaceAll("-", remainingQuestion.toString()),
//                   fontColor: AppColor.bottomNavigationShadow,
//                   fontSize: 16,
//                   fontWeight: AppFontWeight.medium,
//                   height: 2,
//                 )
//               ],
//             );
//           })
//         : Container();
//   }
// }
