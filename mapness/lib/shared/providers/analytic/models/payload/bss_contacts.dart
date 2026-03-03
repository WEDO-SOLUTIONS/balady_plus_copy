part of 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';

/// Type of the contact.
enum BssContactType {
  phone,
  fax,
  email,
  website,
  facebook,
  instagram,
  twitter,
  youtube,
  linkedin,
  googleplus,
  pinterest,
  skype,
  jabber,
  whatsapp,
  viber,
  telegram,
}

/// Description of any contact in the place card. A contact is a link to an external service for contacting the company
class BssContact {
  /// Type of the contact.
  final BssContactType type;

  /// Contact value. Depends on the contact type: phone number, website link or social network.
  final String? value;

  const BssContact({
    required this.type,
    this.value,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'type': type.name,
    };
    if (value != null) {
      data['value'] = value;
    }
    return data;
  }
}
