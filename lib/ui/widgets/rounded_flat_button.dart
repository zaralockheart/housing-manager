import 'package:flutter/material.dart';

class RoundedFlatButtonField extends StatefulWidget {
  final String buttonText;
  final onPress;
  final bool hasBackgroundColor;
  final BorderSide borderSide;
  final Color backgroundColor;

  const RoundedFlatButtonField(
      {Key key,
      this.buttonText,
      this.onPress,
      this.hasBackgroundColor = true,
      this.borderSide,
      this.backgroundColor = Colors.green})
      : super(key: key);

  @override
  _RoundedFlatButtonFieldState createState() => _RoundedFlatButtonFieldState();
}

class _RoundedFlatButtonFieldState extends State<RoundedFlatButtonField> {
  @override
  Widget build(BuildContext context) =>
      FlatButton(
        shape: RoundedRectangleBorder(
            side: widget.borderSide ?? BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        onPressed: widget.onPress,
        textColor: Colors.white,
        color: widget.hasBackgroundColor
            ? widget.backgroundColor
            : Colors.transparent,
        child: Text(widget.buttonText),
      );
}
