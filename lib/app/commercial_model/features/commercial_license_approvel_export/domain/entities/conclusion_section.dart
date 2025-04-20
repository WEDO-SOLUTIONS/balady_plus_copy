class ConclusionSection {
  String? sectionName;
  ConSectionContent? sectionContent;

  ConclusionSection({
    this.sectionName,
    this.sectionContent,
  });
}

class ConSectionContent {
  String? label;
  List<String>? value;
  List<OfficeSection>? offices;
  ConSectionContent({
    this.label,
    this.value,
    this.offices
  });



}
class OfficeSection {
  String? cityName;
  String? officeMobile;
  String? officeName;
   OfficeSection({
    this.cityName,
    this.officeMobile,
    this.officeName,});
}