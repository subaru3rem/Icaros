import 'package:flutter/material.dart';
import 'package:Icaros/main.dart';
import 'package:Icaros/screens/navegador.dart';
import 'package:Icaros/screens/multimidia.dart';
import 'package:Icaros/screens/automacoes.dart';
import 'package:Icaros/screens/env_file.dart';
import 'package:Icaros/values/values.dart';


class BottomAppBarWidgets extends StatefulWidget{
  const BottomAppBarWidgets({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomAppBarWidgets createState() => _BottomAppBarWidgets();
}
class _BottomAppBarWidgets extends State<BottomAppBarWidgets>{
  void navegator(){
    if(Window.window != "mavegator"){
      Window.window = "navegator";
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Navegador())
      );
    }
  }
  void multimidia(){
    if(Window.window != "multimidia"){
      Window.window = "multimidia";
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Multimidia())
      );
    }
  }
  void automacao(){
    if(Window.window != "automacao"){
      Window.window = "automacao";
      Navigator.pop(context);
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context)=>Automacoes())
      );
    }
  }
  void envFile(){
    if(Window.window != "envFile"){
      Window.window = "envFile";
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>Env_file())
      );
    }
  }
  void home(){
    if(Window.window != "home"){
      Window.window = "home";
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>const MyHomePage(title: "Icaros"))
      );
    }
  }
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: custom_colors.secundary_color))
      ),
      height:65.0,
      padding: const EdgeInsets.only(top:5.0),
      child: BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: custom_colors.primary_color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            onPressed: navegator,
            child:Column(
              children:[
                Icon(Icons.language, color:Window.window == "navegator"?custom_colors.secundary_color:Colors.white),
                Text("Navegador", style: TextStyle(color:Window.window == "navegator"?custom_colors.secundary_color:Colors.white))
              ]
            )
          ),
          TextButton(
            onPressed: multimidia,
            child:Column(
              children:[
                Icon(Icons.headphones, color:Window.window == "multimidia"?custom_colors.secundary_color:Colors.white),
                Text("Multimidia", style: TextStyle(color:Window.window == "multimidia"?custom_colors.secundary_color:Colors.white))
              ]
            )
          ),
          TextButton(
            onPressed: home,
            child:Column(
              children:[
                Icon(Icons.home, color:Window.window == "home"?custom_colors.secundary_color:Colors.white),
                Text("Home", style: TextStyle(color:Window.window == "home"?custom_colors.secundary_color:Colors.white))
              ]
            )
          ),
          TextButton(
            onPressed: automacao,
            child:Column(
              children:[
                Icon(Icons.devices, color:Window.window == "automacao"?custom_colors.secundary_color:Colors.white),
                Text("Automações", style: TextStyle(color:Window.window == "automacao"?custom_colors.secundary_color:Colors.white))
              ]
            )
          ),
          TextButton(
            onPressed: envFile,
            child:Column(
              children:[
                Icon(Icons.file_upload, color:Window.window == "envFile"?custom_colors.secundary_color:Colors.white),
                Text("Upload", style: TextStyle(color:Window.window == "envFile"?custom_colors.secundary_color:Colors.white))
              ]
            )
          ),
      ]),
    )
    );
  }
}