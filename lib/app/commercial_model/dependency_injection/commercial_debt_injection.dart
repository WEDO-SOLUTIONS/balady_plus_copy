import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/repositories/commercial_list_debts_repository.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';

import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/data_sources/commercial_debts_data_sources.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/repositories/commercial_debts_repository.dart';

class CommercialDebtInjection {
  static void init() {
    // Repository
    sl.registerLazySingleton<CommercialDebtRepository>(
      () => CommercialDebtRepository(
        sl(),
      ),
    );

    sl.registerLazySingleton<CommercialListDebtRepository>(
      () => CommercialListDebtRepository(
        sl(),
      ),
    );

    // Data Sources
    sl.registerLazySingleton<CommercialDebtsDataSources>(
      () => CommercialDebtsDataSourcesImplementation(webService: sl()),
    );
  }
}
