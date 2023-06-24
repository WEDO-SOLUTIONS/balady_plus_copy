import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../objectable_transactions/presentation/widgets/create_objection_page/objection_reason_attachment.dart';
import '../../blocs/create_retrive_bloc/create_retrive_bloc.dart';

class RetriveAttachmentSection extends StatefulWidget {
  const RetriveAttachmentSection({super.key});

  @override
  State<RetriveAttachmentSection> createState() =>
      _RetriveAttachmentSectionState();
}

class _RetriveAttachmentSectionState extends State<RetriveAttachmentSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRetriveCarBloc, CreateRetriveCarState>(
      builder: (context, state) {
        if (state.file == null)
          return ElevatedIconButtonWidget.upload(
            onPressed: () async {
              FileDataItem? file = await CommonFunctions.pickFile(context);
              if (file != null)
                context
                    .read<CreateRetriveCarBloc>()
                    .add(UploadFileEvent(params: file));
            },
          );
        if (state.file != null)
          return ObjectionReasonAttachment(
            onDelete: () {},
            fileName: state.file?.fileName ?? "",
            filePath: state.file?.filePath ?? "",
          );

        return Container();
      },
    );
  }
}
