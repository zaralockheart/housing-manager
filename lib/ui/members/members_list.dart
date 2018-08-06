import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/ui/members/add_member.dart';
import 'package:housing_manager/ui/members/members_payment_details.dart';

class MembersList extends StatefulWidget {
  final community;
  final userEmail;

  const MembersList({Key key, this.community, this.userEmail})
      : super(key: key);

  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  _deleteUser(DocumentReference reference) {
    reference.delete();
  }

  _seeUserPayments(documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MembersPaymentDetails(
                documentId: documentId,
              )),
    );
  }

  _checkIfFieldEmpty(documentSnapshot, key) =>
      documentSnapshot[key] == null || documentSnapshot[key]
          .toString()
          .isEmpty;

  _renderButtonsRow(documentSnapshot) =>
      Row(
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text('Edit'),
          ),
          FlatButton(
            onPressed: () {
              _seeUserPayments(documentSnapshot.documentID);
            },
            child: Text('Payments'),
          ),
          documentSnapshot.data['email'] != widget.userEmail
              ? FlatButton(
            onPressed: () {
              _deleteUser(documentSnapshot.reference);
            },
            child: Text('Delete'),
          )
              : Container()
        ],
      );

  _renderExpansionTile(documentSnapshot) =>
      ExpansionTile(
        title: Text(_checkIfFieldEmpty(documentSnapshot, 'fullName')
            ? documentSnapshot['email']
            : documentSnapshot['fullName']),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(children: [
              TableRow(
                children: [
                  TableCell(
                    child: Text('User status:'),
                  ),
                  TableCell(
                    child: Text(
                        documentSnapshot['adminStatus'] ? 'Admin' : 'Resident'),
                  )
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Address:'),
                  ),
                  TableCell(
                    child: Text(_checkIfFieldEmpty(documentSnapshot, 'address')
                        ? ''
                        : documentSnapshot['address']),
                  )
                ],
              ),
            ]),
          ),
          _renderButtonsRow(documentSnapshot)
        ],
      );

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMember()),
              );
            },
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          appBar: AppBar(
            title: Text('Members'),
          ),
          body: Container(
            child: StreamBuilder(
                stream: Firestore.instance.collection(widget.community)
                    .snapshots(),
                builder:
                    (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (!snapshots.hasData) return Text('Loading..');
                  List<Widget> innerList = <Widget>[];
                  snapshots.data.documents.map((
                      DocumentSnapshot documentSnapshot) {
                    innerList.add(_renderExpansionTile(documentSnapshot));
                  }).toList();
                  return Container(
                    child: ListView(children: innerList),
                  );
                }),
          ));
}
