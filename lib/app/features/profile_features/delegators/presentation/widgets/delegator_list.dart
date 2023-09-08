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
import 'no_accounts_widget.dart';

class DelegatorList extends StatelessWidget {
  final DelegatorsCubit _delegatorsCubit;
  final bool fromService;
  const DelegatorList({
    super.key,
    required DelegatorsCubit delegatorsCubit,
    this.fromService = false,
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
                  if (fromService && state.delegators.length == 0) ...[
                    NoAccountsWidget()
                  ] else ...[
                    ProfileCard(
                      userInfo: CommonProperties.userInfo,
                      selected: state.selectedDelegate == null,
                    ),
                    ...List.generate(
                      state.delegators.length,
                      (index) => ProfileCard(
                        delegator: state.delegators[index],
                        selected:
                            state.delegators[index] == state.selectedDelegate,
                      ),
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
                    if (state.status == BlocRequestStatus.submissionGetFailure)
                      ReloadWidget(
                        onTab: () {
                          _delegatorsCubit.getDelegators();
                        },
                      ),
                  ]
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
