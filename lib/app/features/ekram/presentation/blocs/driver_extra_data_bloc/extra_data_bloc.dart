
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../data/model/driver/GhuslEmploye.dart';
import '../../../data/model/driver/deceased_attachment.dart';
import '../../../data/model/driver/deceased_identical_item.dart';
import '../../../domain/use_cases/download_attachment.dart';
import '../../../domain/use_cases/get_deceased_attachment.dart';
import '../../../domain/use_cases/get_ghusl_employees.dart';
import '../../../domain/use_cases/get_identical_list_request.dart';
part 'extra_data_bloc_state.dart';
part 'extra_data_bloc_event.dart';

class ExtraDataBloc extends Bloc<ExtraDataEvent, ExtraDataState> {


  final GetGhuslEmployees _getGhuslEmployees;
  final GetDeceasedAttachment _getDeceasedAttachment;
  final DownloadAttachment _downloadAttachment;


  ExtraDataBloc(
      {
        required GetGhuslEmployees getGhuslEmployees,
        required GetDeceasedAttachment getDeceasedAttachment,
        required DownloadAttachment downloadAttachment,
      })
      :
        _getGhuslEmployees = getGhuslEmployees,
        _getDeceasedAttachment = getDeceasedAttachment,
        _downloadAttachment = downloadAttachment,
        super(ExtraDataState()) {


    on<GetGhuslEmployeesEvent>(_getGhuslEmployeesHandler);
    on<GetDeceasedAttachmentEvent>(_getDeceasedAttachmentHandler);
    on<SetSelectEmployeeEvent>(_setSelectedEmployee);
    on<DownLoadDeceasedAttachmentEvent>(_downLoadAttachmentHandler);

  }

  Future<void> _getDeceasedAttachmentHandler(GetDeceasedAttachmentEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    var failureOrSuccess =
    await _getDeceasedAttachment(4617328594);
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {

      Map<int, List<DeceasedAttachment>>? data = prepareAttachmentData(e.requestId,success.data?.result);
      emitter(state.copyWith(
        status: BlocStatus.success,
        lstDeceasedAttachment: data,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getGhuslEmployeesHandler(GetGhuslEmployeesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    var failureOrSuccess =
        await _getGhuslEmployees(e.requestId);
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {

      Map<int, List<GhuslEmploye>>? data = prepareData(e.requestId,success.data?.result);
      emitter(state.copyWith(
        status: BlocStatus.success,
        lstEmploye: data,
        errorMessage: "",
      ));
    });
  }

  Future<void> _downLoadAttachmentHandler(
      DownLoadDeceasedAttachmentEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _downloadAttachment(e.id);

    failureOrSuccess.fold((failure) {
      print(failure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));
      Helpers.openFile(success.data, contentType: success.type);
    });
  }







  Future<void> _setSelectedEmployee(SetSelectEmployeeEvent e, Emitter emitter) async {



    emitter(state.copyWith(
      status: BlocStatus.success,
      lstSelectedEmployee: setSelectedEmployeeData(e.requestId, e.employee),
      errorMessage: "",
    ));

  }

  Map<int, List<GhuslEmploye>>? prepareData(int requestId,List<GhuslEmploye>? res){
    Map<int, List<GhuslEmploye>>? map= state.lstEmployee;
    map ??= <int, List<GhuslEmploye>>{};
    if(res != null &&res.isNotEmpty)
      {
        map[requestId]= res;
      }
    return map;
  }

  Map<int, List<DeceasedAttachment>>? prepareAttachmentData(int requestId,List<DeceasedAttachment>? res){
    Map<int, List<DeceasedAttachment>>? map= state.lstDeceasedAttachment;
    map ??= <int, List<DeceasedAttachment>>{};
    if(res != null &&res.isNotEmpty)
    {
      map[requestId]= res;
    }
    return map;
  }


  Map<int, GhuslEmploye>? setSelectedEmployeeData(int requestId,GhuslEmploye? emp){

    Map<int, GhuslEmploye>? map= state.lstSelectedEmploye;
    map ??= <int, GhuslEmploye>{};
    if(emp != null)
    {
      map[requestId]= emp;
    }
    return map;
  }

  List<GhuslEmploye>? getGhuslEmployeeByRequestId(int requestId)
  {
    Map<int, List<GhuslEmploye>>? map= state.lstEmployee;
    if(map!= null && map.containsKey(requestId))
      {
        return map[requestId];
      }

    return null;
  }

  List<DeceasedAttachment>? getAttachmentByRequestId(int requestId)
  {
    Map<int, List<DeceasedAttachment>>? map= state.lstDeceasedAttachment;
    if(map!= null && map.containsKey(requestId))
    {
      return map[requestId];
    }

    return null;
  }

}
