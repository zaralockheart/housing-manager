import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundTextField extends StatefulWidget {
  final hint;
  final bool obscureText;
  final validator;
  final controller;
  final TextInputType keyboardType;

  const RoundTextField(
      {Key key,
      this.hint,
      this.validator,
      this.obscureText = false,
      this.controller,
      this.keyboardType = TextInputType.url})
      : super(key: key);

  @override
  _RoundTextFieldState createState() => _RoundTextFieldState();
}

class _RoundTextFieldState extends State<RoundTextField> {
  @override
  Widget build(BuildContext context) =>
      Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Color.fromRGBO(255, 255, 255, 0.5)),
          child: TextFormField(
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            validator: widget.validator,
            controller: widget.controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
            ),
          ));
}
