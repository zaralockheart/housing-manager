import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/bloc/main_bloc.dart';
import 'package:housing_manager/bloc/main_provider.dart';
import 'package:housing_manager/ui/home/home_payment_list.dart';
import 'package:housing_manager/ui/home/home_presenter.dart';
import 'package:housing_manager/ui/home/home_user_details.dart';
import 'package:housing_manager/ui/home/home_view.dart';
import 'package:housing_manager/ui/home/widget/home_appbar.dart';

class Home extends StatefulWidget {
  final currentUserEmail;
  final String community;

  const Home({Key key, this.currentUserEmail, this.community})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements HomeView {
  HomePresenter presenter;
  MainBloc mainBloc;
  var lastPaymentString = '';

  @override
  void initState() {
    presenter = HomePresenter(this);
    super.initState();
  }

  @override
  onGetLastPayment(month) {
    mainBloc.homeBloc.lastPaymentMonthSink.add(month);
  }

  @override
  onGetAllData({datas}) {
    mainBloc.homeBloc.paymentListsSink.add(datas);
  }

  @override
  Widget build(BuildContext context) {
    mainBloc = MainProvider.of(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {});
          },
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
                  body: StreamBuilder(
                      stream: Firestore.instance
                          .collection('suakasih')
                          .where('email', isEqualTo: widget.currentUserEmail)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshots) {
                        if (!snapshots.hasData) return Text('Please wait');

                        var docId = snapshots.data.documents[0].documentID;
                        presenter.checkIfPaymentListExist(docId);
                        presenter.getAllPayments(docId: docId);

                        return TabBarView(
                          children: [
                            HomeUserDetails(snapshot: snapshot),
                            HomePaymentList(),
                          ],
                        );
                      }),
                ),
              );
            }));
  }
}
