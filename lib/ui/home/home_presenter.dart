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

  checkIfPaymentListExist(community, docId) {
    var paymentCollection =
    Firestore.instance.collection('$community}/$docId/payments');

    paymentCollection.snapshots().map((QuerySnapshot querySnapshot) {
      if (querySnapshot.documents.isNotEmpty) {
        if (querySnapshot.documents[querySnapshot.documents.length - 1]
        ['year'] !=
            DateTime
                .now()
                .year + 1) {
          _addNextYear(paymentCollection, querySnapshot);
        }
      } else {
        _addValueFrom2017(paymentCollection);
      }
    }).toList();
  }

  _addValueFrom2017(paymentCollection) {
    var yearDif = DateTime
        .now()
        .year - 2017;

    for (int i = 0; i < yearDif + 1; i++) {
      monthsInAYear.map((String month) {
        paymentCollection.add(PaymentStatusModel.toJson(
            month: month, status: false, year: 2017 + i));
      }).toList();
    }
  }

  _addNextYear(paymentCollection, querySnapshot) {
    var docLength = querySnapshot.documents.length - 1;
    if (querySnapshot.documents[docLength]['year'] != DateTime
        .now()
        .year + 1) {
      monthsInAYear.map((String month) {
        paymentCollection.add(
            PaymentStatusModel.toJson(month: month, status: false, year: 2019));
      }).toList();
    }
  }

  getAllPayments({community, docId}) {
    var yearAndMonths = [];
    var collectionPerYear =
    Firestore.instance.collection('$community/$docId/payments');
    collectionPerYear.snapshots().map((QuerySnapshot querySnapshot) {
      var documents = querySnapshot.documents;
      for (int i = 0; i < documents.length; i++) {
        if (i > 0 && documents[i]['status'] != documents[i - 1]['status']) {
          homeView.onGetLastPayment(
              "${documents[i - 1]['month']} ${documents[i - 1]['year']}");
        }
        yearAndMonths.add(documents[i]);
      }
      homeView.onGetAllData(datas: yearAndMonths);
    }).toList();
  }
}
