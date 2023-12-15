import 'package:mapness/features/jobs/models/job_response_model.dart';
import 'package:mapness/features/jobs/models/job_statistic_model.dart';
import 'package:mapness/shared/providers/dgis_hmac_netwrok.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'jobs_statistic_provider.g.dart';

@riverpod
class JobStatisticResponse extends _$JobStatisticResponse {
  @override
  Future<JobStatisticModel?> build() async {
    final dio = ref.watch(dgisHmacNetwrokProvider);

    final response = await dio.get('/jobs/statistics');

    final jobResponse = JobBaseResponse<JobStatisticModel>.fromJson(
        response.data, JobStatisticModel.fromJson);

    final jobStatistic = jobResponse.data?.result;
    if (jobResponse.isSuccess) {
      return jobStatistic;
    } else {
      throw Exception(jobResponse.message);
    }
  }
}
