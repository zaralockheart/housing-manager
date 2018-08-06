import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/generated/i18n.dart';
import 'package:housing_manager/ui/home/model/payment_status_model.dart';
import 'package:housing_manager/util/app_main_config.dart';
import 'package:housing_manager/util/view_util.dart';

class AddMember extends StatefulWidget {
  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  _addMemberForm(
          {TextEditingController controller,
          int maxLines = 1,
          String hint,
          keyboardType = TextInputType.multiline}) =>
      Padding(
        padding: EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
        child: new TextFormField(
            maxLines: maxLines,
            style: TextStyle(color: Colors.black),
            controller: controller,
            keyboardType: keyboardType,
            decoration: new InputDecoration(
              border: InputBorder.none,
              labelStyle: TextStyle(color: Colors.grey),
              labelText: hint,
            )),
      );

  _onPressAddMember({BuildContext context}) {
    if (emailController.text.isEmpty) {
      showSnackBar(context, S.of(context).emailFieldEmpty);
      return;
    }

    Map<String, String> emailMap = <String, String>{};

    Firestore.instance
        .collection('suakasih')
        .getDocuments()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.documents.map((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.data['email'] == emailController.text) {
          emailMap[documentSnapshot.data['email']] = emailController.text;
        }
      }).toList();
    }).then((onValue) {
      if (emailMap.isEmpty) {
        _addUser();
      } else {
        showSnackBar(context, S.of(context).emailExisted);
      }
    });
  }

  _addUser() {
    Firestore.instance.collection('suakasih').add({
      'email': emailController.text,
      'fullName': fullNameController.text,
      'address': addressController.text,
      'mobile': mobileNumberController.text,
      'adminStatus': false
    }).then((DocumentReference documentReference) {
      Firestore.instance.runTransaction((transaction) async {
        var paymentCollection = Firestore.instance
            .collection('suakasih')
            .document(documentReference.documentID)
            .collection('payments');

        monthsInAYear.map((String month) {
          paymentCollection.add(PaymentStatusModel.toJson(
              month: month, status: false, year: DateTime.now().year));
        }).toList();
      }).then((onValue) {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Add Members'),
      ),
      body: Builder(
        builder: (BuildContext context) => Container(
              child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            _addMemberForm(
                                controller: emailController,
                                hint: S.of(context).email,
                                keyboardType: TextInputType.emailAddress),
                            _addMemberForm(
                              controller: fullNameController,
                              hint: S.of(context).fullName,
                            ),
                            _addMemberForm(
                                controller: addressController,
                                hint: S.of(context).address,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline),
                            _addMemberForm(
                                controller: mobileNumberController,
                                hint: S.of(context).mobileNumber,
                                keyboardType: TextInputType.phone),
                          ],
                        ),
                      ),
                      FlatButton(
                        child: Text('Add'),
                        onPressed: () {
                          _onPressAddMember(context: context);
                        },
                      )
                    ],
                  )),
            ),
      ));
}
