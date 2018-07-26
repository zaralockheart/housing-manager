import 'package:flutter/material.dart';
import 'package:housing_manager/bloc/main_bloc.dart';

class MainProvider extends InheritedWidget {
  final MainBloc mainBloc;

  MainProvider({
    Key key,
    MainBloc mainBloc,
    Widget child,
  })  : mainBloc = mainBloc ?? MainBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static MainBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(MainProvider) as MainProvider)
          .mainBloc;
}