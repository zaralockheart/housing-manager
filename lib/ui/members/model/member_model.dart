class MemberModel {
  final String fullName;
  final String address;
  final String email;
  final String mobileNumber;
  final bool adminStatus;

  MemberModel(
      {this.fullName = '',
      this.address = '',
      this.email = '',
      this.mobileNumber = '',
      this.adminStatus = false});
}
