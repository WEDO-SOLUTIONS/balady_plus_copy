import 'package:dio/dio.dart';
import 'package:mapness/features/ai_summary/data/ai_summary_repository.dart';
import 'package:mapness/features/ai_summary/data/http_ai_summary_repository.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/logger/talker_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'ai_summary_repository_provider.g.dart';

/// Auth key for the Momrah AI Summary endpoint.
///
/// Hardcoded alongside other dev/build configuration that lives
/// in the bundle-id / 2gis-key commits at the top of the branch.
/// Move to [EnvironmentConfig] once the backend team issues
/// per-environment keys.
const _aiSummaryAuthKey = '28ed92f1-de4b-4060-b159-2dc19e9b8bf5';

/// Pinned AI Summary host.
///
/// Today only the Momrah staging cluster has the endpoint deployed:
/// * prod (`urbi-lifestyle.momrah.gov.sa`) returns nginx 404 for
///   any path under `/1.0/ai-summary/`.
/// * dev (`momrah-balady-dev.iaas.urbi-sa.com`) responds, but its
///   catalog is empty for the prod-shape syncodes the app sees.
///
/// The hardcoded auth key above is staging-issued, so coupling the
/// host to it here keeps the wiring consistent. Switch to a
/// per-environment URL once the backend team rolls the endpoint
/// out to prod.
const _aiSummaryBaseUrl = 'https://urbi-lifestyle-stg.momrah.gov.sa/1.0/';

/// Dependency-injection seam for the [AiSummaryRepository].
///
/// Builds a dedicated [Dio] pinned to the Momrah staging AI
/// Summary host (see [_aiSummaryBaseUrl] for why), independent of
/// the active app environment.
@Riverpod(keepAlive: true)
Future<AiSummaryRepository> aiSummaryRepository(Ref ref) async {
  const timeout = Duration(seconds: 30);
  final dio = Dio(
    BaseOptions(
      baseUrl: _aiSummaryBaseUrl,
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
