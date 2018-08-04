import 'package:flutter/material.dart';

showSnackBar(context, errorMessage) {
  final snackBar = SnackBar(content: Text(errorMessage));
  Scaffold.of(context).showSnackBar(snackBar);
}
