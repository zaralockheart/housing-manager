import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/ui/home/home_appbar.dart';
import 'package:housing_manager/ui/home/model/home_list.dart';

class Home extends StatefulWidget {
  final currentUserEmail;
  final String community;

  const Home({Key key, this.currentUserEmail, this.community})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lastPaymentString = '';

    return Scaffold(
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
                        child: HomeList(
                            community: widget.community,
                            currentUserEmail: widget.currentUserEmail,
                            lastPayment: (value) {
                              lastPaymentString = value;
                            }),
                      ),
                    ],
                  ));
            }));
  }
}
