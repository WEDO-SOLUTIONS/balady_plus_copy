import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart';

class BoardSelector extends StatelessWidget {
  const BoardSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              'AdvertisingOffices'.tr(),
              textStyle: AppStyle.dropDownTitleTextStyle,
            ),
            if (state.boards.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: state.boards.length,
                itemBuilder: (context, index) {
                  return BoardWidget(
                    key: Key(
                      state.boards[index].typeId != null &&
                              state.boards[index].area != null
                          ? '$index-${state.boards[index].typeId}-${state.boards[index].area}'
                          : '$index',
                    ),
                    board: state.boards[index],
                    index: index,
                  );
                },
              ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.addBoard(
              onPressed: () {
                BlocProvider.of<MunicipalAdvisorBloc>(context)
                    .add(MunicipalAdvisorAddCommercialBoardEvent());
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
