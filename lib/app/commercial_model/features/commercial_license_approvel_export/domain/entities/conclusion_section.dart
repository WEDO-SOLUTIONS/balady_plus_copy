class ConclusionSection {
  String? sectionName;
  Content? sectionContent;

  ConclusionSection({
    this.sectionName,
    this.sectionContent,
  });
}

class Content {
  String? label;
  List<String>? value;
  List<OfficeSection>? offices;
  Content({
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