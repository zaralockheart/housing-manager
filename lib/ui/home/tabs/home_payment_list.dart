import 'package:flutter/material.dart';
import 'package:housing_manager/bloc/main_bloc.dart';
import 'package:housing_manager/bloc/main_provider.dart';

class HomePaymentList extends StatefulWidget {
  final paymentList;

  const HomePaymentList({Key key, this.paymentList}) : super(key: key);

  @override
  _HomePaymentListState createState() => _HomePaymentListState();
}

class _HomePaymentListState extends State<HomePaymentList> {
  MainBloc mainBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mainBloc = MainProvider.of(context);

    return StreamBuilder(
      stream: mainBloc.homeBloc.paymentListsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        List<Widget> innerList = <Widget>[];
        for (int i = 0; i < snapshot.data.length; i++) {
          innerList.add(Column(
            children: <Widget>[
              (i == 0 ||
                      (i > 0 &&
                          snapshot.data[i]['year'] !=
                              snapshot.data[i - 1]['year']))
                  ? Text(snapshot.data[i]['year'].toString())
                  : Text(''),
              ListTile(
                title: Text(snapshot.data[i]['month'].toString()),
                subtitle: Text(snapshot.data[i]['status'].toString() +
                    ' ' +
                    snapshot.data[i]['year'].toString()),
              )
            ],
          ));
        }
        return Container(
          child: ListView(children: innerList),
        );
      },
    );
  }
}
