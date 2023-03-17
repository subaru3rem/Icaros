import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Icaros/values/custom_colors.dart';


class Env_file extends StatefulWidget{
  @override 
  _Env_file createState()=> _Env_file();
}
class _Env_file extends State<Env_file> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text("Transferir Arquivos"),
        shape: const Border(
          bottom: BorderSide(
            color:custom_colors.secundary_color,
            width: 2
          )
        ),
      ),
      body: Env_file_widgets()
    );
  }
}
class Env_file_widgets extends StatefulWidget{
  @override
  _Env_file_widgets createState()=> _Env_file_widgets();
}
class _Env_file_widgets extends State<Env_file_widgets>{
  FilePickerResult? filepick;
  File? file;
  bool file_check = false;
  bool transfe_check = false;
  void get_file() async {
    filepick = await FilePicker.platform.pickFiles();
    if(filepick != null){
      file = File(filepick!.files.single.path.toString());
      setState((){file_check = true;});
    }
  }
  void api_post()async{
    setState(() {transfe_check=true;});
    Uri postUri = Uri.http("192.168.10.50:5000", "/file");
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath('file', filepick!.files.single.path.toString());
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();
    setState(() {transfe_check=false;});
  }
  @override
  Widget build(BuildContext context){
    return Center(
        child: Column(
          children:[Container(
          height: 300,
          width: 300,
          margin: const EdgeInsets.only(bottom:40, top: 100),
          decoration: BoxDecoration(
            color: custom_colors.primary_color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 10, )]
          ),
          child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            TextButton(onPressed: get_file,
            style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(custom_colors.primary_color)
            ),
            child:  const Icon(Icons.folder, color: Colors.white,size: 100,)
            ),
            Text(!file_check
              ?'Selecione o arquivo'
              :filepick!.files.single.name.toString(), 
              softWrap: true,
              textAlign: TextAlign.center,),
            
            FloatingActionButton(
              onPressed: ()=>{if(file_check){api_post()}else{get_file()}}, 
              child: const Icon(Icons.upload_file),
            )
          ]
        ),
      ),
      !transfe_check
      ?const Center()
      :const SizedBox(
        width: 300,
        child:LinearProgressIndicator()
      ),
      ])
      );
  }
}