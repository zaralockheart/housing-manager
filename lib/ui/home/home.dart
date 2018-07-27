import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final currentUserEmail;

  const Home({Key key, this.currentUserEmail}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _listBuilder(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> innerList = List<Widget>();
    snapshot.data.documents.map((DocumentSnapshot document) {
      document['payment'].map((dynamic innerDocument) {
        innerList.add(ListTile(
          title: Text(innerDocument['month'].toString()),
          subtitle: Text(innerDocument['payment'].toString()),
        ));
      }).toList();
    }).toList();

    return innerList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('suakasih').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return Text('Loading...');
              print(snapshot.data.documents[0]['email']);
              return ListView(children: _listBuilder(snapshot));
            },
          ),
        ),
      ),
    );
  }
}
