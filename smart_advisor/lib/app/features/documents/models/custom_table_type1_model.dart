class CustomTableTypeModel {
  int id;
  String mainCategory;
  List<String> subCategory;
  String requirement;

  CustomTableTypeModel({
    required this.id,
    required this.mainCategory,
    required this.subCategory,
    required this.requirement,
  });

  // Factory method to create a Requirement object from a JSON map
  factory CustomTableTypeModel.fromJson(Map<String, dynamic> json) {
    return CustomTableTypeModel(
      id: json['id'],
      mainCategory: json['main_category'],
      subCategory: List<String>.from(json['sub_category']),
      requirement: json['requirement'],
    );
  }

  // Method to convert a Requirement object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main_category': mainCategory,
      'sub_category': subCategory,
      'requirement': requirement,
    };
  }
}
