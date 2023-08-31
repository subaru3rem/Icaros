import 'package:flutter/material.dart';

class CustomColors{
  // ignore: constant_identifier_names
  static const primary_color = Color.fromARGB(255, 11, 22, 37);
  // ignore: constant_identifier_names
  static const secundary_color = Colors.green;
}
class Ips{
  static String ip = '';

  static bool validateIp(String ip){
    RegExp ipRegex = RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)');
    if (ipRegex.hasMatch(ip) || ip.contains('.')) {
      return true;
    }
    return false;
  }
}
class Window{
  static String window = 'home';
}