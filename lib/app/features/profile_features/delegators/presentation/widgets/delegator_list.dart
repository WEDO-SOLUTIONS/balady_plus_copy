import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show BlocRequestStatus, CommonProperties;
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetWithActions, ShimmerEffectWidget;
import '../../../../profile/profile_exports.dart' show ProfileCard;
import '../../delegators_exports.dart' show DelegatorsCubit, DelegatorsState;

class DelegatorList extends StatelessWidget {
  final DelegatorsCubit _delegatorsCubit;
  final bool showAccount;
  const DelegatorList({
    super.key,
    required DelegatorsCubit delegatorsCubit,
    this.showAccount = true,
  }) : _delegatorsCubit = delegatorsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _delegatorsCubit,
      child: Builder(builder: (context) {
        return BottomSheetWithActions(
          title: "choose_profile".tr(),
          body: BlocBuilder<DelegatorsCubit, DelegatorsState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showAccount)
                    ProfileCard(
                      userInfo: CommonProperties.userInfo,
                      selected: state.selectedDelegate == null,
                    ),
                  if (state.status == BlocRequestStatus.submissionGetFailure)
                    ReloadWidget(
                      onTab: () {
                        _delegatorsCubit.getDelegators();
                      },
                    ),
                  if (state.status == BlocRequestStatus.submissionGetLoading)
                    ...List.generate(
                      5,
                      (_) => Container(
                        height: 80,
                        margin: const EdgeInsets.only(top: 16),
                        child: const ShimmerEffectWidget(),
                      ),
                    ),
                  ...List.generate(
                    state.delegators.length,
                    (index) => ProfileCard(
                      delegator: state.delegators[index],
                      selected:
                          state.delegators[index] == state.selectedDelegate,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
