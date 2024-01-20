import 'package:mapness/entry_point.dart';
import 'package:mapness/features/jobs/models/job_response_model.dart';
import 'package:mapness/features/jobs/models/job_statistic_model.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/dgis_hmac_netwrok.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'jobs_statistic_provider.g.dart';

@riverpod
class JobStatistic extends _$JobStatistic {
  static const _metricEventName = 'Jobs: Request statistic for job';

  @override
  Future<JobStatisticModel?> build() async {
    ref.read(urbiMetricsProvider.notifier).logEvent(_metricEventName);

    mixpanel?.timeEvent(_metricEventName);

    // Rebuild statistic, when auth state is changed
    ref.watch(authProvider);

    final dio = await ref.read(dgisHmacNetwrokProvider.future);

    final response = await dio.get('/jobs/statistics');

    final jobResponse = JobBaseResponse<JobStatisticModel>.fromJson(
        response.data, JobStatisticModel.fromJson);

    final jobStatistic = jobResponse.data?.result;
    mixpanel?.track(_metricEventName);
    if (jobResponse.isSuccess) {
      return jobStatistic;
    } else {
      throw Exception(jobResponse.message);
    }
  }
}
