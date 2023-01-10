import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:hello/values/custom_colors.dart';



class Teste extends StatelessWidget {
  FilePickerResult? filePickerResult;
  File? pickedFile;

  getImageorVideoFromGallery(context) async {
    filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      File pickedFile = File(filePickerResult!.files.single.path.toString());
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => diretory(file: pickedFile)));
              
    }
}
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              getImageorVideoFromGallery(context);
            },
            style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(custom_colors.primary_color)
            ),
            child: const Text(
              'Escolher arquivo',
              style: TextStyle(
                color: Colors.white,
              ),)),
      ),
    );
  }
}
class diretory extends StatefulWidget{
  final File file;
  const diretory({Key? key, required this.file}):super(key: key);
  @override
  State<diretory> createState() => _diretory();
}
class _diretory extends State<diretory>{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body:Center(
      child: Text(basename(widget.file.path))
    ));
  }
}