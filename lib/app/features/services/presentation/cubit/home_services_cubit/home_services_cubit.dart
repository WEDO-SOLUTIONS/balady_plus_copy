import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/features/services/core/services.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/domain/use_cases/home_services_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'home_services_state.dart';

class HomeServicesCubit extends Cubit<ServicesState> {
  HomeServicesUseCases homeServicesUseCases;

  HomeServicesCubit({
    required this.homeServicesUseCases,
  }) : super(
          ServicesSuccessState(
            homeServices: HomeServices.fromJson(newServicesConfig),
          ),
        ) {
    loadServices();
  }

  // Future<bool> checkForjoodService() async {
  //   WebService webService = sl();
  //   Response? response;
  //   try {
  //     response = await webService.dio.get(ApiUrl.getJoodShowStatus);
  //     final data = response.data;
  //     final result = ResponseBodyModel.fromMap(data).data?.result;
  //     return result['isEnabled'];
  //   } catch (error, stackTrace) {
  //     LogsViewModel().sendEventFromModel(
  //       event: ErrorExceptionModel(
  //         nameEvent: EventsName.handledException,
  //         message: error.toString(),
  //         stackTrace: stackTrace.toString(),
  //       ),
  //     );
  //     return true;
  //   }
  // }

  // Future<bool> checkForChatBotEnabled() async {
  //   WebService webService = sl();
  //   Response? response;
  //   try {
  //     response = await webService.dio.get(ApiUrl.chatBotEnabled);
  //     final data = response.data;
  //     final result = ResponseBodyModel.fromMap(data).data?.result;
  //     return result['isEnabled'];
  //   } catch (error, stackTrace) {
  //     LogsViewModel().sendEventFromModel(
  //       event: ErrorExceptionModel(
  //         nameEvent: EventsName.handledException,
  //         message: error.toString(),
  //         stackTrace: stackTrace.toString(),
  //       ),
  //     );
  //     return true;
  //   }
  // }

  Future<void> loadServices() async {
    homeServicesUseCases.call(NoParams()).then((value) {
      value.fold(
        (l) {
          emit(
            ServicesSuccessState(
              homeServices: HomeServices.fromJson(newServicesConfig),
            ),
          );
        },
        (r) {
          emit(
            ServicesSuccessState(homeServices: r),
          );
        },
      );
    });
  }








// void checkEkramServices() async {
//   print("checkEkramServices");
//   emit(state.copyWith(status: BlocStatus.closeLoading));
//
//   final businessLicenseServicesList = await ekramServices(NoParams());
//
//   emit(state.copyWith(
//     status: BlocStatus.success,
//     honoringTheDeadServices:
//         businessLicenseServicesList.getOrElse(() => []).where((service) {
//       if (CommonProperties.showEkramDriver) return true;
//       if (CommonProperties.showEkramDriver != true && service.id == 316)
//         return false;
//       return true;
//     }).toList(),
//   ));
// }

// void toggleSearchField() {
//   emit(state.copyWith(showSearchField: !state.showSearchField));
// }
}
