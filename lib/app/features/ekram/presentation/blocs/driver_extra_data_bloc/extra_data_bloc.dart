
import 'package:balady_plus/app/commercial_model/features/comercial_license_renew/data/data_sources/renew_cr_remote_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../data/model/driver/EditAdditionalRequest.dart';
import '../../../data/model/driver/GhuslEmploye.dart';
import '../../../data/model/driver/deceased_attachment.dart';
import '../../../data/model/driver/deceased_identical_item.dart';
import '../../../data/model/upload_letter_params.dart';
import '../../../domain/use_cases/delete_attachment.dart';
import '../../../domain/use_cases/edit_aditional_data.dart';
import '../../../domain/use_cases/get_deceased_attachment.dart';
import '../../../domain/use_cases/get_ghusl_employees.dart';
import '../../../domain/use_cases/get_identical_list_request.dart';
import '../../../domain/use_cases/upload_attachment.dart';
part 'extra_data_bloc_state.dart';
part 'extra_data_bloc_event.dart';

class ExtraDataBloc extends Bloc<ExtraDataEvent, ExtraDataState> {


  final GetGhuslEmployees _getGhuslEmployees;
  final GetDeceasedAttachment _getDeceasedAttachment;
  final UploadAttachment _uploadAttachment;
  final DeleteAttachment _deleteAttachment;
  final EditAdditionalData _editAdditionalData;






  ExtraDataBloc(
      {
        required GetGhuslEmployees getGhuslEmployees,
        required GetDeceasedAttachment getDeceasedAttachment,
        required UploadAttachment uploadAttachment,
        required EditAdditionalData editAdditionalData,
        required DeleteAttachment deleteAttachment
      })
      :
        _getGhuslEmployees = getGhuslEmployees,
        _getDeceasedAttachment = getDeceasedAttachment,
        _editAdditionalData = editAdditionalData,
        _deleteAttachment = deleteAttachment,
        _uploadAttachment = uploadAttachment,
        super(ExtraDataState(lstSelectedEmploye: {},lstEmployee: {},lstDeceasedAttachment: {})) {


    on<GetGhuslEmployeesEvent>(_getGhuslEmployeesHandler);
    on<GetDeceasedAttachmentEvent>(_getDeceasedAttachmentHandler);
    on<SetSelectEmployeeEvent>(_setSelectedEmployeeHandler);
    on<UploadDeceasedAttachmentEvent>(_UploadAttachmentHandler);
    on<DeleteDeceasedAttachmentEvent>(_DeleteAttachmentHandler);
     on<EditAdditionalDataEvent>(_editAdditionalDataHandler);


  }


