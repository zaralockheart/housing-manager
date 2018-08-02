import 'package:housing_manager/ui/home/bloc/home_bloc.dart';

class MainBloc {
  MainBloc() {
    _handleSignIn();
  }

  _handleSignIn() {
    HomeBloc.lastPaymentMonthController.stream.listen(HomeBloc.setLastPayment);
  }
}
