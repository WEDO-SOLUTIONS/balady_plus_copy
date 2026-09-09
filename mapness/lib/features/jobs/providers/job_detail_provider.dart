import 'package:mapness/entry_point.dart';
import 'package:mapness/features/jobs/data/models/job_model.dart';
import 'package:mapness/features/jobs/data/models/job_response_model.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_hmac_netwrok.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_detail_provider.g.dart';

@riverpod
class JobDetail extends _$JobDetail {
  static const _metricEventName = 'Jobs: Request detail for job';

  @override
  Future<JobModel?> build({required String id}) async {
    Metrics.logEvent(
      _metricEventName,
      extras: {'id': id},
    );
    mixpanel?.timeEvent(_metricEventName);
    final dio = await ref.read(dgisHmacNetwrokProvider.future);

    final env = await ref.read(dgisEnvironmentProvider.future);
    final jobsUrl = '${env.jobsApi}/jobs/$id';
    final response = await dio.get(jobsUrl);

    final jobResponse = JobBaseResponse<JobModel>.fromJson(
      response.data as Map<String, dynamic>,
      JobModel.fromJson,
    );

    final jobDetail = jobResponse.data?.result;
    await mixpanel?.track(_metricEventName);
    if (jobResponse.isSuccess) {
      return jobDetail;
    } else {
      throw Exception(jobResponse.message);
    }
  }
}
