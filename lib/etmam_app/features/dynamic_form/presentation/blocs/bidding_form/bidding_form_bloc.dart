import 'package:balady_plus/app/core/utils/utils_exports.dart'
    hide CommonProperties;
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/page_type.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    hide DropDownItem;
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_item.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/create_form_item_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/get_data_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/submit/submit_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/submit_dynamic_form.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/validate_dynamic_form.dart';
import 'package:collection/collection.dart';

import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart'
    show
        CreateBiddingForm,
        CreateFormItemResponse,
        CreateFormParams,
        GetFormFieldData,
        UploadBidAttachment,
        UploadBidAttachmentResponse;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mime/mime.dart';

import '../../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../../app/core/utils/constants/ux_cam_events.dart';
import '../../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../../app/features/_shared_feature_/data/entities/file_data_item.dart';
import '../../../../../core/utils/enums/dynamic_forms.dart';
import '../../../domain/use_cases/upload_bid_attachment.dart';

part 'bidding_form_event.dart';
part 'bidding_form_state.dart';

class BiddingFormBloc extends Bloc<BiddingFormEvent, BiddingFormState> {
  PageController controller = PageController();
  final CreateBiddingForm _createBiddingForm;
  final GetFormFieldData _getFormFieldData;
  final SubmitDynamicForm _submitDynamicForm;
  final ValidateDynamicForm _validateDynamicForm;
  final UploadBiddingAttachment _uploadBiddingAttachment;

  BiddingFormBloc({
    required CreateBiddingForm createBiddingForm,
    required GetFormFieldData getFormFieldData,
    required SubmitDynamicForm submitDynamicForm,
    required ValidateDynamicForm validateDynamicForm,
    required BiddingFormParams params,
  })  : _createBiddingForm = createBiddingForm,
        _getFormFieldData = getFormFieldData,
        _submitDynamicForm = submitDynamicForm,
        _validateDynamicForm = validateDynamicForm,
        _uploadBiddingAttachment = UploadBiddingAttachment(repository: sl()),
        super(BiddingFormState(params: params)) {
    on<BiddingFormEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<GetBiddingFormEvent>(_getBiddingFormsEventHandler);
    on<ChangeTextComponentEvent>(_changeTextComponentEventHandler);

    on<SelectFormFieldDataEvent>(_selectDropDownComponentEventHandler);
    on<SubmitFormEvent>(_submitFormEventHandler);

    on<ValidateFormEvent>(_validateFormEventHandler);
    on<UploadBiddingAttachmentEvent>(_uploadBiddingAttachmentHandler);
    on<RemoveBiddingAttachmentEvent>(_deleteBiddingAttachmentHandler);
    add(GetBiddingFormEvent(
        params: CreateFormParams(
            profileId: sl<EtmamEntryPointCubit>().state.profile?.id,
            requestTypeId: "bidding",
            services: state.getServicesIds)));
  }

  Future<void> _deleteBiddingAttachmentHandler(
      RemoveBiddingAttachmentEvent e, Emitter emitter) async {
    print("GGGF");
    emitter(state.copyWith(status: BlocStatus.loading));

    emitter(state.copyWith(
        status: BlocStatus.success,
        uploadBidAttachmentResponse: Nullable(null),
        attachmentPath: Nullable(null),
        attachmentName: Nullable(null)));
  }

