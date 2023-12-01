import 'package:dio/dio.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'happiness_repository.g.dart';

@riverpod
class _HappinessRepository extends _$HappinessRepository {
  // returns should close or not
  Future<void> submitFeedback(HappinessState feedback) async {
    final dio = ref.read(dGisNetworkProvider);
    state = const AsyncLoading();
    final data = HappinessRequest(
      isPositive: feedback.feedback == HappinessFeedback.like,
      // comment: state.comment,
      tags: feedback.tags.map((e) => HappinessRequest_Tag(name: e)),
      point: Point(
        latitude: feedback.coordinates.latitude,
        longitude: feedback.coordinates.longitude,
      ),
      // coordinates: state.coordinates,
    );
    try {
      final _ = await dio.post(
        '/happiness',
        data: data.writeToBuffer(),
      );
      state = const AsyncData(true);
    } on DioException {
      state = AsyncError(
        'Dio error',
        StackTrace.current,
      );
    }
  }

  @override
  Future<bool> build() async {
    return false;
  }
}

final happinessRepositoryProvider = _happinessRepositoryProvider;
