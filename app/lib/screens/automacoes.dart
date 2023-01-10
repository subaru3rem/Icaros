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
  bool _energia_check = true;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automações'),
        shape:  const Border(
          bottom: BorderSide(
            color:custom_colors.secundary_color,
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
        decoration: BoxDecoration(border: Border.all(color: custom_colors.secundary_color)),
        child: TextButton(
          onPressed: energia,
          child:const Text(
                'Energia',
                style: TextStyle(fontSize: 25, color: custom_colors.secundary_color),
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
    if (_energia_check){
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
        decoration: BoxDecoration(border: Border.all(color: custom_colors.secundary_color)),
        child: TextButton(
          onPressed: () => server({'shutdown':'/s'}),
          child: const Icon(Icons.power_settings_new, color: custom_colors.secundary_color),
        ),
      )),
      Expanded(
        flex: 3,
        child:Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: custom_colors.secundary_color)),
        child: TextButton(
          onPressed: () => server({'shutdown':'/r'}),
          child: const Icon(Icons.restart_alt,color: custom_colors.secundary_color),
        ),
      )
      ),
      Expanded(
        flex: 3,
        child:Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: custom_colors.secundary_color)),
        child: TextButton(
          onPressed: () => server({'shutdown':'/h'}),
          child: const Icon(Icons.nights_stay, color: custom_colors.secundary_color,),
        ),
      )
      ),
    ],
  )
  );
  });
  _energia_check = false;}
  else{
    setState(() {
    _energia = Center();
    _energia_check = true;
    });
  }
  }
  void server(obj) async {
      var url = Uri.http('192.168.10.50:5000');
      final response = await http.post(url, body:jsonEncode(obj));
  }
}