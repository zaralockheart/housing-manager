import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/ui/members/members_payment_details.dart';

class MembersList extends StatefulWidget {
  final community;

  const MembersList({Key key, this.community}) : super(key: key);

  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  @override
  Widget build(BuildContext context) => Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      appBar: AppBar(
        title: Text('Members'),
      ),
      body: Container(
        child: StreamBuilder(
            stream: Firestore.instance.collection(widget.community).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
              if (!snapshots.hasData) return Text('Loading..');
              List<Widget> innerList = <Widget>[];
              snapshots.data.documents.map((DocumentSnapshot documentSnapshot) {
                innerList.add(ExpansionTile(
                  title: Text(documentSnapshot['email']),
                  children: <Widget>[
                    Text(documentSnapshot['adminStatus'].toString()),
                    Row(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {},
                          child: Text('Edit'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MembersPaymentDetails(
                                        documentId: documentSnapshot.documentID,
                                      )),
                            );
                          },
                          child: Text('Payments'),
                        )
                      ],
                    )
                  ],
                ));
              }).toList();
              return Container(
                child: ListView(children: innerList),
              );
            }),
      ));
}
