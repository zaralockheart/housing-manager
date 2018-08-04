import 'package:housing_manager/ui/home/bloc/home_bloc.dart';

class MainBloc {
  var isListened = false;
  HomeBloc homeBloc;

  MainBloc() {
    homeBloc = HomeBloc();
    _handleSignIn();
    isListened = true;
  }

  _handleSignIn() {

  }

  dispose() {
    homeBloc.dispose();
  }
}
