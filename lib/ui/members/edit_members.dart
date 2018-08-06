import 'package:flutter/material.dart';
import 'package:housing_manager/generated/i18n.dart';
import 'package:housing_manager/ui/members/model/member_model.dart';

class EditMembers extends StatefulWidget {
  final documentId;
  final MemberModel memberModel;

  const EditMembers({Key key, this.documentId, this.memberModel})
      : super(key: key);

  @override
  _EditMembersState createState() => _EditMembersState();
}

class _EditMembersState extends State<EditMembers> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  _addMemberForm(
          {TextEditingController controller,
          int maxLines = 1,
          String hint,
          keyboardType = TextInputType.multiline}) =>
      Padding(
        padding: EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
        child: new TextFormField(
            maxLines: maxLines,
            style: TextStyle(color: Colors.black),
            controller: controller,
            keyboardType: keyboardType,
            decoration: new InputDecoration(
              border: InputBorder.none,
              labelStyle: TextStyle(color: Colors.grey),
              labelText: hint,
            )),
      );

  @override
  void initState() {
    super.initState();
    emailController.text = widget.memberModel.email;
    fullNameController.text = widget.memberModel.fullName;
    addressController.text = widget.memberModel.address;
    mobileNumberController.text = widget.memberModel.mobileNumber;
  }

  _updateMember() {
    print(widget.memberModel.email);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Add Members'),
      ),
      body: Builder(
        builder: (BuildContext context) => Container(
              child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            _addMemberForm(
                                controller: emailController,
                                hint: S.of(context).email,
                                keyboardType: TextInputType.emailAddress),
                            _addMemberForm(
                              controller: fullNameController,
                              hint: S.of(context).fullName,
                            ),
                            _addMemberForm(
                                controller: addressController,
                                hint: S.of(context).address,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline),
                            _addMemberForm(
                                controller: mobileNumberController,
                                hint: S.of(context).mobileNumber,
                                keyboardType: TextInputType.phone),
                          ],
                        ),
                      ),
                      FlatButton(
                        child: Text('Edit'),
                        onPressed: _updateMember,
                      )
                    ],
                  )),
            ),
      ));
}
