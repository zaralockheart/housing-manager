import 'package:flutter/material.dart';

class MembersList extends StatefulWidget {
  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  @override
  Widget build(BuildContext context) => Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      appBar: AppBar(
        title: Text('Members'),
      ),
      body: Container(
//        child: StreamBuilder(
//            stream: Firestore.instance.collection('suakasih').snapshots(),
//            builder:
//                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
//              if (!snapshots.hasData) return Text('Loading..');
//              List<Widget> innerList = <Widget>[];
//              snapshots.data.documents.map((DocumentSnapshot documentSnapshot) {
//                innerList.add(ListTile(
//                  title: Text(documentSnapshot['email']),
//                  subtitle: Text(documentSnapshot['adminStatus'].toString()),
//                ));
//              }).toList();
//              return Container(
//                child: ListView(children: innerList),
//              );
//            }),
          ));
}