  Future<void> _getBiddingFormsEventHandler(
      GetBiddingFormEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _createBiddingForm(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      print("success");

      List<CreateFormItemResponse>? list = success.data?.result;
      if (list != null) {
        list = list.map((e) {
          if (state.params?.relation.service?.id == e.serviceId) {
            e.relationId = state.params?.relation.id;
            e.serviceName = state.params?.relation.service?.name;
            e.isPrimary = true;
          } else {
            BiddingTypeItem? item = state.params?.relation.subRelations
                ?.firstWhereOrNull(
                    (element) => element.service?.id == e.serviceId);
            if (item != null) {
              e.relationId = item.id;
              e.serviceName = item.service?.name;
              e.isPrimary = false;
            }
          }
          return e;
        }).toList();
      }
      emitter(state.copyWith(
        status: BlocStatus.success,
        formResponses: list,
        errorMessage: "",
      ));
    });
  }

  Future<void> _changeTextComponentEventHandler(
      ChangeTextComponentEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    int? formIndex = state.formResponses?.indexWhere(
        (element) => element.serviceId == state.currentForm?.serviceId);
    CreateFormItemResponse? form = state.formResponses?[formIndex!];

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
      List<CreateFormItemResponse>? newFormResponse = state.formResponses;
      newFormResponse?[formIndex!] = form;
      emitter(state.copyWith(
          status: BlocStatus.success,
          errorMessage: "",
          formResponses: newFormResponse));
    }
  }

  Future<void> _selectDropDownComponentEventHandler(
      SelectFormFieldDataEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    int? formIndex = state.formResponses?.indexWhere(
        (element) => element.serviceId == state.currentForm?.serviceId);
    CreateFormItemResponse? form = state.formResponses?[formIndex!];

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
      List<CreateFormItemResponse>? newFormResponse = state.formResponses;
      newFormResponse?[formIndex!] = form;
      emitter(state.copyWith(
          status: BlocStatus.success,
          errorMessage: "",
          formResponses: newFormResponse));
    }
  }

  Future<List<DropDownItem>?> getDataEventHandler(
      GetFormFieldDataEvent e) async {
    int? formIndex = state.formResponses?.indexWhere(
        (element) => element.serviceId == state.currentForm?.serviceId);
    CreateFormItemResponse? form = state.formResponses?[formIndex!];

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
            CommonFunctions.showError(trans("bidding_fill_filed")
                .replaceAll("{}", field?.fieldLabel ?? ""));
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
          emit(state.copyWith(
            status: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
          return null;
        }, (success) async {
          print(success);
          field.dataItems = success.data?.result;
          form.items?[fieldIndex!] = field;
          List<CreateFormItemResponse>? newFormResponse = state.formResponses;
          newFormResponse?[formIndex!] = form;
          emit(state.copyWith(
              status: BlocStatus.success,
              errorMessage: "",
              formResponses: newFormResponse));

          return field.dataItems;
        });
      }
    }
    return null;
  }

  Future<void> _submitFormEventHandler(
      SubmitFormEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    CreateFormItemResponse? firstForm = state.formResponses
        ?.firstWhereOrNull((element) => element.isPrimary == true);

    List<CreateFormItemResponse>? subBiddingsFroms = state.formResponses
        ?.where((element) => element.isPrimary == false)
        .toList();

    SubmitFormParams params = SubmitFormParams(
      cityId: CommonProperties.cityId,
      uploadTransactionId:
          state.uploadBidAttachmentResponse?.uploadTransactionId,
      descAttachmentId: state.uploadBidAttachmentResponse?.attachmentId,
      profileId: CommonProperties.profileId ?? "",
      formId: firstForm!.id!,
      relationId: firstForm.relationId!,
      fields: firstForm.getFieldsRequest(),
    );

// Forms Sub Biddiings
    /* if (subBiddingsFroms != null && subBiddingsFroms.isNotEmpty) {
      params.subBiddings = subBiddingsFroms.map((e) {
        return SubmitFormParams(
          cityId: CommonProperties.cityId,
          profileId: CommonProperties.profileId ?? "",
          formId: e.id!,
          relationId: e.relationId!,
          fields: e.getFieldsRequest(),
        );
      }).toList();
    }*/

    params.subBiddings = state.params?.relation.subRelations
        ?.map((e) {
          print("HEREEEEEEEEEEEYYY");
          print(e.isSelected);
          print(e.mandatory);

          if ((e.isSelected ?? false) || (e.mandatory ?? false))
            return SubmitFormParams(
              cityId: CommonProperties.cityId,
              uploadTransactionId:
                  state.uploadBidAttachmentResponse?.uploadTransactionId,
              descAttachmentId: state.uploadBidAttachmentResponse?.attachmentId,
              profileId: CommonProperties.profileId ?? "",
              formId: e.id!,
              relationId: e.id!,
              //  fields: e.getFieldsRequest(),
            );
        })
        .toList()
        .whereNotNull()
        .toList();

    final failureOrSuccess = await _submitDynamicForm(params);
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

      /*  NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          EtmamRoutesNames.successRoute,
          ModalRoute.withName(RoutesNames.bottomNavigationRoute),
          arguments: SuccessScreenArgs(
              thanksMessage: success.data?.result?.successMessage,
              type: PageTypes.orderScreen));
    });*/
      NavigationService.navigatorKey.currentState?.pop();
      NavigationService.navigatorKey.currentState?.pushReplacementNamed(
          EtmamRoutesNames.successRoute,
          arguments: SuccessScreenArgs(
              thanksMessage: success.data?.result?.responseMessage,
              type: PageTypes.orderScreen));

      if (sl<EtmamEntryPointCubit>().classificationId == "municipal") {
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.finishServiceLicensingAndPlanningServices);
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.finishServiceLicensingAndPlanningServicesBidding);
      } else {
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.finishServiceServicesProviders);
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.finishServiceLicensingAndPlanningServicesBidding);
      }
    });
  }

  Future<void> _uploadBiddingAttachmentHandler(
      UploadBiddingAttachmentEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    UploadBidAttachment params = UploadBidAttachment(
      requestTypeId: "bidding.bidding",
      attachmentTypeId: "bidding.bidding-desc",
      base64: e.file.bytes!,
      base64Str: e.file.fileBase64,
      fileName: e.file.fileName,
      filePath: e.file.filePath,
      mimeType: lookupMimeType(e.file.filePath) ?? "",
    );

    final failureOrSuccess = await _uploadBiddingAttachment(params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(status: BlocStatus.loading));

      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (r) {
      print("uccccess ${r.data?.result}");
      emitter(state.copyWith(
          status: BlocStatus.success,
          uploadBidAttachmentResponse: Nullable(r.data?.result),
          errorMessage: "",
          attachmentName: Nullable(params.fileName),
          attachmentPath: Nullable(params.filePath)));
    });
  }

  Future<void> _validateFormEventHandler(
      ValidateFormEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    ValidateFormParams params = ValidateFormParams(
      profileId: CommonProperties.profileId ?? "",
      formId: state.currentForm!.id!,
      fields: state.currentForm?.getFieldsRequest(),
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
        add(SubmitFormEvent());
      } else {
/**
 *  Set Validations Errors for each field 
 */

        List<ValidationsErrors> errors = success.data?.result?.errors ?? [];
        int? formIndex = state.formResponses?.indexWhere(
            (element) => element.serviceId == state.currentForm?.serviceId);
        CreateFormItemResponse? form = state.formResponses?[formIndex!];

        if (form != null) {
          for (int i = 0; i < (form.items?.length ?? 0); i++) {
            FormItems? field = form.items?[i];

            ValidationsErrors? error = errors
                .firstWhereOrNull((element) => element.id == field?.field?.id);

            field?.errors = error;
            form.items?[i] = field!;
          }

          List<CreateFormItemResponse>? newFormResponse = state.formResponses;
          newFormResponse?[formIndex!] = form;
          emitter(state.copyWith(
              status: BlocStatus.success,
              errorMessage: "",
              formResponses: newFormResponse,
              formValidation: success.data?.result));
        }
      }
    });
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    //print("next page");
    print("DataLog ${state}");
    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;
      int nextPage = state.currentPageValue + 1;

      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));

      await controller.animateToPage(nextPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: nextPage));
    }
    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      int prvoiusPage = state.currentPageValue - 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      await controller.animateToPage(prvoiusPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: prvoiusPage));
    }
    hideKeyboard();
  }

  bool isLastPage() {
    return state.currentPageValue + 1 == state.formsCount;
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
