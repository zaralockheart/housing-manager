import 'package:flutter/material.dart';
import 'package:housing_manager/ui/sign_in/sign_in_bloc.dart';

class SignInProvider extends InheritedWidget {
  final SignInBloc signInBloc;

  SignInProvider({
    Key key,
    SignInBloc signInBloc,
    Widget child,
  })  : signInBloc = signInBloc ?? SignInBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SignInBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SignInProvider) as SignInProvider)
          .signInBloc;
}