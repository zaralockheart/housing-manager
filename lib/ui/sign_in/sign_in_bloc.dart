import 'dart:async';

import 'package:rxdart/subjects.dart';

class SignInBloc {
  Sink<String> get emailModelSink => emailModelController.sink;
  final emailModelController = StreamController<String>();

  final emailModelSubject = BehaviorSubject<String>();

  Sink<String> get passwordSink => passwordController.sink;
  final passwordController = StreamController<String>();

  final passwordSubject = BehaviorSubject<String>();
}
