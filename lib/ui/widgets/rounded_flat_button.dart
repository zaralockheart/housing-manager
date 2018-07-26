import 'package:flutter/material.dart';

class RoundedFlatButtonField extends StatefulWidget {
  final String buttonText;
  final onPress;

  const RoundedFlatButtonField({Key key, this.buttonText, this.onPress})
      : super(key: key);

  @override
  _RoundedFlatButtonFieldState createState() => _RoundedFlatButtonFieldState();
}

class _RoundedFlatButtonFieldState extends State<RoundedFlatButtonField> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      onPressed: widget.onPress,
      child: Text(widget.buttonText),
    );
  }
}
