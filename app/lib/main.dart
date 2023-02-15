import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Icaros/values/custom_colors.dart';
import 'package:Icaros/screens/navegador.dart';
import 'package:Icaros/screens/multimidia.dart';
import 'package:Icaros/screens/automacoes.dart';
import 'package:Icaros/screens/env_file.dart';
import 'package:Icaros/search_ip.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
  State<MyHomePage> createState() => _Myhomepage();
}
class _Myhomepage extends State<MyHomePage>{
 @override 
 Widget build(BuildContext context){
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
      body: MyHomePageWidget());
 }
}
class MyHomePageWidget extends StatefulWidget{
  const MyHomePageWidget({super.key});

  @override 
  _MyHomePageWidget createState()=> _MyHomePageWidget();
}
class _MyHomePageWidget extends State<MyHomePageWidget>{
  bool? page_focus;
  Map<String,dynamic> _resposta = {'host':'', 'cpu':'','memory':''};
  Uri url = Uri.http('192.168.10.50:5000');

  void navegator(){
    page_focus = false;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Navegador())
    );
  }
  void multimida(){
    page_focus = false;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Multimidia())
    );
  }
  void automacao(){
    page_focus = false;
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context)=>Automacoes())
    );
  }
  void env_file(){
    page_focus = false;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>Env_file())
    );
  }
  void info_pc() async{
    if(page_focus!){Map<String, dynamic> obj = {'pc_info':''};
    try {final response = await http.post(url, body:jsonEncode(obj));
    setState(() {
      var r = response.body;
      _resposta = jsonDecode(r);
    });}catch(e){
      setState(() {
        _resposta['host'] = 'Falha no servidor';
      });
    }}
  }
  Widget ip_search(){
    return Center(
      child: Container(
        height: 50,
        width: 100,
        color: Colors.green,
        child: TextButton(
          onPressed: ()=>search.init_search(),
          child: Text('ip'),
        ),
      ),
    );
  }
  Widget pc_info(){
    return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  _resposta['host'],
                  style: const TextStyle(
                    fontSize: 40
                  ),
                ),
                Text(
                  'Uso de cpu: ${_resposta['cpu']}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Uso de memoria: ${_resposta['memory']}',
                  style: const TextStyle(fontSize: 20),
                ),
              ]);
  }
  @override
  void initState(){
    page_focus = true;
  }
  @override
  Widget build(BuildContext context) {  
    info_pc();
    return Column(
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
                child: pc_info()
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
        );
  }
}
