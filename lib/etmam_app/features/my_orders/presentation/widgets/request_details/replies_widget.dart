import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/form/form_header_desc_widget.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/request_offers_page_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/request_details/request_details_bloc.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/request_details/reply_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../../app/core/utils/constants/route_names.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class RepliesWidget extends StatelessWidget {
  const RepliesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FormHeaderDesc(
                header: trans("replies_on_request"),
                //img: "titleItemsIconAppointment@3x.png"
              ),
              ListView.builder(
                  itemCount: state.response?.allReplies?.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return ReplyItemWidget(
                      name: state.response?.allReplies?[index].subServiceName ??
                          "",
                      number: state.response?.allReplies?[index]
                              .submittedOffersCount ??
                          0,
                      accepted: state.response?.allReplies?[index].isAccepted ??
                          false,
                      financialAttachmentId: state
                          .response?.allReplies?[index].financialAttachmentId,
                      technicalAttachmentId: state
                          .response?.allReplies?[index].technicalAttachmentId,
                    );
                  }),
              CustomVerticalSpace(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      EtmamRoutesNames.requestOffersPage,
                      arguments: RequestOffersPageParams(
                          requestDetails: state.response!,
                          requestDetailsBloc:
                              context.read<RequestDetailsBloc>()));
                },
                child: CustomTextWidget(
                  trans("view_all_replies"),
                  fontColor: AppColor.primary900Light,
                  fontSize: 16,
                  fontWeight: AppFontWeight.medium,
                  textDecoration: TextDecoration.underline,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
