import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/utils/common_functions.dart';
import '../../../../../app/features/_shared_feature_/data/entities/file_data_item.dart';
import '../../../../../app/features/_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../app/features/objectable_transactions/presentation/widgets/create_objection_page/objection_reason_attachment.dart';
import '../blocs/bidding_form/bidding_form_bloc.dart';

class BidddingUploadWidget extends StatelessWidget {
  const BidddingUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiddingFormBloc, BiddingFormState>(
      builder: (context, state) {
        if (state.uploadBidAttachmentResponse == null)
          return ElevatedIconButtonWidget.upload(
            onPressed: () async {
              FileDataItem? file =
                  await CommonFunctions.pickFile(context, filesOnly: true);
              if (file != null)
                context
                    .read<BiddingFormBloc>()
                    .add(UploadBiddingAttachmentEvent(file: file));
            },
          );
        if (state.uploadBidAttachmentResponse != null &&
            state.attachmentPath != null)
          return ObjectionReasonAttachment(
            onDelete: () {
              context
                  .read<BiddingFormBloc>()
                  .add(RemoveBiddingAttachmentEvent());
            },
            fileName: state.attachmentName ?? "",
            filePath: state.attachmentPath ?? "",
          );

        return Container();
      },
    );
  }
}
