import 'package:flutter/material.dart';
import 'package:hello/values/custom_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Automacoes extends StatefulWidget{
  _Automacoes createState() => _Automacoes();
}
class _Automacoes extends State<Automacoes>{

  @override
  Widget _energia = Center();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automações'),
        shape:  Border(
          bottom: BorderSide(
            color:custom_colors().secundary_color(),
            width: 2
          )
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
        margin: const EdgeInsets.all(20),
        width: 300.0,
        height: 50.0,
        child: TextButton(
          onPressed: energia,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(custom_colors().secundary_color()),
          ),
          child:const Text(
                'Energia',
                style: TextStyle(fontSize: 25),
              )
          ),
        ),
        _energia,
        
          ],
        ),
      )
    );
  }
  void energia(){
    setState(() {    
    _energia = SizedBox(
    width: 300.0,
    height: 80.0,
    child:Row(
    children: [
      Expanded(
        flex: 3,
        child:Container(
        margin: const EdgeInsets.all(5),
        color: custom_colors().secundary_color(),
        child: TextButton(
          onPressed: () => print("foi"),
          child: Icon(Icons.power_settings_new),
        ),
      )),
      Expanded(
        flex: 3,
        child:Container(
        margin: const EdgeInsets.all(5),
        color: custom_colors().secundary_color(),
        child: TextButton(
          onPressed: () => print("foi"),
          child: Icon(Icons.restart_alt),
        ),
      )
      ),
      Expanded(
        flex: 3,
        child:Container(
        margin: const EdgeInsets.all(5),
        color: custom_colors().secundary_color(),
        child: TextButton(
          onPressed: () => print("foi"),
          child: Icon(Icons.nights_stay),
        ),
      )
      ),
    ],
  )
  );
  });
  }
  
}