  Future<void> _editAdditionalDataHandler(EditAdditionalDataEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    String? ghuslEmployeeIdentityNumber;
    GhuslEmploye? emp =getSelectedEmployeeData(e.requestId);
    if(emp != null) {
      ghuslEmployeeIdentityNumber= emp.identityNumber;
    }



    EditAdditionalRequest request = EditAdditionalRequest().copyWith(requestId: e.requestId,attachments:getUpdateAttachmentByRequestId(e.requestId),ghuslEmployeeIdentityNumber:ghuslEmployeeIdentityNumber);
    var failureOrSuccess = await _editAdditionalData(request);
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      CommonFunctions.showError((failure as ServerFailure).errorMessage);
    }, (success) async {

          emitter(state.copyWith(
            status: BlocStatus.success,

            errorMessage: "",
          ));
          CommonFunctions.showSuccess("update_appointment_success_msg".tr());



    });
  }

  Future<void> _getDeceasedAttachmentHandler(GetDeceasedAttachmentEvent e, Emitter emitter) async {
   // emitter(state.copyWith(lstDeceasedAttachment:{}));
    emitter(state.copyWith(status: BlocStatus.loading));
    var failureOrSuccess =
    await _getDeceasedAttachment(e.requestId);
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {

      Map<int, List<DeceasedAttachment>>? data =prepareAttachmentData(e.requestId,success.data?.result);
      emitter(state.copyWith(
        status: BlocStatus.success,
        lstDeceasedAttachment: data,
        errorMessage: "",
      ));

    });
  }

  Future<void> _getGhuslEmployeesHandler(GetGhuslEmployeesEvent e, Emitter emitter) async {
   // emitter(state.copyWith(lstDeceasedAttachment:{},lstSelectedEmployee: {}));
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
      GhuslEmploye? emp  = getDefultSelectedEmployee(data,e.requestId,e.ghuslEmployeeIdentityNo);
      Map<int, GhuslEmploye>? lstSelectedEmployee =setSelectedEmployeeData(e.requestId, emp);
      
      emitter(state.copyWith(
        status: BlocStatus.success,
        lstEmploye: data,
        lstSelectedEmployee: lstSelectedEmployee,
        errorMessage: "",
      ));
    });
  }

  Future<void> _UploadAttachmentHandler(UploadDeceasedAttachmentEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _uploadAttachment([e.attachmentId,e.file!]);

    failureOrSuccess.fold((failure) {
      print(failure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (res) async {

      if(res.data?.result != null)
        {
          Map<int, List<DeceasedAttachment>>?map = state.lstDeceasedAttachment;
          if(map != null && map.containsKey(e.requestId))
            {
              List<DeceasedAttachment>? lst=  map[e.requestId];
              if(lst != null)
                {

                  int index=lst.indexWhere((item) => item.attachmentTypeId == res.data?.result?.attachmentTypeId );
                if(index != -1)
                  {
                    var newAttachment = res.data!.result;
                    newAttachment?.allowedFilesExtension = lst[index].allowedFilesExtension;
                    lst.removeAt(index);
                    lst.add(newAttachment!);
                    map[e.requestId!]=lst;
                    emitter(state.copyWith(
                      status: BlocStatus.success,
                      errorMessage: "",
                      lstDeceasedAttachment: map
                    ));
                    
                    
                    add(EditAdditionalDataEvent(requestId: e.requestId!));

                    //CommonFunctions.showSuccess("uploadSucessfull".tr());

                  }


                }

            }
        }



     // CommonFunctions.showSuccess(success.data?.responseMessage ?? "");

    });

  }

  Future<void> _DeleteAttachmentHandler(DeleteDeceasedAttachmentEvent e, Emitter emitter) async {

    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _deleteAttachment([e.item?.id!,e.requestId]);


    failureOrSuccess.fold((failure) {
      print(failure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      CommonFunctions.showError((failure as ServerFailure).errorMessage);
    }, (res) async {

      if(res.data?.result == true)
      {

        add(GetDeceasedAttachmentEvent(requestId: e.requestId!));
        CommonFunctions.showSuccess("path_deleted".tr());

      }





    });

  }


  _setSelectedEmployeeHandler(SetSelectEmployeeEvent e, Emitter emitter)  {
   emitter(state.copyWith(
     status: BlocStatus.loading,
     errorMessage: "",
   ));
    Map<int, GhuslEmploye>? lstSelectedEmployee =setSelectedEmployeeData(e.requestId,e.employee );

        emitter(state.copyWith(
          status: BlocStatus.success,
          lstSelectedEmployee: lstSelectedEmployee,
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


  Map<int, GhuslEmploye>? setSelectedEmployeeData(int requestId,GhuslEmploye? emp) {

    Map<int, GhuslEmploye>? map= state.lstSelectedEmploye;
    map ??= <int, GhuslEmploye>{};
    if(emp != null)
    {
      map[requestId]= emp;
    }
    return map;
  }
   GhuslEmploye? getSelectedEmployeeData(int requestId){

    Map<int, GhuslEmploye>? map= state.lstSelectedEmploye;
    map ??= <int, GhuslEmploye>{};

    return map[requestId];
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

  GhuslEmploye? getDefultSelectedEmployee(Map<int, List<GhuslEmploye>>? map,int requestId,String? employeeId)
  {

    if(map!= null && map.containsKey(requestId))
    {

      List<GhuslEmploye>? lstEmployee =   map[requestId];
      if(lstEmployee != null && lstEmployee.isNotEmpty && employeeId != null)
        {
          GhuslEmploye emp=lstEmployee.firstWhere((item) => item.identityNumber == employeeId );
        
          return emp;

        }
    
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

  List<DeceasedAttachment>? getUpdateAttachmentByRequestId(int requestId)
  {
    List<DeceasedAttachment>? res=[];
    Map<int, List<DeceasedAttachment>>? map= state.lstDeceasedAttachment;
    if(map!= null && map.containsKey(requestId))
    {
      List<DeceasedAttachment>? lst= map[requestId];

      for(int index=0;index<lst!.length;index++)
        {
          if(lst[index].id!= null &&lst[index].attached== true )
            {
              res.add(lst[index]);
            }
        }
      return res;
    }

    return null;
  }


  bool validateForm(DeceasedIdenticalItem item){
    Map<int, List<DeceasedAttachment>>?map = state.lstDeceasedAttachment;

        if(item.ghuslEmployeeRequired==true && (item.ghuslEmployeeIdentityNo==null||item.ghuslEmployeeIdentityNo!.isEmpty)) {

         CommonFunctions.showError("slectGhuslName".tr());
          return false;
        }
        else if(map != null && map.containsKey(item.requestId))
          {
            List<DeceasedAttachment>? lst = map[item.requestId];
            if (lst != null) {
              for(int index = 0; index<lst.length;index++)
                {
                  if(lst[index].mandatory==true && (lst[index].attachUrl == null||lst[index].attachUrl!.isEmpty))
                    {

                      CommonFunctions.showError("pleaseenter".tr()+ lst[index].name!);
                      return false;
                    }


                }

            }

          }
          return true;
      }


    }


