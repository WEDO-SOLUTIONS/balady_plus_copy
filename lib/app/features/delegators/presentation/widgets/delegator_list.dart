import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:balady_plus/app/features/dashboard/presentation/widgets/profile_card.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/delegators/services/account_selection_service.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/apps_group_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/utils_exports.dart' show CommonFunctions, CommonProperties;
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetWithActions, CustomVerticalSpace, ShimmerEffectWidget;
import '../../delegators_exports.dart' show DelegatorsCubit, DelegatorsState;
import 'no_accounts_widget.dart';

class DelegatorList extends StatefulWidget {
  final DelegatorsCubit _delegatorsCubit;
  final bool fromService;
  final String? groupId;

  const DelegatorList({super.key, required DelegatorsCubit delegatorsCubit, this.fromService = false, this.groupId})
    : _delegatorsCubit = delegatorsCubit;

  @override
  State<DelegatorList> createState() => _DelegatorListState();
}

class _DelegatorListState extends State<DelegatorList> {
  // 0 = الكل, 1 = المنشآت, 2 = الوكالات
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.openDelegators);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget._delegatorsCubit,
      child: Consumer<BaladyThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return BottomSheetWithActions(
            withoutClose: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: "switch_account".tr(),
            body: BlocBuilder<DelegatorsCubit, DelegatorsState>(
              builder: (context, state) {
                final textScale = MediaQuery.of(context).textScaler.scale(1.0);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_shouldShowNoAccessMessage(state)) ...[
                      _buildNoAccessWidget(context, themeNotifier.isDarkMode),
                    ] else if (widget.fromService && state.delegators.isEmpty && state.agents.isEmpty) ...[
                      const NoAccountsWidget(),
                    ] else ...[
                      if (!_isBusinessGroup()) ...[
                        ProfileCard(
                          isIndividual: true,
                          userInfo: CommonProperties.userInfo,
                          selected: state.selectedDelegate == null && state.selectedAgent == null,
                          isListItem: true,
                          groupId: widget.groupId,
                        ),
                      ],
                      if (state.delegators.isNotEmpty || state.agents.isNotEmpty) ...[
                        Column(
                          children: [
                            SizedBox(
                              width: context.screenWidth,
                              child: Card(
                                elevation: 0,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "business_account".tr(),
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          fontFamily: GeneralKey.appFontType,
                                        ),
                                      ),
                                      Text(
                                        "please_select_facility_or_agency".tr(),
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          fontFamily: GeneralKey.appFontType,
                                        ),
                                      ),
                                      const CustomVerticalSpace(height: 16),

                                      //! Filteration Segmented Control ....
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: SizedBox(
                                          width: context.screenWidth,
                                          height: context.h(32) * textScale,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                _buildFilterTab(
                                                  title: "all".tr(),
                                                  isSelected: _selectedFilterIndex == 0,
                                                  onTap: () => setState(() => _selectedFilterIndex = 0),
                                                ),
                                                _buildDivider(
                                                  show: _selectedFilterIndex != 0 && _selectedFilterIndex != 1,
                                                ),
                                                _buildFilterTab(
                                                  title: "facilities".tr(),
                                                  isSelected: _selectedFilterIndex == 1,
                                                  onTap: () => setState(() => _selectedFilterIndex = 1),
                                                ),
                                                _buildDivider(
                                                  show: _selectedFilterIndex != 1 && _selectedFilterIndex != 2,
                                                ),
                                                _buildFilterTab(
                                                  title: "agencies".tr(),
                                                  isSelected: _selectedFilterIndex == 2,
                                                  onTap: () => setState(() => _selectedFilterIndex = 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const CustomVerticalSpace(height: 8),
                                      //! .....
                                      if (_selectedFilterIndex == 0 || _selectedFilterIndex == 1)
                                        DelegatorsBody(
                                          delegatorsCubit: widget._delegatorsCubit,
                                          groupId: widget.groupId,
                                        ),
                                      if (_selectedFilterIndex == 0 || _selectedFilterIndex == 2)
                                        AgentsBody(delegatorsCubit: widget._delegatorsCubit, groupId: widget.groupId),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterTab({required String title, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontFamily: GeneralKey.appFontType,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider({required bool show}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 1,
      height: context.screenHeight,
      color: show ? Theme.of(context).colorScheme.onPrimaryFixedVariant.withAlpha(30) : Colors.transparent,
    );
  }

  bool _shouldShowNoAccessMessage(DelegatorsState state) {
    return widget.groupId != null &&
        AccountSelectionService.isBusinessGroup(widget.groupId!) &&
        state.accountStatus == DelegatorsAccountStatus.normalAccount;
  }

  bool _isBusinessGroup() {
    return widget.groupId != null && AccountSelectionService.isBusinessGroup(widget.groupId!);
  }

  Widget _buildNoAccessWidget(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.business_center_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "no_business_access_title".tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : const Color(0xFF27272A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "no_business_access_message".tr(),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _switchToPersonalGroup(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003449),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("switch_to_personal".tr()),
            ),
          ),
        ],
      ),
    );
  }

  void _switchToPersonalGroup(BuildContext context) {
    final delegatorsCubit = context.read<DelegatorsCubit>();
    delegatorsCubit.clearSelection();

    Navigator.of(context).pop();

    if (context.mounted) {
      Navigator.of(context).pop();

      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.transparent,
          pageBuilder: (_, __, ___) => const AppsGroupPage(groupId: AccountSelectionService.personalGroupId),
        ),
      );
    }
  }
}

class DelegatorsBody extends StatelessWidget {
  final DelegatorsCubit delegatorsCubit;
  final String? groupId;

  const DelegatorsBody({super.key, required this.delegatorsCubit, this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DelegatorsCubit, DelegatorsState>(
      builder: (context, state) {
        return Column(
          children: [
            ...List.generate(
              state.delegators.length,
              (index) => ProfileCard(
                isIndividual: false,
                delegator: state.delegators[index],
                selected: state.delegators[index] == state.selectedDelegate,
                isListItem: true,
                groupId: groupId,
              ),
            ),
            if (state.accountStatus == DelegatorsAccountStatus.loading)
              ...List.generate(
                5,
                (_) =>
                    Container(height: 80, margin: const EdgeInsets.only(top: 16), child: const ShimmerEffectWidget()),
              ),
            if (state.accountStatus == DelegatorsAccountStatus.failed)
              ReloadWidget(
                onTab: () {
                  delegatorsCubit.loadData();
                },
              ),
          ],
        );
      },
    );
  }
}

class AgentsBody extends StatelessWidget {
  final DelegatorsCubit delegatorsCubit;
  final String? groupId;

  const AgentsBody({super.key, required this.delegatorsCubit, this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DelegatorsCubit, DelegatorsState>(
      builder: (context, state) {
        return Column(
          children: [
            ...List.generate(
              state.agents.length,
              (index) => ProfileCard(
                isIndividual: false,
                agent: state.agents[index],
                selected: state.agents[index] == state.selectedAgent,
                isListItem: true,
                groupId: groupId,
              ),
            ),
            if (state.accountStatus == DelegatorsAccountStatus.loading)
              ...List.generate(
                5,
                (_) =>
                    Container(height: 80, margin: const EdgeInsets.only(top: 16), child: const ShimmerEffectWidget()),
              ),
            if (state.accountStatus == DelegatorsAccountStatus.failed)
              ReloadWidget(
                onTab: () {
                  delegatorsCubit.loadData();
                },
              ),
          ],
        );
      },
    );
  }
}
