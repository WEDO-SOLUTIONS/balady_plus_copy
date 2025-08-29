part of 'bss_payload.dart';

/// The type of action that will be performed when a CTA is clicked (e.g., call, click on a link).
enum BssCallToActionType {
  phone,
  link,
}

/// CTA Button Information
sealed class BssCallToAction {
  const BssCallToAction({
    required this.actionType,
    required this.value,
    this.position,
  });

  /// The type of action that will be performed when a CTA is clicked
  final BssCallToActionType actionType;

  /// Value (phone number, url value, etc.).
  final String value;

  /// The ordinal number of the element in the list
  final int? position;

  Map<String, dynamic> toJson() => {
        'actionType': actionType.name,
        'value': value,
        'position': position,
      };
}

class BssCallToActionPhone extends BssCallToAction {
  const BssCallToActionPhone({
    /// Phone in format +<numbers without separators>
    required String phone,
    super.position,
  }) : super(actionType: BssCallToActionType.phone, value: phone);
}

class BssCallToActionLink extends BssCallToAction {
  const BssCallToActionLink({
    /// URL of the page you want to open
    required String link,
    super.position,
  }) : super(actionType: BssCallToActionType.link, value: link);
}
