import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/agent_entity.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/delegator_entity.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

enum GroupType {
  personal, // 124a4dd1-7a7b-47f1-09eb-08de2cce6088
  business, // 6f736c81-c998-4c3e-09ea-08de2cce6088
  other,
}

class AccountSelectionService {
  static const String personalGroupId = '124a4dd1-7a7b-47f1-09eb-08de2cce6088';
  static const String businessGroupId = '6f736c81-c998-4c3e-09ea-08de2cce6088';

  static GroupType getGroupType(String groupId) {
    switch (groupId) {
      case personalGroupId:
        return GroupType.personal;
      case businessGroupId:
        return GroupType.business;
      default:
        return GroupType.other;
    }
  }

  static bool isPersonalGroup(String groupId) {
    return groupId == personalGroupId;
  }

  static bool isBusinessGroup(String groupId) {
    return groupId == businessGroupId;
  }

  /// Determines and applies the appropriate account selection for the given group
  static Future<void> applyAccountSelectionForGroup(String groupId) async {
    debugPrint("DEBUG: applyAccountSelectionForGroup called for groupId: $groupId");
    final groupType = getGroupType(groupId);
    debugPrint("DEBUG: Group type determined as: $groupType");
    DelegatorsCubit cubit = GetIt.instance<DelegatorsCubit>();
    switch (groupType) {
      case GroupType.personal:
        debugPrint("DEBUG: Applying personal account selection");
        await _selectPersonalAccount(cubit);
        break;
      case GroupType.business:
        debugPrint("DEBUG: Applying business account selection");
        await _selectBusinessAccount(cubit);
        break;
      case GroupType.other:
        debugPrint("DEBUG: Other group type, no selection change");
        // For other groups, don't change selection
        break;
    }

    debugPrint(
      (
        "DEBUG: Final selection - Delegator: ${cubit.state.selectedDelegate?.entityName}, Agent: ${cubit.state.selectedAgent?.grantorName}",
      ).toString(),
    );
  }

  /// Selects personal account (clears delegator/agent selection)
  static Future<void> _selectPersonalAccount(DelegatorsCubit cubit) async {
    debugPrint("DEBUG: Selecting personal account - clearing delegator/agent selection");

    // Clear any selected delegator or agent
    cubit.selectDelegator(null);
    cubit.selectAgent(null);

    // Clear from shared preferences
    await sharedPrefs.clearSelectedAccounts();

    debugPrint("DEBUG: Personal account selected, delegator/agent cleared");
  }

  /// Selects appropriate business account (delegator or agent)
  static Future<void> _selectBusinessAccount(DelegatorsCubit cubit) async {
    debugPrint("DEBUG: Starting business account selection");

    // First, try to apply selection from saved preferences immediately if we have data
    final hasExistingData = cubit.state.delegators.isNotEmpty || cubit.state.agents.isNotEmpty;
    if (hasExistingData) {
      debugPrint("DEBUG: Attempting immediate selection from existing data");
      await _applySelectionFromPreferences(cubit);

      // If selection was successful, return early
      if (cubit.state.selectedDelegate != null || cubit.state.selectedAgent != null) {
        debugPrint("DEBUG: Immediate selection successful from existing data");
        return;
      }
    }

    // Check if we need to fetch fresh data
    final isDataStale = cubit.state.accountStatus == DelegatorsAccountStatus.initial;

    if (!hasExistingData || isDataStale) {
      debugPrint("DEBUG: Fetching fresh delegator/agent data");
      cubit.loadData();

      // Wait for both API calls to complete
      int attempts = 0;
      while (attempts < 20) {
        await Future.delayed(const Duration(milliseconds: 300));
        attempts++;

        final isDone =
            cubit.state.accountStatus != DelegatorsAccountStatus.loading &&
            cubit.state.accountStatus != DelegatorsAccountStatus.initial;

        debugPrint(
          (
            "DEBUG: Attempt $attempts - accountStatus: ${cubit.state.accountStatus}, delegators: ${cubit.state.delegators.length}, agents: ${cubit.state.agents.length}",
          ).toString(),
        );

        if (isDone) {
          debugPrint("DEBUG: Both API calls completed");
          break;
        }
      }
    } else {
      debugPrint("DEBUG: Using existing delegator/agent data");
    }

    debugPrint("DEBUG: Final data - ${cubit.state.delegators.length} delegators, ${cubit.state.agents.length} agents");

    // If still no data after waiting, return without selection
    if (cubit.state.delegators.isEmpty && cubit.state.agents.isEmpty) {
      debugPrint("DEBUG: No delegators or agents available");
      return;
    }

    // Apply selection from preferences or select first available
    await _applySelectionFromPreferences(cubit);
  }

  /// Quick check if user currently has business access (without fetching)
  static bool hasCurrentBusinessAccess(DelegatorsCubit cubit) {
    return cubit.state.delegators.isNotEmpty || cubit.state.agents.isNotEmpty;
  }

