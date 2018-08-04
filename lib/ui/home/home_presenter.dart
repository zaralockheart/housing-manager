import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/generated/i18n.dart';
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

  checkIfPaymentListExist({community, docId}) {
    var paymentCollection =
    Firestore.instance.collection('$community/$docId/payments');

    paymentCollection.snapshots().map((QuerySnapshot querySnapshot) {
      if (querySnapshot.documents.isEmpty) {
        _addThisYearPayments(paymentCollection);
      }
    }).toList();
  }

  _addThisYearPayments(paymentCollection) {
    monthsInAYear.map((String month) {
      paymentCollection.add(PaymentStatusModel.toJson(
          month: month, status: false, year: DateTime
          .now()
          .year));
    }).toList();
  }

  getAllPayments({context, community, docId}) {
    var collectionPerYear =
    Firestore.instance.collection('$community/$docId/payments');
    collectionPerYear.snapshots().map((QuerySnapshot querySnapshot) {
      var documents = querySnapshot.documents;
      var yearAndMonths = [];
      var lastPayment = '';
      for (int i = 0; i < documents.length; i++) {
        if (i > 0 && !documents[i]['status'] && documents[i - 1]['status']) {
          lastPayment =
          "${documents[i - 1]['month']} ${documents[i - 1]['year']}";
          homeView.onGetLastPayment(
              "${documents[i - 1]['month']} ${documents[i - 1]['year']}");
        }
        yearAndMonths.add(documents[i]);
      }
      if (lastPayment.isEmpty) {
        homeView.onGetLastPayment(S
            .of(context)
            .noPayment);
      } else {
        homeView.onGetLastPayment(lastPayment);
      }
      homeView.onGetAllData(datas: yearAndMonths);
    }).toList();
  }
}
