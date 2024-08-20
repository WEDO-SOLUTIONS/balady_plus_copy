import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts//data/data_sources/commercial_debts_data_sources.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/repositories/commercial_debts_repository.dart';

class CommercialDebtInjection {
  static void init() {
    // Data Sources
    sl.registerLazySingleton<CommercialDebtsDataSources>(
      () => ChatBotDataSourcesImplementation(webService: sl()),
    );
    // Repository
    sl.registerLazySingleton<CommercialDebtRepository>(
      () => CommercialDebtRepository(sl()),
    );
  }
}
