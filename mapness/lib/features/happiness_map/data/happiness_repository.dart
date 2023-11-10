import 'package:mapness/features/common/providers/dgis_network.dart';
import 'package:mapness/features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'happiness_repository.g.dart';

@riverpod
class HappinessRepository extends _$HappinessRepository {
  Future<void> submitFeedback(HappinessState state) async {
    final dio = ref.read(dGisNetworkProvider);
    final data = HappinessRequest(
      isPositive: state.feedback == HappinessFeedback.like,
      // comment: state.comment,
      tags: state.tags.map((e) => HappinessRequest_Tag(name: e)),
      point: Point(
        latitude: state.coordinates.latitude,
        longitude: state.coordinates.longitude,
      ),
      // coordinates: state.coordinates,
    );
    await dio.post(
      '/happiness',
      data: data.writeToBuffer(),
    );
  }

  @override
  void build() {}
}
