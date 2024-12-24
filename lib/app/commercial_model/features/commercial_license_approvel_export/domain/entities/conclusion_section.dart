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

  Content({
    this.label,
    this.value,
  });
}