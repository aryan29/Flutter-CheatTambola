import 'package:flutter/material.dart';

class Modes with ChangeNotifier {
  String _mode = "manual";
  String get mode => _mode;

  void notifyRebuild(String mode) {
    print("Going to Notify THem");
    _mode = mode;
    notifyListeners();
  }
}
