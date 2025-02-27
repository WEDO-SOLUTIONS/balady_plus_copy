import 'package:bloc/bloc.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show Branch;
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:collection/collection.dart';
import '../../../../../../app/core/utils/constants/constants.dart';
import '../../../../../../app/core/utils/map_utils.dart';

part 'branch_map_event.dart';
part 'branch_map_state.dart';

class BranchMapBloc extends Bloc<BranchMapEvent, BranchMapState> {
  List<Branch> branches;
  BranchMapBloc({required this.branches}) : super(BranchMapState()) {
    on<BranchMapEvent>((event, emit) {
      // TODO: implement event handler
    });
    branches = branches.mapIndexed((index, e) {
      e.id = index.toString();
      return e;
    }).toList();

    on<SelectBranchEvent>(_selectBranchHandler);
  }

  Future<void> _selectBranchHandler(
      SelectBranchEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    Branch? selected =
        branches.firstWhereOrNull((element) => element.id == e.id);

    if (selected != null)
      emitter(
          state.copyWith(selectedBranch: selected, status: BlocStatus.success));
  }

  Set<Marker> getMarkers() {
    return branches
        .map((e) => e.getLatLng() != null
            ?  Marker(
        id: e.id ?? "1",
        onTap: () {
          if (e.id != null)
            if (e.id != null) add(SelectBranchEvent(id: e.id!));
        },
        options: MarkerOptionsMessage(
          position: GeoPointWithElevationMessage(
            latitude: e.getLatLng()!.latitude,
            longitude: e.getLatLng()!.longitude,
            elevation: 0,
          ),
          icon: MarkerIconMessage(
            width: 28,
            pngPath: Constants.pinDarkGreenMarkerLocation,
          ),
        ),)


        // Marker(
        //         markerId: MarkerId(e.id ?? "1"),
        //         position: e.getLatLng()!,
        //         icon: MapUtils.pinMarkerDarkGreen ??
        //             BitmapDescriptor.defaultMarker,
        //         onTap: () {
        //           if (e.id != null) add(SelectBranchEvent(id: e.id!));
        //         })


            : null)
        .whereNotNull()
        .toSet();
  }
}
