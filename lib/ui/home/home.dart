import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/ui/home/home_payment_list.dart';
import 'package:housing_manager/ui/home/home_user_details.dart';
import 'package:housing_manager/ui/home/widget/home_appbar.dart';

class Home extends StatefulWidget {
  final currentUserEmail;
  final String community;

  const Home({Key key, this.currentUserEmail, this.community})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var lastPaymentString = '';
  final controller = new PageController();

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
                        HomeUserDetails(
                            lastPaymentString: lastPaymentString,
                            snapshot: snapshot),
                        HomePaymentList(
                          currentUserEmail: widget.currentUserEmail,
                          community: widget.community,
                        ),
                      ],
                    ),
                  ),
                );
              }));
}
