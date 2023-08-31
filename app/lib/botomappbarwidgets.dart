import 'package:flutter/material.dart';
import 'package:icaros/main.dart';
import 'package:icaros/screens/navegador.dart';
import 'package:icaros/screens/multimidia.dart';
import 'package:icaros/screens/automacoes.dart';
import 'package:icaros/screens/env_file.dart';
import 'package:icaros/values/values.dart';

class BottomAppBarWidgets extends StatefulWidget {
  const BottomAppBarWidgets({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomAppBarWidgets createState() => _BottomAppBarWidgets();
}

class _BottomAppBarWidgets extends State<BottomAppBarWidgets> {
  void navegator() {
    if (Window.window != "navegator") {
      Window.window = "navegator";
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Navegador()));
    }
  }

  void multimidia() {
    if (Window.window != "multimidia") {
      Window.window = "multimidia";
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MultimidiaState()));
    }
  }

  void automacao() {
    if (Window.window != "automacao") {
      Window.window = "automacao";
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Automacoes()));
    }
  }

  void envFile() {
    if (Window.window != "envFile") {
      Window.window = "envFile";
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const EnvFileState()));
    }
  }

  void home() {
    if (Window.window != "home") {
      Window.window = "home";
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                top:
                    BorderSide(width: 1, color: CustomColors.secundary_color))),
        height: 60,
        padding: const EdgeInsets.only(top: 5.0),
        child: BottomAppBar(
          color: CustomColors.primary_color,
          child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                    child: TextButton(
                        onPressed: envFile,
                        child: Column(children: [
                          Icon(Icons.file_upload,
                              color: Window.window == "envFile"
                                  ? CustomColors.secundary_color
                                  : Colors.white),
                          Text("Upload",
                              style: TextStyle(
                                  color: Window.window == "envFile"
                                      ? CustomColors.secundary_color
                                      : Colors.white,
                                  fontSize: 10))
                        ]))),
                Flexible(
                    child: TextButton(
                        onPressed: multimidia,
                        child: Column(children: [
                          Icon(Icons.headphones,
                              color: Window.window == "multimidia"
                                  ? CustomColors.secundary_color
                                  : Colors.white),
                          Text("Multimidia",
                              style: TextStyle(
                                  color: Window.window == "multimidia"
                                      ? CustomColors.secundary_color
                                      : Colors.white,
                                  fontSize: 10))
                        ]))),
                Flexible(
                    child: TextButton(
                        onPressed: home,
                        child: Column(children: [
                          Icon(Icons.home,
                              color: Window.window == "home"
                                  ? CustomColors.secundary_color
                                  : Colors.white),
                          Text("Home",
                              style: TextStyle(
                                  color: Window.window == "home"
                                      ? CustomColors.secundary_color
                                      : Colors.white,
                                  fontSize: 10))
                        ]))),
                Flexible(
                    child: TextButton(
                        onPressed: navegator,
                        child: Column(children: [
                          Icon(Icons.language,
                              color: Window.window == "navegator"
                                  ? CustomColors.secundary_color
                                  : Colors.white),
                          Text("Navegador",
                              style: TextStyle(
                                  color: Window.window == "navegator"
                                      ? CustomColors.secundary_color
                                      : Colors.white,
                                  fontSize: 10))
                        ]))),
                Flexible(
                    child: TextButton(
                        onPressed: automacao,
                        child: Column(children: [
                          Icon(Icons.more_horiz,
                              color: Window.window == "automacao"
                                  ? CustomColors.secundary_color
                                  : Colors.white),
                          Text("Opções",
                              style: TextStyle(
                                  color: Window.window == "automacao"
                                      ? CustomColors.secundary_color
                                      : Colors.white,
                                  fontSize: 10))
                        ]))),
              ]),
        ));
  }
}
