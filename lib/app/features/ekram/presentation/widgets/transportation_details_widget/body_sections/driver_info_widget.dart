import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/presentation/widgets/custom_enhanced_expansion_panel_widget.dart';

class DriversInfoWidget extends StatelessWidget {
  const DriversInfoWidget({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      builder: (context, state) {
        return CustomEnhancedExpansionPanelWidget(
            underline: false,
            title: "driversInfo".tr(),
            child: SizedBox(
              height: 240,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,

                itemCount:
                    state.details.deceasedInfoResponseDtoList?.length ?? 0,
                scrollDirection: Axis.horizontal,
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return DriverCardWidget(
                    item: state.details.deceasedInfoResponseDtoList![index],
                  );
                },
              ),
            ));
      },
    );
  }
}
