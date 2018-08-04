import 'package:housing_manager/ui/home/bloc/home_bloc.dart';

class MainBloc {
  HomeBloc homeBloc;

  MainBloc() {
    homeBloc = HomeBloc();
  }

  dispose() {
    homeBloc.dispose();
  }
}
