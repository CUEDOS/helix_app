import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SoftwareUploadManager extends ChangeNotifier {
  String softwareDirectory = 'please select a folder';
  void updateDirectory(String _softwareDirectory) {
    softwareDirectory = _softwareDirectory;
    notifyListeners();
  }
}
