import 'package:housing_manager/ui/sign_in/sign_in_bloc.dart';
import 'package:housing_manager/ui/sign_in/sign_in_model.dart';

class MainBloc {
  final SignInBloc signInBloc = SignInBloc();

  final SignInModel signInModel = SignInModel();

//  var count = 0;
//  Sink<int> get itemCount2 => _additionController.sink;
//  final _additionController = StreamController<int>();
//  Stream<int> get itemCount => _itemCountSubject.stream;
//  final _itemCountSubject = BehaviorSubject<int>();

  MainBloc() {
    _handleSignIn();
  }

  _handleSignIn() {
    signInBloc.emailModelController.stream.listen(_handleSignInEmail);
    signInBloc.passwordController.stream.listen(_handleSignInPassword);
  }

  void _handleSignInEmail(String email) {
    this.signInModel.email = email;
    signInBloc.emailModelSubject.add(email);
  }

  void _handleSignInPassword(String password) {
    this.signInModel.password = password;
    signInBloc.passwordSubject.add(password);
  }
}
