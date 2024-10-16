import 'package:mapness/entry_point.dart';
import 'package:mapness/features/jobs/data/models/job_list_model.dart';
import 'package:mapness/features/jobs/data/models/job_response_model.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_hmac_netwrok.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_list_provider.g.dart';

@riverpod
class JobList extends _$JobList {
  static const _jobPageSize = 10;
  static const _jobStartPage = 1;

  int? _page;
  int? _size;
  bool _canLoadMore = true;

  bool _isLoading = false;

  JobListModel? _allJobs;

  Future<JobListModel?> _load() async {
    mixpanel?.timeEvent('JobList: _load');
    try {
      _isLoading = true;
      final dio = await ref.read(dgisHmacNetwrokProvider.future);

      final env = await ref.read(dgisEnvironmentProvider.future);
      final jobsUrl = '${env.jobsApi}/published/jobs';

      final response = await dio.get(
        jobsUrl,
        queryParameters: {
          'page-no': _page,
          'page-size': _size,
          'sort': sort,
        },
      );

      final jobResponse = JobBaseResponse<JobListModel>.fromJson(
        response.data as Map<String, dynamic>,
        JobListModel.fromJson,
      );

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
    } on Exception catch (_) {
    } finally {
      _isLoading = false;
    }
    await mixpanel?.track('JobList: _load');
    return _allJobs;
  }

  Future<void> loadNextPage() async {
    if (_page != null && _size != null && _canLoadMore) {
      if (_isLoading) {
        return;
      }
      _page = _page! + 1;
      await _load();
      ref.invalidateSelf();
    }
  }

  @override
  Future<JobListModel?> build({
    int? page,
    int? size,
    String sort = 'desc',
  }) async {
    // set default values
    _page ??= page ?? _jobStartPage;
    _size ??= size ?? _jobPageSize;

    return _allJobs ?? await _load();
  }
}
