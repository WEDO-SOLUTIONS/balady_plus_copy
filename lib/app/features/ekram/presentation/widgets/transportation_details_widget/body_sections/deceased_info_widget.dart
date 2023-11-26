import 'package:balady_new_app/app/core/core_exports.dart'
    show CustomEnhancedExpansionPanelWidget, Helpers;
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:balady_new_app/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeceasedInfoWidget extends StatelessWidget {
  const DeceasedInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      builder: (context, state) {
        return Stack(
          children: [
            CustomEnhancedExpansionPanelWidget(
                underline: false,
                title: Helpers.translatingWord("deceasedData"),
                child: SizedBox(
                  height: 520,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        state.details.deceasedInfoResponseDtoList?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return DeceasedGreyCardWidget(
                        item: state.details.deceasedInfoResponseDtoList![index],
                        isDriver: state.isDriver,
                        showLogTrip: state.details.requestStatusId != 5 &&
                            state.details.requestStatusId != 6,
                        onPressLogTrip: () async {
                          context
                              .read<RequestDetailsBloc>()
                              .add(GetTripsEvent(index: index));
                        },
                        showLocation: () {
                          context
                              .read<RequestDetailsBloc>()
                              .add(GetTripsLocationEvent(index: index));
                        },
                        onPressShowTrips: () {
                          context.read<RequestDetailsBloc>().add(
                              GetTripsDetailsEvent(
                                  requestStatusId:
                                      state.details.requestStatusId!,
                                  requestId: state.details.requestId!,
                                  letters: state
                                      .details.transportAttachResponseDtoList,
                                  dto: state.details
                                      .deceasedInfoResponseDtoList![index]));
                        },
                      );
                    },
                  ),
                )),
            if (state.status == BlocStatus.loading) const CustomLoadingWidget()
          ],
        );
      },
    );
  }
}
