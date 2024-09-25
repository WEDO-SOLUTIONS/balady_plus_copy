class PeopleProfileProperties {
  final int userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String profileCreatedAt;

  //////////////////////////////////////////////////////////////////
  final int pharmacyId;
  final String pharmacyName;
  final String pharmacyPhone;

  //////////////////////////////////////////////////////////////////
  final String language;
  final String notificationsAllowed;
  final String locationAllowed;

  PeopleProfileProperties({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.profileCreatedAt,
    //////////////////////////////////////////////////////////////////
    required this.pharmacyId,
    required this.pharmacyName,
    required this.pharmacyPhone,
    //////////////////////////////////////////////////////////////////
    required this.language,
    required this.notificationsAllowed,
    required this.locationAllowed,
  });

  Map<String, dynamic> toJson() {
    return {
      "User ID": userId,
      "User Name": userName,
      "User Phone": userPhone,
      "User Email": userEmail,
      "Profile Created at": profileCreatedAt,
      //////////////////////////////////////////////////////////////////
      "Pharmacy ID": pharmacyId,
      "Pharmacy name": pharmacyName,
      "Pharmacy Phone": pharmacyPhone,
      //////////////////////////////////////////////////////////////////
      "Language": language,
      "Notifications Allowed": notificationsAllowed,
      "Location Allowed": locationAllowed,
    };
  }
}
