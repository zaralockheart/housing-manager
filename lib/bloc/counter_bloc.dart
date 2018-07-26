import 'dart:async';
import 'package:rxdart/subjects.dart';

class MainBloc {

  var count = 0;

  Sink<int> get itemCount2 => _additionController.sink;

  final _additionController = StreamController<int>();

  Stream<int> get itemCount => _itemCountSubject.stream;

  final _itemCountSubject = BehaviorSubject<int>();

  MainBloc() {
    _additionController.stream.listen(_handle);
  }

  void _handle(int counter) {
    count = count + counter;
    _itemCountSubject.add(count);
  }
}