import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/ui/home/model/payment_status_model.dart';
import 'package:housing_manager/util/app_main_config.dart';

class MembersPaymentDetails extends StatefulWidget {
  final documentId;

  const MembersPaymentDetails({Key key, this.documentId}) : super(key: key);

  @override
  _MembersPaymentDetailsState createState() => _MembersPaymentDetailsState();
}

class _MembersPaymentDetailsState extends State<MembersPaymentDetails> {
  _onPressUpdatePayment(documentSnapshot) {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(documentSnapshot.reference, {'status': true});
    });
  }

  _addNextYearPayments() {
    Firestore.instance.runTransaction((transaction) async {
      var paymentCollection = Firestore.instance
          .collection('suakasih')
          .document(widget.documentId)
          .collection('payments');

      monthsInAYear.map((String month) {
        paymentCollection.add(PaymentStatusModel.toJson(
            month: month, status: false, year: DateTime.now().year + 1));
      }).toList();
    });
  }

  Widget _handleMainUi(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<dynamic> yearList = <dynamic>[];
    var documents = snapshot.data.documents;
    yearList.add(documents[0]['year']);
    for (int i = 0; i < documents.length; i++) {
      if (i > 0 && documents[i]['year'] != documents[i - 1]['year']) {
        yearList.add(documents[i]['year']);
      }
    }
    List<Widget> expansionTileList = <Widget>[];
    for (int j = 0; j < yearList.length; j++) {
      expansionTileList.add(ExpansionTile(
        title: Text(yearList[j].toString()),
        children: documents.map((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.data['year'] == yearList[j]) {
            return FlatButton(
              onPressed: () {
                print(documentSnapshot.data['year'] == yearList[j]);
              },
              child: Text(documentSnapshot.data['month']),
            );
          } else {
            return Container();
          }
        }).toList(),
      ));
    }

    return Container(
      child: ListView(children: expansionTileList.reversed.toList()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder(
        stream: Firestore.instance
            .collection('suakasih')
            .document(widget.documentId)
            .collection('payments')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          return _handleMainUi(snapshot);
        },
      ));
}
