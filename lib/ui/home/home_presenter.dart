import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/ui/home/home_view.dart';
import 'package:housing_manager/ui/home/model/payment_status_model.dart';
import 'package:housing_manager/util/app_main_config.dart';

class HomePresenter {
  HomeView homeView;

  HomePresenter(this.homeView);

  Widget paymentStatusBuilder(CollectionReference payments) => StreamBuilder(
        stream: payments.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> futureSnapshot) {
          List<Widget> innerList = <Widget>[];
          if (!futureSnapshot.hasData) return Text('Loading...');
          futureSnapshot.data.documents.map((DocumentSnapshot snapshot) {
            for (int i = 0; i < snapshot['paymentStatus'].length; i++) {
              _getLastPayment(i, snapshot);

              innerList.add(ListTile(
                title: Text(snapshot['paymentStatus'][i]['month'].toString()),
                subtitle:
                    Text(snapshot['paymentStatus'][i]['status'].toString()),
              ));
            }
          }).toList();
          return ListView(children: innerList);
        },
      );

  _getLastPayment(i, snapshot) {
    if (i > 0 &&
        snapshot['paymentStatus'][i]['status'] !=
            snapshot['paymentStatus'][i - 1]['status']) {
      homeView.onGetLastPayment(
          snapshot['paymentStatus'][i - 1]['month'].toString());
    }
  }

  checkIfPaymentListExist(docId) {
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

  _getAll(docId) {
    var yearDif = DateTime.now().year - 2017;

    var yearAndMonths = [];
    for (int i = 0; i < yearDif + 1; i++) {
      var test = Firestore.instance.collection('suakasih/$docId/${2017 + i}');

      test.getDocuments().then((QuerySnapshot value) {
        for (int j = 0; j < value.documents.length; j++) {
          yearAndMonths.add({
            'year': 2017 + i,
            'payments': value.documents[j]['paymentStatus']
          });
        }
      }).then(((onValue) {
        print(yearAndMonths);
      }));
    }
  }
}
