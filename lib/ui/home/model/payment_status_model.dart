class PaymentStatusModel {
  final String month;
  final bool status;
  final String year;

  PaymentStatusModel(this.year, {this.month, this.status});

  static Map<String, dynamic> toJson({month, status, year}) =>
      {'month': month, 'status': status, 'year': year};
}
