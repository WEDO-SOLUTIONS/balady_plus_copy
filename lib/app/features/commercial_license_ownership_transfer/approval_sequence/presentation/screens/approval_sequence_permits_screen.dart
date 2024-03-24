import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license/presentation/commercial_license/widgets/cr_header_desc.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/blocs/commercial_license_cancel/commercial_license_cancel_bloc.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/request_attachments_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/mvvm/commercial_license_reason_cancel_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/widgets/button_in_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import 'package:balady_plus/app/features/_shared_feature_/presentation/enhanced_widgets/pickers/hijri_picker/hijri_picker.dart'
    as hijri_picker;

class ApprovalSequencePermitsScreen extends StatelessWidget {
  final void Function() goToNewPage;

  const ApprovalSequencePermitsScreen({
    Key? key,
    required this.goToNewPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: Column(
            children: [],
          ),
        ),
        ButtonInCard(
          onPressed: () {
            goToNewPage();
          },
          text: "next".tr(),
        ),
      ],
    );
  }
}
