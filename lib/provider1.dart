import 'package:flutter/material.dart';

class Modes with ChangeNotifier {
  static String _mode = "manual";
  String get mode => _mode;

  void notifyRebuild(String mode) {
    print("Notfying rebuild");
    _mode = mode;
    notifyListeners(); //Notify consumers to rebuild themselves
  }
}
