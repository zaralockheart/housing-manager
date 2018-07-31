import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/ui/home/home_appbar.dart';
import 'package:housing_manager/ui/home/model/payment_status_model.dart';
import 'package:housing_manager/util/app_main_config.dart';

class Home extends StatefulWidget {
  final currentUserEmail;
  final String community;

  const Home({Key key, this.currentUserEmail, this.community})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _listBuilder(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> innerList = <Widget>[];
    snapshot.data.documents.map((DocumentSnapshot document) {
      var docId = '';

      Firestore.instance.runTransaction((Transaction transaction) async {
        await Firestore.instance
            .collection('suakasih')
            .where('email', isEqualTo: widget.currentUserEmail)
            .snapshots()
            .map((QuerySnapshot snapshot) {
          snapshot.documents.map((DocumentSnapshot snapshot) async {
            docId = snapshot.documentID;
          }).toList();
        }).toList();
      }).then((onValue) async {
        _checkIfPaymentListExist(docId);
      }).whenComplete(() {
        print('Completed!');
        return;
      });

      if (document['paymentStatus'] == null) {
        innerList.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('No value')]));
      } else {
        document['paymentStatus'].map((innerDocument) {
          innerList.add(ListTile(
            title: Text(innerDocument['month'].toString()),
            subtitle: Text(innerDocument['payment'].toString()),
          ));
        }).toList();
      }
    }).toList();

    return innerList;
  }

  _checkIfPaymentListExist(docId) {
    var paymentCollection =
    Firestore.instance.collection('suakasih/$docId/${DateTime
        .now()
        .year}');

    paymentCollection.snapshots().map((QuerySnapshot querySnapshot) {
      if (querySnapshot.documents.isNotEmpty) {
        print("Don't add this year");
      } else {
        List<Map<String, dynamic>> yearInit = <Map<String, dynamic>>[];

        monthsInAYear.map((String month) {
          yearInit.add(PaymentStatusModel.toJson(month: month, status: false));
        }).toList();

        paymentCollection.add({'paymentStatus': yearInit});
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: HomeAppbar(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection(widget.community)
                  .where('email', isEqualTo: 'test@test.test')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text('Loading...');

                return ListView(children: _listBuilder(snapshot));
              },
            ),
          ),
        ),
      );
}
