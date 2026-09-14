import 'package:dio/dio.dart';
import 'package:mapness/features/ai_summary/data/ai_summary_repository.dart';
import 'package:mapness/features/ai_summary/data/http_ai_summary_repository.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/logger/talker_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import '../../../shared/providers/base_dio.dart';
import '../../../shared/providers/dgis_environment.dart';

part 'ai_summary_repository_provider.g.dart';

/// Auth key for the Momrah AI Summary endpoint.
///
/// Hardcoded alongside other dev/build configuration that lives
/// in the bundle-id / 2gis-key commits at the top of the branch.
/// Move to [EnvironmentConfig] once the backend team issues
/// per-environment keys.
const _aiSummaryAuthKey = '28ed92f1-de4b-4060-b159-2dc19e9b8bf5';

/// Dependency-injection seam for the [AiSummaryRepository].
///
/// Builds a dedicated [Dio] pinned to the Momrah staging AI
/// Summary host (see [_aiSummaryBaseUrl] for why), independent of
/// the active app environment.
@Riverpod(keepAlive: true)
Future<AiSummaryRepository> aiSummaryRepository(Ref ref) async {
  const timeout = Duration(seconds: 30);
  final env = await ref.watch(dgisEnvironmentProvider.future);

  logger.log('ai_summary base url: ${env.url}');
  final dio = Dio(
    BaseOptions(
      baseUrl: env.url,
      connectTimeout: timeout,
      sendTimeout: timeout,
      receiveTimeout: timeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-auth-key': _aiSummaryAuthKey,
      },
    ),
  );
  if (logger is TalkerMapnessLogger) {
    dio.interceptors.add(
      TalkerDioLogger(talker: (logger as TalkerMapnessLogger).talker),
    );
  }
  return HttpAiSummaryRepository(dio);
}
