import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';


class search{
  static Future<List<String>> init_search()async{
    List<String> ips = [];
    final info = NetworkInfo();
    var wifiIP = await info.getWifiIP();
    var wifiSubmask = await info.getWifiSubmask();


    return ips;
  }
}