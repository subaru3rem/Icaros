import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:icaros/values/values.dart';
import 'package:icaros/botomappbarwidgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: CustomColors.primary_color,
            secondary: CustomColors.secundary_color),
        scaffoldBackgroundColor: CustomColors.primary_color,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
        )),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.black54),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _Myhomepage();
}

class _Myhomepage extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        shape: const Border(
            bottom: BorderSide(color: CustomColors.secundary_color, width: 2)),
      ),
      body: const MyHomePageWidget(),
      bottomNavigationBar: const BottomAppBarWidgets(),
    );
  }
}

class MyHomePageWidget extends StatefulWidget {
  const MyHomePageWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageWidget createState() => _MyHomePageWidget();
}

class _MyHomePageWidget extends State<MyHomePageWidget> {
  Map<String, dynamic>? _resposta;
  String? errorResposta;
  bool checked = false;
  void infoPc() async {
    // Ips.ip = '';
    if (Ips.ip != "" && Window.window == "home") {
      Uri url = Uri.http(Ips.ip);
      try {
        final response = await http.get(url);
        setState(() {
          var r = response.body;
          _resposta = jsonDecode(r);
        });
      } catch (e) {
        return;
      }
    }
  }

  Widget desktopInfoWidget() {
    Widget infoPc;
    if (_resposta != null) {
      infoPc = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.all(20),
                      child: const Icon(
                        Icons.desktop_mac_outlined,
                        color: Colors.white,
                        size: 100,
                      )),
                  Text(
                    _resposta?['host'],
                    style: const TextStyle(fontSize: 40),
                  ),
                ],
              ),
              // ignore: avoid_unnecessary_containers
              Container(child: TextButton(onPressed: ip, child: const Center()))
            ],
          ),
          Container(
            width: 300,
            height: 300,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: CustomColors.primary_color,
                boxShadow: const [
                  BoxShadow(
                      color: CustomColors.secundary_color,
                      spreadRadius: 1,
                      blurRadius: 20)
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Uso de cpu: ${_resposta?['cpu']}%',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Uso de memoria: ${_resposta?['memory']}%',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Uso do disco: ${_resposta?['disco']}%',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Bateria: ${_resposta?['bateria']}%',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      infoPc = Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.all(20),
            child: const Icon(
              Icons.desktop_mac_outlined,
              color: Colors.white,
              size: 100,
            )),
        const Text(
          "Host não disponivel",
          style: TextStyle(fontSize: 40),
        ),
        Container(
            margin: const EdgeInsets.all(20),
            height: 50,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CustomColors.secundary_color),
            child: TextButton(
                onPressed: ip,
                child: const Text(
                  "Conectar Novamente",
                  textAlign: TextAlign.center,
                )))
      ]));
    }
    return infoPc;
  }

  void saveip(ip) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ip", ip);
  }

  void ip() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
        "#FFFFFF", "Cancel", false, ScanMode.QR);
    if (Ips.validateIp(code)) {
      confirmIp(code);
      return;
    }
    errorIp();
  }

  void confirmIp(code) {
    CheckboxWidget checkbox = CheckboxWidget();
    Scaffold.of(context).showBottomSheet((BuildContext context) {
      return Stack(
        children: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Container(color: const Color.fromRGBO(0, 0, 0, .5))),
          Center(
              child: Container(
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(20),
            color: CustomColors.primary_color,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Confirmar IP:",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  code,
                  style: const TextStyle(fontSize: 30),
                ),
                Flex(
                    direction: Axis.horizontal,
                    children: [checkbox, const Text("Manter conectado")]),
                Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: TextButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  CustomColors.secundary_color)),
                          onPressed: () {
                            setState(() {
                              Ips.ip = code;
                            });
                            if (checkbox.check!.checked == true) {
                              saveip(code);
                            }
                            infoPc();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Confirma",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                    ),
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: TextButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  CustomColors.secundary_color)),
                          onPressed: ip,
                          child: const Text(
                            "Escanear novamente",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                    )
                  ],
                )
              ],
            )),
          ))
        ],
      );
    });
  }

  void errorIp() {
    Scaffold.of(context).showBottomSheet((BuildContext context) {
      return Center(
          child: Container(
        width: 300,
        height: 300,
        color: CustomColors.primary_color,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 100),
            const Text(
              "Erro ao ler o código",
              style: TextStyle(fontSize: 20),
            ),
            Container(
              decoration: BoxDecoration(
                  color: CustomColors.secundary_color,
                  borderRadius: BorderRadius.circular(10)),
              width: 150,
              height: 50,
              child: TextButton(
                  onPressed: () {
                    manualIp();
                  },
                  child: const Text("Digitar ip")),
            )
          ],
        )),
      ));
    }, enableDrag: true);
  }

  void manualIp() {
    // ignore: non_constant_identifier_names
    String ip_manual = "";
    Scaffold.of(context).showBottomSheet((BuildContext context) {
      return Center(
          child: Container(
        color: CustomColors.primary_color,
        width: 300,
        height: 200,
        child: Column(
          children: [
            Container(
                height: 65,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                margin: const EdgeInsets.only(bottom: 30),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: CustomColors.secundary_color))),
                child: const Text(
                  "Ip",
                  style: TextStyle(fontSize: 20),
                )),
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 60,
                width: 250,
                child: TextField(
                  onChanged: (text) => ip_manual = text,
                  onSubmitted: (text) {
                    if (Ips.validateIp(text)) {
                      Ips.ip == text;
                      Navigator.pop(context);
                      setState((){});               
                      return;
                    }
                    errorIp();
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.secundary_color, width: 0.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.secundary_color, width: 0.0)),
                      border: OutlineInputBorder(),
                      labelText: 'Nome do Site',
                      labelStyle: TextStyle(color: Colors.white)),
                ),
              ),
              Expanded(
                  child: TextButton(
                      onPressed: () {
                        if (Ips.validateIp(ip_manual)) {
                          Ips.ip == ip_manual;
                          Navigator.pop(context);
                          return;
                        }
                        errorIp();
                      },
                      child: const Icon(Icons.arrow_right)))
            ])
          ],
        ),
      ));
    });
  }

  void verificarIP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var ip = prefs.getString("ip");
    if (ip != null) {
      setState(() {
        Ips.ip = ip;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    verificarIP();
  }

  @override
  Widget build(BuildContext context) {
    infoPc();
    return Column(
      children: [
        Expanded(child: desktopInfoWidget()),
      ],
    );
  }
}

// ignore: must_be_immutable
class CheckboxWidget extends StatefulWidget {
  CheckboxWidget({super.key});
  _CheckboxWidget? check;

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _CheckboxWidget createState(){
    check = _CheckboxWidget();
    return check!;
  }

}

class _CheckboxWidget extends State<CheckboxWidget> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.white;
        }
        return Colors.black;
      }),
      value: checked,
      onChanged: (bool? value) {
        setState(() {
          checked = value!;
        });
      },
    );
  }
}
