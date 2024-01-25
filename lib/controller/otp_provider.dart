import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OtpProvider extends ChangeNotifier {
  String? otpcode;
 

  otpSetter(value) {
    otpcode = value;
    notifyListeners();
  }
}
