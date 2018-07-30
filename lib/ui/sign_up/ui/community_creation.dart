import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/generated/i18n.dart';
import 'package:housing_manager/ui/home/home.dart';
import 'package:housing_manager/ui/sign_up/model/sign_up_model.dart';
import 'package:housing_manager/ui/widgets/rounded_flat_button.dart';

class CommunityCreation extends StatefulWidget {
  final bool isCreating;
  final String email;

  const CommunityCreation({Key key, this.isCreating, this.email})
      : super(key: key);

  @override
  _CommunityCreationState createState() => _CommunityCreationState();
}

class _CommunityCreationState extends State<CommunityCreation> {
  TextEditingController communityTextController = TextEditingController();
  var emailLists = Map<int, String>();

  _createUser(context) async {
    Firestore.instance.runTransaction((Transaction transaction) {
      _getReference().getDocuments().then((QuerySnapshot querySnapshot) {
        var errorMessage = "User is already exist in the community";

        if (widget.isCreating && querySnapshot.documents.length != 0) {
          if (emailLists.containsValue(widget.email)) {
            _showSnackBar(context, errorMessage);
            return;
          }

          for (int i = 0; i < querySnapshot.documents.length; i++) {
            if (querySnapshot.documents[i]['email'] == widget.email) {
              emailLists[i] = widget.email;
              _showSnackBar(context, errorMessage);
            } else {
              _createCommunity(_getReference());
            }
          }
        } else {
          _createCommunity(_getReference());
        }
      });
    });
  }

  _showSnackBar(context, errorMessage) {
    final snackBar = SnackBar(content: Text(errorMessage));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  CollectionReference _getReference() =>
      Firestore.instance.collection(communityTextController.text);

  _createCommunity(collectionRefence) {
    Future<String> email = FirebaseAuth.instance.currentUser().then((onValue) {
      return onValue.email;
    });

    email.then((onValue) {
      var signUpModel =
          SignUpModel.toJson(email: onValue, adminStatus: widget.isCreating);
      collectionRefence.add(signUpModel);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    community: communityTextController.text,
                    currentUserEmail: widget.email,
                  )));
    });
  }

  textInput() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Color.fromRGBO(255, 255, 255, 0.5)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 20.0),
          child: new TextFormField(
              controller: communityTextController,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: S.of(context).communityHint,
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("res/images/background.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Builder(
              builder: (BuildContext context) => Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        textInput(),
                        Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: RoundedFlatButtonField(
                                borderSide: BorderSide(color: Colors.white),
                                hasBackgroundColor: false,
                                buttonText: widget.isCreating
                                    ? S.of(context).createCommunity
                                    : S.of(context).joinCommunity,
                                onPress: () => _createUser(context))),
                      ],
                    ),
                  ))),
    );
  }
}
