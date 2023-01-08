import 'package:flutter/material.dart';
import 'package:hello/values/custom_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Multimidia extends StatelessWidget{
  void midia_command (command)async{
    var url = Uri.http('192.168.10.50:5000');
      Map<String, dynamic> x = {'multimidia':'true','tecla': command};
      final response = await http.post(url, body:jsonEncode(x));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multmidia"),
        shape:  Border(
          bottom: BorderSide(
            color:custom_colors().secundary_color(),
            width: 2
          )
        ),
      ),
     body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'prevtrack',
            onPressed: () => midia_command('prevtrack'),
            child: const Icon(Icons.skip_previous)
          ),
          FloatingActionButton(
            heroTag: 'playpause',
            onPressed: () => midia_command('playpause'),
            child: const Icon(Icons.play_arrow),
          ),
          FloatingActionButton(
            heroTag: 'nexttrack',
            onPressed: () => midia_command('nexttrack'),
            child: const Icon(Icons.skip_next),
          )
        ],
      )
     )
    );
  }
}