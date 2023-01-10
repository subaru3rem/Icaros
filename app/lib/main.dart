import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello/values/custom_colors.dart';
import 'package:hello/screens/navegador.dart';
import 'package:hello/screens/multimidia.dart';
import 'package:hello/screens/automacoes.dart';
import 'package:hello/screens/env_file.dart';
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
          primary: custom_colors.primary_color,
          secondary: custom_colors.secundary_color
        ),
        scaffoldBackgroundColor:  custom_colors.primary_color,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.black54),
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
Map<String,dynamic> _resposta = {'host':'', 'cpu':'','memory':''};
Uri url = Uri.http('192.168.10.50:5000');

  void navegator(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Navegador())
    );
  }
  void multimida(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Multimidia())
    );
  }
  void automacao(){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context)=>Automacoes())
    );
  }
  void env_file(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>Teste())
    );
  }
  void search_ip() async{
    
    Map<String, dynamic> obj = {'pc_info':''};
    try {final response = await http.post(url, body:jsonEncode(obj));
    setState(() {
      
      var r = response.body;
      _resposta = jsonDecode(r);
    });}catch(e){
      setState(() {
        _resposta['host'] = 'Falha no servidor';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    search_ip();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        shape: const Border(
          bottom: BorderSide(
            color:custom_colors.secundary_color,
            width: 2
          )
        ),
      ),
      body: Column(
          children: [
            Expanded(child:FractionallySizedBox(
              heightFactor: .9,
              widthFactor: .9,
              child: Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: custom_colors.primary_color,
                  boxShadow: const [BoxShadow(
                    color: custom_colors.secundary_color,
                    spreadRadius: 1,
                    blurRadius: 20,
                  )],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  _resposta['host'],
                  style: const TextStyle(
                    fontSize: 40
                  ),
                ),
                Text(
                  'Uso de cpu: '+_resposta['cpu'],
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Uso de memoria: '+_resposta['memory'],
                  style: TextStyle(fontSize: 20),
                ),
                
              ]),
              )
            )),
            GridView.count(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: [
                    TextButton(
              onPressed: navegator,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>( custom_colors.secundary_color)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [ Icon(Icons.language, color: Colors.white,),
                 Text('Navegador', style: TextStyle(color: Colors.white),)]
              ),
            )
            ,
            TextButton(
              onPressed: multimida,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>( custom_colors.secundary_color)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [ Icon(Icons.headphones, color: Colors.white,),
                 Text('Multimidia', style: TextStyle(color: Colors.white),)]
              ),
            ),
            TextButton(
              onPressed: automacao,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>( custom_colors.secundary_color)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [ Icon(Icons.devices, color: Colors.white,),
                 Text('Automações', style: TextStyle(color: Colors.white),)]
              ),
            ),
            TextButton(
              onPressed: env_file,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>( custom_colors.secundary_color)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [ Icon(Icons.file_upload, color: Colors.white,),
                 Text('Arquivos', style: TextStyle(color: Colors.white),)]
              ),
            )
                  ],
                ),            
          ],
        ),
      )
    ;
  }
}
