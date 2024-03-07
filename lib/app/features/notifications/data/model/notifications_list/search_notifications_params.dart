
class SearchNotificationsParams {
  //////////////////////////////////////
  // Use This When User Selected
  // String? ownerNumber;
  // String? ownerTypeId;

  // Use This When Selecteded Delegator
  // String? unifiedNationalNumber;
  // int? relationTypeeId;

  //////////////////////////////////////
  // This For Filter Opation
  // List<String>? filterationEntity;
  // bool hijri;
  //////////////////////////////////////
  int page;
  int pageSize;




  SearchNotificationsParams({
    this.page = 0,
    this.pageSize = 10,
    // this.ownerNumber,
    // this.ownerTypeId,
    // this.unifiedNationalNumber,
    // this.relationTypeeId,
    // this.filterationEntity,
    // this.hijri = false,
  });

  SearchNotificationsParams copyWith({
    String? loginIdentityId,
    String? loginIdentityType,
    String? unifiedNationalNumber,
    int? relationTypeeId,
    List<String>? filterationEntity,
    bool? hijri,
  }) =>
      SearchNotificationsParams(
        // ownerNumber: loginIdentityId ?? this.ownerNumber,
        // ownerTypeId: loginIdentityType ?? this.ownerTypeId,
        // unifiedNationalNumber:
        //     unifiedNationalNumber ?? this.unifiedNationalNumber,
        // relationTypeeId: relationTypeeId ?? this.relationTypeeId,
        // filterationEntity: filterationEntity ?? this.filterationEntity,
        // hijri: hijri ?? this.hijri,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "notification-channel-id": "mobile-mobile",
      "page": page,
      "page-size": pageSize,
    };

    // {
    //   if (ownerNumber != null) {
    //     data["page"] = ownerNumber;
    //   }
    //   if (ownerTypeId != null) {
    //     data["page-size"] = ownerTypeId;
    //   }
    //   if (unifiedNationalNumber != null) {
    //     data["unifiedNationalNumber"] = unifiedNationalNumber;
    //   }
    //   if (relationTypeeId != null) {
    //     data["relationTypeId"] = relationTypeeId;
    //   }
    // }
    return data;
  }
}

