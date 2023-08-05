import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_expansion_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/features/services/presentation/blocs/service_details_bloc/service_details_bloc.dart';

class ServiceFaqSection extends StatelessWidget {
  const ServiceFaqSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
      builder: (context, state) {
        return (state.response.service?.faqs?.length ?? 0) > 0
            ? Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            (state.response.service?.faqs?.length ?? 0) > 3
                                ? 3
                                : (state.response.service?.faqs?.length ?? 0),
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return ExpansionItemWidget(
                            title:
                                state.response.service?.faqs?[index].question ??
                                    "",
                            subTitle:
                                state.response.service?.faqs?[index].answer ??
                                    "",
                            isExpanded: index == 0,
                          );
                        },
                      ),
                    ),
                    ShowMoreFaq(
                      questionCount:
                          (state.response.service?.faqs?.length ?? 0),
                    )
                  ],
                ),
              )
            : Container();
      },
    );
  }
}

class ShowMoreFaq extends StatelessWidget {
  final int questionCount;

  const ShowMoreFaq({Key? key, required this.questionCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int remainingQuestion = questionCount - 3;
    return remainingQuestion > 1
        ? BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
            builder: (context, state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextButtonWidget(
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextColor: AppColor.darkTurquoise,
                  btnPressed: () {
                    NavigationService.pushNamed(
                        routeName: EtmamRoutesNames.faqPage,
                        args: state.response.service?.faqs);
                  },
                  btnText: trans("show_more"),
                ),
                const CustomHorizontalSpace(width: 4),
                CustomTextWidget(
                  trans("faq_more_question")
                      .replaceAll("-", remainingQuestion.toString()),
                  fontColor: AppColor.bottomNavigationShadow,
                  fontSize: 16,
                  fontWeight: AppFontWeight.medium,
                  height: 2,
                )
              ],
            );
          })
        : Container();
  }
}
