import 'package:flutter/material.dart';
import 'package:housing_manager/bloc/counter_bloc.dart';
import 'package:housing_manager/bloc/counter_provider.dart';
import 'package:housing_manager/settings/AppConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appConfig = AppConfig.of(context);
    return MainProvider(
      mainBloc: MainBloc(),
      child: new MaterialApp(
        title: appConfig.appName,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(title: appConfig.appName),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter({MainBloc bloc}) {
    bloc.itemCount2.add(2);
  }

  @override
  Widget build(BuildContext context) {

    final MainBloc counterBloc = MainProvider.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('bandnames').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading...');
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['name']),
                  subtitle: new Text(document['votes'].toString()),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _incrementCounter(bloc: counterBloc),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
