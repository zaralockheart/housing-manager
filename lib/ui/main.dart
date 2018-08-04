import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/bloc/main_bloc.dart';
import 'package:housing_manager/bloc/main_provider.dart';
import 'package:housing_manager/generated/i18n.dart';
import 'package:housing_manager/settings/AppConfig.dart';
import 'package:housing_manager/ui/home/home.dart';
import 'package:housing_manager/ui/sign_in/sign_in.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appConfig = AppConfig.of(context);
    return MainProvider(
      mainBloc: MainBloc(),
      child: MaterialApp(
        localizationsDelegates: [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        localeResolutionCallback:
        S.delegate.resolution(fallback: new Locale('en', '')),
        title: appConfig.appName,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder:
                (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (!snapshot.hasData) {
                return SignIn(title: appConfig.appName);
              } else {
                return Home(
                  currentUserEmail: snapshot.data.email,
                  community: 'suakasih',);
              }
            }),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  MainBloc counterBloc;

  void _incrementCounter({MainBloc bloc}) {
//    bloc.itemCount2.add(1);
  }

  @override
  Widget build(BuildContext context) {
    counterBloc = MainProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('bandnames').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text('Loading...');
            return ListView(
              children:
              snapshot.data.documents.map((DocumentSnapshot document) =>
                  ListTile(
                    title: Text(document['name']),
                    subtitle: Text(document['votes'].toString()),
                  )).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(bloc: counterBloc),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
