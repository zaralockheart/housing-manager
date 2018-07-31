class PaymentStatusModel {
  final String month;
  final bool status;

  PaymentStatusModel({this.month, this.status});

  static Map<String, dynamic> toJson({month, status}) =>
      {'month': month, 'status': status};
}
