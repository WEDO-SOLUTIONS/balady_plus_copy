import 'package:flutter/widgets.dart';

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
    validatorMessage: "certificate_number_validator",
    regex: r'(?=.*?[0-9]).{8,10}',
    keyboardType: TextInputType.number,
  ),
  byFacilityName(
    title: "the_contractor_engineering_office",
    hintText: "enter_the_contractor_office_name",
    validatorMessage: "the_contractor_engineering_office_validator",
    regex: r"[a-zA-Z\u0621-\u064A]{2,100}",
    keyboardType: TextInputType.text,
  ),
  byCRLICNumber(
    title: "commercial_registration_engineering_office_license",
    hintText: "enter_commercial_registration_engineering_office_license",
    validatorMessage: "commercial_registration_engineering_office_license_validator",
    regex: r'(?=.*?[0-9]).{10}',
    keyboardType: TextInputType.number,
  ),
  byEstablishmentId(
    title: "establishment_Id",
    hintText: "enter_establishment_Id",
    validatorMessage: "establishment_Id_validator",
    regex: r'(?=.*?[0-9]).{10}',
    keyboardType: TextInputType.number,
  );

  const NormalSearchByType({
    required this.title,
    required this.hintText,
    required this.regex,
    required this.validatorMessage,
    required this.keyboardType,
  });

  final String title;
  final String hintText;
  final String validatorMessage;
  final String regex;
  final TextInputType keyboardType;
}
