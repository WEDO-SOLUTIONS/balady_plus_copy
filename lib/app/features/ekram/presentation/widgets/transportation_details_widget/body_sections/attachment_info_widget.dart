import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../data/model/driver/deceased_attachment.dart';
import '../../../../data/model/request_details_response_model/location_info.dart';

class AttachmentInfoWidget extends StatelessWidget {
  final ExtraDataBloc? bloc;
  final EkramRequestTransportationBloc? detailsBloc;
  final LocationInfo? model;
  final int requestId;
  final int? requestStatusId;

  AttachmentInfoWidget({
    Key? key,
    this.bloc,
    required this.requestId,
    this.model,
    this.requestStatusId,
    this.detailsBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        if (bloc != null)
          BlocProvider.value(
            value: bloc!,
          ),
        if (detailsBloc != null)
          BlocProvider.value(
            value: detailsBloc!,
          ),
      ],
      child: BlocConsumer<ExtraDataBloc, ExtraDataState>(
        listener: (context, state) {
          // Handle state changes here if needed
        },
        builder: (BuildContext context, state) {
          return Container(
            width: MediaQuery.of(context).size.width - 30,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocConsumer<EkramRequestTransportationBloc, EkramRequestTransportationState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return Row(
                        children: [
                          CustomTextWidget(
                            "ekram_step4_title".tr(),
                            fontSize: 20.0,
                            fontWeight: AppFontWeight.bold,
                            fontColor: AppColor.blackModern700Light,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                          if (requestStatusId == 352)
                            CustomButton(
                              onPress: () {
                                   context
                                                      .read<EkramRequestTransportationBloc>()
                                                      .add(getCurrentTrackLocationEvent(requestId: requestId));
                              },
                              text: 'text',
                            )
                          else
                            SizedBox.shrink(),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  EkramHeaderAndDescWidget_With_Background(
                    title: "deathLocation".tr(),
                    details: model?.locationAddress ?? "",
                    margin: EdgeInsets.all(0),
                  ),
                  SizedBox(height: 15),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.lstDeceasedAttachment?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      if (state.lstDeceasedAttachment![requestId]![index]
                              .attached ==
                          true) {
                        return getAttachmentWidget(
                          context,
                          state.lstDeceasedAttachment![requestId]![index],
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getAttachmentWidget(BuildContext context, DeceasedAttachment model) {
    String fileName = "";
    if (model.contentType != null &&
        (model.contentType!.toLowerCase().contains("png") ||
            model.contentType!.toLowerCase().contains("jpeg"))) {
      fileName = "${model.fileName!}.png";
    } else {
      if (model.fileName != null) {
        fileName = "${model.fileName!}.pdf";
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColor.greenOptacty.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: EkramHeaderAndDescWidget_With_Background(
                title: model.name ?? "",
                details: fileName,
                color: Colors.transparent,
                margin: EdgeInsets.all(0),
              ),
            ),
            SizedBox(
              width: 110,
              child: ElevatedButtonWidget.primaryCustomBorderColor(
                bgColor: AppColor.primary800Light,
                color: Colors.white,
                fontSize: 11,
                height: 35,
                onPressed: () {
                  CommonFunctions.showApigeeFile(
                    CommonFunctions.getDMSUrl(model.uuid ?? ""),
                    fileName,
                    serviceId: 0,
                  );
                },
                text: "showAttachment".tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
