import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/etmam_app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_page_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';

part 'service_details_event.dart';
part 'service_details_state.dart';

class ServiceDetailsBloc
    extends Bloc<ServiceDetailsEvent, ServiceDetailsState> {
  ServiceDetailsResponse response;
  final GetReleation _getRelations;
  ServiceDetailsBloc({
    required this.response,
    required GetReleation getRelations,
  })  : _getRelations = getRelations,
        super(ServiceDetailsState(
            response: response,
            subServiceId: response.service?.id,
            subServiceName: response.service?.name)) {
    on<ServiceDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetRelationsForDetailsEvent>(_getRelationsHandler);
  }

  Future<void> _getRelationsHandler(
      GetRelationsForDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getRelations(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));

      if (success.data?.result?.subRelations?.isNotEmpty ?? false) {
        NavigationService.pushNamed(
            routeName: EtmamRoutesNames.relationsList,
            args: RelationPageParam(
                relationResponse: success.data?.result,
                serviceProviderId: e.params.serviceProviderId,
                serviceProviderName: e.params.serviceProviderName,
                subServiceId: state.subServiceId,
                subServiceName: state.subServiceName));
      } else {
        NavigationService.pushNamed(
            routeName: EtmamRoutesNames.orderInfo,
            args: SubmitPageParams(
                serviceProviderId: e.params.serviceProviderId,
                serviceProviderName: e.params.serviceProviderName,
                subServiceId: state.subServiceId,
                relationId: success.data?.result?.id,
                inputsRequired: success.data?.result?.inputsRequired,
                subServiceName: state.subServiceName,
                subRelations: success.data?.result?.subRelations));
      }
    });
  }
}
