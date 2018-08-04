import 'package:flutter/material.dart';
import 'package:housing_manager/ui/home/bloc/home_bloc.dart';
import 'package:housing_manager/ui/home/home_presenter.dart';
import 'package:housing_manager/ui/home/home_view.dart';

class HomePaymentList extends StatefulWidget {
  final paymentList;

  const HomePaymentList({Key key, this.paymentList}) : super(key: key);

  @override
  _HomePaymentListState createState() => _HomePaymentListState();
}

class _HomePaymentListState extends State<HomePaymentList> implements HomeView {
  HomePresenter presenter;
  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc();
    presenter = HomePresenter(this);
  }

  @override
  onGetLastPayment(month) {
    homeBloc.lastPaymentMonthSink.add(month);
  }

  @override
  onGetAllData({datas}) {
    homeBloc.paymentLists.add(datas);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> innerList = <Widget>[];
    for (int i = 0; i < homeBloc.paymentLists.length; i++) {
      innerList.add(ListTile(
        title:
        Text(homeBloc.paymentLists[i]['month'].toString()),
        subtitle:
        Text(homeBloc.paymentLists[i]['status'].toString() + ' ' +
            homeBloc.paymentLists[i]['year'].toString()),
      ));
    }

    return Container(
      child: ListView(children: innerList),
    );
  }
}
