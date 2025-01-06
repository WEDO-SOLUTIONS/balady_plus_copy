import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/models/success_screen_args.dart';
import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_page_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/use_cases/submit_request.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;
import 'package:collection/collection.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' as balady;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:smart_advisor/app/core/utils/constants/app_config.dart';
import '../../../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../../../app/core/utils/constants/ux_cam_events.dart';
import '../../../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../../core/utils/enums/dynamic_forms.dart';
import '../../../../../dynamic_form/domain/entities/create_form_item_response.dart';
import '../../../../../dynamic_form/domain/entities/create_form_params.dart';
import '../../../../../dynamic_form/domain/entities/get_data_params.dart';
import '../../../../../dynamic_form/domain/entities/validate/validate_form_params.dart';
import '../../../../../dynamic_form/domain/entities/validate/validate_form_response.dart';
import '../../../../../dynamic_form/domain/use_cases/create_bidding_form.dart';
import '../../../../../dynamic_form/domain/use_cases/get_form_field_data.dart';
import '../../../../../dynamic_form/domain/use_cases/validate_dynamic_form.dart';
import '../../../../../etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';

part 'submit_request_event.dart';

part 'submit_request_state.dart';

class SubmitRequestBloc extends Bloc<SubmitRequestEvent, SubmitRequestState> {
  SubmitRequest _submitRequest;
  RelationBloc? _relationBloc;
  CreateBiddingForm _createBiddingForm;
  final GetFormFieldData _getFormFieldData;
  final ValidateDynamicForm _validateDynamicForm;

  final SendOTP _sendOTP;
  final Function? callBack;

  SubmitRequestBloc(
      {required SubmitRequest submitRequest,
      required SendOTP sendOTP,
      required CreateBiddingForm createBiddingForm,
      required GetFormFieldData getFormFieldData,
      required ValidateDynamicForm validateDynamicForm,
      RelationBloc? relationBloc,
      required SubmitPageParams args})
      : _sendOTP = sendOTP,
        _submitRequest = submitRequest,
        _relationBloc = relationBloc,
        _createBiddingForm = createBiddingForm,
        _getFormFieldData = getFormFieldData,
        _validateDynamicForm = validateDynamicForm,
        callBack = args.callBack,
        super(SubmitRequestState(
          relationId: args.relationId,
          serviceProviderId: args.serviceProviderId,
          serviceProviderName: args.serviceProviderName,
          subRelations: args.subRelations,
          subServiceId: args.subServiceId,
          subServiceName: args.subServiceName,
          changeProvider: args.changeProvider,
          orderId: args.orderId,
        )) {
    on<SubmitRequestEvent>((event, emit) {});
    on<SubmitEvent>(_submitRequestHandler);
    on<CreateFormEvent>(_createFormHandler);
    on<DeleteSubReleation>(_deleteSubRelationHandler);
    on<ChangeTextComponentEvent>(_changeTextComponentEventHandler);
    on<ValidateFormEvent>(_validateFormEventHandler);

    on<SelectFormFieldDataEvent>(_selectDropDownComponentEventHandler);
    if (args.subServiceId != null &&
        args.subServiceId!.isNotEmpty &&
        args.inputsRequired == true)
      add(CreateFormEvent(serviceId: args.subServiceId));
  }

