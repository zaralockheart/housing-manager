import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/ui/home/home_appbar.dart';
import 'package:housing_manager/ui/home/home_presenter.dart';
import 'package:housing_manager/ui/home/home_view.dart';

class Home extends StatefulWidget {
  final currentUserEmail;
  final String community;

  const Home({Key key, this.currentUserEmail, this.community})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements HomeView {
  var lastPaymentString = '';

  HomePresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = HomePresenter(this);
  }

  @override
  onGetLastPayment(month) {
    Timer(Duration(milliseconds: 50), () {
      setState(() {
        lastPaymentString = month;
      });
    });
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          appBar: HomeAppbar(),
          body: FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('');
                return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Hi ${snapshot.data.displayName}'),
                        Text(lastPaymentString.toUpperCase()),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection(widget.community)
                                .where(
                                'email', isEqualTo: widget.currentUserEmail)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) return Text('Loading...');

                              var docId = snapshot.data.documents[0].documentID;
                              var payments = Firestore.instance
                                  .collection('suakasih/$docId/${DateTime
                                  .now()
                                  .year}');

                              presenter.checkIfPaymentListExist(docId);

                              return presenter.paymentStatusBuilder(payments);
                            },
                          ),
                        ),
                      ],
                    ));
              }));
}
