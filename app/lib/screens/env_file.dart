import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:icaros/values/values.dart';
import 'package:icaros/botomappbarwidgets.dart';


class EnvFileState extends StatefulWidget{
  const EnvFileState({super.key});
  @override 
  EnvFile createState()=> EnvFile();
}
class EnvFile extends State<EnvFileState> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text("Transferir Arquivos"),
        shape: const Border(
          bottom: BorderSide(
            color:CustomColors.secundary_color,
            width: 2
          )
        ),
      ),
      body: const EnvFileWidgetsState(),
      bottomNavigationBar: const BottomAppBarWidgets(),
    );
  }
}
class EnvFileWidgetsState extends StatefulWidget{
  const EnvFileWidgetsState({super.key});
  @override
  EnvFileWidgets createState()=> EnvFileWidgets();
}
class EnvFileWidgets extends State<EnvFileWidgetsState>{
  FilePickerResult? filepick;
  File? file;
  // ignore: non_constant_identifier_names
  bool file_check = false;
  // ignore: non_constant_identifier_names
  bool transfe_check = false;
  void getFile() async {
    filepick = await FilePicker.platform.pickFiles();
    if(filepick != null){
      file = File(filepick!.files.single.path.toString());
      setState((){file_check = true;});
    }
  }
  void apiPost()async{
    setState(() {transfe_check=true;});
    Uri postUri = Uri.http(Ips.ip, "/file");
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath('file', filepick!.files.single.path.toString());
    request.files.add(multipartFile);
    await request.send();
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
            color: CustomColors.primary_color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 10, )]
          ),
          child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            TextButton(onPressed: getFile,
            style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(CustomColors.primary_color)
            ),
            child:  const Icon(Icons.folder, color: Colors.white,size: 100,)
            ),
            Text(!file_check
              ?'Selecione o arquivo'
              :filepick!.files.single.name.toString(), 
              softWrap: true,
              textAlign: TextAlign.center,),
            
            FloatingActionButton(
              onPressed: ()=>{if(file_check){apiPost()}else{getFile()}}, 
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