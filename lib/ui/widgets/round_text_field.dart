import 'package:flutter/material.dart';

class RoundTextField extends StatefulWidget {
  final hint;
  final output;

  const RoundTextField({Key key, this.hint, this.output}) : super(key: key);

  @override
  _RoundTextFieldState createState() => _RoundTextFieldState();
}

class _RoundTextFieldState extends State<RoundTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white),
        child: TextField(
          onChanged: (value) => widget.output.add(value),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hint,
          ),
        ));
  }
}
