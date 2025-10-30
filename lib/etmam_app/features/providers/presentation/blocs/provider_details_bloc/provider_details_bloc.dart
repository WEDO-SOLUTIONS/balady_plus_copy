import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:bloc/bloc.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerFailure;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show ProviderDetailsResponse;
import 'package:balady_plus/etmam_app/features/services/domain/entities/service_details/service_details_params.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show GetServiceDetails;

import 'package:collection/collection.dart';

import '../../../../../../app/core/utils/constants/constants.dart';
import '../../../../../../app/core/utils/map_utils.dart';

part 'provider_details_event.dart';
part 'provider_details_state.dart';

class ProviderDetailsBloc
    extends Bloc<ProviderDetailsEvent, ProviderDetailsState> {
  GetServiceDetails _getServiceDetails;

  ProviderDetailsBloc({
    required ProviderDetailsResponse args,
    required GetServiceDetails getServiceDetails,
  })  : _getServiceDetails = getServiceDetails,
        super(ProviderDetailsState(args: args)) {
    on<ProviderDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetServiceDetailsEvent>(_getGetServiceDetailsHandler);
    args.branches = args.branches?.mapIndexed((index, e) {
      e.id = index.toString();
      return e;
    }).toList();
  }

  Future<void> _getGetServiceDetailsHandler(
      GetServiceDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getServiceDetails(e.params);

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

      NavigationService.pushNamed(
          routeName: EtmamRoutesNames.serviceProvidersDetails,
          args: success.data?.result);
    });
  }

  Set<Marker> getMarkers() {
    return state.args.branches != null
        ? state.args.branches!
            .map((e) => e.getLatLng() != null
                ? Marker(
      id: e.id ?? "1",
      onTap: () {
        if (e.id != null)
          CommonFunctions.launchMap(e.location?.getLatLng());
      },
      options: MarkerOptionsMessage(
        position: GeoPointWithElevationMessage(
          latitude: e.getLatLng()!.latitude,
          longitude: e.getLatLng()!.longitude,
          elevation: 0,
        ),
        icon: MarkerIconMessage(
          width: 28,
          pngPath:Constants.pinDarkGreenMarkerLocation,
        ),
      ),
    )

    // Marker(
    //                 id: MarkerId(e.id ?? "1"),
    //                 position: e.getLatLng()!,
    //                 icon: MapUtils.mapIconMarker ??
    //                     BitmapDescriptor.defaultMarker,
    //                 onTap: () {
    //                   if (e.id != null)
    //                     CommonFunctions.launchMap(e.location?.getLatLng());
    //                 }, )



                : null)
            .whereNotNull()
            .toSet()
        : {};
  }
}
