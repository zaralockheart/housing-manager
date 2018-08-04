import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/generated/i18n.dart';
import 'package:housing_manager/ui/sign_up/ui/community_creation.dart';
import 'package:housing_manager/ui/sign_up/ui/sign_up.dart';
import 'package:housing_manager/ui/widgets/round_text_field.dart';
import 'package:housing_manager/ui/widgets/rounded_flat_button.dart';
import 'package:housing_manager/util/view_util.dart';

class SignIn extends StatefulWidget {
  final String title;

  const SignIn({Key key, this.title}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  _onSignIn(context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .then((onValue) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CommunityCreation(
                    isCreating: false,
                    isSigningIn: true,
                    email: emailController.text)),
      );
    }).catchError((onError) {
      showSnackBar(context, 'Wrong Email / Password');
      print('onError sign in $onError');
    });
  }

  _onPressSignUp() =>
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUp()),
      );

  _signInEditText({controller, hint, obscureText}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: RoundTextField(
          controller: controller,
          obscureText: obscureText,
          hint: hint,
        ),
      );

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body: new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('res/images/background.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Builder(
              builder: (BuildContext context) =>
                  Padding(
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
                            _signInEditText(
                                controller: emailController,
                                hint: S
                                    .of(context)
                                    .emailHint,
                                obscureText: false),
                            _signInEditText(
                                controller: passwordController,
                                hint: S
                                    .of(context)
                                    .passwordHint,
                                obscureText: true),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 20.0),
                              child: RoundedFlatButtonField(
                                  borderSide: BorderSide(color: Colors.black),
                                  buttonText: S
                                      .of(context)
                                      .signIn,
                                  onPress: () => _onSignIn(context)),
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
                                  buttonText: S
                                      .of(context)
                                      .signUp,
                                  onPress: _onPressSignUp,
                                )),
                          ],
                        )
                      ],
                    ),
                  )),
        ),
      );
}
