import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/rating_section_widget.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/self_ratiing_sections_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../bloc/self_rating_bloc.dart';
import '../../bloc/self_rating_state.dart';
import '../../bloc/self_rating_event.dart';

class FirstSectionRatingWidget extends StatelessWidget {
  const FirstSectionRatingWidget({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelfRatingBloc, SelfRatingState>(
        builder: (context, state) {
      return SingleChildScrollView(
        child: Column(
          children: [
            SelfRatingSectionsTitle(
              title: "evaluation_rating_certificate".tr(),
            ),
            SizedBox(
              height: 16,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: state.items?.length ?? 0,
              itemBuilder: (context, index) {
                return SelfRatingSectionWidget(
                  item: state.items![index],
                  onSelect: (bool selected) {
                    context.read<SelfRatingBloc>().add(
                        SelfRatingRadioSelectEvent(
                            index: index, compliance: selected));
                  },
                );
              },
            ),
            ElevatedButtonWidget.next(
              onPressed: onPressed,
            ),
          ],
        ),
      );
    });
  }
}
