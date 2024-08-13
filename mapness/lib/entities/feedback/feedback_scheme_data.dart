class FeedbackListData {
  final List<FeedbackSchemeData> feedbacks;

  const FeedbackListData({required this.feedbacks});

  factory FeedbackListData.fromJson(Map<String, dynamic> json) {
    final feedbacks = (json['feedbacks'] as List).map((e) => FeedbackSchemeData.fromJson(e)).toList();
    return FeedbackListData(feedbacks: feedbacks);
  }
}

class FeedbackSchemeData {
  final String id;
  final String title;
  final String icon;
  final String appBar;
  final List<FeedbackFieldData> fields;

  const FeedbackSchemeData({
    required this.id,
    required this.title,
    required this.icon,
    required this.appBar,
    required this.fields,
  });

  factory FeedbackSchemeData.fromJson(Map<String, dynamic> json) {
    final fields = (json['fields'] as List).map((e) {
      switch (e['type']) {
        case FeedbackFieldInputData.typeValue:
          return FeedbackFieldInputData.fromJson(e);
        case FeedbackFieldCommentData.typeValue:
          return const FeedbackFieldCommentData();
        case FeedbackFieldBusinessOwnerData.typeValue:
          return const FeedbackFieldBusinessOwnerData();
        case FeedbackFieldImagesData.typeValue:
          return const FeedbackFieldImagesData();
        case FeedbackFieldChipsData.typeValue:
          return FeedbackFieldChipsData.fromJson(e);
        default:
          throw Exception('Unknown type');
      }
    }).toList();

    return FeedbackSchemeData(
      id: json['id'],
      title: json['title'],
      appBar: json['app_bar'],
      icon: json['icon'],
      fields: fields,
    );
  }
}

sealed class FeedbackFieldData {
  final String type;

  const FeedbackFieldData({
    required this.type,
  });
}

final class FeedbackFieldInputData extends FeedbackFieldData {
  final String label;
  final String hint;
  final String error;
  final String inputId;

  static const typeValue = 'input';

  const FeedbackFieldInputData({
    required this.label,
    required this.hint,
    required this.error,
    required this.inputId,
  }) : super(type: typeValue);

  factory FeedbackFieldInputData.fromJson(Map<String, dynamic> json) => FeedbackFieldInputData(
        label: json['label'],
        hint: json['hint'],
        error: json['error'],
        inputId: json['id'],
      );
}

final class FeedbackFieldChipsData extends FeedbackFieldData {
  final String label;
  final int canBeChosen;
  final List<FeedbackFieldChipsValue> values;

  static const typeValue = 'chips';

  const FeedbackFieldChipsData({
    required this.label,
    required this.canBeChosen,
    required this.values,
  }) : super(type: typeValue);

  factory FeedbackFieldChipsData.fromJson(Map<String, dynamic> json) => FeedbackFieldChipsData(
        label: json['label'],
        canBeChosen: json['can_be_chosen'] as int,
        values: (json['values'] as List).map((e) => FeedbackFieldChipsValue.fromJson(e)).toList(),
      );
}

final class FeedbackFieldChipsValue {
  final String text;
  final String icon;

  const FeedbackFieldChipsValue({
    required this.text,
    required this.icon,
  });

  factory FeedbackFieldChipsValue.fromJson(Map<String, dynamic> json) => FeedbackFieldChipsValue(
        text: json['text'],
        icon: json['icon'],
      );
}

final class FeedbackFieldCommentData extends FeedbackFieldData {
  static const typeValue = 'comment';

  const FeedbackFieldCommentData() : super(type: typeValue);
}

final class FeedbackFieldBusinessOwnerData extends FeedbackFieldData {
  static const typeValue = 'business_owner';

  const FeedbackFieldBusinessOwnerData() : super(type: typeValue);
}

final class FeedbackFieldImagesData extends FeedbackFieldData {
  static const typeValue = 'images';

  const FeedbackFieldImagesData() : super(type: typeValue);
}
