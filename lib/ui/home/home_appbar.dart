import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housing_manager/ui/main.dart';

class HomeAppbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _HomeAppbarState createState() => _HomeAppbarState();

  // TODO: implement preferredSize
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _HomeAppbarState extends State<HomeAppbar> {
  _exitApp() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) =>
      AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
                icon: Icon(Icons.exit_to_app), onPressed: _exitApp),
          )
        ],
      );
}
