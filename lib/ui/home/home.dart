import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final currentUserEmail;
  final String community;

  const Home({Key key, this.currentUserEmail, this.community}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _listBuilder(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> innerList = List<Widget>();
    snapshot.data.documents.map((DocumentSnapshot document) {
      if (document['payment'] == null) {
        innerList.add(ListTile(title: Text("No value")));
      } else {
        document['payment'].map((dynamic innerDocument) {
          innerList.add(ListTile(
            title: Text(innerDocument['month'].toString()),
            subtitle: Text(innerDocument['payment'].toString()),
          ));
        }).toList();
      }
    }).toList();

    return innerList;
  }

  _exitApp() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                IconButton(icon: Icon(Icons.exit_to_app), onPressed: _exitApp),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection(widget.community).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return Text('Loading...');

              return ListView(children: _listBuilder(snapshot));
            },
          ),
        ),
      ),
    );
  }
}