  /// Saves the currently selected account to SharedPrefs
  static Future<void> saveCurrentSelection(DelegatorsCubit cubit) async {
    final selectedDelegator = cubit.state.selectedDelegate;
    final selectedAgent = cubit.state.selectedAgent;

    if (selectedDelegator != null) {
      await sharedPrefs.saveSelectedDelegator(selectedDelegator.id);
      await sharedPrefs.saveSelectedAgent(null); // Clear agent
    } else if (selectedAgent != null) {
      await sharedPrefs.saveSelectedAgent(selectedAgent.agencyNumber);
      await sharedPrefs.saveSelectedDelegator(null); // Clear delegator
    } else {
      // Personal account selected
      await sharedPrefs.clearSelectedAccounts();
    }
  }

  /// Handles account switching with cross-group navigation
  static Future<void> handleAccountSwitch({
    required String currentGroupId,
    required DelegatorEntity? newDelegator,
    required AgentEntity? newAgent,
    required DelegatorsCubit cubit,
    required Function(String) onNavigateToGroup,
  }) async {
    final currentGroupType = getGroupType(currentGroupId);
    debugPrint("DEBUG: handleAccountSwitch - Current group: $currentGroupId ($currentGroupType)");
    debugPrint(
      (
        "DEBUG: handleAccountSwitch - New delegator: ${newDelegator?.entityName}, New agent: ${newAgent?.grantorName}",
      ).toString(),
    );

    // Determine target group based on selection
    GroupType targetGroupType;
    if (newDelegator != null || newAgent != null) {
      targetGroupType = GroupType.business;
    } else {
      targetGroupType = GroupType.personal;
    }
    debugPrint("DEBUG: handleAccountSwitch - Target group type: $targetGroupType");

    // Apply the selection
    if (newDelegator != null) {
      cubit.selectDelegator(newDelegator);
    } else if (newAgent != null) {
      cubit.selectAgent(newAgent);
    } else {
      cubit.selectDelegator(null);
      cubit.selectAgent(null);
    }

    // Save selection
    await saveCurrentSelection(cubit);

    // Navigate to appropriate group if needed
    debugPrint("DEBUG: handleAccountSwitch - Current: $currentGroupType, Target: $targetGroupType");
    if (currentGroupType != targetGroupType) {
      debugPrint("DEBUG: handleAccountSwitch - Navigation needed!");
      switch (targetGroupType) {
        case GroupType.personal:
          debugPrint("DEBUG: handleAccountSwitch - Navigating to personal group: $personalGroupId");
          onNavigateToGroup(personalGroupId);
          break;
        case GroupType.business:
          debugPrint("DEBUG: handleAccountSwitch - Navigating to business group: $businessGroupId");
          onNavigateToGroup(businessGroupId);
          break;
        case GroupType.other:
          // Should not happen
          break;
      }
    } else {
      debugPrint("DEBUG: handleAccountSwitch - No navigation needed, staying in same group");
    }
  }

  /// Applies selection from SharedPrefs or selects first available
  static Future<void> _applySelectionFromPreferences(DelegatorsCubit cubit) async {
    // First, try to restore last selected account from SharedPrefs
    final lastSelectedDelegatorId = sharedPrefs.getSelectedDelegatorId();
    final lastSelectedAgentId = sharedPrefs.getSelectedAgentId();

    debugPrint("DEBUG: Last selected delegator: $lastSelectedDelegatorId, agent: $lastSelectedAgentId");

    // Try to restore last selected delegator
    if (lastSelectedDelegatorId != null && cubit.state.delegators.isNotEmpty) {
      try {
        final delegator = cubit.state.delegators.firstWhere((d) => d.id == lastSelectedDelegatorId);
        debugPrint("DEBUG: Selecting saved delegator: ${delegator.entityName}");
        cubit.selectDelegator(delegator);
        return;
      } catch (e) {
        debugPrint("DEBUG: Saved delegator not found: $e");
      }
    }

    // Try to restore last selected agent
    if (lastSelectedAgentId != null && cubit.state.agents.isNotEmpty) {
      try {
        final agent = cubit.state.agents.firstWhere((a) => a.agencyNumber == lastSelectedAgentId);
        debugPrint("DEBUG: Selecting saved agent: ${agent.grantorName}");
        cubit.selectAgent(agent);
        return;
      } catch (e) {
        debugPrint("DEBUG: Saved agent not found: $e");
      }
    }

    // If no last selection or it's no longer valid, select first available
    if (cubit.state.delegators.isNotEmpty) {
      debugPrint("DEBUG: Selecting first delegator: ${cubit.state.delegators.first.entityName}");
      cubit.selectDelegator(cubit.state.delegators.first);
    } else if (cubit.state.agents.isNotEmpty) {
      debugPrint("DEBUG: Selecting first agent: ${cubit.state.agents.first.grantorName}");
      cubit.selectAgent(cubit.state.agents.first);
    }
  }

  /// Clears all account selections (used on logout)
  static Future<void> clearAllSelections() async {
    await sharedPrefs.clearSelectedAccounts();
  }

  /// Gets the saved delegator ID from SharedPreferences
  static String? getSavedDelegatorId() {
    return sharedPrefs.getSelectedDelegatorId();
  }

  /// Gets the saved agent ID from SharedPreferences
  static String? getSavedAgentId() {
    return sharedPrefs.getSelectedAgentId();
  }
}
