import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;
import '../../municipal_advisor_exports.dart'
    show MunicipalAdvisorBloc, MunicipalAdvisorState;

class EmptyChat extends StatelessWidget {
  const EmptyChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        if (state.messages.isNotEmpty) return const SizedBox.shrink();
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DrawIconBasedTypeWidget(
                icon: IconPath.chat,
                iconSize: 82,
              ),
              const SizedBox(height: 16),
              CustomTextWidget(
                'startChatting'.tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
            ],
          ),
        );
      },
    );
  }
}
