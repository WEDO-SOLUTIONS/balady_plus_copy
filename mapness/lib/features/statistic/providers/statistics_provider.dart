import 'package:mapness/features/statistic/model/statistics_request.dart';
import 'package:mapness/features/statistic/providers/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'statistics_provider.g.dart';

@riverpod
Future<void> sendStatistic(SendStatisticRef ref, String query) async {
  final repository = ref.read(repositoryProvider).value;
  await repository?.sendStatistics(StatisticsRequest(
    query: query,
    eventId: const Uuid().v1(),
    timestamp: DateTime.now().millisecondsSinceEpoch,
  ).toBssPayload());
}
