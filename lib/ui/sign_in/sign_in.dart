import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/bloc/main_bloc.dart';
import 'package:housing_manager/bloc/main_provider.dart';
import 'package:housing_manager/generated/i18n.dart';
import 'package:housing_manager/ui/sign_up/sign_up.dart';
import 'package:housing_manager/ui/widgets/round_text_field.dart';
import 'package:housing_manager/ui/widgets/rounded_flat_button.dart';

class SignIn extends StatefulWidget {
  final String title;

  const SignIn({Key key, this.title}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordlController = TextEditingController();

  _handleOnPress(MainBloc mainbloc) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordlController.text)
        .then((onValue) {
      print("onValue sign in $onValue");
    }).catchError((onError) {
      print("onError sign in $onError");
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc counterBloc = MainProvider.of(context);
    return Scaffold(
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
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  hint: S.of(context).emailHint,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: RoundTextField(
                controller: passwordlController,
                obscureText: true,
                hint: S.of(context).passwordHint,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: RoundedFlatButtonField(
                  buttonText: S.of(context).signIn,
                  onPress: () => _handleOnPress(counterBloc)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: RoundedFlatButtonField(
                  buttonText: S.of(context).signUp,
                  onPress: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
