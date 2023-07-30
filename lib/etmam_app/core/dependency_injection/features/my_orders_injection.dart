import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/get_order_details.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/get_rating_items.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/submit_rating.dart';

import '../dependency_injection_exports.dart' show sl;
import '../../../features/my_orders/my_orders_exports.dart'
    show
        GetMyOrders,
        MyOrdersRepository,
        MyOrdersRepositoryImpl,
        MyOrdersRemoteDataSource,
        CancelOrder,
        MyOrdersRemoteDataSourceImpl,
        MyOrdersLocalDataSource,
        MyOrdersLocalDataSourceImpl;

class MyOrdersInjection {
  static void init() {
    //! blocs
    // sl.registerLazySingleton(
    //    () => MyOrdersBloc(cancelOrder: sl(), getMyOrders: sl()));

    //! Use Case
    sl.registerLazySingleton(() => GetMyOrders(repository: sl()));
    sl.registerLazySingleton(() => CancelOrder(repository: sl()));
    sl.registerLazySingleton(() => GetRatingItems(repository: sl()));
    sl.registerLazySingleton(() => GetOrderDetails(repository: sl()));
    sl.registerLazySingleton(() => SubmitRating(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<MyOrdersRepository>(
      () =>
          MyOrdersRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<MyOrdersRemoteDataSource>(
      () => MyOrdersRemoteDataSourceImpl(webService: sl()),
    );
    sl.registerLazySingleton<MyOrdersLocalDataSource>(
      () => MyOrdersLocalDataSourceImpl(),
    );
  }
}
