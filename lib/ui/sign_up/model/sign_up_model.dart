class SignUpModel {
  final String email;
  final adminStatus;

  SignUpModel({this.email, this.adminStatus});

  static Map<String, dynamic> toJson({email, adminStatus}) =>
      {'email': email, 'adminStatus': adminStatus};
}
