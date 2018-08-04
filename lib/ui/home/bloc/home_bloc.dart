import 'dart:async';

import 'package:rxdart/rxdart.dart';

class HomeBloc {
  var lastPaymentMonth = '';

  Sink<String> get lastPaymentMonthSink => _lastPaymentMonthController.sink;
  final _lastPaymentMonthController = StreamController<String>();

  Stream<String> get lastPaymentMonthStream => _lastPaymentMonthSubject.stream;
  final _lastPaymentMonthSubject = BehaviorSubject<String>();

  var paymentLists = [];

  Sink<dynamic> get paymentListsSink => _paymentListsController.sink;
  final _paymentListsController = StreamController<dynamic>();

  Stream<dynamic> get paymentListsStream => _paymentListsSubject.stream;
  final _paymentListsSubject = BehaviorSubject<dynamic>();

  HomeBloc() {
    _lastPaymentMonthController.stream.listen(_setLastPayment);
    _paymentListsController.stream.listen(_setPaymentList);
  }

  _setLastPayment(String lastPayment) {
    lastPaymentMonth = lastPayment;
    _lastPaymentMonthSubject.add(lastPaymentMonth);
  }

  _setPaymentList(paymentList) {
    paymentLists = paymentList;
    _paymentListsSubject.add(paymentLists);
  }

  dispose() {
    _paymentListsController.close();
    _lastPaymentMonthController.close();
  }
}
