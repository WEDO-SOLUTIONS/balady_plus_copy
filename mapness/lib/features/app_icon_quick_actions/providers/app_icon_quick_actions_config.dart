import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_datasource.dart';
import 'package:mapness/features/app_icon_quick_actions/models/app_icon_quick_action.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_icon_quick_actions_config.g.dart';

@Riverpod(keepAlive: true)
Future<AppIconQuickActionsConfig> appIconQuickActionsConfig(Ref ref) async {
  final dio = ref.watch(baseDioProvider);
  final environment = await ref.watch(dgisEnvironmentProvider.future);
  return AppIconQuickActionsConfigDatasource(
    dio: dio,
    environment: environment,
  ).getConfig();
}
