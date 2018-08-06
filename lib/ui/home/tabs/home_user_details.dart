import 'package:flutter/material.dart';
import 'package:housing_manager/bloc/main_bloc.dart';
import 'package:housing_manager/bloc/main_provider.dart';
import 'package:housing_manager/generated/i18n.dart';

class HomeUserDetails extends StatefulWidget {
  final snapshot;
  final lastPaymentString;
  final name;

  const HomeUserDetails(
      {Key key, this.snapshot, this.lastPaymentString, this.name})
      : super(key: key);

  @override
  _HomeUserDetailsState createState() => _HomeUserDetailsState();
}

class _HomeUserDetailsState extends State<HomeUserDetails> {
  @override
  Widget build(BuildContext context) {
    MainBloc mainBloc = MainProvider.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Hi ${widget.name}',
                style: TextStyle(fontSize: 20.0)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Your last payment is at',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
                stream: mainBloc.homeBloc.lastPaymentMonthStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                snapshot.hasData
                    ? Text(snapshot.data,
                    style: TextStyle(
                        fontSize: 40.0, fontWeight: FontWeight.bold))
                    : Text(S
                    .of(context)
                    .communityHint)),
          )
        ],
      ),
    );
  }
}
