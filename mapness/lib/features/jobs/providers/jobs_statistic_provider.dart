import 'package:mapness/entry_point.dart';
import 'package:mapness/features/jobs/data/models/job_response_model.dart';
import 'package:mapness/features/jobs/data/models/job_statistic_model.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_hmac_netwrok.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'jobs_statistic_provider.g.dart';

@riverpod
class JobStatistic extends _$JobStatistic {
  static const _metricEventName = 'Jobs: Request statistic for job';

  @override
  Future<JobStatisticModel?> build() async {
    Metrics.logEvent(_metricEventName);

    mixpanel?.timeEvent(_metricEventName);

    // Rebuild statistic, when auth state is changed
    ref.watch(authProvider);

    final dio = await ref.read(dgisHmacNetwrokProvider.future);

    final env = await ref.read(dgisEnvironmentProvider.future);
    final jobsUrl = '${env.jobsApi}/jobs/statistics';
    final response = await dio.get(jobsUrl);

    final jobResponse = JobBaseResponse<JobStatisticModel>.fromJson(
      response.data as Map<String, dynamic>,
      JobStatisticModel.fromJson,
    );

    final jobStatistic = jobResponse.data?.result;
    await mixpanel?.track(_metricEventName);
    if (jobResponse.isSuccess) {
      return jobStatistic;
    } else {
      throw Exception(jobResponse.message);
    }
  }
}
