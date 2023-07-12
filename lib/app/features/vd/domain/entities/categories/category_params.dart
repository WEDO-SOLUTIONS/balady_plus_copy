class CategoryParams {
  List<String> type;
  bool? isPromoted;

  CategoryParams({required this.type, this.isPromoted});

  CategoryParams copyWith({List<String>? type, bool? isPromoted}) {
    return CategoryParams(
      type: type ?? this.type,
      isPromoted: isPromoted ?? this.isPromoted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (type.isNotEmpty) "type": type.join(","),
      if (isPromoted != null) "isPromoted": isPromoted,
    };
  }
}