  Future<void> _createFormHandler(CreateFormEvent e, Emitter emitter) async {
    emitter(state.copyWith(formStatus: BlocStatus.loading));

    final failureOrSuccess = await _createBiddingForm(CreateFormParams(
        profileId: CommonProperties.profileId,
        requestTypeId: "delegate",
        services: [e.serviceId ?? state.subServiceId ?? ""]));

    failureOrSuccess.fold((failure) {
      print("failure $failure");
      emitter(state.copyWith(
        formStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      CreateFormItemResponse? form = success.data?.result?.first;
      form?.relationId = state.relationId;
      form?.serviceName = state.subServiceName;
      print("HEREEEE $form");
      emitter(state.copyWith(
        formStatus: BlocStatus.success,
        form: form,
        errorMessage: "",
      ));
    });
  }

  Future<void> _submitRequestHandler(SubmitEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    var otpValue;

    if (e.params.changeProvider != true && state.isOTPConfirmed != true) {
      emitter(state.copyWith(status: BlocStatus.loading));

      final failureOrSuccess1 = await _sendOTP(SendOTPParamas(
          expireSeconds: "60", serviceId: e.params.relationId ?? ""));

      ApigeeResponse<SendOTPResponse>? res =
          await failureOrSuccess1.fold((failure) async {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
        return null;
      }, (success) async {
        emitter(state.copyWith(
          status: BlocStatus.success,
          errorMessage: "",
        ));
        return success;
      });

      if (res != null && res.data?.result?.otpId != null)
        otpValue = await NavigationService.navigatorKey.currentState?.pushNamed(
            EtmamRoutesNames.otpRoute,
            arguments: OTPPageParams(
                otpResponse: res.data?.result, serviceId: e.params.relationId));
      else
        return;
    }
    if (otpValue == true ||
        e.params.changeProvider == true ||
        state.isOTPConfirmed == true) {
      emitter(
          state.copyWith(status: BlocStatus.loading, isOTPConfirmed: otpValue));

      final failureOrSuccess = await _submitRequest(e.params);

      await failureOrSuccess.fold((failure) async {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      }, (success) async {
        emitter(state.copyWith(
          status: BlocStatus.success,
          errorMessage: "",
        ));

        if (state.changeProvider == true && callBack != null) {
          int count = 0;
          final value = await NavigationService.navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(
                  EtmamRoutesNames.successRoute, (_) => count++ >= 2,
                  arguments: SuccessScreenArgs(
                      idNumber: success.data?.result?.number,
                      thanksMessage: success.data?.result?.successMessage,
                      changeProvider: true,
                      type: e.params.pageType ?? PageTypes.orderScreen));
          callBack!();
        } else {
          final value = await NavigationService.navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(EtmamRoutesNames.successRoute,
                  ModalRoute.withName(RouteName.bottomNavigation),
                  arguments: SuccessScreenArgs(
                      idNumber: success.data?.result?.number,
                      thanksMessage: success.data?.result?.successMessage,
                      type: PageTypes.orderScreen));
        }

        if (sl<EtmamEntryPointCubit>().classificationId == "municipal") {
          balady.CommonFunctions.sendUXCamEvent(
              UXCamEvents.finishServiceLicensingAndPlanningServices);
          balady.CommonFunctions.sendUXCamEvent(
              UXCamEvents.finishServiceLicensingAndPlanningServicesDelegation);
        } else {
          balady.CommonFunctions.sendUXCamEvent(
              UXCamEvents.finishServiceServicesProviders);
          balady.CommonFunctions.sendUXCamEvent(
              UXCamEvents.finishServiceLicensingAndPlanningServicesDelegation);
        }
      });
    }
  }

  Future<void> _deleteSubRelationHandler(
      DeleteSubReleation e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    _relationBloc?.add(DeleteRelationItem(id: e.id));
    emitter(state.copyWith(status: BlocStatus.success));
  }

  Future<void> _changeTextComponentEventHandler(
      ChangeTextComponentEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    CreateFormItemResponse? form = state.form;

    if (form != null) {
      int? fieldIndex =
          form.items?.indexWhere((element) => element.field?.id == e.fieldId);
      FormItems? field = form.items?[fieldIndex!];

      if (form != null) {
        FormItems? field = form.items
            ?.firstWhereOrNull((element) => element.field?.id == e.fieldId);

        if (field?.getFieldDataType() == DynamicFormFieldDataType.integer)
          field!.value = int.tryParse(e.text ?? "");
        else if (field?.getFieldDataType() == DynamicFormFieldDataType.decimal)
          field!.value = double.tryParse(e.text ?? "");
        else
          field!.value = e.text;

        field.errors = null;
      }

      form.items?[fieldIndex!] = field!;
      CreateFormItemResponse? newFormResponse = state.form;
      newFormResponse = form;
      emitter(state.copyWith(
          status: BlocStatus.success, errorMessage: "", form: newFormResponse));
    }
  }

  Future<void> _selectDropDownComponentEventHandler(
      SelectFormFieldDataEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    CreateFormItemResponse? form = state.form;

    if (form != null) {
      int? fieldIndex =
          form.items?.indexWhere((element) => element.field?.id == e.fieldId);
      FormItems? field = form.items?[fieldIndex!];
      field?.selectedDataItem = e.item;
      field?.errors = null;

      form.items?[fieldIndex!] = field!;

      /** Clear Lists releated to this field */
      form.items = form.items?.map((el) {
        if (el.field?.dataSourceFields?.contains(e.fieldId!) ?? false) {
          el.selectedDataItem = null;
          el.dataItems = null;
        }
        return el;
      }).toList();
      /** */
      CreateFormItemResponse? newFormResponse = state.form;
      newFormResponse = form;
      emitter(state.copyWith(
          status: BlocStatus.success, errorMessage: "", form: newFormResponse));
    }
  }

  Future<List<DropDownItem>?> getDataEventHandler(
      GetFormFieldDataEvent e) async {
    CreateFormItemResponse? form = state.form;

    if (form != null) {
      int? fieldIndex =
          form.items?.indexWhere((element) => element.field?.id == e.fieldId);
      FormItems? field = form.items?[fieldIndex!];
      Map<String, dynamic> dependantFields = {};
      if (field?.field?.dataSourceFields != null &&
          (field?.field?.dataSourceFields?.isNotEmpty ?? false)) {
        field?.field?.dataSourceFields?.forEach((e) {
          FormItems? field =
              form.items?.firstWhereOrNull((element) => element.field?.id == e);

          if (field?.value != null) {
            dependantFields.putIfAbsent(field!.field!.id!, () => field.value);
          } else if (field?.getComponentType() ==
                  DynamicFormComponentType.dropDown &&
              field?.selectedDataItem != null) {
            dependantFields.putIfAbsent(
                field!.field!.id!, () => field.selectedDataItem!.id);
          } else if (field?.getComponentType() ==
              DynamicFormComponentType.hidden) {
            dependantFields.putIfAbsent(
                field!.field!.id!, () => CommonProperties.cityId);
          } else {
            CommonFunctions.showError(
              "bidding_fill_filed"
                  .tr()
                  .replaceAll("{}", field?.fieldLabel ?? ""),
            );
          }
        });
      }

      if ((field?.field?.dataSourceFields?.length ?? 0) ==
          dependantFields.length) {
        GetDataParams params = GetDataParams(
            fieldId: field!.field!.id!,
            profileId: sl<EtmamEntryPointCubit>().state.profile!.id!,
            fields: dependantFields);
        emit(state.copyWith(status: BlocStatus.loading));

        final failureOrSuccess = await _getFormFieldData(params);

        return await failureOrSuccess.fold((failure) async {
          print(failure);
          String errorMessage = "";

          if (failure is ServerFailure) {
            errorMessage = "no_data".tr();
          }
          emit(
            state.copyWith(
              status: BlocStatus.failure,
              errorMessage:
                  errorMessage.isEmpty ? failure.toString() : errorMessage,
            ),
          );
          return null;
        }, (success) async {
          print(success);
          field.dataItems = success.data?.result;
          form.items?[fieldIndex!] = field;
          CreateFormItemResponse? newFormResponse = state.form;
          newFormResponse = form;
          emit(state.copyWith(
              status: BlocStatus.success,
              errorMessage: "",
              form: newFormResponse));

          return field.dataItems;
        });
      }
    }
    return null;
  }

  Future<void> _validateFormEventHandler(
      ValidateFormEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    ValidateFormParams params = ValidateFormParams(
      profileId: CommonProperties.profileId ?? "",
      formId: state.form!.id!,
      fields: state.form?.getFieldsRequest(),
    );

    final failureOrSuccess = await _validateDynamicForm(params);
    failureOrSuccess.fold((failure) {
      print(failure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));
      if (success.data?.result?.isSuccess == true) {
        emitter(state.copyWith(
            status: BlocStatus.success,
            errorMessage: "",
            formValidation: success.data?.result));
        add(SubmitEvent(params: e.params));
      } else {
        /**
         *  Set Validations Errors for each field
         */

        List<ValidationsErrors> errors = success.data?.result?.errors ?? [];

        CreateFormItemResponse? form = state.form;

        if (form != null) {
          for (int i = 0; i < (form.items?.length ?? 0); i++) {
            FormItems? field = form.items?[i];

            ValidationsErrors? error = errors
                .firstWhereOrNull((element) => element.id == field?.field?.id);

            field?.errors = error;
            form.items?[i] = field!;
          }

          CreateFormItemResponse? newFormResponse = state.form;
          newFormResponse = form;
          emitter(state.copyWith(
              status: BlocStatus.success,
              errorMessage: "",
              form: newFormResponse,
              formValidation: success.data?.result));
        }
      }
    });
  }
}
