import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/generated/i18n.dart';
import 'package:housing_manager/ui/sign_up/ui/community_creation.dart';
import 'package:housing_manager/ui/widgets/rounded_flat_button.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  _signUpUser({BuildContext context, bool isCreating}) {
    String errorMessage = "";
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        emailController.text.isEmpty) {
      errorMessage = "Please will in all the details";
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage = "Password not same";
    }
    final snackBar = SnackBar(content: Text(errorMessage));

    if (errorMessage.isNotEmpty) {
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((FirebaseUser firebaseUser) {

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CommunityCreation(isCreating: isCreating)),
        );
      }).catchError((onError) {
        Scaffold
            .of(context)
            .showSnackBar(SnackBar(content: Text(onError.details)));
      });
    }
  }

  textInput(emailController, hint, top) {
    double marginTop = 0.0;
    double marginBottom = 0.0;

    if (top != null) {
      marginTop = top ? 12.0 : 0.0;
      marginBottom = top ? 0.0 : 20.0;
    }

    return Container(
        decoration: BoxDecoration(
            borderRadius: top != null
                ? (top
                    ? BorderRadius.vertical(top: Radius.circular(20.0))
                    : BorderRadius.vertical(bottom: Radius.circular(20.0)))
                : null,
            color: Color.fromRGBO(255, 255, 255, 0.5)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(6.0, marginTop, 6.0, marginBottom),
          child: new TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: S.of(context).emailHint,
              )),
        ));
  }

  mainContainer(BuildContext context) => Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("res/images/wood.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            textInput(emailController, S.of(context).emailHint, true),
            textInput(passwordController, S.of(context).passwordHint, null),
            textInput(confirmPasswordController,
                S.of(context).confirmPasswordHint, false),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: RoundedFlatButtonField(
                  borderSide: BorderSide(color: Colors.white),
                  hasBackgroundColor: false,
                  buttonText: S.of(context).createCommunity,
                  onPress: () =>
                      _signUpUser(context: context, isCreating: true)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: RoundedFlatButtonField(
                  borderSide: BorderSide(color: Colors.white),
                  hasBackgroundColor: false,
                  buttonText: S.of(context).joinCommunity,
                  onPress: () =>
                      _signUpUser(context: context, isCreating: false)),
            ),
          ],
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            Builder(builder: (BuildContext context) => mainContainer(context)));
  }
}
