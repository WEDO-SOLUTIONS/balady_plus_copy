import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/accept_offer.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/cancel_request.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/edit_dynamic_form.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/find_by_request_type.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/get_edit_form_view.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/get_form_view.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/get_offers.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/reject_offer.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/submit_dynamic_form.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/submit_order.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/validate_dynamic_form.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/presentation/blocs/city_bloc.dart';

import '../dependency_injection_exports.dart' show sl;

class DynamicFormsInjection {
  static void init() {
    //! Use Case
    sl.registerLazySingleton(() => CreateBiddingForm(repository: sl()));
    sl.registerLazySingleton(() => GetFormFieldData(repository: sl()));
    sl.registerLazySingleton(() => FindByRequestType(repository: sl()));
    sl.registerLazySingleton(() => SubmitDynamicForm(repository: sl()));
    sl.registerLazySingleton(() => ValidateDynamicForm(repository: sl()));
    sl.registerLazySingleton(() => GetFormView(repository: sl()));
    sl.registerLazySingleton(() => GetOffers(repository: sl()));
    sl.registerLazySingleton(() => AcceptOffer(repository: sl()));
    sl.registerLazySingleton(() => RejectOffer(repository: sl()));
    sl.registerLazySingleton(() => SubmitOrder(repository: sl()));
    sl.registerLazySingleton(() => CancelRequest(repository: sl()));
    sl.registerLazySingleton(() => GetEditFormView(repository: sl()));
    sl.registerLazySingleton(() => EditDynamicForm(repository: sl()));

    //! Entities

    //! Repository
    sl.registerLazySingleton<DynamicFormsRepository>(
      () => DynamicFormsRepositoryImpl(remoteDataSource: sl()),
    );

    //! Data Sources
    sl.registerLazySingleton<DynamicFormRemoteDataSource>(
      () => DynamicFormRemoteDataSourceImpl(webService: sl()),
    );
  }
}
