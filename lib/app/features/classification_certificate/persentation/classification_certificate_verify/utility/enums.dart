enum SearchMethod {
  search(title: "search_name"),
  advancedSearch(title: "advanced_search");

  const SearchMethod({required this.title});

  final String title;
}

enum NormalSearchType {
  byCertificationNumber(
    title: "byCertificationNumber_title",
    description: "byCertificationNumber_description",
    verifiedBy: NormalSearchByType.byCertificationNumber,
  ),
  byContractorEngineeringOfficeName(
    title: "byContractorEngineeringOfficeName_title",
    description: "byContractorEngineeringOfficeName_description",
    verifiedBy: NormalSearchByType.byFacilityName,
  ),
  byCommercialRegistrationNoEngineeringOfficeLicenseNumber(
    title: "byCommercialRegistrationNoEngineeringOfficeLicenseNumber_title",
    description:
        "byCommercialRegistrationNoEngineeringOfficeLicenseNumber_description",
    verifiedBy: NormalSearchByType.byCRLICNumber,
  ),
  byNationalID(
    title: "byNationalID_title",
    description: "byNationalID_description",
    verifiedBy: NormalSearchByType.byEstablishmentId,
  );

  const NormalSearchType({
    required this.title,
    required this.description,
    required this.verifiedBy,
  });

  final String title;
  final String description;
  final NormalSearchByType verifiedBy;
}

enum NormalSearchByType {
  byCertificationNumber(
    title: "certificate_number",
    hintText: "enter_number",
  ),
  byFacilityName(
    title: "the_contractor_office_name",
    hintText: "enter_the_contractor_office_name",
  ),
  byCRLICNumber(
    title: "commercial_registration_engineering_office_license",
    hintText: "enter_commercial_registration_engineering_office_license",
  ),
  byEstablishmentId(
    title: "establishment_Id",
    hintText: "enter_establishment_Id",
  );

  const NormalSearchByType({required this.title, required this.hintText});

  final String title;
  final String hintText;
}
