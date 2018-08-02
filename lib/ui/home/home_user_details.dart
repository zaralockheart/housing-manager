import 'package:flutter/material.dart';
import 'package:housing_manager/ui/home/bloc/home_bloc.dart';

class HomeUserDetails extends StatefulWidget {
  final snapshot;
  final lastPaymentString;

  const HomeUserDetails({Key key, this.snapshot, this.lastPaymentString})
      : super(key: key);

  @override
  _HomeUserDetailsState createState() => _HomeUserDetailsState();
}

class _HomeUserDetailsState extends State<HomeUserDetails> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Hi ${widget.snapshot.data.displayName}'),
          Text(HomeBloc.lastPaymentMonth.toUpperCase()),
        ],
      );
}
