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
        shape:  const Border(
          bottom: BorderSide(
            color:custom_colors.secundary_color,
            width: 2
          )
        ),
      ),
     body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'prevtrack',
            onPressed: () => midia_command('prevtrack'),
            child: const Icon(Icons.skip_previous)
          )),
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'playpause',
            onPressed: () => midia_command('playpause'),
            child: const Icon(Icons.play_arrow),
          )),
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'nexttrack',
            onPressed: () => midia_command('nexttrack'),
            child: const Icon(Icons.skip_next),
          )),
        ],
      ),
      Row(
        
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'volumedown',
            onPressed: ()=> midia_command('volumedown'),
            child: const Icon(Icons.volume_down),
          )),
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'volumemute',
            onPressed: ()=> midia_command('volumemute'),
            child: const Icon(Icons.volume_off),
          )),
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'volumeup',
            onPressed: ()=> midia_command('volumeup'),
            child: const Icon(Icons.volume_up),
          )),
        ],
      )
      ]
      )
    );
  }
}