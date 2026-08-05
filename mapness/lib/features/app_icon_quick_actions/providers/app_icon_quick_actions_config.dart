import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_defaults.dart';
import 'package:mapness/features/app_icon_quick_actions/models/app_icon_quick_action.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_icon_quick_actions_config.g.dart';

/// BRD v0.2 static shortcut list (BR#01, BR#02) — no remote configuration.
@Riverpod(keepAlive: true)
AppIconQuickActionsConfig appIconQuickActionsConfig(Ref ref) => AppIconQuickActionsDefaults.config;
