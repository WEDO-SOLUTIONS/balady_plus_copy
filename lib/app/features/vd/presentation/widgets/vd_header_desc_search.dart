import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/vd_search_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show CreateVDBloc, CreateVDState, ShowSPLSearchEvent, SearchForSPLEvent;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class VDHeaderDescSearch extends StatelessWidget {
  final String header;
  final String? desc;
  final double verticalSpace;
  final bool isSearchShown;

  const VDHeaderDescSearch(
      {Key? key,
      required this.header,
      this.desc,
      this.verticalSpace = 24,
      this.isSearchShown = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextWidget(
                    header,
                    fontColor: AppColor.black,
                    fontSize: 22.0,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                    iconSize: 24,
                    onPressed: () {
                      context.read<CreateVDBloc>().add(ShowSPLSearchEvent());
                    },
                    icon: SvgPicture.asset(
                      !isSearchShown
                          ? IconPath.vdSplSearch
                          : IconPath.vdSplSearchExit,
                      height: !isSearchShown ? 42 : 24,
                      width: !isSearchShown ? 42 : 24,
                    )),
              ],
            ),
            if (desc != null) ...[
              CustomVerticalSpace(height: 8),
              CustomTextWidget(
                desc ?? "",
                fontColor: AppColor.blackModern500Light,
                fontSize: 14.0,
                maxLines: 10,
                height: 1.4,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.start,
              ),
            ],
            CustomVerticalSpace(height: verticalSpace),
            AnimatedScale(
              scale: isSearchShown ? 1 : 0,
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 300),
              child: VDSearchTextFieldWidget(
                containerHeight: isSearchShown ? 52 : 0,
                hintText: ('searchFor').tr(),
                onTextChanged: (value) {
                  context
                      .read<CreateVDBloc>()
                      .add(SearchForSPLEvent(text: value));
                },
                onSubmitSearch: (String val) {
                  context
                      .read<CreateVDBloc>()
                      .add(SearchForSPLEvent(text: val));
                },
              ),
            ),
            if (isSearchShown) CustomVerticalSpace(height: verticalSpace),
          ],
        );
      },
    );
  }
}
