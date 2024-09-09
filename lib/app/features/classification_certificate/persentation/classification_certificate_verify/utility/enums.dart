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
  ),
  byContractorEngineeringOfficeName(
    title: "byContractorEngineeringOfficeName_title",
    description: "byContractorEngineeringOfficeName_description",
  ),
  byCommercialRegistrationNoEngineeringOfficeLicenseNumber(
    title: "byCommercialRegistrationNoEngineeringOfficeLicenseNumber_title",
    description:
        "byCommercialRegistrationNoEngineeringOfficeLicenseNumber_description",
  ),
  byNationalID(
    title: "byNationalID_title",
    description: "byNationalID_description",
  );

  const NormalSearchType({required this.title, required this.description});

  final String title;
  final String description;
}
