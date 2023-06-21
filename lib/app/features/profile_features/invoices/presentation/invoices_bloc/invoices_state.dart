part of 'invoices_bloc.dart';

class InvoicesState extends Equatable {
  final BlocRequestStatus invoicesStatus;
  final List<InvoiceEntity> invoices;
  //invoice statuses
  final BlocRequestStatus invoiceStatusesStatus;
  final List<InvoiceStatusEntity> invoiceStatuses;
  final InvoiceStatusEntity? selectedInvoiceStatus;
  //municipalities
  final BlocRequestStatus municipalitiesStatus;
  final List<MunicipalityEntity> municipalities;
  final MunicipalityEntity? selectedMunicipality;
  //sub municipalities
  final BlocRequestStatus subMunicipalitiesStatus;
  final List<SubMunicipalityEntity> subMunicipalities;
  final SubMunicipalityEntity? selectedSubMunicipality;
  //invoice types
  final BlocRequestStatus invoiceTypesStatus;
  final List<InvoiceTypeEntity> invoiceTypes;
  final InvoiceTypeEntity? selectedInvoiceType;
  //invoice sub types
  final BlocRequestStatus invoiceSubTypesStatus;
  final List<InvoiceSubTypeEntity> invoiceSubTypes;
  final InvoiceSubTypeEntity? selectedInvoiceSubType;
  // invoice Date
  final DateTime? selectedInvoiceDate;
  // invoice number query
  final String? invoiceNumberQuery;
  //sort type
  final SortType sortType;
  //error message
  final String? errorMessage;
  // pagination
  final int page;
  final int limit;
  final bool noMoreData;

  const InvoicesState({
    this.invoicesStatus = BlocRequestStatus.initial,
    this.invoices = const [],
    this.invoiceStatusesStatus = BlocRequestStatus.initial,
    this.invoiceStatuses = const [],
    this.selectedInvoiceStatus,
    this.municipalitiesStatus = BlocRequestStatus.initial,
    this.municipalities = const [],
    this.selectedMunicipality,
    this.subMunicipalitiesStatus = BlocRequestStatus.initial,
    this.subMunicipalities = const [],
    this.selectedSubMunicipality,
    this.invoiceTypesStatus = BlocRequestStatus.initial,
    this.invoiceTypes = const [],
    this.selectedInvoiceType,
    this.invoiceSubTypesStatus = BlocRequestStatus.initial,
    this.invoiceSubTypes = const [],
    this.selectedInvoiceSubType,
    this.selectedInvoiceDate,
    this.invoiceNumberQuery,
    this.sortType = SortType.desc,
    this.errorMessage,
    this.page = 0,
    this.limit = PaginationConstants.limit,
    this.noMoreData = false,
  });

  String get error => errorMessage ?? '';
  bool get paginationLoading =>
      invoicesStatus == BlocRequestStatus.submissionGetLoading && page > 0;

