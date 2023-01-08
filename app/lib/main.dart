import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hello/values/custom_colors.dart';
import 'package:hello/screens/navegador.dart';
import 'package:hello/screens/multimidia.dart';
import 'package:hello/screens/automacoes.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pc connection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: custom_colors().primary_color(),
          secondary: custom_colors().secundary_color()
        ),
        scaffoldBackgroundColor:  custom_colors().primary_color(),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        )
        ),
      home: const MyHomePage(title: 'Connector'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  void navegator(){
    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Navegador()));
  }
  void multimida(){
    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Multimidia()));
  }
  void automacao(){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context)=>Automacoes()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        shape: Border(
          bottom: BorderSide(
            color:custom_colors().secundary_color(),
            width: 2
          )
        ),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child:FloatingActionButton.extended(
              heroTag: 'bnt_navegator',
              onPressed: navegator,
              icon: const Icon(Icons.language),
              label: const Text('Navegador')
            )
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child:FloatingActionButton.extended(
              heroTag: 'btn_multmidia',
              onPressed:multimida,
              icon: const Icon(Icons.headphones),
              label: const Text('Multimidia')
              )
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: FloatingActionButton.extended(
                heroTag: 'bnt_automacao',
                onPressed: automacao,
                icon: const Icon(Icons.devices),
                label: Text('Automações'),
              )
            )
          ],
        ),
      )
    );
  }
}
