class CommercialSignRequirementsModel {
  String sectionNumber;
  List<Requirement> requirements;

  CommercialSignRequirementsModel({
    required this.sectionNumber,
    required this.requirements,
  });

  // Factory constructor to create a Section object from JSON
  factory CommercialSignRequirementsModel.fromJson(Map<String, dynamic> json) {
    return CommercialSignRequirementsModel(
      sectionNumber: json['section_number'] ?? '',
      requirements: List<Requirement>.from(json['requirements']
          .map((requirement) => Requirement.fromJson(requirement))),
    );
  }

  // Method to convert Section object to JSON
  Map<String, dynamic> toJson() {
    return {
      'section_number': sectionNumber,
      'requirements':
          requirements.map((requirement) => requirement.toJson()).toList(),
    };
  }
}

class Requirement {
  int number;
  String description;

  Requirement({
    required this.number,
    required this.description,
  });

  // Factory constructor to create a Requirement object from JSON
  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      number: json['number'],
      description: json['description'],
    );
  }

  // Method to convert Requirement object to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'description': description,
    };
  }
}
