import 'package:mapness/features/jobs/models/job_model.dart';
import 'package:mapness/features/jobs/models/job_response_model.dart';
import 'package:mapness/shared/providers/dgis_hmac_netwrok.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_detail_provider.g.dart';

@riverpod
class JobDetailResponse extends _$JobDetailResponse {
  @override
  Future<JobModel?> build({required String id}) async {
    final dio = await ref.read(dgisHmacNetwrokProvider.future);

    final response = await dio.get('/jobs/$id');

    final jobResponse =
        JobBaseResponse<JobModel>.fromJson(response.data, JobModel.fromJson);

    final jobDetail = jobResponse.data?.result;
    if (jobResponse.isSuccess) {
      return jobDetail;
    } else {
      throw Exception(jobResponse.message);
    }
  }
}
