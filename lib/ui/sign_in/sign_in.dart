import 'package:flutter/material.dart';
import 'package:housing_manager/bloc/main_bloc.dart';
import 'package:housing_manager/bloc/main_provider.dart';
import 'package:housing_manager/generated/i18n.dart';
import 'package:housing_manager/ui/sign_in/sign_in_bloc.dart';
import 'package:housing_manager/ui/sign_in/sign_in_provider.dart';
import 'package:housing_manager/ui/widgets/round_text_field.dart';
import 'package:housing_manager/ui/widgets/rounded_flat_button.dart';

class SignIn extends StatefulWidget {
  final String title;

  const SignIn({Key key, this.title}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  _handleOnPress(MainBloc mainbloc) {
    print("email ${mainbloc.signInModel.email}");
    print("password ${mainbloc.signInModel.password}");
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc counterBloc = MainProvider.of(context);

    return SignInProvider(
      signInBloc: SignInBloc(),
      child: Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RoundTextField(
                    hint: S.of(context).emailHint,
                    output: counterBloc.signInBloc.emailModelSink,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: RoundTextField(
                  hint: S.of(context).passwordHint,
                  output: counterBloc.signInBloc.passwordSink,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: RoundedFlatButtonField(
                    buttonText: S.of(context).signInSignUp,
                    onPress: () => _handleOnPress(counterBloc)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
