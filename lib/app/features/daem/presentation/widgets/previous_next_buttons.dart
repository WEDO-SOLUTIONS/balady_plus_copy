import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/daem/daem_exports.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class PreviousNextButtons extends StatelessWidget {
  const PreviousNextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewDaemTicketBloc, NewDaemTicketState>(
      builder: (context, state) {
        bool isButtonDisabled = !state.isNextButtonEnabled();
        bool isLastPage = context.read<NewDaemTicketBloc>().isLastPage();
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: EnhancedCustomElevatedButtonWidget(
            btnColor:
                isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
            btnTextColor: isButtonDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: isButtonDisabled
                ? () {}
                : () {
                    if (!isLastPage) {
                      context
                          .read<NewDaemTicketBloc>()
                          .add(GoToNextPageEvent());
                    } else {
                      if (state.errorInUploading ?? false) {
                        context
                            .read<NewDaemTicketBloc>()
                            .add(UploadTicketFilesEvent());
                      } else {
                        context
                            .read<NewDaemTicketBloc>()
                            .add(CreateTicketEvent());
                      }
                    }
                  },
            btnRadius: 8,
            btnText: isLastPage
                ? (state.errorInUploading ?? false)
                    ? ("upload_documents").tr()
                    : ('daem_raise_ticket').tr()
                : ("next").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.bold,
            btnHeight: 56,
          ),
        );
      },
    );
  }
}
