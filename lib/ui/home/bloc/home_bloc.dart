import 'dart:async';

import 'package:rxdart/rxdart.dart';

class HomeBloc {
  static var lastPaymentMonth = '';

  static Sink<String> get lastPaymentMonthSink =>
      lastPaymentMonthController.sink;
  static final lastPaymentMonthController = StreamController<String>();

//    static Stream<String> get lastPaymentMonthStream => lastPaymentMonthSubject.stream;
  static final lastPaymentMonthSubject = BehaviorSubject<String>();

  static setLastPayment(String lastPaymentMonths) {
    lastPaymentMonth = lastPaymentMonths;
    lastPaymentMonthSubject.add(lastPaymentMonth);
  }
}
