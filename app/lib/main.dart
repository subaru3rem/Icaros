import 'dart:convert';

import 'package:flutter/material.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: Colors.blueGrey
        )
        ),
      home: const MyHomePage(title: 'Connector'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: navegator,
              icon: const Icon(Icons.language),
              label: const Text('Navegador')
            )
          ],
        ),
      )
    );
  }
}
class Navegador extends StatefulWidget {
  static const String routeName = "/MyItemsPage";
  @override
  _Navegador createState() => new _Navegador();
}
class _Navegador extends State<Navegador>{
  var Link = '';
  var resposta = '50';
  var lista = <Widget>[];
  
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Navegador"),
      ),
      body: Center(
          child: Column(
          children: <Widget> [Container(
            margin: const EdgeInsets.all(40),
            child: TextField(
              onChanged: (text){Link = text;},
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Digite o link',
              ),
            )
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            FloatingActionButton(
              onPressed: server,
              child: const Icon(Icons.search),
            ),
            FloatingActionButton.extended(
              onPressed: teste, 
              icon:const Icon(Icons.replay_outlined),
              label:const Text('state'),
            )
            ]
        ),
        ]
    )
    )
    );
  }
  void server() async {
      var url = Uri.http('192.168.10.50:5000');
      Map<String, dynamic> x = {'link': Link};
      final response = await http.post(url, body:jsonEncode(x));
      resposta = response.body;
  }
  void teste(){
    
}
}