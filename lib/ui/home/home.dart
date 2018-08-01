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
  final controller = new PageController();

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

  _myColumn(snapshot) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Hi ${snapshot.data.displayName}'),
          Text(lastPaymentString.toUpperCase()),
        ],
      );

  _paymentList() =>
      StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(widget.community)
            .where('email', isEqualTo: widget.currentUserEmail)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text('Loading...');

          var docId = snapshot.data.documents[0].documentID;
          var payments =
          Firestore.instance.collection('suakasih/$docId/${DateTime
              .now()
              .year}');

          presenter.checkIfPaymentListExist(docId);

          return presenter.paymentStatusBuilder(payments);
        },
      );

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          appBar: HomeAppbar(),
          body: FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('');
                return DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      elevation: 0.0,
                      actions: <Widget>[],
                      title: TabBar(
                        indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2.5)),
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(icon: Icon(Icons.person)),
                          Tab(icon: Icon(Icons.details)),
                        ],
                        indicatorColor: Colors.white,
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        _myColumn(snapshot),
                        _paymentList(),
                      ],
                    ),
                  ),
                );
//                child: PageView.builder(
//                  controller: controller,
//                  itemCount: 2,
//                  itemBuilder: (_, i) {
//                    List<Widget> mList = <Widget>[];
//                    mList.add(_myColumn(snapshot));
//                    mList.add(_paymentList());
//                    return mList[i];
//                  },
//                ));
              }));
}
