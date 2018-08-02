import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/ui/home/bloc/home_bloc.dart';
import 'package:housing_manager/ui/home/home_presenter.dart';
import 'package:housing_manager/ui/home/home_view.dart';

class HomePaymentList extends StatefulWidget {
  final community;
  final currentUserEmail;

  const HomePaymentList({Key key, this.community, this.currentUserEmail})
      : super(key: key);

  @override
  _HomePaymentListState createState() => _HomePaymentListState();
}

class _HomePaymentListState extends State<HomePaymentList> implements HomeView {
  HomePresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = HomePresenter(this);
  }

  @override
  onGetLastPayment(month) {
    HomeBloc.lastPaymentMonthSink.add(month);
  }

  @override
  Widget build(BuildContext context) => Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(widget.community)
              .where('email', isEqualTo: widget.currentUserEmail)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text('Loading...');

            var docId = snapshot.data.documents[0].documentID;
            var payments =
                Firestore.instance.collection('suakasih/$docId/${DateTime
                .now()
                .year}');

            presenter.checkIfPaymentListExist(docId);

            return presenter.paymentStatusBuilder(payments);
          },
        ),
      );
}