  InvoicesState copyWith({
    BlocRequestStatus? invoicesStatus,
    List<InvoiceEntity>? invoices,
    BlocRequestStatus? invoiceStatusesStatus,
    List<InvoiceStatusEntity>? invoiceStatuses,
    InvoiceStatusEntity? selectedInvoiceStatus,
    BlocRequestStatus? municipalitiesStatus,
    List<MunicipalityEntity>? municipalities,
    MunicipalityEntity? selectedMunicipality,
    BlocRequestStatus? subMunicipalitiesStatus,
    List<SubMunicipalityEntity>? subMunicipalities,
    SubMunicipalityEntity? selectedSubMunicipality,
    BlocRequestStatus? invoiceTypesStatus,
    List<InvoiceTypeEntity>? invoiceTypes,
    InvoiceTypeEntity? selectedInvoiceType,
    BlocRequestStatus? invoiceSubTypesStatus,
    List<InvoiceSubTypeEntity>? invoiceSubTypes,
    InvoiceSubTypeEntity? selectedInvoiceSubType,
    DateTime? selectedInvoiceDate,
    String? invoiceNumberQuery,
    SortType? sortType,
    String? errorMessage,
    int? page,
    int? limit,
    bool? noMoreData,
  }) {
    return InvoicesState(
      invoicesStatus: invoicesStatus ?? this.invoicesStatus,
      invoices: invoices ?? this.invoices,
      invoiceStatusesStatus:
          invoiceStatusesStatus ?? this.invoiceStatusesStatus,
      invoiceStatuses: invoiceStatuses ?? this.invoiceStatuses,
      selectedInvoiceStatus:
          selectedInvoiceStatus ?? this.selectedInvoiceStatus,
      municipalitiesStatus: municipalitiesStatus ?? this.municipalitiesStatus,
      municipalities: municipalities ?? this.municipalities,
      selectedMunicipality: selectedMunicipality ?? this.selectedMunicipality,
      subMunicipalitiesStatus:
          subMunicipalitiesStatus ?? this.subMunicipalitiesStatus,
      subMunicipalities: subMunicipalities ?? this.subMunicipalities,
      selectedSubMunicipality:
          selectedSubMunicipality ?? this.selectedSubMunicipality,
      invoiceTypesStatus: invoiceTypesStatus ?? this.invoiceTypesStatus,
      invoiceTypes: invoiceTypes ?? this.invoiceTypes,
      selectedInvoiceType: selectedInvoiceType ?? this.selectedInvoiceType,
      invoiceSubTypesStatus:
          invoiceSubTypesStatus ?? this.invoiceSubTypesStatus,
      invoiceSubTypes: invoiceSubTypes ?? this.invoiceSubTypes,
      selectedInvoiceSubType:
          selectedInvoiceSubType ?? this.selectedInvoiceSubType,
      selectedInvoiceDate: selectedInvoiceDate ?? this.selectedInvoiceDate,
      invoiceNumberQuery: invoiceNumberQuery ?? this.invoiceNumberQuery,
      sortType: sortType ?? this.sortType,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      noMoreData: noMoreData ?? this.noMoreData,
    );
  }

  InvoicesState clearFilters() => InvoicesState(
        invoicesStatus: invoicesStatus,
        invoices: invoices,
        invoiceStatusesStatus: invoiceStatusesStatus,
        invoiceStatuses: invoiceStatuses,
        selectedInvoiceStatus: null,
        municipalitiesStatus: municipalitiesStatus,
        municipalities: municipalities,
        selectedMunicipality: null,
        subMunicipalitiesStatus: subMunicipalitiesStatus,
        subMunicipalities: subMunicipalities,
        selectedSubMunicipality: null,
        invoiceTypesStatus: invoiceTypesStatus,
        invoiceTypes: invoiceTypes,
        selectedInvoiceType: null,
        invoiceSubTypesStatus: invoiceSubTypesStatus,
        invoiceSubTypes: invoiceSubTypes,
        selectedInvoiceSubType: null,
        selectedInvoiceDate: selectedInvoiceDate,
        invoiceNumberQuery: invoiceNumberQuery,
        sortType: sortType,
        errorMessage: errorMessage,
        page: page,
        limit: limit,
        noMoreData: noMoreData,
      );

  @override
  List<Object?> get props => [
        invoicesStatus,
        invoices,
        invoiceStatusesStatus,
        invoiceStatuses,
        selectedInvoiceStatus,
        municipalitiesStatus,
        municipalities,
        selectedMunicipality,
        subMunicipalitiesStatus,
        subMunicipalities,
        selectedSubMunicipality,
        invoiceTypesStatus,
        invoiceTypes,
        selectedInvoiceType,
        invoiceSubTypesStatus,
        invoiceSubTypes,
        selectedInvoiceSubType,
        selectedInvoiceDate,
        invoiceNumberQuery,
        sortType,
        errorMessage,
        page,
        limit,
        noMoreData,
      ];
}
