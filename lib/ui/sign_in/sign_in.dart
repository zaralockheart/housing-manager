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
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("res/images/background.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
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
                        borderSide: BorderSide(color: Colors.black),
                        buttonText: S.of(context).signIn,
                        onPress: () => _handleOnPress(counterBloc)),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: RoundedFlatButtonField(
                        borderSide: BorderSide(color: Colors.white),
                        hasBackgroundColor: false,
                        buttonText: S.of(context).signUp,
                        onPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
