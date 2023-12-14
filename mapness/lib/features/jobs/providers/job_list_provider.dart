import 'package:mapness/features/jobs/models/job_list_model.dart';
import 'package:mapness/features/jobs/models/job_response_model.dart';
import 'package:mapness/shared/providers/dgis_hmac_netwrok.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_list_provider.g.dart';

@riverpod
class JobListResponse extends _$JobListResponse {
  int? _page;
  int? _size;
  bool _canLoadMore = true;

  bool _isLoading = false;

  JobListModel? _allJobs;

  Future<JobListModel?> _load() async {
    try {
      _isLoading = true;
      final dio = ref.watch(dgisHmacNetwrokProvider);

      final response = await dio.get('/published/jobs', queryParameters: {
        'page-no': _page,
        'page-size': _size,
        'sort': sort,
      });

      final jobResponse = JobBaseResponse<JobListModel>.fromJson(
          response.data, JobListModel.fromJson);

      final jobList = jobResponse.data?.result;
      if (jobResponse.isSuccess) {
        final records = state.value?.records ?? [];
        final loadedRecords = jobList?.records ?? [];
        _canLoadMore = loadedRecords.length == _size;
        records.addAll(jobList?.records ?? []);
        if (jobList != null) {
          _allJobs = jobList.copyWith(records: records);
        }
      } else {
        throw Exception(jobResponse.message);
      }
    } catch (_) {
    } finally {
      _isLoading = false;
    }

    return _allJobs;
  }

  Future<void> loadNextPage() async {
    if (_page != null && _size != null && _canLoadMore) {
      if (_isLoading) return;
      _page = _page! + 1;
      await _load();
      ref.invalidateSelf();
    }
  }

  @override
  Future<JobListModel?> build(
      {required int page, required int size, String sort = 'desc'}) async {
    _page ??= page;
    _size ??= size;

    return _allJobs ?? await _load();
  }
}
